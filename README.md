# AVO-elasticsearch-cluster with matchbox plugin
Elasticsearch (6.4.2) cluster on top of Kubernetes made easy.


## Setup
### Openshift project setup
- Edit the Makefile , eg to set the kubernetes namespace 
- running the make file will setup the project and install the templates to deploy the cluster and application
```
BRANCH=master make all

```
### templates setup
- login to the openshift cluster
- import the templates select from project:
  - for each env add a es cluster and indexer app and fill in the params
