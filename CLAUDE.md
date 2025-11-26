# Today I Did - tmux 세션 로깅

tmux 세션에 attach/create할 때 자동으로 ntfy.sh를 통해 알림을 보내는 도구.

## 구조

```
~/git/today_I_did/
├── bin/tid-log      # tmux hook에서 호출되는 스크립트
├── logs/            # 일별 로컬 로그 (YYYY-MM-DD.log)
├── config.sh        # ntfy 토픽 설정
└── CLAUDE.md
```

## 동작 방식

1. tmux 세션 생성 또는 attach 시 `~/.tmux.conf`의 hook이 `bin/tid-log` 실행
2. 세션 이름과 시간을 ntfy.sh로 전송
3. 로컬 로그 파일에도 기록

## 설정 파일

### ~/.tmux.conf
```bash
set-hook -g client-attached 'run-shell "/Users/kyw/git/today_I_did/bin/tid-log"'
set-hook -g session-created 'run-shell "/Users/kyw/git/today_I_did/bin/tid-log"'
```

### config.sh
```bash
NTFY_TOPIC="tid-xxxxxxxxxxxxxxxx"
```

## 알림 형식

```
🔧 14:30 - session-name
```

## 로그 형식

`logs/2025-11-26.log`:
```
14:30 - session-name
15:45 - another-session
```

## 수동 테스트

```bash
# 스크립트 직접 실행
~/git/today_I_did/bin/tid-log

# ntfy 직접 전송
curl -d "테스트" https://ntfy.sh/$(grep NTFY_TOPIC ~/git/today_I_did/config.sh | cut -d'"' -f2)
```

## 의존성

- tmux 3.x+
- curl
- ntfy 앱 (iOS/Android)
