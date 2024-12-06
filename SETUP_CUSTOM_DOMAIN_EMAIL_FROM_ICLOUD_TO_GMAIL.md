[Reference](https://gist.github.com/GetVladimir/f26ecf553e62a2308fc446d0e426bdea)
Password is in `apple password app`

Copy of original for history

# How to setup iCloud+ Custom Domain Catch All email with Gmail

I've recently tested on how to move the custom domain catch all email from G Suite to the new iCloud+ Catch All feature and wanted to share my experience.

**The end result is having Custom Domain email and Catch All routing, that can be fully used via Gmail, including receiving and sending emails.**

<br>

## The steps
- Setup your Custom Domain (or subdomain) with iCloud+
- Setup the Domain DNS settings
- Enable Catch All email on iCloud+
- Forwarding all email, including Catch All to Gmail
- Adding your Custom Domain Email to Gmail for sending emails

<br>

## Prerequisites
- Standard Gmail account
- iCloud+ subscription ($0.99)
- Your Domain name and access to the DNS settings

<br>

## Step-by-step tutorial
To begin:
1. Go to [https://wwww.icloud.com/icloudplus/](https://www.icloud.com/icloudplus/) and login with your Apple ID
2. Click on "Custom Email Domain" and select "Add a Domain you own" (you can also select this option by clicking on the dots in the top right corner of the dashboard)
3. Choose "You and Other People" and enter your domain name (you can also use a subdomain)
4. If you already have a main email setup with G Suite (or on any other service), add it and and select "Add Email Address". Otherwise click on "No email addresses" and skip to step 6. You'll need to manually create your email later if you skip this.
5. Open the link that you've received on your main email to confirm it.
6. Click on "View" on to see the DNS changes that you need to make on your Domain Name. How to make the changes vary depending on your Domain provider. Check [the additonal notes below](https://gist.github.com/GetVladimir/f26ecf553e62a2308fc446d0e426bdea#additional-notes) if you use a subdomain or need to send email from other services. 


You can find more details on how to make the DNS changes on your Domain here:
https://support.apple.com/en-us/HT212524

<br/>

7. If you already have other MX DNS records on your domain, like from G Suite, you will need to remove them and add only the iCloud MX records:

```
Type:
MX
Host:
@
Value:
mx01.mail.icloud.com.
Priority:
10
```

and

```
Type:
MX
Host:
@
Value:
mx02.mail.icloud.com.
Priority:
10
```

**If you use a subdomain, make sure to replace @ with your subdomain instead.**

<br>

### Check the settings

8. After you setup the DNS changes, click on "Finish Setup" to have iCloud+ check your settings. It might take a while for the changes to propagate, but it's usually a few minutes if you use any of the bigger domain providers.

You can check your if your DNS settings are correct and propagated in Terminal by using these commands (replace example.com with your domain):
```
dig +short sig1._domainkey.example.com
dig +short txt example.com
dig +short mx example.com
```

or with an online service, like https://mxtoolbox.com/spf.aspx

<br>

### Enable Catch All email on your Custom Domain

9. After the domain is added to iCloud and confirmed, go to https://www.icloud.com/icloudplus/, click on "Custom Email Domain" and select your new domain.

10. Click on "Turn on Allow All" to enable the Catch All email feature

11. If you haven't added a main Custom Email account on step 4, now you can go ahead and create one that will be your main address. All Catch All emails will also arrive on your iCloud email.

<br>

### Forward your Custom Domain Emails to Gmail

12. Next, go to the iCloud email on https://www.icloud.com/mail/ and click on the small Gear icon in the top left corner, above the "Mailboxes" title

13. Under "Mail Forwarding > Forward my email to", add your Gmail address where you'd like to receive all your emails. You can also choose to keep a copy on iCloud or forward and delete the emails.

If you decide to keep a copy on iCloud, you can also set up additional forwarding rules under "Rules" and they should still work.

<br>

### Connect Gmail to be able to manage and send emails from your Custom Domain

14. Next, you'll need to create an App-Specific password on your AppleID. Go to https://appleid.apple.com/account/manage and click on App-specific passwords.

15. Name the password Gmail or however you like and copy it for later on step 19

16. Next, you'll need to setup to be able to send and manage all emails via Gmail if you like. Open Gmail Web App (https://mail.google.com/), click on the Gear icon on the top right corner and select "See all settings"

17. Go to Accounts and Import and select "Add another email address".

18. Here, enter your name and enter the Custom Domain email that you have setup on iCloud in step 4. Make sure to have "Treat as an alias" checked.

19. For the username, enter your full AppleID username that ends with @icloud.com here (and not the custom email username or a 3rd party email associeted with your AppleID)

20. For password, enter the App-Specific password from your AppleID that you've created on step 14.

21. For SMTP use:
```
SMTP Server:	
smtp.mail.me.com

Port: 
587

Secured connection using TLS (recommended)
```

22. Verify your settings and finish adding your Custom Email Address.

<br>

**That's it!** Now you'll have a **Catch All email that you can manage with your Gmail account**, and you'll also be able to send emails from your Custom Email.

Since we made the emails to be sent using the iCloud server, the recipients should only see your Custom Email, and not your gmail address.

<br/><br/>
## Additional notes

### If you use a subdomain instead of a main domain
If you use a subdomain instead of a domain, you will need to change @ to your subdomain. So this part:

```
sig1._domainkey
```
will need to be:
```
sig1._domainkey.yoursubdomain
```

<br>

### If you plan to use other services to send emails from the same domain
If you also plan to send email using Gmail, Zendesk or other services from that same domain, you might also need to include the SPF from the specific services too.

For example, you will need to change this:
```
v=spf1 include:icloud.com ~all
```

to this:
```
v=spf1 include:_spf.google.com include:icloud.com ~all
```

And you can add as many services as need. For example:
```
v=spf1 include:mail.zendesk.com include:_spf.google.com include:icloud.com ~all
```

<br/>

### Add your custom domain email as alternative email, so that you can accept Google Docs with it 
(Optional) You can also add your new custom email as alternative email to your Google Account on https://myaccount.google.com/alternateemail - This will allow you to receive Google Drive shares and invites to your Custom Email too, same as if they are sent to your Gmail. Your Gmail email might show in Google Drive shares though if you do this.

I hope you find this tutorial useful.

<br/><br/>


## Credits

Link to the original Reddit post:
https://www.reddit.com/r/gsuitelegacymigration/comments/wohcey/tutorial_how_to_setup_icloud_custom_domain_catch/

Credit for the subdomains info goes to isitjeremy and this Reddit post:
https://www.reddit.com/r/iCloud/comments/s94l3b/do_icloud_custom_domains_work_with_subdomains/

Other Sources:

https://support.apple.com/en-us/HT202304

https://support.apple.com/en-ie/guide/icloud/mm0e4339d289/icloud

https://support.apple.com/en-us/HT204397

https://www.reddit.com/r/iCloud/comments/vpmqgj/catchall_email_addresses_for_custom_domains/
