## FROM golang:alpine

## ARG PORT=3000
## ARG DIR=/docker

    echo "package main"       > main.go \
 && echo "import ("          >> main.go \
 && echo "  \"net/http\""    >> main.go \
 && echo ")"                 >> main.go \
 && echo "func main() {"     >> main.go \
 && echo "  http.Handle(\"/\", http.FileServer(http.Dir(\"$DIR\")))"  >> main.go \
 && echo "  http.ListenAndServe(\":$PORT\", nil)"  >> main.go \
 && echo "}"  >> main.go \
 && go fmt main.go \
 && CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -a -ldflags '-s' main.go