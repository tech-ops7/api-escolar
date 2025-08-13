# # Configuração do bucket para o backend do Terraform
# # Este bucket será usado para armazenar o state file

# # Habilitar a API do Cloud Storage
# resource "google_project_service" "storage" {
#   project = var.project_id
#   service = "storage.googleapis.com"

#   disable_dependent_services = true
#   disable_on_destroy         = false
# }

# # Criar o bucket para o state do Terraform
# resource "google_storage_bucket" "terraform_state" {
#   name          = "terraform-state-api-escolar"
#   location      = var.region
#   force_destroy = false

#   # Configurações de versionamento para backup
#   versioning {
#     enabled = true
#   }

#   # Configurações de lifecycle para manter apenas as últimas versões
#   lifecycle_rule {
#     condition {
#       age = 30  # Manter por 30 dias
#     }
#     action {
#       type = "Delete"
#     }
#   }

#   # Configurações de uniform bucket-level access
#   uniform_bucket_level_access = true

#   # Configurações de proteção contra exclusão acidental
#   lifecycle {
#     prevent_destroy = true
#   }

#   depends_on = [google_project_service.storage]
# }

# # Configurar permissões IAM para o bucket
# resource "google_storage_bucket_iam_member" "terraform_state_admin" {
#   bucket = google_storage_bucket.terraform_state.name
#   role   = "roles/storage.admin"
#   member = "serviceAccount:${var.service_account_email}"
# }

# resource "google_storage_bucket_iam_member" "terraform_state_object_viewer" {
#   bucket = google_storage_bucket.terraform_state.name
#   role   = "roles/storage.objectViewer"
#   member = "serviceAccount:${var.service_account_email}"
# }

# resource "google_storage_bucket_iam_member" "terraform_state_object_creator" {
#   bucket = google_storage_bucket.terraform_state.name
#   role   = "roles/storage.objectCreator"
#   member = "serviceAccount:${var.service_account_email}"
# }
