build:
	@ echo "Building application... "
	@ go build -trimpath -o ./bin/engine ./app/
	@ echo "Done!"

build-migrate:
	@ echo "Building migrate... "
	@ go build -trimpath -o ./bin/migrate ./command/migrate.db.go
	@ echo "Done!"

build-image:
	@ echo "Bualding docker amage..."
	@ docker build \
		--file ./infra/docker/prod.Dockerfile \
		--tag xeff09/decauth-be \
		.
	@ echo "Done!"

# container env (default)

up:
	@ docker compose up

follow:
	@ docker logs decauth-app-1 --follow

migrate:
	@ docker exec -it decauth-app-1 go run ./command/migrate.db.go 

# k8s

kube-env-a:
	@ kubectl kustomize ./infra/.
	@ kubectl apply -k ./infra/.

kube-dep-a:
	@ kubectl apply -k ./infra/k8s/gofiber/base/.
	@ kubectl apply -k ./infra/k8s/postgres/base/.

.PHONY: kube-vol-d

kube-vol-d:
	@kubectl delete pvc -l owner-namespace=$(ns)-volumes
	@kubectl delete pv -l owner-namespace=$(ns)-volumes

kup: kube-env-a kube-dep-a

kdown:
	@ kubectl delete all --all

kdown-v: down kube-vol-d
