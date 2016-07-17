FROM golang:alpine

ARG PACK=true
ARG PORT=3000
ARG DIR=/docker

COPY upx /bin/upx

RUN echo "package main"       > main.go \
 && echo "import ("          >> main.go \
 && echo "  \"net/http\""    >> main.go \
 && echo ")"                 >> main.go \
 && echo "func main() {"     >> main.go \
 && echo "  http.Handle(\"/\", http.FileServer(http.Dir(\"$DIR\")))"  >> main.go \
 && echo "  http.ListenAndServe(\":$PORT\", nil)"  >> main.go \
 && echo "}"  >> main.go \
 && go fmt main.go \
 && CGO_ENABLED=0 go build -a -ldflags '-s' main.go \
 && if [ "$PACK" = "true" ]; then \
         chmod +x /bin/upx \
      && upx --lzma --best main \
  ; fi \
 && echo "FROM scratch"          > Dockerfile \
 && echo "EXPOSE $PORT"          >> Dockerfile \
 && echo "COPY main  /usr/bin/main"     >> Dockerfile \
 && echo "ENTRYPOINT [\"/usr/bin/main\"]" >> Dockerfile

CMD tar -cf - main Dockerfile

