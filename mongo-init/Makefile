harbor=example.lijiaocn.com
account=lijiaocn
mongo-init:
	docker build -t ${harbor}/${account}/$@:latest  .
push: mongo-init login
	docker push ${harbor}/${account}/$<:latest
login:
	docker login ${harbor}
