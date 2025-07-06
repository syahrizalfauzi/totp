package main

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/syahrizalfauzi/totp/service/handler"
)

var userMap map[string]string // This map is used to store user data in memory for demonstration purposes.

func main() {
	userMap = make(map[string]string)

	r := gin.Default()
	r.Use(cors.Default())

	r.POST("/enroll", handler.Enroll(userMap))
	r.POST("/validate", handler.Validate(userMap))
	r.Run()
}
