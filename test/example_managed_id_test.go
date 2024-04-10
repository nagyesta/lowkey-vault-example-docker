package test

import (
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/policy"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/tracing"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/security/keyvault/azcertificates"
	"github.com/Azure/azure-sdk-for-go/sdk/security/keyvault/azkeys"
	"github.com/Azure/azure-sdk-for-go/sdk/security/keyvault/azsecrets"
	"testing"
)

func TestMISecret(t *testing.T) {
	//given
	httpClient := prepareClient()
	cred, _ := azidentity.NewDefaultAzureCredential(nil) // Will use Managed Identity via the Assumed Identity container
	client, _ := azsecrets.NewClient("https://localhost:8443",
		cred,
		&azsecrets.ClientOptions{ClientOptions: struct {
			APIVersion                      string
			Cloud                           cloud.Configuration
			InsecureAllowCredentialWithHTTP bool
			Logging                         policy.LogOptions
			Retry                           policy.RetryOptions
			Telemetry                       policy.TelemetryOptions
			TracingProvider                 tracing.Provider
			Transport                       policy.Transporter
			PerCallPolicies                 []policy.Policy
			PerRetryPolicies                []policy.Policy
		}{Transport: &httpClient}, DisableChallengeResourceVerification: true})

	//when
	value := secret(client, "secret-name")

	//then
	if value != "It worked!" {
		t.Errorf("got %q, wanted %q", value, "It worked!")
	}
}

func TestMIKeys(t *testing.T) {
	//given
	httpClient := prepareClient()
	cred, _ := azidentity.NewDefaultAzureCredential(nil) // Will use Managed Identity via the Assumed Identity container
	client, _ := azkeys.NewClient("https://localhost:8443",
		cred,
		&azkeys.ClientOptions{ClientOptions: struct {
			APIVersion                      string
			Cloud                           cloud.Configuration
			InsecureAllowCredentialWithHTTP bool
			Logging                         policy.LogOptions
			Retry                           policy.RetryOptions
			Telemetry                       policy.TelemetryOptions
			TracingProvider                 tracing.Provider
			Transport                       policy.Transporter
			PerCallPolicies                 []policy.Policy
			PerRetryPolicies                []policy.Policy
		}{Transport: &httpClient}, DisableChallengeResourceVerification: true})

	//when
	rsaKeyName := latestVersionOfKey(client, "rsa-key").KID.Name()
	ecKeyName := latestVersionOfKey(client, "ec-key").KID.Name()
	octKeyName := latestVersionOfKey(client, "oct-key").KID.Name()

	//then
	if rsaKeyName != "rsa-key" {
		t.Errorf("got %q, wanted %q", rsaKeyName, "rsa-key")
	}
	if ecKeyName != "ec-key" {
		t.Errorf("got %q, wanted %q", rsaKeyName, "ec-key")
	}
	if octKeyName != "oct-key" {
		t.Errorf("got %q, wanted %q", rsaKeyName, "oct-key")
	}
}

func TestMICertificates(t *testing.T) {
	//given
	httpClient := prepareClient()
	cred, _ := azidentity.NewDefaultAzureCredential(nil) // Will use Managed Identity via the Assumed Identity container
	client, _ := azcertificates.NewClient("https://localhost:8443",
		cred,
		&azcertificates.ClientOptions{ClientOptions: struct {
			APIVersion                      string
			Cloud                           cloud.Configuration
			InsecureAllowCredentialWithHTTP bool
			Logging                         policy.LogOptions
			Retry                           policy.RetryOptions
			Telemetry                       policy.TelemetryOptions
			TracingProvider                 tracing.Provider
			Transport                       policy.Transporter
			PerCallPolicies                 []policy.Policy
			PerRetryPolicies                []policy.Policy
		}{Transport: &httpClient}, DisableChallengeResourceVerification: true})

	//when
	rsaCert := latestVersionOfCertificate(client, "rsa-cert")

	//then
	if *rsaCert.KeyProperties.KeyType != azcertificates.KeyTypeRSA {
		t.Errorf("got %q, wanted %q", *rsaCert.KeyProperties.KeyType, "RSA")
	}
	if *rsaCert.X509CertificateProperties.Subject != "CN=example.com" {
		t.Errorf("got %q, wanted %q", *rsaCert.X509CertificateProperties.Subject, "CN=example.com")
	}
	if *rsaCert.SecretProperties.ContentType != "application/x-pkcs12" {
		t.Errorf("got %q, wanted %q", *rsaCert.SecretProperties.ContentType, "application/x-pkcs12")
	}
}
