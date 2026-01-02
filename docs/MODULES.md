# Module Development Guide

This document explains how to create and maintain modules in Rumah.

## What is a Module?

A module is a self-contained vertical feature slice. Each module:

- Is compiled into the binary (no dynamic plugins)
- Self-registers on application startup
- Owns its routes, templates, and database tables
- Can depend on other modules

## Module Metadata

Every module must provide:

| Field | Type | Description |
|-------|------|-------------|
| `ID` | `string` | Stable identifier (e.g., `"beans"`) |
| `Name` | `string` | Display name (e.g., `"Beans Logger"`) |
| `Icon` | `string` | Icon for sidebar navigation |
| `RoutePrefix` | `string` | URL prefix (e.g., `"/beans"`) |
| `Dependencies` | `[]string` | IDs of required modules |

## Directory Structure

```
internal/modules/<name>/
├── module.go      # Module definition and registration
├── handlers.go    # HTTP handlers
├── queries.go     # Database queries
└── ...

templates/<name>/
├── list.html      # List view
├── form.html      # Create/edit form
├── view.html      # Single item view
└── ...
```

## Creating a New Module

### 1. Create the module directory

```bash
mkdir -p internal/modules/mymodule
mkdir -p templates/mymodule
```

### 2. Define the module (module.go)

```go
package mymodule

import (
    "database/sql"
    "net/http"
)

type Module struct {
    db *sql.DB
}

func New(db *sql.DB) *Module {
    return &Module{db: db}
}

func (m *Module) ID() string          { return "mymodule" }
func (m *Module) Name() string        { return "My Module" }
func (m *Module) Icon() string        { return "box" }
func (m *Module) RoutePrefix() string { return "/mymodule" }
func (m *Module) Dependencies() []string { return nil }

func (m *Module) Routes() http.Handler {
    mux := http.NewServeMux()
    mux.HandleFunc("GET /", m.handleList)
    mux.HandleFunc("GET /new", m.handleNew)
    mux.HandleFunc("POST /", m.handleCreate)
    return mux
}
```

### 3. Add handlers (handlers.go)

```go
package mymodule

import "net/http"

func (m *Module) handleList(w http.ResponseWriter, r *http.Request) {
    // Fetch data, render template
}

func (m *Module) handleNew(w http.ResponseWriter, r *http.Request) {
    // Render form template
}

func (m *Module) handleCreate(w http.ResponseWriter, r *http.Request) {
    // Parse form, insert to database, redirect
}
```

### 4. Register the module

In `cmd/rumah/main.go` or a registration file:

```go
registry.Register(mymodule.New(db))
```

### 5. Create database migration

Create a migration file in `migrations/`:

```sql
-- migrations/003_create_mymodule_tables.sql

CREATE TABLE mymodule_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Database Conventions

- **Table prefix**: All tables must be prefixed with module ID
  - `beans_entries`, `beans_categories`
  - `tasks_items`, `tasks_labels`
- **Primary keys**: Use `UUID` with `gen_random_uuid()`
- **Timestamps**: Use `TIMESTAMPTZ` for time fields
- **Soft deletes**: Optional, module's choice

## Template Conventions

- Extend the base layout: `{{template "layout" .}}`
- Pass page title and content
- Use HTMX for interactivity where appropriate
- Keep templates simple—logic belongs in handlers

## Route Conventions

Standard RESTful patterns:

| Method | Path | Action |
|--------|------|--------|
| GET | `/prefix` | List all |
| GET | `/prefix/new` | Show create form |
| POST | `/prefix` | Create new |
| GET | `/prefix/:id` | Show one |
| GET | `/prefix/:id/edit` | Show edit form |
| PUT | `/prefix/:id` | Update |
| DELETE | `/prefix/:id` | Delete |

## Dependencies

Modules can depend on other modules:

```go
func (m *Module) Dependencies() []string {
    return []string{"users", "categories"}
}
```

**Behavior:**
- If a dependency is disabled, this module is automatically disabled
- Cyclic dependencies are invalid (checked at startup)
- Access dependencies through their public interfaces

## Module Enable/Disable

- Module state stored in `modules` table
- Disabled modules:
  - Routes are not mounted
  - Hidden from sidebar navigation
  - Requests redirect to dashboard
  - Data is retained (not deleted)
- Currently requires app restart to apply changes

