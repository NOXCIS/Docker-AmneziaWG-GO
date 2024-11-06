# awg: BUILD AmneziaWG (Obfuscated Wireguard) 
FROM  golang:alpine3.20
WORKDIR /go
RUN apk update && apk add --no-cache git make bash build-base linux-headers
RUN git clone --depth=1 https://github.com/amnezia-vpn/amneziawg-tools.git && \
    git clone --depth=1 https://github.com/amnezia-vpn/amneziawg-go.git
RUN cd /go/amneziawg-tools/src && make
RUN cd /go/amneziawg-go && \
    go get -u ./... && \
    go mod tidy && \
    make 
RUN echo "DONE AmneziaWG"