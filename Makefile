
.PHONY: deploy delete clean info rebuild

deploy:
	bash scripts/deploy_bsides_lab.sh

delete:
	kind delete cluster --name bsides-training

clean:
	kind delete cluster --name bsides-training
	docker system prune -f -a --volumes -f

rebuild: clean deploy

info:
	kubectl cluster-info --context kind-bsides-training
