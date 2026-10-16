// Onboards a new legal entity in Storecove, registers its Peppol identifier and an additional tax identifier,
// and reads the entity back to confirm the setup.

import ballerina/io;
import ballerinax/storecove;

configurable string apiKey = ?;
configurable string partyName = ?;
configurable string addressLine = ?;
configurable string city = ?;
configurable string zip = ?;
configurable string countryCode = ?;
configurable string peppolScheme = ?;
configurable string peppolIdentifier = ?;
configurable string taxScheme = ?;
configurable string taxIdentifier = ?;

public function main() returns error? {
    storecove:Client storecoveClient = check new ({auth: {token: apiKey}});
    storecove:Country country = check countryCode.ensureType();

    // Step 1: Create the legal entity.
    storecove:LegalEntity legalEntity = check storecoveClient->createLegalEntity({
        partyName,
        line1: addressLine,
        city,
        zip,
        country
    });
    int? legalEntityId = legalEntity?.id;
    if legalEntityId is () {
        return error("Storecove did not return an id for the new legal entity");
    }
    io:println("Created legal entity: ", legalEntityId);

    // Step 2: Register its Peppol identifier.
    storecove:PeppolIdentifier peppol = check storecoveClient->createPeppolIdentifier(legalEntityId, {
        superscheme: "iso6523-actorid-upis",
        scheme: peppolScheme,
        identifier: peppolIdentifier
    });
    io:println("Registered Peppol identifier: ", peppol?.scheme, ":", peppol?.identifier);

    // Step 3: Register an additional tax identifier.
    storecove:AdditionalTaxIdentifier tax = check storecoveClient->createAdditionalTaxIdentifier(legalEntityId, {
        country,
        superscheme: "iso6523-actorid-upis",
        scheme: taxScheme,
        identifier: taxIdentifier
    });
    io:println("Registered tax identifier: ", tax?.identifier);

    // Step 4: Read the legal entity back.
    storecove:LegalEntity confirmed = check storecoveClient->getLegalEntity(legalEntityId);
    io:println("Legal entity ready: ", confirmed?.partyName);
}
