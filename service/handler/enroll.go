package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/pquerna/otp"
	"github.com/pquerna/otp/totp"
)

type EnrollRequest struct {
	Email string `json:"email" binding:"required"`
}

type EnrollResponse struct {
	Secret string `json:"secret"`
	Email  string `json:"email"`
}

func Enroll(userMap map[string]string) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Parse the request body
		var requestBody EnrollRequest
		if err := c.ShouldBindJSON(&requestBody); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Check if the email already exists in the userMap
		if _, exists := userMap[requestBody.Email]; exists {
			c.JSON(http.StatusConflict, gin.H{"error": "Email already exists"})
			return
		}

		// Store the email in the userMap
		key, err := totp.Generate(totp.GenerateOpts{
			Issuer:      Issuer,
			AccountName: requestBody.Email,
			Algorithm:   otp.AlgorithmSHA1,
		})
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate TOTP key"})
			return
		}
		secret := key.Secret()
		userMap[requestBody.Email] = secret

		c.JSON(http.StatusOK, gin.H{"message": "Enrollment successful", "data": EnrollResponse{
			Secret: secret,
			Email:  requestBody.Email,
		}})
	}
}
