# ADR-003: Gebruik van Backstage als Developer Portal

## Status
Accepted

## Context
We willen developers in staat stellen om zelf projecten aan te vragen en rollen te beheren, zonder direct in Git repositories te hoeven werken.

## Opties

1. **Backstage** — CNCF, plugin ecosysteem, self-service
2. **Eigen portal** — Volledige controle maar hoge ontwikkelkosten
3. **GitLab alleen** — Beperkt tot GitLab, geen centraal overzicht
4. **Port** — Commercieel alternatief

## Besluit

We kiezen **Backstage**.

## Argumenten

- **CNCF incubating** — actieve community, veel plugins
- **Software templates** — self-service project provisioning
- **OpenFGA plugin** beschikbaar voor autorisatie-inzicht
- **GitLab/Harbor/K8s plugins** beschikbaar
- **Extensible** — eigen plugins mogelijk

## Gevolgen

- Backstage moet gehost en geconfigureerd worden
- Plugins moeten geconfigureerd en mogelijk aangepast worden
- Training nodig voor developers
