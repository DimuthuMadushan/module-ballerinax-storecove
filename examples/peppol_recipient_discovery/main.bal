// Checks whether a business can receive documents on the Peppol network before sending it an invoice.

import ballerina/io;
import ballerinax/storecove;

configurable string apiKey = ?;
configurable string recipientScheme = ?;
configurable string recipientIdentifier = ?;

public function main() returns error? {
    storecove:Client storecoveClient = check new ({auth: {token: apiKey}});

    // Step 1: List the identifier schemes Storecove supports per country.
    storecove:CountrySpecifications specifications = check storecoveClient->discoverIdentifiers();
    io:println("Countries with identifier specifications: ", (specifications?.countries ?: []).length());

    // Step 2: Check that the recipient exists on the network.
    storecove:DiscoveredParticipant existence = check storecoveClient->discoverExists({
        scheme: recipientScheme,
        identifier: recipientIdentifier
    });
    io:println("Recipient lookup result: ", existence?.code);

    // Step 3: Check which document types the recipient can receive.
    storecove:DiscoveredParticipant capabilities = check storecoveClient->discoverReceives({
        scheme: recipientScheme,
        identifier: recipientIdentifier,
        documentTypes: ["invoice", "creditnote"]
    });
    io:println("Recipient capability result: ", capabilities?.code);
}
