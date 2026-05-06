# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification.
The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json -o ballerina --mode client --license docs/license.txt
```

Note: The license year is hardcoded to 2025, change if necessary.