ANTHROPIC_MODEL='claude-3-5-haiku-20241022'
ANTHROPIC_SMALL_FAST_MODEL='claude-3-haiku-20240307'
DOCKER_HOST="unix://${XDG_CONFIG_HOME}/default/docker.sock"

alias terraform_prod="export GOOGLE_BACKEND_CREDENTIALS=\"$HOME/.config/gcloud/terraform-remote-state-credentials.json\" && export GOOGLE_APPLICATION_CREDENTIALS=\"$HOME/.config/gcloud/terraform-admin-credentials-prod.json\""
alias terraform_dev="export GOOGLE_BACKEND_CREDENTIALS=\"$HOME/.config/gcloud/terraform-remote-state-credentials.json\" && export GOOGLE_APPLICATION_CREDENTIALS=\"$HOME/.config/gcloud/terraform-admin-credentials-dev.json\""
