#!/bin/bash
set -e

INSTALL_DIR="$HOME/.today_i_did"
REPO_URL="https://github.com/kyupid/today_i_did.git"

echo "📋 Today I Did 설치 시작..."

# 1. 설치 디렉토리 생성
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  이미 설치되어 있습니다: $INSTALL_DIR"
    read -p "다시 설치하시겠습니까? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    rm -rf "$INSTALL_DIR"
fi

# 2. 저장소 클론 또는 로컬 복사
if [ -d "$(dirname "$0")/bin" ]; then
    echo "📁 로컬에서 설치 중..."
    cp -r "$(dirname "$0")" "$INSTALL_DIR"
else
    echo "📥 저장소에서 다운로드 중..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# 3. 디렉토리 생성
mkdir -p "$INSTALL_DIR/logs"

# 4. config.sh 설정
if [ ! -f "$INSTALL_DIR/config.sh" ]; then
    RANDOM_TOPIC="tid-$(openssl rand -hex 8)"
    cat > "$INSTALL_DIR/config.sh" << EOF
#!/bin/bash
NTFY_TOPIC="$RANDOM_TOPIC"
EOF
    echo "🔑 ntfy 토픽 생성됨: $RANDOM_TOPIC"
fi

# 5. 실행 권한 부여
chmod +x "$INSTALL_DIR/bin/tid-log"

# 6. tmux.conf 설정
TMUX_HOOK='set-hook -g client-attached '\''run-shell "~/.today_i_did/bin/tid-log"'\'''
TMUX_HOOK2='set-hook -g session-created '\''run-shell "~/.today_i_did/bin/tid-log"'\'''

if [ -f "$HOME/.tmux.conf" ]; then
    if grep -q "today_i_did" "$HOME/.tmux.conf"; then
        echo "✅ tmux hook 이미 설정됨"
    else
        echo "" >> "$HOME/.tmux.conf"
        echo "# Today I Did - 세션 로깅" >> "$HOME/.tmux.conf"
        echo "$TMUX_HOOK" >> "$HOME/.tmux.conf"
        echo "$TMUX_HOOK2" >> "$HOME/.tmux.conf"
        echo "✅ tmux hook 추가됨"
    fi
else
    echo "# Today I Did - 세션 로깅" > "$HOME/.tmux.conf"
    echo "$TMUX_HOOK" >> "$HOME/.tmux.conf"
    echo "$TMUX_HOOK2" >> "$HOME/.tmux.conf"
    echo "✅ tmux.conf 생성됨"
fi

# 7. tmux 설정 리로드
if tmux info &> /dev/null; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
    echo "✅ tmux 설정 리로드됨"
fi

# 완료 메시지
TOPIC=$(grep NTFY_TOPIC "$INSTALL_DIR/config.sh" | cut -d'"' -f2)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 설치 완료!"
echo ""
echo "📱 다음 단계:"
echo "   1. ntfy 앱 설치 (iOS/Android)"
echo "   2. 앱에서 토픽 구독: $TOPIC"
echo "   3. tmux 세션 시작하면 자동 알림!"
echo ""
echo "🧪 테스트:"
echo "   curl -d '테스트' https://ntfy.sh/$TOPIC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
