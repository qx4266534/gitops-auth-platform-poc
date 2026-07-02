# Rollen Definities

## Platform Rollen

Deze rollen worden gedefinieerd door het Platform Team en zijn beschikbaar voor alle tenants.

### Owner
- Mag rechten uitdelen voor de tenant
- Volledige toegang tot alle resources binnen de tenant
- Kan projecten aanmaken en verwijderen

**Systeemrechten:**

| Systeem | Rol |
|---------|-----|
| GitLab | Group Owner |
| Harbor | Project Admin |
| Kubernetes | admin (namespace) |

### Developer
- Geeft developer rechten op projecten binnen de tenant
- Kan code pushen en deployen
- Geen rechten om andere gebruikers toe te voegen

**Systeemrechten:**

| Systeem | Rol |
|---------|-----|
| GitLab | Developer |
| Harbor | Developer |
| Kubernetes | edit (namespace) |

### PO (Product Owner)
- Geeft planner role op projecten binnen de tenant
- Kan issues en boards beheren
- Geen rechten op Harbor

**Systeemrechten:**

| Systeem | Rol |
|---------|-----|
| GitLab | Planner |
| Harbor | Geen rechten |
| Kubernetes | view (namespace) |

## Afdelingspecifieke Rollen

Afdelingen kunnen in samenspraak met het Platform Team eigen rollen definiëren. Voorbeelden:

### Security Officer
- Read-only toegang tot alle resources
- Toegang tot audit logs en vulnerability reports

### DevOps Engineer
- Developer rechten + Kubernetes admin (namespace)
- Toegang tot CI/CD pipelines en secrets

### Auditor
- Read-only toegang
- Toegang tot compliance rapporten

## Permissie Matrix

| Permissie | Owner | Developer | PO | Security Officer | DevOps | Auditor |
|-----------|-------|-----------|----|-----------------|--------|---------|
| Gebruikers uitdelen | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Code lezen | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Code schrijven | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Deployen | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ |
| Secrets beheren | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Audit logs zien | ✅ | ❌ | ❌ | ✅ | ❌ | ✅ |
| Projecten aanmaken | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

## Governance

- Nieuwe platform rollen: goedkevering door Platform Team + Security
- Nieuwe afdelingsrollen: aanvraag via Backstage, goedkeuring door Platform Team
- Rol wijzigingen: pull request + CODEOWNERS review
- Quarterly access review: verplicht voor alle rollen
