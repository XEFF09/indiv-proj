package main

import (
	"log"

	"github.com/XEFF09/decauth-be/domain"
	"github.com/XEFF09/decauth-be/setup"
)

func main() {
	cfg := setup.NewConfig()
	db := setup.NewDB(&cfg)

	if err := db.AutoMigrate(
		&domain.User{},
		&domain.Account{},
	); err != nil {
		log.Fatal(err)
	}

	log.Println("🚀 Migration completed")
}
