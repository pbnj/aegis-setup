package main

import (
	"bufio"
	"crypto/rand"
	"encoding/base64"
	"flag"
	"os"

	//"flag"
	"fmt"
	"github.com/nortonlifelock/config"
	"github.com/nortonlifelock/crypto"
	"github.com/nortonlifelock/database"
	"github.com/nortonlifelock/domain"
	"strings"
)

func main() {
	path := flag.String("path", "", "")
	flag.Parse()

	if len(*path) == 0 {
		panic("must provide a -path flag leading to the application config (app.json)")
	}

	db, appConfig := loadDatabaseConnectionAppConfig(*path)

	reader := bufio.NewReader(os.Stdin)

	createOrganization(reader, appConfig, db)

	fmt.Println("Now let's get your sources setup! We'll start with the essentials")
}

func createOrganization(reader *bufio.Reader, appConfig config.AppConfig, db domain.DatabaseConnection) {
	fmt.Print("Enter the name of your organization: ")
	name := getInput(reader)

	fmt.Print("Enter a shorthand code for the name of your organization: ")
	code := getInput(reader)
	code = strings.ToUpper(code)

	kmsClient, err := crypto.CreateKMSClientWithProfile(appConfig.EncryptionKey(), "")
	check(err)

	encryptedOrganizationKey, err := kmsClient.Encrypt(generateSecureEncryptionKey())
	check(err)

	// {"lowest_ticketed_cvss":4,"cvss_version":2,"severities":[{"name":"Medium","duration":90,"cvss_min":4},{"name":"High","duration":60,"cvss_min":7},{"name":"Critical","duration":30,"cvss_min":9}]"}

	// TODO org payload/encryption Key
	// TODO set AD information
	_, _, err = db.CreateOrganization(code, name, 0, "initializer")
	check(err)

	//db.org

	fmt.Printf("Organization [%s] created", code)
	organization, err := db.GetOrganizationByCode(code)
	check(err)

	_, _ = encryptedOrganizationKey, organization
}

func generateSecureEncryptionKey() (ekey string) {
	b := make([]byte, 32)
	_, err := rand.Read(b)
	check(err)
	ekey = base64.StdEncoding.EncodeToString(b)
	if len(ekey) > 32 {
		ekey = ekey[:32]
	}

	return ekey
}

func loadDatabaseConnectionAppConfig(path string) (db domain.DatabaseConnection, appConfig config.AppConfig) {
	var err error
	appConfig, err = config.LoadConfigByPath(path)
	check(err)
	kmsClient, err := crypto.CreateKMSClientWithProfile(appConfig.EKey, "")
	check(err)
	appConfig.DatabasePassword, err = kmsClient.Decrypt(appConfig.DatabasePassword)
	check(err)
	db, err = database.NewConnection(appConfig)
	check(err)

	return db, appConfig
}

func getInput(reader *bufio.Reader) (userInput string) {
	var err error
	userInput, err = reader.ReadString('\n')
	check(err)

	userInput = strings.TrimSuffix(userInput, "\n")
	return userInput
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}
