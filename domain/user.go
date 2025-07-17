package domain

import "gorm.io/gorm"

type User struct {
	gorm.Model
	Username string    `gorm:"size:50;not null"`
	Email    string    `gorm:"unique";not null`
	Password *string   `gorm:"size:255" json:"-"`
	Accounts []Account `gorm:"foreignKey:UserID"`
}
