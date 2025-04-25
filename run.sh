#!/bin/bash
# 1. Node.js 버전 확인 (node >= v22)
REQUIRED_NODE_MAJOR=22
NODE_VERSION=$(node -v | sed 's/v\([0-9]*\).*/\1/')
if [ "$NODE_VERSION" -lt "$REQUIRED_NODE_MAJOR" ]; then
  echo "❌ Node.js v$REQUIRED_NODE_MAJOR 이상이 필요합니다. 현재 버전: $(node -v)"
  exit 1
else
  echo "✅ Node.js 버전 확인: $(node -v)"
fi

# 2. 의존성 설치
echo "📦 의존성 설치 중..."
yarn install

# 3. .env 파일 초기화
if [ ! -f .env ]; then
  echo "📄 .env 파일 생성..."
  cp .env-sample .env
fi

# 4. 기존 Anvil 프로세스 종료
echo "🛑 기존 Anvil 프로세스 종료 시도..."
ANVIL_PIDS=$(pgrep -f "anvil --block-time 1 --auto-impersonate")
if [ -n "$ANVIL_PIDS" ]; then
  kill -15 $ANVIL_PIDS  # SIGTERM 먼저 시도
  sleep 2  # 종료 대기 시간
  # 강제 종료 필요한 경우
  if pgrep -f "anvil --block-time 1 --auto-impersonate" >/dev/null; then
    kill -9 $ANVIL_PIDS
    echo "⚠️ 기존 Anvil 프로세스 종료"
  fi
fi

# 5. RPC (Anvil) 네트워크 실행 (로그 저장)
echo "🚀 로컬 RPC(Anvil) 네트워크 실행..."
yarn network > anvil.log 2>&1 &
NETWORK_PID=$!
sleep 5 # Anvil 초기화 대기

# 5. 0번째 개인키 추출
echo "🔑 개인키 추출 중..."
PRIV_KEY=$(awk '/Private Keys/{flag=1; next} /Wallet/{flag=0} flag' anvil.log | grep "(0)" | awk '{print $2}')
if [ -z "$PRIV_KEY" ]; then
  echo "❌ 개인키 추출 실패! anvil.log 확인"
  exit 1
fi

# 6. .env 파일 업데이트
sed -i.bak "s/^PRIV_KEY=.*/PRIV_KEY=$PRIV_KEY/" .env
rm -f .env.bak
echo "✅ .env 업데이트 완료"

# 7. Smart Contract 컴파일
echo "🛠️ 스마트 컨트랙트 컴파일 중..."
yarn compile:contracts

# 8. Smart Contract 배포
echo "🚀 스마트 컨트랙트 배포 중..."
yarn deploy:contracts

# 9. Ethernaut 프론트엔드 실행
echo "🌐 Ethernaut 프론트엔드 실행 (http://localhost:3000)..."
export NODE_OPTIONS=--openssl-legacy-provider
yarn start:ethernaut

# 10. 종료 안내
echo "🎉 준비 완료! 다음 단계를 수행하세요:"
echo "1. 메타마스크에 개인키 임포트 (.env 파일 참조)"
echo "2. http://localhost:3000 접속"

wait
