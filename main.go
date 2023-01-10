package main

import (
	_ "embed"
	"html/template"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/websocket"
)

const (
	defaultPort = "8080"
)

//go:embed index.html.tmpl
var page string

func main() {
	u := websocket.Upgrader{}

	port := defaultPort
	if v := os.Getenv("PORT"); v != "" {
		port = v
	}

	t, err := template.New("page").Parse(page)
	if err != nil {
		log.Println("[ERROR] " + err.Error())
	}

	http.HandleFunc(
		"/ws", func(w http.ResponseWriter, r *http.Request) {
			u.CheckOrigin = func(r *http.Request) bool { return true }
			con, err := u.Upgrade(w, r, nil)
			if err != nil {
				log.Println("[ERROR] " + err.Error())
				return
			}
			defer func() { _ = con.Close() }()

			log.Println("[INFO] Client Connected")

			for {
				if err := con.WriteMessage(1, []byte(time.Now().UTC().Format(time.RFC3339Nano))); err != nil {
					log.Println("[ERROR] " + err.Error() + " it's likely that the page html was closed")
					return
				}
				time.Sleep(200 * time.Millisecond)
			}
		},
	)

	http.HandleFunc(
		"/", func(w http.ResponseWriter, r *http.Request) {
			if err := t.Execute(w, port); err != nil {
				log.Println("[ERROR] " + err.Error())
			}
		},
	)

	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalln(err)
	}
}
