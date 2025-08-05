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
