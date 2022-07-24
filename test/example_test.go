package test

import (
	"context"
	"crypto/tls"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/policy"
	"github.com/Azure/azure-sdk-for-go/sdk/keyvault/azkeys"
	"github.com/Azure/azure-sdk-for-go/sdk/keyvault/azsecrets"
	"log"
	"net/http"
	"testing"
	"time"
)

func TestSecret(t *testing.T) {
	//given
	httpClient := prepareClient()
	client := azsecrets.NewClient("https://localhost:8443",
		&FakeCredential{},
		&policy.ClientOptions{Transport: &httpClient})

	//when
	value := secret(client, "secret-name")

	//then
	if value != "It worked!" {
		t.Errorf("got %q, wanted %q", value, "It worked!")
	}
}

func TestKeys(t *testing.T) {
	//given
	httpClient := prepareClient()
	client := azkeys.NewClient("https://localhost:8443",
		&FakeCredential{},
		&policy.ClientOptions{Transport: &httpClient})

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

func secret(client *azsecrets.Client, name string) string {
	resp, err := client.GetSecret(context.TODO(), name, "", nil)
	if err != nil {
		log.Fatalf("failed to get the secret: %v", err)
	}

	return *resp.Value
}

func latestVersionOfKey(client *azkeys.Client, name string) *azkeys.JSONWebKey {
	key, err := client.GetKey(context.TODO(), name, "", nil)
	if err != nil {
		log.Fatalf("failed to get key: %v", err)
	}
	return key.Key
}

/*
	Ignore SSL error caused by the self-signed certificate.
*/
func prepareClient() http.Client {
	customTransport := http.DefaultTransport.(*http.Transport).Clone()
	customTransport.TLSClientConfig = &tls.Config{InsecureSkipVerify: true}
	return http.Client{Transport: customTransport}
}

/*
	Fake token used for bypassing the fake authentication of Lowkey Vault
*/
type FakeCredential struct{}

//goland:noinspection GoUnusedParameter
func (f *FakeCredential) GetToken(ctx context.Context, options policy.TokenRequestOptions) (azcore.AccessToken, error) {
	return azcore.AccessToken{Token: "faketoken", ExpiresOn: time.Now().Add(time.Hour).UTC()}, nil
}
