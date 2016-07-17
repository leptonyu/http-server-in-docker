FROM golang:alpine

ARG PACK=true

COPY upx /bin/upx

RUN echo "package main"       > main.go \
 && echo "import ("          >> main.go \
 && echo "  \"net/http\""    >> main.go \
 && echo ")"                 >> main.go \
 && echo "func main() {"     >> main.go \
 && echo "  http.Handle(\"/\", http.FileServer(http.Dir(\"/docker\")))"  >> main.go \
 && echo "  http.ListenAndServe(\":3000\", nil)"  >> main.go \
 && echo "}"  >> main.go \
 && go fmt main.go \
 && CGO_ENABLED=0 go build -a -ldflags '-s' main.go \
 && if [ "$PACK" = "true" ]; then \
         chmod +x /bin/upx \
      && upx --lzma --best main \
  ; fi

COPY Dockerfile.run Dockerfile

CMD tar -cf - main Dockerfile

