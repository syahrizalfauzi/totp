package handler

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/pquerna/otp/totp"
)

type ValidateRequest struct {
	Email string `json:"email" binding:"required"`
	Code  string `json:"code" binding:"required"`
}

type ValidateResponse struct {
	IsValid bool `json:"isValid"`
}

func Validate(userMap map[string]string) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Parse the request body
		var requestBody ValidateRequest
		if err := c.ShouldBindJSON(&requestBody); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Check if the email exists in the userMap
		secret, exists := userMap[requestBody.Email]
		if !exists {
			c.JSON(http.StatusNotFound, gin.H{"error": "Email not found"})
			return
		}

		// Validate the TOTP code
		isValid, err := totp.ValidateCustom(requestBody.Code, secret, time.Now(), totp.ValidateOpts{
			Period: 30,
			Digits: 6,
			Skew:   0,
		})
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		if !isValid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid TOTP code"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Validation successful", "data": ValidateResponse{
			IsValid: isValid,
		}})
	}
}
