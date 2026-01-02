# Architecture

Rumah is structured in three conceptual layers. There is no strict enforcement between layers—only discipline.

## Layers

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation                         │
│         HTML Templates • HTMX • Sidebar Nav             │
├─────────────────────────────────────────────────────────┤
│                      Modules                            │
│     Module A  •  Module B  •  Module C  •  ...          │
├─────────────────────────────────────────────────────────┤
│                        Core                             │
│  Startup • Auth • Registry • Router • Layout • Admin    │
├─────────────────────────────────────────────────────────┤
│                     PostgreSQL                          │
└─────────────────────────────────────────────────────────┘
```

## Directory Structure

```
rumah/
├── cmd/
│   └── rumah/
│       └── main.go           # Application entry point
├── internal/
│   ├── core/
│   │   ├── app.go            # Application setup
│   │   ├── auth.go           # Authentication
│   │   ├── registry.go       # Module registry
│   │   ├── router.go         # Global routing
│   │   └── admin/            # Admin UI handlers
│   ├── modules/
│   │   ├── dashboard/        # Dashboard module
│   │   └── <module>/         # Feature modules
│   └── web/
│       ├── layout.go         # Base layout rendering
│       └── middleware.go     # HTTP middleware
├── migrations/               # SQL migration files
├── templates/
│   ├── layout/               # Base layouts
│   ├── admin/                # Admin UI templates
│   └── <module>/             # Per-module templates
└── static/                   # Static assets (CSS, JS)
```

## Request Flow

```
HTTP Request
     │
     ▼
┌─────────────┐
│  Middleware │  ← Logging, session, auth check
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Router    │  ← Routes to appropriate handler
└──────┬──────┘
       │
       ├──────────────┬──────────────┐
       ▼              ▼              ▼
┌──────────┐   ┌──────────┐   ┌──────────┐
│  Core    │   │ Module A │   │ Module B │
│ Handlers │   │ Handlers │   │ Handlers │
└────┬─────┘   └────┬─────┘   └────┬─────┘
     │              │              │
     ▼              ▼              ▼
┌─────────────────────────────────────────┐
│              Database (SQL)              │
└─────────────────────────────────────────┘
     │              │              │
     ▼              ▼              ▼
┌─────────────────────────────────────────┐
│         Template Rendering               │
│    (Base Layout + Module Content)        │
└─────────────────────────────────────────┘
     │
     ▼
HTTP Response (HTML)
```

## Core Responsibilities

The core is intentionally small and boring. It owns:

| Responsibility | Description |
|----------------|-------------|
| Application startup | Initialize DB, register modules, start server |
| Database connection | Single connection pool for all modules |
| Authentication | Username/password, session management |
| Role checks | Verify user permissions |
| Module registry | Track registered modules and their state |
| Module enable/disable | Store and check module enabled state |
| Global routing | Mount module routes, handle disabled redirects |
| Global layout | Render base layout with sidebar |
| Admin UI | Module management interface |

The core does **not**:
- Know module-specific schemas
- Know module internal logic
- Special-case any module

## Module System

Each module is a self-contained vertical feature slice that:

1. **Self-registers** on application startup
2. **Exposes metadata**: ID, name, icon, route prefix
3. **Owns its routes**: Mounted under its prefix
4. **Owns its templates**: Stored in `templates/<module>/`
5. **Owns its tables**: Namespaced with module prefix

See [MODULES.md](MODULES.md) for the full module development guide.

## Database Connection

- Single `*sql.DB` connection pool created at startup
- Passed to modules during registration
- Modules run their own queries—no shared query layer
- Connection configuration via environment variables

## Session & Auth

- Cookie-based sessions
- Session data stored in database or memory (TBD)
- Auth middleware checks session on protected routes
- Role stored in session after login

