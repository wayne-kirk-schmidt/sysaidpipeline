# Data Model

## Extract Phase Output

Each ticket becomes a structured JSON document.

Multiline fields preserve '\n' to ensure CSV safety.

## Assemble Phase

JSON files are normalized according to schema-driven rules.

## Snapshot Phase

Outputs:
- Schema-driven CSV
- Stable artifact for reporting or downstream ingestion
