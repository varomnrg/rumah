# Roadmap

Project phases and progress tracking for Rumah.

---

## Phase 1: Foundation

Core scaffolding and infrastructure.

- [ ] Project structure setup
- [ ] Go module initialization
- [ ] Database connection
- [ ] Migration system
- [ ] Core tables (users, roles, modules)
- [ ] Authentication (username/password)
- [ ] Session management
- [ ] Role-based access control (admin check)
- [ ] Module registry implementation
- [ ] Module interface definition
- [ ] Route mounting for enabled modules
- [ ] Disabled module handling (redirect)
- [ ] Base HTML layout
- [ ] Sidebar navigation (expanded/collapsed)
- [ ] Admin UI for module management
- [ ] Dashboard module (home page)
- [ ] Makefile with common commands

---

## Phase 2: First Real Module

Build a real feature module to validate the architecture.

- [ ] Beans logging module
  - [ ] Database schema
  - [ ] CRUD operations
  - [ ] List view
  - [ ] Entry form
  - [ ] Detail view
- [ ] Module dependency system
- [ ] Iteration based on learnings

---

## Future Ideas

Parking lot for future features (not committed):

- Magic link authentication
- Dashboard widgets per module
- Server stats display
- Module settings storage
- User preferences
- Dark mode toggle
- Mobile-responsive sidebar
- Search across modules
- Data export

---

## Non-Goals

These are explicitly out of scope:

- Multi-tenant SaaS features
- Public hosting considerations
- API-first architecture
- Background job system
- Message queues
- Event-driven architecture
- Plugin sandboxing
- Hot reload
- Perfect abstractions

---

## Progress Notes

*Add dated notes as you make progress:*

**2026-01-02:** Project initialized with living documentation.

