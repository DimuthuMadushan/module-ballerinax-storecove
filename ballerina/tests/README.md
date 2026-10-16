# Tests

The test suite runs every operation covered by the mock server in `tests/mock_service.bal`: legal entity create, read, update and delete; Peppol and additional tax identifier management; invoice and document submissions with their delivery evidence; recipient discovery; purchase invoice and received document retrieval; and webhook instances. Each test calls the client against the mock and asserts on the typed response, or on a successful empty response for delete operations.

## Running Tests

```bash
bal test
```

By default the tests run against the mock server, so no credentials are required. To run them against the live Storecove API, set the following environment variables:

```bash
export IS_LIVE_SERVER=true
export STORECOVE_API_KEY=<your API key>
```

The live run creates and deletes real records, so use a sandbox account.
