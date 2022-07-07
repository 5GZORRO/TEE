FROM alpine:edge

RUN apk add gcc-go

#COPY ./alpine-gcc/packages/builder/x86_64/*.apk /
COPY ./patched-gcc/packages/builder/x86_64/*.apk /
RUN apk add --allow-untrusted /*.apk

RUN apk add git musl-dev make npm
RUN apk add bash curl yarn
WORKDIR /
RUN git clone https://github.com/prometheus/prometheus.git -b release-2.34

#RUN nm -D --defined-only /usr/lib/libgo.so | grep 'reflect' && sleep 3600

WORKDIR /prometheus/web/ui
RUN npm install -g rollup @rollup/plugin-node-resolve
RUN npm install @rollup/plugin-node-resolve
WORKDIR /prometheus
RUN env GOFLAGS="-buildmode=pie" CGO_ENABLED=1 make build
#ENTRYPOINT ["tail", "-f", "/dev/null"]
