# Architecture Decision Records

This document captures significant architectural decisions made in Rumah.

---

## 2026-01-02: Flat Go Architecture

**Context:** Choosing an architectural pattern for the Go backend. Options included hexagonal architecture, DDD, clean architecture, or a flat/simple approach.

**Decision:** Use flat architecture with minimal packages and direct calls. No hexagonal, no DDD, no CQRS.

**Consequences:**
- Simpler codebase, easier to understand
- Less indirection, faster to navigate
- May need refactoring if complexity grows significantly
- Abstractions added only when pain is proven

---

## 2026-01-02: Server-Rendered HTML with HTMX

**Context:** Choosing a frontend approach. Options included SPA (React/Vue), API-first with separate frontend, or server-rendered HTML.

**Decision:** Server-rendered HTML using Go templates, enhanced with HTMX for interactivity. Backend is authoritative.

**Consequences:**
- Simpler deployment (single binary)
- No build step for frontend
- SEO-friendly by default
- Less JavaScript complexity
- HTMX provides interactivity without SPA overhead
- Frontend can be replaced later if needed

---

## 2026-01-02: Restart-Based Module Toggling

**Context:** Modules can be enabled/disabled. Options were dynamic toggling (no restart) or restart-based toggling.

**Decision:** Initial implementation requires application restart to apply module toggle changes.

**Consequences:**
- Simpler implementation
- No complex route hot-swapping
- Acceptable for single-user system
- Architecture allows future dynamic toggling
- Module state stored in database for persistence

---

## 2026-01-02: SQL-First Database Access

**Context:** Choosing database access approach. Options included ORM (GORM, Ent), query builder, or direct SQL.

**Decision:** SQL-first with direct queries. PostgreSQL-specific features allowed.

**Consequences:**
- Full control over queries
- Better performance tuning
- PostgreSQL features available (JSONB, UUID, etc.)
- More verbose than ORM for simple CRUD
- No automatic migrations from structs
- Not locked to PostgreSQL, but switching requires query rewrites

---

## 2026-01-02: Compile-Time Modules

**Context:** Module loading strategy. Options were runtime plugins, dynamic loading, or compile-time modules.

**Decision:** All modules compiled into the Go binary. No dynamic plugins.

**Consequences:**
- Single binary deployment
- Type safety across modules
- No plugin sandboxing concerns
- Adding modules requires recompilation
- Simpler dependency management

---

## Template

Use this format for new decisions:

```markdown
## YYYY-MM-DD: Decision Title

**Context:** Why this decision came up. What problem needed solving.

**Decision:** What was chosen and why.

**Consequences:** Trade-offs, benefits, and drawbacks of this decision.
```

