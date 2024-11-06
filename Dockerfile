# compiler: BUILD AmneziaWG (Obfuscated Wireguard) 
FROM  golang:alpine3.20 AS compiler
WORKDIR /go
RUN apk update && apk add --no-cache git make bash build-base linux-headers
RUN git clone --depth=1 https://github.com/amnezia-vpn/amneziawg-tools.git && \
    git clone --depth=1 https://github.com/amnezia-vpn/amneziawg-go.git
RUN cd /go/amneziawg-tools/src && make
RUN cd /go/amneziawg-go && \
    go get -u ./... && \
    go mod tidy && \
    make && \
    chmod +x /go/amneziawg-go/amneziawg-go /go/amneziawg-tools/src/wg /go/amneziawg-tools/src/wg-quick/linux.bash
RUN echo "DONE AmneziaWG"

FROM scratch
COPY --from=compiler  /go/amneziawg-go/amneziawg-go /amneziawg-go
COPY --from=compiler  /go/amneziawg-tools/src/wg /awg
COPY --from=compiler  /go/amneziawg-tools/src/wg-quick/linux.bash /awg-quick

