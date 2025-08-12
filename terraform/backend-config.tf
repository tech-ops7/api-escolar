# Configuração do backend para o Terraform
# Este arquivo deve ser usado após a criação inicial do bucket
# 
# Para usar esta configuração:
# terraform init -backend-config=backend-config.tf

terraform {
  backend "gcs" {
    bucket = "terraform-state-api-escolar"
    prefix = "artifact-registry"
  }
}
