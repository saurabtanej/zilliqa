# zilliqa
Zilliqa Infra Environment. 

The repo consist of Infra as a code for Zilliqa infrastructure. The repo is using terragrunt [https://terragrunt.gruntwork.io/] to keep the configuration DRY along with terraform to setup the infrastructure. 
Infrastructure is broken into different states deliberately to keep self sufficent teams in mind so the repo is open for collaboration from the organisation and one bad configuration do not lead to catastrophic effect of breaking other changes. 

It has setup state which needs to be run first so k8s state and services state can read from it. 

Although, once setup is completed, we should run all pipelines together and hence the pipelines are configured in such a way. 

Readme of all states are also updated. 

This repo also consist of different workflows for auto auto applying the changes when merged. And it also has a pipeline for deploying an app (knote for testing). 
