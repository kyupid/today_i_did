# Today I Did

Auto-notify when you start/attach to tmux sessions.
See what you worked on at a glance at the end of the day.

## Notification Example

```
🔧 09:30 - feature-auth
🔧 11:15 - bug-fix-login
🔧 14:00 - refactor-api
```

## Installation

```bash
git clone https://github.com/kyupid/today_i_did.git
cd today_i_did
./install.sh
```

## Setup

1. **Install ntfy app** (iOS/Android)
2. **Subscribe to topic** - Use the topic name shown during installation
3. **Done!** - Start a tmux session and get notified

## Usage

Just use tmux as usual:

```bash
tmux new -s my-feature
tmux attach -t my-feature
```

Notifications are sent automatically.

## Local Logs

Daily logs are saved in `~/.today_i_did/logs/`:

```
~/.today_i_did/logs/2025-11-26.log
```

## Change Topic

```bash
vim ~/.today_i_did/config.sh
# NTFY_TOPIC="new-topic-name"
```

## Uninstall

```bash
rm -rf ~/.today_i_did
# Remove today_i_did lines from ~/.tmux.conf
```

## Requirements

- tmux 3.x+
- curl
- ntfy app
