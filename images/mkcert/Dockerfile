FROM golang:alpine

RUN apk add git

RUN apk add sudo

RUN echo "Rebuilding..."

RUN cd /go && git clone https://github.com/FiloSottile/mkcert
RUN cd /go/mkcert && go build -ldflags "-X main.Version=$(git describe --tags)"

RUN cd /go/mkcert && mv mkcert /usr/local/bin/mkcert

RUN mkdir /certs

WORKDIR /certs

CMD mkcert -install && for i in $(echo $DOMAIN | sed "s/,/ /g"); do mkcert -key-file $i.key -cert-file $i.crt $i ; done