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

setup:
	ansible-galaxy install -r ansible/requirements.yml
	ansible-playbook --vault-password-file vault_password_file ansible/setup.yml -i ansible/inventory.ini

deploy:
	ansible-playbook --vault-password-file vault_password_file ansible/deploy.yml -i ansible/inventory.ini

encrypt-vault:
	ansible-vault encrypt ansible/group_vars/webservers/vault.yml

edit-vault:
	ansible-vault edit ansible/group_vars/webservers/vault.yml
