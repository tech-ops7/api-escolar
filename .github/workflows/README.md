# GitHub Actions - Pipeline GCP

Este diretório contém os workflows do GitHub Actions para automatizar o build e deploy da API Escolar no Google Cloud Platform.

## Workflows Disponíveis

### `build-and-push-gcp.yaml`

Pipeline principal que:
1. Constrói a imagem Docker da aplicação
2. Envia a imagem para o Artifact Registry do GCP
3. Faz deploy automático em ambiente de preview para Pull Requests

### `deploy-production.yaml`

Pipeline de produção que:
1. É acionado quando uma tag de versão é criada (ex: `v1.0.0`)
2. Faz deploy da versão específica em produção
3. Cria um GitHub Release automaticamente

## Configuração dos Secrets

Para que o pipeline funcione corretamente, você precisa configurar os seguintes secrets no repositório GitHub:

### 1. Acesse as configurações do repositório
- Vá para `Settings` > `Secrets and variables` > `Actions`
- Clique em `New repository secret`

### 2. Configure os secrets necessários

#### `GCP_PROJECT_ID`
- **Descrição**: ID do projeto no Google Cloud Platform
- **Exemplo**: `meu-projeto-123456`

#### `GCP_REGION`
- **Descrição**: Região do GCP onde estão os recursos
- **Exemplo**: `us-central1`, `southamerica-east1`

#### `GCP_SA_KEY`
- **Descrição**: Chave JSON da Service Account do GCP
- **Como obter**:
  1. No Console do GCP, vá para `IAM & Admin` > `Service Accounts`
  2. Crie uma nova Service Account ou use uma existente
  3. Adicione as seguintes roles:
     - `Artifact Registry Writer`
     - `Kubernetes Engine Developer` (se usar GKE)
     - `Storage Object Viewer` (se usar Cloud Storage)
  4. Crie uma nova chave JSON
  5. Copie todo o conteúdo do arquivo JSON gerado

#### `GKE_CLUSTER_NAME` (opcional)
- **Descrição**: Nome do cluster GKE para deploy automático
- **Exemplo**: `api-escolar-cluster`
- **Nota**: Só necessário se você quiser deploy automático em Pull Requests

## Como Configurar a Service Account

### 1. Criar a Service Account
```bash
gcloud iam service-accounts create github-actions \
    --description="Service account for GitHub Actions" \
    --display-name="GitHub Actions"
```

### 2. Atribuir as permissões necessárias
```bash
# Projeto ID
PROJECT_ID="seu-projeto-id"

# Artifact Registry
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.writer"

# GKE (se usar)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.developer"

# Cloud Storage (se usar)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.objectViewer"
```

### 3. Criar e baixar a chave JSON
```bash
gcloud iam service-accounts keys create ~/github-actions-key.json \
    --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com
```

## Triggers do Pipeline

Os pipelines são executados automaticamente quando:

### build-and-push-gcp.yaml:
- **Push** para as branches `main` ou `develop`
- **Pull Request** para a branch `main`
- **Manual** através do `workflow_dispatch`

### deploy-production.yaml:
- **Push de tag** com padrão `v*` (ex: `v1.0.0`, `v2.1.3`)

## Estrutura do Pipeline

### Job: `build-and-push`
1. **Checkout**: Baixa o código do repositório
2. **Setup Docker**: Configura o Docker Buildx para builds multi-plataforma
3. **Auth GCP**: Autentica no Google Cloud
4. **Configure Docker**: Configura o Docker para usar o Artifact Registry
5. **Extract Metadata**: Extrai metadados para tagging automático
6. **Build & Push**: Constrói e envia a imagem Docker

### Job: `deploy-preview` (apenas em PRs)
1. **Auth GCP**: Autentica no Google Cloud
2. **Setup kubectl**: Configura o kubectl
3. **Get GKE Credentials**: Obtém credenciais do cluster GKE
4. **Deploy**: Faz deploy da nova imagem
5. **Comment PR**: Comenta no PR com informações do deploy

### Job: `deploy-production` (apenas em tags)
1. **Auth GCP**: Autentica no Google Cloud
2. **Setup kubectl**: Configura o kubectl
3. **Get GKE Credentials**: Obtém credenciais do cluster GKE
4. **Deploy Production**: Faz deploy da versão específica em produção
5. **Create Release**: Cria um GitHub Release automaticamente

## Tags Geradas Automaticamente

O pipeline gera automaticamente as seguintes tags para as imagens:

- `latest` (apenas na branch principal)
- `main` (para commits na branch main)
- `develop` (para commits na branch develop)
- `pr-123` (para Pull Request #123)
- `v1.2.3` (para tags de versão)
- `main-abc123` (commit SHA com prefixo da branch)

## Exemplo de Uso

Após configurar os secrets, os pipelines funcionarão automaticamente:

1. **Push para main**: Constrói e envia a imagem com tag `latest`
2. **Pull Request**: Constrói a imagem e faz deploy em ambiente de preview
3. **Tag de versão**: Faz deploy da versão específica em produção e cria GitHub Release

## Troubleshooting

### Erro de autenticação
- Verifique se o `GCP_SA_KEY` está correto
- Confirme se a Service Account tem as permissões necessárias

### Erro de Artifact Registry
- Verifique se o repositório `api-escolar-repo` existe
- Confirme se a região está correta

### Erro de GKE
- Verifique se o cluster existe e está acessível
- Confirme se o namespace `api-escolar` existe
- Verifique se o deployment `api-escolar` existe
