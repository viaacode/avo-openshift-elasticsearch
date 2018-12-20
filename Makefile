PROJECT=avo-elasticsearch
WD=/tmp
REPO_URI=https://github.com/viaacode/avo-openshift-elasticsearch.git
GIT_NAME=avo-openshift-elasticsearch
APP_NAME=elasticsearch
TOKEN=`oc whoami -t`
path_to_oc=`which oc`
.ONESHELL:
SHELL = /bin/bash
.PHONY:	all
check-env:
OC_PROJECT=${PROJECT}
ifndef BRANCH
  $(error BRANCH is undefined)
endif

commit:
	git add .
	git commit -a
	git push
checkTools:
	if [ -x "${path_to_executable}" ]; then  echo "OC tools found here: ${path_to_executable}"; else echo please install the oc tools: https://github.com/openshiftorigin/releases/tag/v3.9.0; fi; uname && netstat | grep docker| grep -e CONNECTED  1> /dev/null || echo docker not running or not using linux
login:	check-env
	oc login do-prd-okp-m0.do.viaa.be:8443
	oc new-project "${OC_PROJECT}" || oc project "${OC_PROJECT}"
	sleep 4 && oc new-project "${OC_PROJECT}" || oc project "${OC_PROJECT}"
	oc adm policy add-scc-to-user privileged -n${OC_PROJECT} -z default

clone:
	cd /tmp && git clone  --single-branch -b ${BRANCH} "${REPO_URI}" 
deploy:
	oc create -f avo-indexer-tmpl.yaml
	oc create -f es-cluster-tmpl.yaml
clean:
	rm -rf /tmp/${GIT_NAME}
all:	clean commit login deploy  clone  clean

