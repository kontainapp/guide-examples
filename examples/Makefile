examplestest: build test kindcluster-clean kindcluster-up deployk8s testk8s kindcluster-clean

aks: akscluster-up deployk8sgo testk8sgo akscluster-clean

gke: gkecluster-up deployk8sgo testk8sgo gkecluster-clean

eks: ekscluster-up deployk8sgo testk8sgo ekscluster-clean

build: buildgo buildjava buildjs buildpython

test: testgo testjava testjs testpython

push: pushgo pushjava pushjs pushpython

deployk8s: deployk8sgo deployk8sjava deployk8sjs deployk8spython

testk8s: testk8sgo testk8sjava testk8sjs testk8spython

buildjava:
	make -C java/spring-boot-hello build

buildgo:
	make -C go/golang-http-hello build

buildjs:
	make -C js/node-express-hello build

buildpython:
	make -C python/py-flask-hello build
	make -C python/fastapi-hello build

testjava:
	make -C java/spring-boot-hello test

testgo:
	make -C go/golang-http-hello test

testjs:
	make -C js/node-express-hello test

testpython:
	make -C python/py-flask-hello test
	make -C python/fastapi-hello test

pushjava:
	make -C java/spring-boot-hello push

pushgo:
	make -C go/golang-http-hello push

pushjs:
	make -C js/node-express-hello push

pushpython:
	make -C python/py-flask-hello push
	make -C python/fastapi-hello push

deployk8sjava:
	make -C java/spring-boot-hello deployk8s

deployk8sgo:
	make -C go/golang-http-hello deployk8s

deployk8sjs:
	make -C js/node-express-hello deployk8s

deployk8spython:
	make -C python/py-flask-hello deployk8s
	make -C python/fastapi-hello deployk8s

testk8sjava:
	make -C java/spring-boot-hello testk8s

testk8sgo:
	make -C go/golang-http-hello testk8s

testk8sjs:
	make -C js/node-express-hello testk8s

testk8spython:
	make -C python/py-flask-hello testk8s
	make -C python/fastapi-hello testk8s

kindcluster-up:
	make -C ../infra -f infra.mk kindcluster kindcluster-apply-km
	sleep 20

kindcluster-clean:
	make -C ../infra -f infra.mk kindcluster-clean

akscluster-up:
	make -C ../infra -f infra.mk akscluster akscluster-apply-km

akscluster-clean:
	make -C ../infra -f infra.mk akscluster-clean

gkecluster-up:
	make -C ../infra -f infra.mk gkecluster gkecluster-apply-kkm

gkecluster-clean:
	make -C ../infra -f infra.mk gkecluster-clean

ekscluster-up:
	make -C ../infra -f infra.mk ekscluster ekscluster-apply-kkm

ekscluster-clean:
	make -C ../infra -f infra.mk ekscluster-clean