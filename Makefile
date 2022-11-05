init:
	terraform -chdir=terraform init

plan:
	terraform -chdir=terraform plan

apply:
	terraform -chdir=terraform apply

destroy:
	terraform -chdir=terraform destroy

output:
	terraform -chdir=terraform output
