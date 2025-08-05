build:
	@ echo "Building application... "
	@ go build -trimpath -o ./bin/engine ./app/
	@ echo "Done!"

build-migrate:
	@ echo "Building migrate... "
	@ go build -trimpath -o ./bin/migrate ./command/migrate.db.go
	@ echo "Done!"

.PHONY: build-image follow migrate

build-image:
	@ echo "Bualding docker image..."
	@ docker build \
		--file ./infra/docker/prod.Dockerfile \
		--tag $(AUTHOR)/$(PROJ) \
		.
	@ echo "Done!"

up:
	@ docker compose up

follow:
	@ docker logs $(PROJ)-app-1 --follow

migrate:
	@ docker exec -it $(PROJ)-app-1 go run ./command/migrate.db.go 
