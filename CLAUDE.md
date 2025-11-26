# Today I Did - tmux Session Logging

A tool that automatically sends ntfy.sh notifications when attaching/creating tmux sessions.

## Structure

```
~/.today_i_did/
├── bin/tid-log      # Script called by tmux hook
├── logs/            # Daily local logs (YYYY-MM-DD.log)
├── config.sh        # ntfy topic configuration
└── CLAUDE.md
```

## How It Works

1. tmux hook in `~/.tmux.conf` runs `bin/tid-log` on session create/attach
2. Session name and time are sent to ntfy.sh
3. Also logged locally

## Config Files

### ~/.tmux.conf
```bash
set-hook -g client-attached 'run-shell "~/.today_i_did/bin/tid-log"'
set-hook -g session-created 'run-shell "~/.today_i_did/bin/tid-log"'
```

### config.sh
```bash
NTFY_TOPIC="tid-xxxxxxxxxxxxxxxx"
```

## Notification Format

```
🔧 14:30 - session-name
```

## Log Format

`logs/2025-11-26.log`:
```
14:30 - session-name
15:45 - another-session
```

## Manual Testing

```bash
# Run script directly
~/.today_i_did/bin/tid-log

# Send ntfy directly
curl -d "test" https://ntfy.sh/$(grep NTFY_TOPIC ~/.today_i_did/config.sh | cut -d'"' -f2)
```

## Dependencies

- tmux 3.x+
- curl
- ntfy app (iOS/Android)
