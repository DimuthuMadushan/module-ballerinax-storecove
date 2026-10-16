# Ballerina Storecove connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-storecove/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-storecove/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-storecove.svg)](https://github.com/ballerina-platform/module-ballerinax-storecove/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/storecove.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fstorecove)

## Overview

[Storecove](https://www.storecove.com/) is a document exchange platform that sends and receives electronic business documents, such as invoices and credit notes, over networks like Peppol on behalf of its customers. It handles legal entity registration, recipient discovery, document submission with delivery evidence, and the retrieval of documents received from trading partners.

The Storecove connector lets Ballerina applications call the Storecove API, version 2.0.1, to manage legal entities and their identifiers, discover trading partners on the network, submit documents and track their delivery, and fetch received documents and purchase invoices.

## Setup guide

To use the Storecove connector, you need a Storecove account and an API key.

1. Sign in to your [Storecove account](https://app.storecove.com) or request access from Storecove if you do not have one.

2. Open the API settings of your account and create an API key.

3. Copy the key and keep it secure. The connector sends it as a bearer token in the `Authorization` header (`Authorization: Bearer <API_KEY>`) of every request.

## Quickstart

To use the Storecove connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/storecove;
```

### Step 2: Instantiate a new connector

Create a `Config.toml` file with your API key.

```toml
apiKey = "<API_KEY>"
```

Then create a `storecove:Client` using the configured key as a bearer token.

```ballerina
configurable string apiKey = ?;

final storecove:Client storecoveClient = check new ({auth: {token: apiKey}});
```

### Step 3: Invoke the connector operation

Retrieve the identifier specifications that Storecove supports for each country.

```ballerina
public function main() returns error? {
    storecove:CountrySpecifications _ = check storecoveClient->discoverIdentifiers();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `Storecove` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-storecove/tree/main/examples/), covering the following use cases:

1. [Legal entity onboarding](examples/legal_entity_onboarding/legal_entity_onboarding.md) - Create a legal entity, register its Peppol and additional tax identifiers, and read it back.
2. [Peppol recipient discovery](examples/peppol_recipient_discovery/peppol_recipient_discovery.md) - Check whether a recipient exists on the Peppol network and which document types it can receive.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`storecove` package](https://central.ballerina.io/ballerinax/storecove/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
