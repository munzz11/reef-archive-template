# Reef Archive Template

## Project Structure

The following is a template of the archive structure used with REEF. The structure is intended to be flexible depending on the platforms, ROCs involved as well as the various paylods each platform may carry. For example, this template outlines an operation with one drix, with the "standard" set of sensors (mbes and ek80), as well as two ROCs. But this can be customized using the archive_init.sh script.

```
.
├── 01-catalog
│   ├── data-manifest
│   └── ops-log
├── 02-raw
│   ├── cloud
│   │   └── cloud-robobox
│   │       ├── data
│   │       └── metadata
│   └── platforms
│       ├── drix-08
│       │   ├── data
│       │   │   ├── ctd
│       │   │   ├── drix
│       │   │   ├── ek80
│       │   │   ├── gps
│       │   │   ├── mastervolt
│       │   │   ├── mbes
│       │   │   └── phins
│       │   └── metadata
│       │       ├── ctd
│       │       ├── drix
│       │       ├── ek80
│       │       ├── gps
│       │       ├── mastervolt
│       │       ├── mbes
│       │       └── phins
│       └── rocs
│           ├── roc-1
│           │   ├── data
│           │   │   └── screenshots
│           │   └── metadata
│           └── roc-2-nautilus
│               ├── data
│               │   └── screenshots
│               └── metadata
├── 03-Processed
│   ├── gsf
│   └── pointclouds
├── 04-Products
│   ├── bags
│   ├── bs_mosaics
│   └── geotiffs
├── archive_clean.sh
├── archive_init.sh
├── config.json
└── README.md
```

## Setup and Usage

### Prerequisites

- Bash 4+
- `jq` for JSON parsing
- Write permissions within the project directory tree

### Configuration

1. **Update `config.json`:**
   - Set the `archive_path` to your desired archive location.
   - Configure the `platforms` and `cloud` sections as needed.

### Initializing the Archive

To initialize the archive structure, run:

```bash
./archive_init.sh
```

This script will:
- Check if the basic archive structure exists and create it if necessary.
- Read platform and sensor configurations from `config.json`.
- Display a tree-like view of the directory structure to be created.
- Prompt for confirmation before creating the directories.

### Cleaning the Archive

To clean the archive structure, run:

```bash
./archive_clean.sh
```

This script will:
- Check for significant files in the `02-raw` directory.
- Prompt for confirmation before deleting the contents of the `platforms` and `cloud` folders.

## Additional Information

For more details on the archive structure and customization options, refer to the comments within the scripts and the `config.json` file.
