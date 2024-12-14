FROM alpine:3 AS builder

RUN apk update
RUN apk add bash pandoc

WORKDIR /work
COPY . .
RUN bash build.sh

FROM nginx:1
COPY --from=builder /work/build /usr/share/nginx/html
EXPOSE 80
