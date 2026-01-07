🚀 Desafio DevOps Avançado – Plataforma Cloud Native Segura
🎯 Objetivo

Projetar, implementar e documentar uma plataforma de entrega contínua (CI/CD + GitOps) para uma aplicação cloud-native, garantindo segurança, observabilidade, alta disponibilidade e automação completa.

🧱 Cenário

Você trabalha em uma empresa SaaS que está migrando para Kubernetes.
A aplicação é composta por microserviços e precisa atender requisitos rígidos de segurança, confiabilidade e escalabilidade.

📦 Stack obrigatória

Você pode adaptar, mas o ideal é usar:

Cloud: GCP ou AWS

Kubernetes (GKE ou EKS)

Terraform (infra modular)

ArgoCD (GitOps)

CI: GitHub Actions ou Azure DevOps

Container Registry

Vault (ou alternativa segura)

Helm ou Kustomize

Ingress Controller (Traefik ou NGINX)

Observabilidade: Prometheus + Grafana

Segurança: Trivy + TruffleHog

🧩 Requisitos Técnicos
1️⃣ Infraestrutura (IaC)

Criar infraestrutura 100% via Terraform

Cluster Kubernetes HA

VPC com:

Subnets públicas e privadas

NAT Gateway

State remoto e seguro

Separação por ambientes: dev, staging, prod

2️⃣ Kubernetes

Deploy de pelo menos 2 microserviços

Uso de:

Requests e Limits

HPA

PodDisruptionBudget

Secrets nunca hardcoded

Ingress com TLS

3️⃣ GitOps

Repositório separado para manifests

ArgoCD:

Sync automático

Health checks

Rollback funcional

Estratégia de promoção entre ambientes

4️⃣ CI Pipeline

Pipeline deve:

Buildar imagem

Rodar testes

Scan de segurança:

Trivy (imagem)

TruffleHog (secrets)

Push da imagem

Atualizar manifests GitOps automaticamente

5️⃣ Segurança

Secrets gerenciados via:

Vault (Kubernetes Auth) ou

External Secrets

RBAC restritivo

NetworkPolicy aplicada

Scan contínuo de vulnerabilidades

6️⃣ Observabilidade

Métricas customizadas da aplicação

Dashboards no Grafana

Alertas básicos (CPU, memória, erro 5xx)

📚 Entregáveis

Repositório Git (ou monorepo organizado)

README.md com:

Arquitetura

Decisões técnicas

Fluxo CI/CD

Diagrama (pode ser draw.io)

Evidências:

Prints do ArgoCD

Pipeline executando

Dashboard do Grafana