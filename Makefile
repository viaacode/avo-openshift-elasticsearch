PROJECT=sc-avo2
WD=/tmp
REPO_URI=https://github.com/viaacode/avo-openshift-elasticsearch.git
GIT_NAME=avo-openshift-elasticsearch
$APP_NAME=es
TOKEN=`oc whoami -t`
path_to_oc=`which oc`
ES_VERSION=6.6.0
oc_registry=docker-registry-default.apps.do-prd-okp-m0.do.viaa.be
ENDPOINT=`oc project | awk '{print $6}'| cut -d '"' -f 2`
APP_NAME=es
.ONESHELL:
SHELL = /bin/bash
.PHONY:	all
check-env:
OC_PROJECT=${PROJECT}
ifndef BRANCH
#  $(error BRANCH is undefined)
BRANCH=master
endif
ENV=qas
TAG=`git describe --tags`

# LOGIN

commit:
	git add .
	git commit -a
	git push
checkTools:
	if [ -x "${path_to_executable}" ]; then  echo "OC tools found here: ${path_to_executable}"; else echo please install the oc tools: https://github.com/openshiftorigin/releases/tag/v3.9.0; fi; uname && netstat | grep docker| grep -e CONNECTED  1> /dev/null || echo docker not running or not using linux
login:	check-env
	sh login_oc.sh ${ENDPOINT}
	#docker login -p "${TOKEN}" -u unused ${oc_registry}
	oc new-project "${OC_PROJECT}" || oc project "${OC_PROJECT}"
	sleep 4 && oc new-project "${OC_PROJECT}" || oc project "${OC_PROJECT}"
	oc adm policy add-scc-to-user privileged -n${OC_PROJECT} -z default

clone:
	cd /tmp && git clone  --single-branch -b ${BRANCH} "${REPO_URI}" 
buildimage:
	cd /tmp/${GIT_NAME}
	docker build -t ${oc_registry}/${OC_PROJECT}/${APP_NAME}:${TAG} .

deploy:
	oc apply -f avo-indexer-tmpl.yaml
	oc apply -f es-cluster-tmpl.yaml
	oc apply -f asset-api-tmpl.yaml
clean:
	rm -rf /tmp/${GIT_NAME}
all:	clean commit clone buildimage  clean

