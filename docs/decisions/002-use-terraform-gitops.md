# ADR-002: Gebruik van Terraform + GitOps voor Provisioning

## Status
Accepted

## Context
We moeten autorisatie-resources provisioneren in GitLab, Harbor en Kubernetes op een gestandaardiseerde, traceerbare manier.

## Opties

1. **Terraform + GitOps** — Declaratief, version controlled, automated
2. **Custom scripts/API calls** — Flexibel maar niet gestandaardiseerd
3. **Kubernetes operators** — Kubernetes-native maar beperkt tot K8s
4. **Ansible** — Imperatief, minder geschikt voor state management

## Besluit

We kiezen **Terraform + GitOps**.

## Argumenten

- **Declaratief** — gewenste toestand in code, niet procedures
- **Git als audit trail** — elke wijziging traceerbaar
- **Drift detection** — Terraform detecteert handmatige wijzigingen
- **Rollback** — via Git revert
- **Multi-platform** — één tool voor GitLab, Harbor en Kubernetes
- **CI/CD integratie** — GitHub Actions voor plan/apply workflow

## Gevolgen

- Terraform state management vereist (S3 + DynamoDB)
- Team moet Terraform kennis opbouwen
- GitHub Actions runners nodig voor CI/CD
