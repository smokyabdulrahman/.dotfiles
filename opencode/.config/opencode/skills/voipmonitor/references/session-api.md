# Session-based CDR API and SIP history

Use this reference only after following the environment and security requirements in `../SKILL.md`.

Official reference: https://www.voipmonitor.org/doc/WEB_API#CDR_HTTP_API

## Authentication

The CDR API and GUI utility endpoints use a session. They do not use HTTP Basic authentication or the HTTP API 2 task envelope.

1. POST form-encoded fields to `${VOIPMONITOR_SERVER_URL%/}/php/model/sql.php`:
   - `module=bypass_login`
   - `user` from `VOIPMONTIOR_USERNAME`
   - `pass` from `VOIPMONTIOR_PASSWORD` (not `password` for this login)
2. Check that the JSON response indicates success and contains `SID` and `cookie_name`. Do not print or persist the login response.
3. Use the returned cookie name and SID for subsequent requests. Never assume `PHPSESSID`: installations under a prefix may return names such as `PHPSESSID-voipmonitor`.
4. Keep sessions in memory if possible. Never put cookie values in command arguments, URLs, logs, or chat. If a cookie file is necessary, use a private temporary directory, permissions `0600`, and remove only the temporary files you created when finished.
5. Reauthenticate at most once after a genuine session-expired response. Do not repeatedly retry a permissions error or bad password.

Prefer Python's standard-library HTTP client with an in-memory cookie jar. Some installations set cookies on login, but do not rely on that alone: construct the session cookie from the response fields if needed. Keep all requests on the configured HTTPS origin and installation prefix, and reject redirects.

## Minimal in-memory Python example

This example performs a bounded CDR listing and prints only selected fields from up to 20 records. Replace the dates and filters before running it. Credentials are read inside Python, not supplied as command arguments. If response structure differs, inspect only a small redacted sample before adapting it.

```python
import http.cookiejar
import json
import os
import urllib.error
import urllib.parse
import urllib.request


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


names = (
    "VOIPMONITOR_SERVER_URL",
    "VOIPMONTIOR_USERNAME",
    "VOIPMONTIOR_PASSWORD",
)
missing = [name for name in names if not os.environ.get(name)]
if missing:
    raise SystemExit("Export these variables locally: " + ", ".join(missing))

base = os.environ[names[0]].rstrip("/")
url = urllib.parse.urlsplit(base)
if (
    url.scheme != "https"
    or not url.hostname
    or url.username is not None
    or url.password is not None
    or url.query
    or url.fragment
    or url.path.endswith("/php/api.php")
):
    raise SystemExit("Use an HTTPS GUI base URL without credentials or query/fragment.")

opener = urllib.request.build_opener(
    urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()), NoRedirect()
)


def post_json(path, fields):
    request = urllib.request.Request(
        base + path,
        data=urllib.parse.urlencode(fields).encode(),
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    try:
        with opener.open(request, timeout=60) as response:
            return json.load(response)
    except urllib.error.HTTPError as error:
        raise SystemExit(f"VoIPmonitor HTTP {error.code}; inspect configuration and permissions.") from None
    except (urllib.error.URLError, TimeoutError, OSError, ValueError):
        raise SystemExit("VoIPmonitor connection or JSON response failed; do not dump credentials or raw responses.") from None


login = post_json("/php/model/sql.php", {
    "module": "bypass_login",
    "user": os.environ[names[1]],
    "pass": os.environ[names[2]],
})
if not isinstance(login, dict) or login.get("success") is not True:
    raise SystemExit("VoIPmonitor login failed; verify the local GUI account.")
cookie_name, sid = login.get("cookie_name"), login.get("SID")
if not isinstance(cookie_name, str) or not isinstance(sid, str) or not cookie_name or not sid:
    raise SystemExit("Login did not return a usable session.")
if any(char in cookie_name + sid for char in "\r\n;"):
    raise SystemExit("Login returned an invalid session cookie.")
opener.addheaders = [("Cookie", f"{cookie_name}={sid}")]

result = post_json("/php/model/sql.php", {
    "task": "LISTING",
    "module": "CDR",
    "fdatefrom": "2026-11-08T10:00:00",
    "fdateto": "2026-11-08T10:10:00",
    "fcaller": "1001",
    "start": 0,
    "limit": 20,
})
if not isinstance(result, dict) or result.get("success") is not True:
    raise SystemExit("CDR listing failed; inspect a redacted API error locally.")
rows = result.get("results") or []
if not isinstance(rows, list) or any(not isinstance(row, dict) for row in rows):
    raise SystemExit("Unexpected CDR response structure; inspect a small redacted sample locally.")
fields = ("id", "cdrId", "calldate", "caller", "called", "duration", "lastSIPresponseNum")
print(json.dumps([{key: row[key] for key in fields if key in row} for row in rows[:20]], indent=2))
```

## CDR listing filters

POST to `/php/model/sql.php` using the authenticated session. Required fields are `task=LISTING`, `module=CDR`, and at least one of `fdatefrom` or `fdateto`.

| Field | Meaning |
| --- | --- |
| `fdatefrom`, `fdateto` | Date bounds, e.g. `2026-11-08T10:00:00` |
| `fcaller`, `fcalled` | Caller/called number |
| `fcallerd_type` | `0` for OR, `1` for AND between caller/called conditions |
| `fcallid` | SIP Call-ID |
| `fsipcallerip`, `fsipcalledip` | SIP endpoint IP address |
| `fsipresponse` | SIP response code, e.g. `503` |
| `fdurationgt`, `fdurationlt` | Duration bounds in seconds |
| `fsensor_id` | Sensor identifier |
| `fcodec` | Comma-separated codec numbers |
| `suppress_results` | `1` for count-only requests |
| `start`, `limit`, `page` | Pagination controls; begin with 20 results and inspect the response |
| `sort` | JSON array, e.g. `[{"property":"calldate","direction":"DESC"}]` |

Advance `start` by the page size while matching records remain, using the returned total when available. Bound the number of pages to the user's scope. Do not assume the first page is the complete result set.

MOS/loss/jitter filters include `fmosf1`, `fmosf2`, `fmosadapt`, `frtcp_maxjitter`, `frtcp_avgjitter`, and `floss1` through `floss10`. Their accepted values can depend on the GUI version. Check the deployed GUI's filter form or current documentation rather than guessing a threshold representation.

## SIP history

After login, GET one of these paths with the in-memory session cookie and a verified CDR ID:

- `/php/pcap2text.php?action=brief_data&id=12345` — JSON SIP history.
- `/php/pcap2text.php?action=brief&id=12345` — HTML SIP history.
- `/php/pcap2text.php?action=getMSC&id=12345` — message-sequence diagram.

Use `urllib.parse.urlencode` to construct query strings. The existing Python opener can make these GET requests with `opener.open(base + path, timeout=60)`; reject redirects and handle failures as above. Request only the needed call. Summarize signaling order and relevant messages, and redact Authorization headers, tokens, telephone numbers, or private details when sharing externally.

## Direct capture download

After session login:

- `/php/pcap.php?id=12345` — full capture.
- `/php/pcap.php?id=12345&disable_rtp=1` — SIP-only capture.

Stream bytes to a new local file opened exclusively (`open(path, "xb")`) with restrictive permissions. Do not call `json.load` for a successful binary response. Verify actual file format and detect JSON/HTML errors before reporting success. Keep partial downloads clearly marked and never overwrite an existing capture.
