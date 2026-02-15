# sysaidticketget

SysAid Ticket provides an exasy way to get SysAid System Record tickets sustainably. 

While tested on Incidents and Requests, this should work on any Service Ticket Type.

The project is intentionally built as **standalone** script.

---

## Important Documentation

- [OVERVIEW](/README.md)  
  This document. General overview of the tool and abilities.

- [EXAMPLES](doc/EXAMPLES.md)  
  How to run the code.

- [ENDPOINTS](doc/ENDPOINTS.md)  
  The web service this script is leveraging

- [AUTHORIZATION](doc/AUTHORIZATION.md)  
  what to use, and how to obtain the JSESSIONID

- [TROUBLESHOOTING](doc/TROUBLESHOOTING.md)  
  what to use, and how to obtain the JSESSIONID

## Design Principles

- **KISS** – Keep it Simple and Speedy
- **Deterministic** – same input ticket always extracts the same output
- **Explainable** – every PDF can be traced back to the input ticket

---

## Repository Layout

```
.
├── README.md
├── bin
│   ├── sysaidticketget.ksh
│   └── sysaidticketget.py
├── cfg
│   └── requirements.txt
└── doc
    ├── AUTHORIZATION.md
    ├── ENDPOINTS.md
    ├── EXAMPLES.md
    └── TROUBLESHOOTING.md

```

---

## Installation

This project intentionally does **not** require packaging or installation.

### Requirements

- Python 3.9+

```bash
pip install pdfplumber
```

Clone the repository and run directly.

---

## Usage

```bash
python sysaidpdfview.py --help
```

| Option              | Description                        |
|---------------------|------------------------------------|
| -h, --help          | show this help message and exit |
| --cookie COOKIE     | JSESSIONID value |
| --tenant TENANT     | SysAid Tenant Value |
| --tickets TICKETS   | Ticket, comma list, or file path |
| --dst DST           | Destination directory |
| --workers WORKERS   | Specify the number of workers processing tickets |
| --sleep SLEEP       | Specify time to wait between processing queue items |
| --verbose           | Specify verbose output |

To Do List:
===========

* Add other format outputs.
* turn this into a packaged module.
* extend the CLI to handle processing in parallel using workers and queues.

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
