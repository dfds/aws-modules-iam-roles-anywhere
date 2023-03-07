package main

import (
	"context"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/rolesanywhere"
	"io"
	"log"
	"net/http"
	"os"
)

func HandleRequest(ctx context.Context) (string, error) {

	// Download Certificate Revocation List
	resp, err := http.Get(os.Getenv("CRL_URL"))
	if err != nil {
		fmt.Println(err.Error())
		return "", err
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err.Error())
		return "", err
	}

	crl, err := x509.ParseRevocationList(body)
	if err != nil {
		fmt.Println(err.Error())
		return "", err
	}

	// Convert CRL to pem format
	crlData := pem.EncodeToMemory(&pem.Block{Type: "X509 CRL", Bytes: crl.Raw})

	err = resp.Body.Close()
	if err != nil {
		fmt.Println(err.Error())
		return "", err
	}

	// Load config
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Fatalf("failed to load configuration, %v", err)
	}

	svc := rolesanywhere.NewFromConfig(cfg)

	// Check if there are any CRLs in the account
	lco, err := svc.ListCrls(ctx, &rolesanywhere.ListCrlsInput{})
	if err != nil {
		fmt.Println(err.Error())
		return "", err
	}

	if len(lco.Crls) > 0 {
		for _, v := range lco.Crls {

			if *v.TrustAnchorArn == *aws.String(os.Getenv("TRUST_ANCHOR_ARN")) {

				fmt.Println("Checking if CRL needs to be updated...")

				if string(v.CrlData) != string(crlData) {

					fmt.Println("Updating CRL...")

					uci := &rolesanywhere.UpdateCrlInput{
						CrlId:   v.CrlId,
						CrlData: crlData,
					}
					_, err := svc.UpdateCrl(ctx, uci)
					if err != nil {
						fmt.Println(err.Error())
						return "", err
					}

					fmt.Println("CRL updated successfully")
				}

				fmt.Println("CRL is up to date")
			}
		}

		return "Success", nil
	}

	// Import CRL
	fmt.Println("Importing CRL")

	ici := &rolesanywhere.ImportCrlInput{
		CrlData:        crlData,
		Name:           aws.String(os.Getenv("CRL_NAME")),
		TrustAnchorArn: aws.String(os.Getenv("TRUST_ANCHOR_ARN")),
		Enabled:        aws.Bool(false),
	}

	ico, err := svc.ImportCrl(ctx, ici)
	if err != nil {
		fmt.Println(err.Error())
		return "", err
	}

	// Enable CRL
	fmt.Println("Enabling CRL")
	eci := rolesanywhere.EnableCrlInput{
		CrlId: ico.Crl.CrlId,
	}

	_, err = svc.EnableCrl(ctx, &eci)
	if err != nil {
		fmt.Println(err.Error())
		return "", err
	}

	return "Success!", nil
}

func main() {
	lambda.Start(HandleRequest)
}
