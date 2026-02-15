# Runbook

## Standard Full Run

```bash
./pipeline.sh all
```

## Individual Phases

```bash
./pipeline.sh download
./pipeline.sh extract
./pipeline.sh assemble
./pipeline.sh snapshot
```

Each phase assumes prior phase artifacts exist.

## Output Location

Each run creates an isolated directory:

/var/tmp/tickets/<RUN_ID>/

Containing:
- pdf/
- json/
- assembled/
- snapshot/
- manifest.json
