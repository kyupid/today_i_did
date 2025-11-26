#!/bin/bash
set -e

INSTALL_DIR="$HOME/.today_i_did"
REPO_URL="https://github.com/kyupid/today_i_did.git"

echo "📋 Installing Today I Did..."

# 1. Create install directory
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Already installed at: $INSTALL_DIR"
    read -p "Reinstall? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    rm -rf "$INSTALL_DIR"
fi

# 2. Clone repo or copy local
if [ -d "$(dirname "$0")/bin" ]; then
    echo "📁 Installing from local..."
    cp -r "$(dirname "$0")" "$INSTALL_DIR"
else
    echo "📥 Downloading from repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# 3. Create directories
mkdir -p "$INSTALL_DIR/logs"

# 4. Setup config.sh
if [ ! -f "$INSTALL_DIR/config.sh" ]; then
    RANDOM_TOPIC="tid-$(openssl rand -hex 8)"
    cat > "$INSTALL_DIR/config.sh" << EOF
#!/bin/bash
NTFY_TOPIC="$RANDOM_TOPIC"
EOF
    echo "🔑 Generated ntfy topic: $RANDOM_TOPIC"
fi

# 5. Set permissions
chmod +x "$INSTALL_DIR/bin/tid-log"

# 6. Setup tmux.conf
TMUX_HOOK='set-hook -g client-attached '\''run-shell "~/.today_i_did/bin/tid-log"'\'''
TMUX_HOOK2='set-hook -g session-created '\''run-shell "~/.today_i_did/bin/tid-log"'\'''

if [ -f "$HOME/.tmux.conf" ]; then
    if grep -q "today_i_did" "$HOME/.tmux.conf"; then
        echo "✅ tmux hook already configured"
    else
        echo "" >> "$HOME/.tmux.conf"
        echo "# Today I Did - session logging" >> "$HOME/.tmux.conf"
        echo "$TMUX_HOOK" >> "$HOME/.tmux.conf"
        echo "$TMUX_HOOK2" >> "$HOME/.tmux.conf"
        echo "✅ Added tmux hook"
    fi
else
    echo "# Today I Did - session logging" > "$HOME/.tmux.conf"
    echo "$TMUX_HOOK" >> "$HOME/.tmux.conf"
    echo "$TMUX_HOOK2" >> "$HOME/.tmux.conf"
    echo "✅ Created tmux.conf"
fi

# 7. Reload tmux config
if tmux info &> /dev/null; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
    echo "✅ Reloaded tmux config"
fi

# Done
TOPIC=$(grep NTFY_TOPIC "$INSTALL_DIR/config.sh" | cut -d'"' -f2)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation complete!"
echo ""
echo "📱 Next steps:"
echo "   1. Install ntfy app (iOS/Android)"
echo "   2. Subscribe to topic: $TOPIC"
echo "   3. Start a tmux session and get notified!"
echo ""
echo "🧪 Test:"
echo "   curl -d 'test' https://ntfy.sh/$TOPIC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
