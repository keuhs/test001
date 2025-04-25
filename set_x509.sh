#!/bin/bash

# 입력 인자 확인
if [ -z "$1" ]; then
    echo "Usage: $0 <address:port>"
    exit 1
fi

ADDRESS=$1

# 호스트명과 포트 추출
HOST=$(echo "$ADDRESS" | cut -d':' -f1)
PORT=$(echo "$ADDRESS" | cut -d':' -f2)

# 호스트명에서 .을 -로 변환
HOST=$(echo "$HOST" | sed 's/\./_/g')

# 파일명 설정
FILENAME="${HOST}_${PORT}.crt"
OUTPUT_PATH="/usr/local/share/ca-certificates/$FILENAME"

# OpenSSL 명령 실행 및 결과 저장
openssl s_client -connect "$ADDRESS" 2>/dev/null </dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "$FILENAME"

# 결과 확인 메시지 출력
echo "Certificate saved to $OUTPUT_PATH"
sudo mv $FILENAME $OUTPUT_PATH
sudo update-ca-certificates
