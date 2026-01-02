# Database Documentation

Rumah uses PostgreSQL with a SQL-first approach.

## Connection

Database connection is configured via environment variables:

```bash
DATABASE_URL=postgres://user:password@localhost:5432/rumah?sslmode=disable
```

Or individual variables:

```bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=rumah
DB_PASSWORD=secret
DB_NAME=rumah
```

## Core Tables

### users

Stores user accounts.

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'user',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### roles

Role definitions (if needed beyond simple strings).

```sql
CREATE TABLE roles (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

INSERT INTO roles (id, name, description) VALUES
    ('admin', 'Administrator', 'Full system access'),
    ('user', 'User', 'Standard user access');
```

### modules

Tracks registered modules and their enabled state.

```sql
CREATE TABLE modules (
    id TEXT PRIMARY KEY,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### sessions (optional)

If using database-backed sessions:

```sql
CREATE TABLE sessions (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    data JSONB NOT NULL DEFAULT '{}',
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX sessions_user_id_idx ON sessions(user_id);
CREATE INDEX sessions_expires_at_idx ON sessions(expires_at);
```

## Module Tables

Each module owns its tables. Conventions:

- **Prefix**: `<module_id>_<table_name>`
- **Primary key**: UUID with `gen_random_uuid()`
- **Timestamps**: `created_at`, `updated_at` as `TIMESTAMPTZ`

Example for a `beans` module:

```sql
CREATE TABLE beans_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    roaster TEXT,
    origin TEXT,
    variety TEXT,
    process TEXT,
    roast_date DATE,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX beans_entries_user_id_idx ON beans_entries(user_id);
```

## PostgreSQL Features

These PostgreSQL-specific features are allowed:

| Feature | Use Case |
|---------|----------|
| `UUID` | Primary keys |
| `gen_random_uuid()` | UUID generation |
| `JSONB` | Flexible data, settings |
| `TIMESTAMPTZ` | Timezone-aware timestamps |
| `TEXT` | Variable-length strings (no VARCHAR limits) |
| Arrays | Multi-value fields |
| `CHECK` constraints | Data validation |

## Migrations

Migrations are plain SQL files in `migrations/`:

```
migrations/
├── 001_create_users.sql
├── 002_create_modules.sql
├── 003_create_beans_tables.sql
└── ...
```

### Naming Convention

```
<sequence>_<description>.sql
```

- Sequence: 3-digit zero-padded number
- Description: snake_case action

### Running Migrations

```bash
make migrate
```

Or manually:

```bash
psql $DATABASE_URL -f migrations/001_create_users.sql
```

### Migration Strategy

- **Up only**: No down migrations (simplicity)
- **Idempotent**: Use `IF NOT EXISTS` where possible
- **Forward only**: Fix mistakes with new migrations

## Queries

Modules write their own SQL queries. No shared query layer.

Example pattern:

```go
// queries.go
package mymodule

const (
    queryListItems = `
        SELECT id, name, created_at
        FROM mymodule_items
        WHERE user_id = $1
        ORDER BY created_at DESC
    `
    
    queryGetItem = `
        SELECT id, name, created_at
        FROM mymodule_items
        WHERE id = $1 AND user_id = $2
    `
    
    queryInsertItem = `
        INSERT INTO mymodule_items (name, user_id)
        VALUES ($1, $2)
        RETURNING id
    `
)
```

## Backup & Restore

```bash
# Backup
pg_dump rumah > backup.sql

# Restore
psql rumah < backup.sql
```

