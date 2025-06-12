# Reef Archive Template

## Project Structure

The following is a template of the archive structure used with REEF. The structure is intended to be flexible depending on the platforms, ROCs involved as well as the various paylods each platform may carry. For example, this template outlines an operation with one drix, with the "standard" set of sensors (mbes and ek80), as well as two ROCs. But this can be customized using the archive_init.sh script.

```
├── 01-catalog
│   ├── data-manifest
│   └── ops-log
├── 02-raw
│   ├── cloud
│   │   └── cloud-robobox
│   │       ├── data
│   │       └── metadata
│   ├── platforms
│   │   └── drix-08
│   │       ├── data
│   │       │   ├── ctd
│   │       │   ├── drix
│   │       │   ├── ek80
│   │       │   ├── gps
│   │       │   ├── mastervolt
│   │       │   ├── mbes
│   │       │   └── phins
│   │       └── metadata
│   │           ├── ctd
│   │           ├── drix
│   │           ├── ek80
│   │           ├── gps
│   │           ├── mastervolt
│   │           ├── mbes
│   │           └── phins
│   └── rocs
│       ├── roc-1
│       │   ├── data
│       │   │   └── screenshots
│       │   └── metadata
│       └── roc-2
│           ├── data
│           │   └── screenshots
│           └── metadata
├── 03-Processed
│   └── platforms
│       └── drix-08
├── 04-Products
└── README.md
```

