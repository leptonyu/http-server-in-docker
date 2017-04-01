## FROM golang:alpine

## ARG PORT=3000
## ARG DIR=/docker

cat > main.go <<-EOF
package main
import "net/http"
func main() {
  http.Handle("/", http.FileServer(http.Dir("$DIR")))
  http.ListenAndServe(":$PORT", nil)
}
EOF
go fmt main.go && CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -a -ldflags '-s' main.go
