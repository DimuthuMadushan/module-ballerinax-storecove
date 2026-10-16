_Author_:  @DimuthuMadushan \
_Created_: 2026/10/16 \
_Updated_: 2026/10/16 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Storecove. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/storecove/storecove/2.0.1/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Removed the redundant `/api/v2` prefix from the eight `/api/v2/legal_entities/{legal_entity_id}/c5…` paths (`c5_activation/activate`, `c5_deactivation/deactivate` and the `c5/iras/email` and `c5/iras/redirect` `activate`, `deactivate` and `cancel` paths). The spec already declares `basePath: /api/v2`, so the prefix was applied twice and every other path was relative to the base path. This was changed in the original spec `docs/spec/openapi.json`.

2. Added the missing `operationId` to the two cancellation operations, `PUT /legal_entities/{legal_entity_id}/c5/iras/email/cancel` (`cancel_c5_email`) and `PUT /legal_entities/{legal_entity_id}/c5/iras/redirect/cancel` (`cancel_c5_redirect`). Without it the generated method names are derived from the path.

3. Fixed the `peppol_identifiers` property of the `PurchaseInvoiceSender` schema, which was declared as `type: array` with a sibling `$ref` and no `items`. It now declares `items: {$ref: "#/definitions/PeppolIdentifier"}`, so it is generated as an array of `PeppolIdentifier`.

4. Replaced the generic `Success` description on the 200 responses that return a body with a description of the returned entity (for example "The legal entity", "The result of the invoice submission"), grouped by response schema. The `Success` description is kept on the no-content 204 responses.

5. Changed the `Bearer` security scheme from `type: apiKey` (`name: Authorization`, `in: header`) to `type: http`, `scheme: bearer`, so the client is configured with `http:BearerTokenConfig` and sends `Authorization: Bearer <API key>`, which is what Storecove expects. Swagger 2.0 cannot express a bearer scheme, so this edit is made in the aligned spec `docs/spec/aligned_ballerina_openapi.json` (`components.securitySchemes.Bearer`) and **must be re-applied after a re-align**; the original `openapi.json` is unchanged.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```
