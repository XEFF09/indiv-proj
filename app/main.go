package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"

	"github.com/XEFF09/decauth-be/setup"
)

func initApp() *fiber.App {
	app := fiber.New()
	// TODO:
	cfg := setup.NewConfig()
	db := setup.NewDB(&cfg)
	// ctx := ctx.ProvideContext()

	app.Use(logger.New())

	app.Use(cors.New(cors.Config{
		AllowOrigins: "http://localhost:3000", // Allow requests from the frontend
		AllowMethods: "GET,POST,PUT,DELETE",   // Allow specific HTTP methods
		AllowHeaders: "Content-Type,Authorization",
	}))

	apiRoute := app.Group("/api")
	apiRoute.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("decauth is running 🚀")
	})
	apiRoute.Get("/db", func(c *fiber.Ctx) error {
		// test database connection

		dbConn, err := db.DB()
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": err.Error(),
			})
		}
		return c.Status(fiber.StatusOK).JSON(fiber.Map{
			"message": "✅ Database connection is successful",
			"data":    dbConn.Stats(),
		})
	})

	// oauthRepoFactory := repository.NewOAuthRepositoryFactory()
	// oauthRepoFactory.Register("google", oauth.NewGoogleOAuthRepository(&cfg))
	//
	// userRepo := gorm.NewUserGormRepository(db)
	// userUsecase := usecase.NewUserUsecase(userRepo)
	// _userHandler := rest.NewUserHandler(userUsecase)
	//
	// authUsecase := usecase.NewAuthUsecase(userRepo, &oauthRepoFactory, &cfg, minioRepo, ctx)
	// authHandler := rest.NewAuthHandler(authUsecase)
	//
	//
	// authRoute := app.Group("/auth")
	// authRoute.Post("/login", authHandler.LoginWithCredentials)
	// authRoute.Post("/login/oauth", authHandler.LoginWithOAuth)
	// authRoute.Post("/register", authHandler.Register)

	return app
}

func main() {
	app := initApp()
	app.Listen(":9090")
}
