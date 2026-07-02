# Architectuur Documentatie

## Doel

Dit document beschrijft de architectuur van het GitOps Autorisatie Platform. Het platform stelt een bank in staat om op een gestandaardiseerde, geautomatiseerde en compliant manier autorisaties te beheren over GitLab, Harbor en Kubernetes.

## Principes

1. **Git als single source of truth** — Alle autorisaties staan in Git
2. **Declaratief** — Gewenste toestand wordt beschreven, niet de stappen
3. **Automated reconciliation** — Wijzigingen worden automatisch uitgerold
4. **Audit trail** — Elke wijziging is traceerbaar
5. **Least privilege** — Minimale rechten per rol
6. **Segregation of duties** — Scheiding van verantwoordelijkheden

## Componenten

### Identity Layer — Dex IdP

Dex fungeert als OIDC bridge tussen het enterprise LDAP/Active Directory en de platform componenten. Dex vertaalt LDAP authenticatie naar OIDC tokens met groepsinformatie.

### Authorization Layer — OpenFGA

OpenFGA is de centrale autorisatiestore. Het gebruikt Relationship-Based Access Control (ReBAC) gebaseerd op Google's Zanzibar paper. Het slaat op:
- Welke gebruikers welke rollen hebben op welke tenants
- Hiërarchische permissies (organisatie → team → project → resource)
- Custom rollen per afdeling

### Provisioning Layer — Terraform + GitOps

Terraform is verantwoordelijk voor het daadwerkelijk aanmaken en wijzigen van autorisatie-resources in GitLab, Harbor en Kubernetes. De GitOps pipeline zorgt ervoor dat alleen goedgekeurde wijzigingen worden doorgevoerd.

### Portal Layer — Backstage

Backstage biedt een gebruiksvriendelijke interface voor developers om:
- Projecten aan te vragen
- Rollen toe te wijzen aan teamleden
- Hun toegangsrechten in te zien

## Data Flow

```
1. Gebruiker logt in → Dex authenticeert tegen LDAP
2. Dex geeft OIDC token met username + groepen
3. Backstage toont beschikbare acties op basis van OpenFGA checks
4. Tenant owner wijzigt rollen in Backstage
5. Wijziging wordt opgeslagen in Git (config/tenants/)
6. GitHub Actions triggert terraform plan/apply
7. Terraform rolt wijzigingen uit naar GitLab, Harbor, K8s
8. OpenFGA relaties worden bijgewerkt
```

## Multi-Tenant Isolatie

| Laag | Isolatie Mechanisme |
|------|-------------------|
| Kubernetes | Namespace per tenant + RBAC + NetworkPolicy |
| Harbor | Project per tenant |
| GitLab | Groep per tenant |
| OpenFGA | Store per tenant (optioneel) |

## Security

- Alle communicatie via TLS (mTLS intern)
- OIDC tokens met korte levensduur (5-15 min)
- Terraform state encrypted at rest
- Git commits signed (GPG)
- CODEOWNERS verplicht voor alle wijzigingen
