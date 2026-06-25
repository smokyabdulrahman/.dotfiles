---
description: Read the trace/span details from logfire, then create a ticket on linear and return the URL
agent: work-manager
---

# 1st Step
Given this trace-id: $1, query logfire for the trace details.
Make sure you look for logs that are error/warnning or is_exception.
These are the ones that are the issue mostly.

# 2nd Step
Understand what the issue that happened, try to see:
- which step led to the error
- what the error exactly is
- what is the error trying to say.
- what could be the reason of the error (maybe next spans/logs could tell us)

# 3th Step
Create an issue on Linear with:
- A title that describes the issue concisly
- A detailed description that includes:
  - link to logfire span.
  - link to file in question (if possible).
  - summary of the issue and how it happens.
  - possible solution if a solution is clear. otherwise no need. 

# 4th Step
Show me the issue URL on linear.
