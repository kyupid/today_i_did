# Today I Did

tmux 세션 시작/attach 시 자동으로 알림을 보내는 도구.
하루 끝에 뭘 했는지 한눈에 확인할 수 있습니다.

## 알림 예시

```
🔧 09:30 - feature-auth
🔧 11:15 - bug-fix-login
🔧 14:00 - refactor-api
```

## 설치

```bash
git clone https://github.com/YOUR_USERNAME/today_i_did.git
cd today_i_did
./install.sh
```

## 설정

1. **ntfy 앱 설치** (iOS/Android)
2. **토픽 구독** - 설치 시 출력된 토픽 이름으로 구독
3. **끝!** - tmux 세션 시작하면 자동 알림

## 사용법

그냥 평소처럼 tmux 사용하면 됩니다:

```bash
tmux new -s my-feature
tmux attach -t my-feature
```

자동으로 알림이 옵니다.

## 로컬 로그

`~/.today_i_did/logs/` 에 일별 로그 저장:

```
~/.today_i_did/logs/2025-11-26.log
```

## 토픽 변경

```bash
vim ~/.today_i_did/config.sh
# NTFY_TOPIC="새토픽이름"
```

## 제거

```bash
rm -rf ~/.today_i_did
# ~/.tmux.conf 에서 today_i_did 관련 줄 삭제
```

## 의존성

- tmux 3.x+
- curl
- ntfy 앱
