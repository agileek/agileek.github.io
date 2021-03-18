---
layout: post
title: "Never miss a google meet with systemd"
categories: [software, terminal]
date: 2021-03-18
tags: [software, terminal, systemd]
---

I don't like to be late at meetings, and I relied heavily on my coworkers to warn me about a meeting starting.

Now, I'm working in a fully remote company, and I can't rely on my coworkers, because they can only message me, and I don't look at slack/emails all day.

So I came up with 1 little script (and 2 systemd units) to automatically launch my meeting 1-2 minutes before it actually starts.

The script relies on [gcalcli][gcalcli]:
- it checks the next meeting I accepted
- it retrieves the Google Meet URL
- it launches a new Google Chrome windows.

```bash
#!/bin/bash
set -eufo pipefail

EMAIL_ADDRESS='your@email.com'
BACKUP_FILE=.previous-meetup
touch "${BACKUP_FILE}"
PREVIOUS_MEETUP=$(cat "${BACKUP_FILE}")

NEW_MEETUP=$(gcalcli --calendar="${EMAIL_ADDRESS}" agenda --details url --tsv --nodeclined "$(date --date="+1 minutes" +"%Y-%m-%dT%H:%M")" "$(date --date="+3 minutes" +"%Y-%m-%dT%H:%M")" | cut -d$'\t' -f6)

if [ "$NEW_MEETUP" != "$PREVIOUS_MEETUP" ]; then
  if [ "$NEW_MEETUP" != "" ]; then
    export DISPLAY=:0
    nohup google-chrome --new-window "${NEW_MEETUP}" &
  fi
fi

echo "${NEW_MEETUP}" > "${BACKUP_FILE}"
```

The next step is to have one systemd user service:

{% highlight ruby %}
[Unit]
Description=Auto launch google-meet
PartOf=graphical.target

[Service]
Type=forking
ExecStart={{ auto_google_meet_path }}

[Install]
WantedBy=timers.target
{% endhighlight %}

and a systemd timer:

{% highlight ruby %}
[Timer]
OnUnitActiveSec=1min
Unit=auto-google-meet.service

[Install]
WantedBy=timers.target
{% endhighlight %}

and voilà! you'll never miss a google meet now.

[gcalcli]: https://github.com/insanum/gcalcli
