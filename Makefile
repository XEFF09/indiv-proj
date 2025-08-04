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

kube-vol-d:
	@ kubectl delete pvc --all -n database-space
	@ kubectl delete pv --all 

kube-db-d:
	@ kubectl delete all --all -n database-space

kube-be-d:
	@ kubectl delete all --all -n backend-space

kube-cm-d:
	@kubectl delete configmap --all --all-namespaces

kup:
	@ echo "Deploy: namespace"
	@ kubectl apply -f ./infra/k8s/overlays/namespace.yml
	@ echo "Deploy: configmaps & app"
	@ kubectl apply -k ./infra/k8s/.
	@ kubectl apply -f ./infra/k8s/ingress.yml

kdown: kube-be-d kube-db-d

kdown-v: kdown kube-vol-d kube-cm-d

.PHONY: kdesc

kdesc:
	@ kubectl describe pod $(id) -n $(n)
