# Ethernaut
 
[![Twitter Follow](https://img.shields.io/twitter/follow/OpenZeppelin?style=plastic&logo=twitter)](https://twitter.com/OpenZeppelin)
[![OpenZeppelin Forum](https://img.shields.io/badge/Ethernaut%20Forum%20-discuss-blue?style=plastic&logo=discourse)](https://forum.openzeppelin.com/tag/ethernaut)

Ethernaut는 [overthewire](https://overthewire.org)에서 영감을 받은 Web3/Solidity 기반 워게임으로, 이더리움 가상 머신(EVM)에서 플레이됩니다. 각 레벨은 '해킹'해야 하는 스마트 Smart Contract으로 구성되어 있습니다.

이 게임은 이더리움 학습을 위한 도구이자 역사적인 해킹 사례를 레벨로 체계화한 플랫폼입니다. 레벨 제한이 없으며 순서에 구애받지 않고 자유롭게 플레이할 수 있습니다.

## 공식 배포 버전

현재 공식 버전은 다음에서 확인할 수 있습니다:  
[ethernaut.openzeppelin.com](https://ethernaut.openzeppelin.com)

---

## 설치 및 빌드

로컬에서 Ethernaut를 실행/배포하려면 다음 세 가지 구성 요소가 필요합니다:

1. **테스트 네트워크**: Ganache, Hardhat Network, Geth 등 로컬에서 실행되는 테스트넷
2. **Smart Contract 배포**: 스마트 Smart Contract을 로컬 테스트넷에 배포
3. **클라이언트/프론트엔드**: 로컬에서 실행되는 React 앱 (localhost:3000 접속)

### 로컬 실행 절차

0. **Node.js 버전 확인**:  
   호환되는 Node.js 버전을 사용하세요. `nvm`을 사용한다면 루트 디렉토리에서 `nvm use`를 실행하여 적절한 버전을 선택합니다.

   > node >= v22 에서 테스트하였습니다.

1. **저장소 복제 및 의존성 설치**:
    ```
    git clone https://github.com/jskimm/ethernaut
    yarn install
    ```

2. **RPC 시작**:
    ```
    yarn network
    ```

3. **Metamask 지갑에 개인 키 임포트**:  
   Ganache-cli 출력에서 제공되는 개인 키 중 하나를 Metamask 지갑에 추가합니다.
   > 메타마스크 > `계정` 클릭 > 계정 또는 하드웨어 지갑 추가 > Private key 

4. **Smart Contract 컴파일**:
    ```
    yarn compile:contracts
    ```

5. **네트워크 설정**:  
   `client/src/constants.js` 파일에서 `ACTIVE_NETWORK`를 `NETWORKS.LOCAL`로 설정합니다.

6. **Smart Contract 배포**:
    ```
    yarn deploy:contracts
    ```

7. **로컬에서 Ethernaut 실행**:
    ```
    yarn start:ethernaut
    ```

---

### Sepolia 네트워크에서 로컬 실행

로컬 네트워크 사용과 동일하지만 2, 3, 6단계가 필요하지 않습니다.  
대신 5단계를 다음과 같이 변경합니다:
- `client/src/constants.js`에서 `ACTIVE_NETWORK`를 `NETWORKS.SEPOLIA`로 설정

---

### 테스트 실행
```
yarn test:contracts
```

### 빌드
```
yarn build:ethernaut
```

### 배포

**로컬 네트워크 배포**:  
기본적으로 `yarn deploy:contracts`를 실행하면 `localhost:8545`에 모든 계약이 배포되며,  
`deploy.local.json` 파일에서 각 레벨 주소를 확인할 수 있습니다.

**Sepolia 네트워크 배포**:  
1. `constants.js`에서 `ACTIVE_NETWORK` 변수를 Sepolia로 설정
2. `deploy.sepolia.json` 파일을 편집하여 새로운 인스턴스를 "x"로 추가:
    ```
    {
      "0": "x",
      "1": "0x4b1d5eb6cd2849c7890bcacd63a6855d1c0e79d5",
      "2": "0xdf51a9e8ce57e7787e4a27dd19880fd7106b9a5c",
      ...
    }
    ```
3. 배포 명령 실행:
    ```
    yarn deploy:contracts
    ```

---