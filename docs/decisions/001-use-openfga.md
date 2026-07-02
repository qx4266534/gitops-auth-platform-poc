# ADR-001: Gebruik van OpenFGA als Centrale Autorisatiestore

## Status
Accepted

## Context
We hebben een centrale autorisatiestore nodig die:
1. Multi-tenant autorisatie ondersteunt
2. Hiërarchische permissies modelleert
3. Snelle "check" queries uitvoert (< 10ms)
4. "List alle projecten van gebruiker X" queries ondersteunt
5. Integreert met GitOps workflows

## Opties

1. **OpenFGA** — CNCF incubating, ReBAC, Zanzibar-based
2. **SpiceDB** — CNCF, Zanzibar-based, managed optie
3. **Eigen RBAC service** — Custom ontwikkeling
4. **Policy engine (OPA)** — Alleen voor policies, niet voor relaties

## Besluit

We kiezen **OpenFGA**.

## Argumenten

- **ReBAC** past het beste bij ons use case (gebruikers hebben rollen op resources)
- **CNCF incubating** — actieve community, goede documentatie
- **Terraform provider** beschikbaar voor GitOps integratie
- **ListObjects API** essentieel voor UI use cases
- **Self-hosted** optie voldoet aan security eisen
- Betere **developer experience** dan SpiceDB (REST API, meer SDKs)

## Gevolgen

- We moeten OpenFGA deployen en beheren (PostgreSQL als backing store)
- Het authorization model moet ontworpen en getest worden
- OPA blijft beschikbaar voor context-aware policies (fase 2)
