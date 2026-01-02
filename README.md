# Rumah

A personal, always-online, modular web dashboard built as a long-term workbench. Rumah hosts independent feature modules that can evolve, be rewritten, disabled, or experimented with over time—without forcing rewrites of the core system.

## Tech Stack

- **Backend:** Go (single binary, single HTTP server)
- **Frontend:** Server-rendered HTML + HTMX
- **Database:** PostgreSQL

## Quick Start

```bash
# Clone the repository
git clone https://github.com/varomnrg/rumah.git
cd rumah

# Set up the database
createdb rumah
make migrate

# Run the application
make run
```

The application will be available at `http://localhost:8080`.

## Documentation

- [Architecture](docs/ARCHITECTURE.md) — System structure and layers
- [Modules](docs/MODULES.md) — How to build a module
- [Database](docs/DATABASE.md) — Schema and conventions
- [Decisions](docs/DECISIONS.md) — Architecture decision records
- [Roadmap](docs/ROADMAP.md) — Project phases and progress

## Development

```bash
make run       # Run the application
make build     # Build the binary
make migrate   # Run database migrations
make seed      # Seed initial data
```

## Philosophy

Rumah prioritizes learning, experimentation, and long-term maintainability over production perfection. It's not a SaaS product, but it's built with discipline so it can be safely self-hosted.
