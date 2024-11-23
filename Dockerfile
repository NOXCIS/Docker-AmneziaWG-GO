# Compiler: Build AmneziaWG (Obfuscated Wireguard)
FROM golang:1.23.3-alpine3.20@sha256:c694a4d291a13a9f9d94933395673494fc2cc9d4777b85df3a7e70b3492d3574 AS compiler
WORKDIR /go
RUN apk update && apk add --no-cache git make bash build-base linux-headers upx
RUN git clone --depth=1 https://github.com/amnezia-vpn/amneziawg-tools.git && \
    git clone --depth=1 https://github.com/amnezia-vpn/amneziawg-go.git
RUN cd /go/amneziawg-tools/src && make
RUN cd /go/amneziawg-go && \
    go get -u ./... && \
    go mod tidy && \
    make && \
    chmod +x /go/amneziawg-go/amneziawg-go /go/amneziawg-tools/src/wg /go/amneziawg-tools/src/wg-quick/linux.bash
RUN upx --best --lzma  /go/amneziawg-go/amneziawg-go && \
    upx --best --lzma /go/amneziawg-tools/src/wg 
RUN echo "DONE AmneziaWG"


FROM scratch
LABEL maintainer="NOXCIS"
COPY --from=compiler /go/amneziawg-go/amneziawg-go /amneziawg-go
COPY --from=compiler /go/amneziawg-tools/src/wg /awg
COPY --from=compiler /go/amneziawg-tools/src/wg-quick/linux.bash /awg-quick

