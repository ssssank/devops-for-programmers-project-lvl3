### Hexlet tests and linter status:
[![Actions Status](https://github.com/ssssank/devops-for-programmers-project-lvl3/workflows/hexlet-check/badge.svg)](https://github.com/ssssank/devops-for-programmers-project-lvl3/actions)

## Devops project
Infrastructure as a code

Demo: [http://devops-hexlet.lol](http://devops-hexlet.lol)

## Prepare

* `make prepare-tokens`
* Put your tokens to *secrets.auto.tfvars* in *terraform* directory:

```
do_token = ...
pvt_key  = ...
datadog_api_key = ...
datadog_app_key = ...
```

## Installation

```bash
git clone https://github.com/ssssank/devops-for-programmers-project-lvl3.git
# Prepare infrastructure
make init
make apply
# Prepare project
make setup
# Deploy project
make deploy
```
