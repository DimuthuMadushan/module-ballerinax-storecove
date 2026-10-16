# Peppol recipient discovery

This example checks whether a business can receive documents on the Peppol network before you send it an invoice. It lists the identifier schemes Storecove supports per country, checks that the recipient exists, and finds the document types the recipient can receive.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Storecove API key
- Create a `Config.toml` in this directory:
  ```toml
  apiKey = "<API_KEY>"
  recipientScheme = "<RECIPIENT_SCHEME>"
  recipientIdentifier = "<RECIPIENT_IDENTIFIER>"
  ```

## Run the example

```bash
bal run
```
