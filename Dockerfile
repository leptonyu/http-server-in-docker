FROM golang:alpine

RUN echo "package main"       > main.go \
 && echo "import ("          >> main.go \
 && echo "  \"net/http\""    >> main.go \
 && echo ")"                 >> main.go \
 && echo "func main() {"     >> main.go \
 && echo "  http.Handle(\"/\", http.FileServer(http.Dir(\"/docker\")))"  >> main.go \
 && echo "  http.ListenAndServe(\":3000\", nil)"  >> main.go \
 && echo "}"  >> main.go \
 && go fmt main.go \
 && mkdir -p src/http \
 && mv main.go src/http \
 && CGO_ENABLED=0 go build -a -ldflags '-s' http

COPY Dockerfile.run Dockerfile

CMD tar -cf - http Dockerfile

