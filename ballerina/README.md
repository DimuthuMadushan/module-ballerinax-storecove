## Overview

[Storecove](https://www.storecove.com/) is a document exchange platform that sends and receives electronic business documents, such as invoices and credit notes, over networks like Peppol on behalf of its customers. It handles legal entity registration, recipient discovery, document submission with delivery evidence, and the retrieval of documents received from trading partners.

The Storecove connector lets Ballerina applications call the Storecove API, version 2.0.1, to manage legal entities and their identifiers, discover trading partners on the network, submit documents and track their delivery, and fetch received documents and purchase invoices.

### Key features

- Register and manage legal entities, their Peppol identifiers and additional tax identifiers
- Discover whether trading partners exist on the network and which documents they can receive
- Submit invoices and other documents and retrieve their delivery evidence
- Retrieve received documents and purchase invoices in JSON or the original format

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

1. [Legal entity onboarding](../examples/legal_entity_onboarding/legal_entity_onboarding.md) - Create a legal entity, register its Peppol and additional tax identifiers, and read it back.
2. [Peppol recipient discovery](../examples/peppol_recipient_discovery/peppol_recipient_discovery.md) - Check whether a recipient exists on the Peppol network and which document types it can receive.
