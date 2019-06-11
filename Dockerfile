FROM golang:1 as build

ENV GO111MODULE=on

RUN mkdir -p /app
WORKDIR /app
ADD . /app

RUN go build -ldflags="-s -w" -o keycloak-gatekeeper .

FROM ubuntu:rolling

ENV NAME keycloak-gatekeeper
ENV KEYCLOAK_VERSION 6.0.1
ENV GOOS linux
ENV GOARCH amd64

LABEL Name=keycloak-gatekeeper \
    Release=https://github.com/keycloak/keycloak-gatekeeper \
    Url=https://github.com/keycloak/keycloak-gatekeeper \
    Help=https://issues.jboss.org/projects/KEYCLOAK

WORKDIR /

COPY --from=build /app/keycloak-gatekeeper /keycloak-gatekeeper
ENTRYPOINT [ "/keycloak-gatekeeper" ]