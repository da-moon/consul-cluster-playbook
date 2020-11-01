DELAY:=5
# container specific vars
PRIVILEGED_CONTAINER_SUPPORT:=true
LXC_IMAGE:=images:debian/buster
CONTAINER_COUNT:=3

# ansible specific

STAGING_VAULT_PASSWORD_FILE=~/.vault_pass.txt
VAULT_PASSWORD_FILE=~/.gcloud_vault_pass.txt