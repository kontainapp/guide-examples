package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"syscall"
	"time"
)

type Log struct {
}

func handler(w http.ResponseWriter, r *http.Request) {
	l := &Log{}
	l.Info("Kontain Detector received a request.")
	utsname := &syscall.Utsname{}
	if err := syscall.Uname(utsname); err != nil {
		l.Fatalf("Uname failed:%s", err.Error())
		return
	}

	toString := func(f [65]int8) string {
		out := make([]byte, 0, 64)
		for _, v := range f[:] {
			if v == 0 {
				break
			}
			out = append(out, uint8(v))
		}
		return string(out)
	}

	m, _ := json.Marshal(map[string]string{"sysname": toString(utsname.Sysname),
		"nodename": toString(utsname.Nodename),
		"release":  toString(utsname.Release),
		"version":  toString(utsname.Version),
		"machine":  toString(utsname.Machine),
	})

	fmt.Fprintf(w, "%s", string(m))

	l.Info("http handler success")

}

func main() {
	l := &Log{}
	l.Info("Kontain detector started.")

	http.HandleFunc("/", handler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	if err := http.ListenAndServe(fmt.Sprintf(":%s", port), nil); err != nil {
		log.Fatalf("ListenAndServe error:%s ", err.Error())
	}
}

/*
func arrayToString(x [65]int8) string {
	str := ""
	for _, b := range x {
		if (b == 0) {
			break;
		}
		str += string(byte(b))
	}
	return str
}
*/

func (log *Log) Infof(format string, a ...interface{}) {
	log.log("INFO", format, a...)
}

func (log *Log) Info(msg string) {
	log.log("INFO", "%s", msg)
}

func (log *Log) Errorf(format string, a ...interface{}) {
	log.log("ERROR", format, a...)
}

func (log *Log) Error(msg string) {
	log.log("ERROR", "%s", msg)
}

func (log *Log) Fatalf(format string, a ...interface{}) {
	log.log("FATAL", format, a...)
}

func (log *Log) Fatal(msg string) {
	log.log("FATAL", "%s", msg)
}

func (log *Log) log(level, format string, a ...interface{}) {
	var cstSh, _ = time.LoadLocation("Asia/Shanghai")
	ft := fmt.Sprintf("%s %s %s\n", time.Now().In(cstSh).Format("2006-01-02 15:04:05"), level, format)
	fmt.Printf(ft, a...)
}
