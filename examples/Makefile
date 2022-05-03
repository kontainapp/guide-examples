build: buildgo buildjava buildjs buildpython

test: testgo testjava testjs testpython

push: pushgo pushjava pushjs pushpython

deployk8s: deploysk8sgo deployk8sjava deployk8sjs deployk8spython

testk8s: testk8sgo testk8sjava testk8sjs testk8spython

buildjava:
	make -C java/spring-boot-hello build

buildgo:
	make -C go/golang-http-hello build

buildjs:
	make -C js/node-express-hello build

buildpython:
	make -C python/py-flask-hello build

testjava:
	make -C java/spring-boot-hello test

testgo:
	make -C go/golang-http-hello test

testjs:
	make -C js/node-express-hello test

testpython:
	make -C python/py-flask-hello test

pushjava:
	make -C java/spring-boot-hello push

pushgo:
	make -C go/golang-http-hello push

pushjs:
	make -C js/node-express-hello push

pushpython:
	make -C python/py-flask-hello push

deployk8sjava:
	make -C java/spring-boot-hello deployk8s

deployk8sgo:
	make -C go/golang-http-hello deployk8s

deployk8sjs:
	make -C js/node-express-hello deployk8s

deployk8spython:
	make -C python/py-flask-hello deployk8s

testk8sjava:
	make -C java/spring-boot-hello testk8s

testk8sgo:
	make -C go/golang-http-hello testk8s

testk8sjs:
	make -C js/node-express-hello testk8s

testk8spython:
	make -C python/py-flask-hello testk8s

kindcluster:
	make -C common -f kind.mk kindcluster kindcluster-apply-km
	sleep 20

kindcluster-clean:
	make -C common -f kind.mk kindcluster-clean