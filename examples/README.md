# Examples

The `ballerinax/storecove` connector provides practical examples illustrating usage in various scenarios.

1. [Legal entity onboarding](legal_entity_onboarding/legal_entity_onboarding.md) - Create a legal entity, register its Peppol and additional tax identifiers, and read it back.
2. [Peppol recipient discovery](peppol_recipient_discovery/peppol_recipient_discovery.md) - Check whether a recipient exists on the Peppol network and which document types it can receive.

## Prerequisites

- A Storecove API key, supplied to each example through the `apiKey` configurable in its `Config.toml`.
- Ballerina Swan Lake 2201.12.0 or later.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
