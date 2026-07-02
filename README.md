# GitOps Autorisatie Platform — Proof of Concept

> Proof of Concept voor een GitOps-gebaseerd autorisatieplatform binnen een bankcontext. Dit platform stuurt GitLab, Harbor en Kubernetes aan via een centrale autorisatielaag op basis van OpenFGA, met Terraform als provisioning tool en GitOps als operationeel model.

## Architectuur Overzicht

```
┌─────────────────────────────────────────────────────────────┐
│                      Identity Layer                          │
│              Dex IdP (LDAP → OIDC bridge)                    │
└──────────────────────────┬──────────────────────────────────┘
                           │ OIDC tokens
┌──────────────────────────▼──────────────────────────────────┐
│                  Authorization Layer                         │
│              OpenFGA (ReBAC, Zanzibar)                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Tenants    │  │    Roles     │  │ Permissions  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└──────────────────────────┬──────────────────────────────────┘
                           │ Terraform
┌──────────────────────────▼──────────────────────────────────┐
│                  Platform Resources                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────────┐  │
│  │  GitLab  │  │  Harbor  │  │     Kubernetes           │  │
│  │ Groepen  │  │ Projecten│  │  Namespaces / RBAC       │  │
│  │ Projecten│  │  Leden   │  │  Quotas / NetPol         │  │
│  └──────────┘  └──────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ▲
┌──────────────────────────┴──────────────────────────────────┐
│                   GitOps Control Plane                       │
│  Git Repo → CI/CD (GitHub Actions) → Terraform → APIs       │
└─────────────────────────────────────────────────────────────┘
```

## Componenten

| Component | Technologie | Rol |
|-----------|-------------|-----|
| Identity Provider | Dex IdP | LDAP → OIDC vertaling |
| Authorization Engine | OpenFGA | Relationship-Based Access Control (ReBAC) |
| Provisioning | Terraform | Infrastructure-as-Code voor RBAC |
| GitOps | GitHub Actions | CI/CD pipeline voor autorisatie |
| Portal | Backstage | Developer self-service (fase 2) |

## Quick Start

### Lokale Ontwikkelomgeving

```bash
# 1. Clone de repository
git clone https://github.com/qx4266534/gitops-auth-platform-poc.git
cd gitops-auth-platform-poc

# 2. Start lokale services (OpenFGA, Dex, PostgreSQL, OpenLDAP)
docker-compose up -d

# 3. Wacht tot alle services gezond zijn
./scripts/setup-local.sh

# 4. Valideer configuratie
./scripts/validate-config.sh

# 5. Initialiseer Terraform
cd terraform/environments/dev
terraform init

# 6. Review en pas terraform.tfvars aan
cp terraform.tfvars.example terraform.tfvars
# Bewerk terraform.tfvars met je waarden

# 7. Terraform plan
terraform plan

# 8. Terraform apply
terraform apply
```

## Repository Structuur

```
.
├── README.md                          # Dit bestand
├── docker-compose.yml                 # Lokale services
│
├── docs/
│   ├── architecture.md               # Architectuur documentatie
│   ├── roles.md                      # Rollen definitie & permissie matrix
│   └── decisions/                    # Architecture Decision Records
│
├── terraform/
│   ├── modules/
│   │   ├── openfga/                  # OpenFGA store & model module
│   │   ├── gitlab-rbac/              # GitLab RBAC module
│   │   ├── harbor-rbac/              # Harbor RBAC module
│   │   └── kubernetes-rbac/          # Kubernetes RBAC module
│   └── environments/
│       ├── dev/                      # Development omgeving
│       └── prod/                     # Productie omgeving
│
├── openfga/
│   ├── models/                        # Authorization models
│   ├── tests/                         # Model tests
│   └── store-config.yaml             # Initiële configuratie
│
├── config/
│   ├── dex.yaml                       # Dex IdP configuratie
│   ├── tenants/                       # Tenant definities
│   └── roles/                         # Rol definities
│
├── .github/
│   └── workflows/                     # CI/CD pipelines
│
├── scripts/                           # Hulp scripts
└── policy/opa/                        # OPA policies (fase 2)
```

## Rollen

### Platform Rollen (door Platform Team gedefinieerd)

| Rol | GitLab | Harbor | Kubernetes |
|-----|--------|--------|------------|
| Owner | Group Owner | Project Admin | admin (namespace) |
| Developer | Developer | Developer | edit (namespace) |
| PO | Planner | Guest | view (namespace) |

Zie `docs/roles.md` voor de volledige rollen matrix en afdelingspecifieke custom rollen.

## GitOps Workflow

### Pull Request Flow

1. Developer wijzigt `config/tenants/<tenant>.yaml`
2. GitHub Actions draait `terraform plan` bij PR
3. Plan output wordt als PR comment gepost
4. Verplichte reviewers (CODEOWNERS) keuren goed
5. Na merge: `terraform apply` wordt automatisch uitgevoerd

### Access Reviews

Quarterly access reviews worden geautomatiseerd via `.github/workflows/access-review.yml`.

## Architecture Decision Records

- [ADR-001: Gebruik van OpenFGA](docs/decisions/001-use-openfga.md)
- [ADR-002: Gebruik van Terraform + GitOps](docs/decisions/002-use-terraform-gitops.md)
- [ADR-003: Gebruik van Backstage](docs/decisions/003-use-backstage.md)
- [ADR-004: Gebruik van Dex IdP](docs/decisions/004-use-dex-idp.md)

## Status

Dit is een **Proof of Concept**. Productie-inzet vereist aanvullende security review, performance testing, en integratie met de bestaande enterprise identity provider.

## Licentie

MIT
