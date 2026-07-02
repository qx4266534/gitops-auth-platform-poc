# ADR-004: Gebruik van Dex als Identity Provider Bridge

## Status
Accepted

## Context
De bank heeft een enterprise LDAP/Active Directory. We moeten deze koppelen aan onze platform componenten (GitLab, Harbor, Kubernetes) die OIDC verwachten.

## Opties

1. **Dex** — CNCF, lightweight, OIDC bridge
2. **Keycloak** — Feature-rijk maar complexer
3. **Directe LDAP integratie** — Per component configureren
4. **Pinniped** — VMware, Kubernetes-focussed

## Besluit

We kiezen **Dex**.

## Argumenten

- **Lightweight** — enkele Go binary, geen database nodig
- **Multi-connector** — LDAP, SAML, GitHub, etc.
- **OIDC output** — uniforme interface voor alle componenten
- **Group propagation** — LDAP groepen worden OIDC claims
- **CNCF sandbox** — open source, actief onderhouden

## Gevolgen

- Dex moet gehost en geconfigureerd worden
- LDAP schema moet gemapt worden naar OIDC claims
- Kubernetes API server moet geconfigureerd worden voor OIDC
