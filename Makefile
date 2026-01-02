# Rumah Makefile
# Run `make help` to see available commands

.PHONY: help run build migrate seed clean

# Default target
help:
	@echo "Rumah - Available commands:"
	@echo ""
	@echo "  make run       Run the application"
	@echo "  make build     Build the binary"
	@echo "  make migrate   Run database migrations"
	@echo "  make seed      Seed initial data"
	@echo "  make clean     Remove build artifacts"
	@echo ""

# Run the application
run:
	go run ./cmd/rumah

# Build the binary
build:
	go build -o bin/rumah ./cmd/rumah

# Run database migrations
migrate:
	@echo "Running migrations..."
	@for f in migrations/*.sql; do \
		echo "Applying $$f"; \
		psql $$DATABASE_URL -f $$f; \
	done
	@echo "Migrations complete."

# Seed initial data
seed:
	@echo "Seeding data..."
	@psql $$DATABASE_URL -f seeds/seed.sql
	@echo "Seeding complete."

# Clean build artifacts
clean:
	rm -rf bin/

