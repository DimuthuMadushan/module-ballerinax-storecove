# Legal entity onboarding

This example onboards a new business in Storecove. It creates a legal entity, registers its Peppol identifier and an additional tax identifier, and then reads the legal entity back to confirm the setup.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Storecove API key
- Create a `Config.toml` in this directory:
  ```toml
  apiKey = "<API_KEY>"
  partyName = "<PARTY_NAME>"
  addressLine = "<ADDRESS_LINE>"
  city = "<CITY>"
  zip = "<ZIP_CODE>"
  countryCode = "<COUNTRY_CODE>"
  peppolScheme = "<PEPPOL_SCHEME>"
  peppolIdentifier = "<PEPPOL_IDENTIFIER>"
  taxScheme = "<TAX_SCHEME>"
  taxIdentifier = "<TAX_IDENTIFIER>"
  ```

## Run the example

```bash
bal run
```
