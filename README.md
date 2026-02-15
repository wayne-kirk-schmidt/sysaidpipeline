# SysAid Pipeline

## Executive Summary

The SysAid DOC Pipeline is a phase-driven extraction and transformation 
engine designed for governance-grade ticket processing.

Validated end-to-end:
- download → extract → assemble → snapshot
- Schema-driven CSV export
- Multiline field preservation
- ~1K ticket batch validation

---

## Architecture

This system is deterministic and filesystem-backed.

Each run creates an isolated run directory under:

/var/tmp/tickets/<RUN_ID>/

No shared mutable state. No hidden services.

---

## Phases

### Download
Pulls raw ticket artifacts.

### Extract
Transforms raw artifacts into structured JSON.

### Assemble
Normalizes JSON into schema-aligned records.

### Snapshot
Produces stable CSV export artifacts.

---

## Design Characteristics

- Fail-fast execution
- Append-only per run
- Manifest-based tracking
- Governance-ready outputs
- No concurrency hazards

---

## Important Documentation

- [ARCHITECTURE](doc/00_Architecture.md)
- [RUNBOOK](doc/10_Runbook.md)
- [DATA_MODEL](doc/20_Data_Model.md)
- [MANIFEST_SPECIFICATION](doc/30_Manifest_Spec.md)
- [BATCHING_STRATEGY](doc/60_Batching_Strategy.md)
- [ROADMAP](doc/80_Roadmap.md)

## Design Principles

- **KISS** – Keep it Simple and Speedy
- **Deterministic** – same input ticket always extracts the same output
- **Explainable** – every PDF can be traced back to the input ticket

---

To Do List:
===========

* Add other format outputs.

License
=======

Copyright 2026 

* Wayne Kirk Schmidt (wayne.kirk.schmidt@gmail.com)

Licensed under the Apache 2.0 License (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    license-name   Apache 2.0 
    license-url    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Support
=======

Feel free to e-mail me with issues to: 

+   wayne.kirk.schmidt@gmail.com

I will provide "best effort" fixes and extend the scripts.
