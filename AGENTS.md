# Rumah — Agent Context

This document provides context for AI agents working on this project.

## What is Rumah?

A personal, modular web dashboard. Single owner, always online, built for long-term use and experimentation.

## Philosophy

- **Personal workbench, not SaaS** — One real user (the owner/admin). No multi-tenant concerns.
- **Experimentation is valued** — Trying new patterns, even questionable ones, is acceptable in modules.
- **Simplicity preferred** — But not sacred. Overengineering is allowed intentionally for learning.
- **Momentum over purity** — Ship working code, iterate later.

## Key Principles

### Flat Go Architecture
- No hexagonal architecture
- No DDD (Domain-Driven Design)
- No CQRS
- Minimal packages, direct calls
- Abstractions only when pain is proven

### Backend-Authoritative
- Backend controls routing, rendering, permissions
- HTMX enhances UX but doesn't own state
- Server-rendered HTML is mandatory

### SQL-First Database
- PostgreSQL with direct SQL
- PostgreSQL-specific features allowed (`jsonb`, `uuid`)
- No ORM abstractions unless pain is proven

### Compile-Time Modules
- All modules compiled into the Go binary
- No dynamic plugins or runtime loading
- Modules self-register on startup

## When Making Changes

1. **Prefer editing existing code** over creating new abstractions
2. **Module changes should not touch core** — Modules are self-contained
3. **Core changes should not special-case any module** — Core is generic
4. **Keep it simple** — Suggest simplification when overengineering appears

## Non-Goals (Don't Suggest These)

- API-first architecture
- Multi-tenant features
- Event-driven architecture
- Message queues or background job systems
- Plugin sandboxing or hot reload
- Perfect abstractions

## Key Files for Context

- `docs/ARCHITECTURE.md` — System structure
- `docs/MODULES.md` — How modules work
- `docs/DECISIONS.md` — Why choices were made
- `.cursor/rules/rumah.mdc` — Coding conventions

## Common Tasks

### Adding a new module
1. Create module directory in `internal/modules/<name>/`
2. Implement the module interface
3. Register in module registry
4. Add database migration if needed
5. Create templates in `templates/<name>/`

### Modifying core behavior
1. Check if it can be done in a module instead
2. Ensure change doesn't break module contract
3. Update `docs/ARCHITECTURE.md` if structure changes
4. Add ADR to `docs/DECISIONS.md` if significant

