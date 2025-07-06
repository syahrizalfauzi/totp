# TOTP Demo

## Service
This is a simple TOTP backend service with Go that provides an API to generate and verify TOTP tokens.
The service uses the `github.com/pquerna/otp` package to handle TOTP generation and verification.
### Endpoints
- `POST /enroll`: Generates a TOTP secret with a given email that's saved in a memory and returns it in the response.
- `POST /validate`: Validates a TOTP token against a given secret and email.

## Authenticator
This one is the authenticator app made with Flutter, which uses the `totp` package to generate TOTP tokens.
### Pages
- `Enroll`: Allows the user to enter their email and generate a TOTP secret.
- `TOTP`: Shows the TOTP token for the given secret and allows the user to validate it against the backend service.

