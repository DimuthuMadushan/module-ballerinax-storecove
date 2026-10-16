// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.storecove.com/api/v2" : "http://localhost:9090";
final string apiKey = isLiveServer ? os:getEnv("STORECOVE_API_KEY") : "test_api_key";

final Client storecove = check new ({auth: {token: apiKey}, httpVersion: http:HTTP_1_1}, serviceUrl);

isolated function legalEntityPayload() returns LegalEntityCreate => {
    partyName: "Acme Trading GmbH",
    line1: "Hauptstrasse 12",
    city: "Berlin",
    zip: "10115",
    country: "DE"
};

// The legal entity shared by the tests that need an existing one; created before and deleted after the suite.
isolated int fixtureLegalEntityId = 0;

isolated function legalEntityId() returns int {
    lock {
        return fixtureLegalEntityId;
    }
}

@test:BeforeSuite
isolated function createFixtures() returns error? {
    LegalEntity created = check storecove->createLegalEntity(legalEntityPayload());
    lock {
        fixtureLegalEntityId = <int>created?.id;
    }
}

@test:AfterSuite {alwaysRun: true}
isolated function deleteFixtures() returns error? {
    int id = legalEntityId();
    if id != 0 {
        check storecove->deleteLegalEntity(id);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateLegalEntity() returns error? {
    LegalEntity response = check storecove->createLegalEntity(legalEntityPayload());
    test:assertTrue(response?.id is int);
    test:assertEquals(response?.partyName, "Acme Trading GmbH");
    check storecove->deleteLegalEntity(<int>response?.id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetLegalEntity() returns error? {
    int id = legalEntityId();
    LegalEntity response = check storecove->getLegalEntity(id);
    test:assertEquals(response?.id, id);
    test:assertTrue(response?.partyName is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateLegalEntity() returns error? {
    LegalEntity created = check storecove->createLegalEntity(legalEntityPayload());
    int id = <int>created?.id;
    LegalEntity response = check storecove->updateLegalEntity(id, {partyName: "Acme Trading GmbH", city: "Munich"});
    test:assertEquals(response?.id, id);
    test:assertEquals(response?.city, "Munich");
    check storecove->deleteLegalEntity(id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteLegalEntity() returns error? {
    LegalEntity created = check storecove->createLegalEntity(legalEntityPayload());
    int createdId = <int>created?.id;
    error? response = storecove->deleteLegalEntity(createdId);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreatePeppolIdentifier() returns error? {
    PeppolIdentifier response = check storecove->createPeppolIdentifier(legalEntityId(), {
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    test:assertEquals(response?.identifier, "DE123456789");
    check storecove->deletePeppolIdentifier(legalEntityId(), <string>response?.superscheme, <string>response?.scheme,
            <string>response?.identifier);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdatePeppolIdentifier() returns error? {
    int id = legalEntityId();
    PeppolIdentifier created = check storecove->createPeppolIdentifier(id, {
        superscheme: "iso6523-actorid-upis",
        scheme: "FR:CTC",
        identifier: "123456789"
    });
    string superscheme = <string>created?.superscheme;
    string scheme = <string>created?.scheme;
    string identifier = <string>created?.identifier;
    PeppolIdentifier response = check storecove->updatePeppolIdentifier(id, superscheme, scheme, identifier, {
        annuaire: {routingCodeLabel: "Accounts payable"}
    });
    test:assertEquals(response?.scheme, "FR:CTC");
    check storecove->deletePeppolIdentifier(id, superscheme, scheme, identifier);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeletePeppolIdentifier() returns error? {
    int id = legalEntityId();
    PeppolIdentifier created = check storecove->createPeppolIdentifier(id, {
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    error? response = storecove->deletePeppolIdentifier(id, <string>created?.superscheme, <string>created?.scheme, <string>created?.identifier);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateAdditionalTaxIdentifier() returns error? {
    int id = legalEntityId();
    AdditionalTaxIdentifier response = check storecove->createAdditionalTaxIdentifier(id, {
        country: "DE",
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    test:assertTrue(response?.id is int);
    test:assertEquals(response?.identifier, "DE123456789");
    check storecove->deleteAdditionalTaxIdentifier(id, <int>response?.id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAdditionalTaxIdentifier() returns error? {
    int id = legalEntityId();
    AdditionalTaxIdentifier created = check storecove->createAdditionalTaxIdentifier(id, {
        country: "DE",
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    int taxIdentifierId = <int>created?.id;
    AdditionalTaxIdentifier response = check storecove->getAdditionalTaxIdentifier(id, taxIdentifierId);
    test:assertEquals(response?.id, taxIdentifierId);
    check storecove->deleteAdditionalTaxIdentifier(id, taxIdentifierId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateAdditionalTaxIdentifier() returns error? {
    int id = legalEntityId();
    AdditionalTaxIdentifier created = check storecove->createAdditionalTaxIdentifier(id, {
        country: "DE",
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    int taxIdentifierId = <int>created?.id;
    AdditionalTaxIdentifier response = check storecove->updateAdditionalTaxIdentifier(id, taxIdentifierId, {identifier: "DE987654321"});
    test:assertEquals(response?.identifier, "DE987654321");
    check storecove->deleteAdditionalTaxIdentifier(id, taxIdentifierId);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteAdditionalTaxIdentifier() returns error? {
    int id = legalEntityId();
    AdditionalTaxIdentifier created = check storecove->createAdditionalTaxIdentifier(id, {
        country: "DE",
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    error? response = storecove->deleteAdditionalTaxIdentifier(id, <int>created?.id);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateInvoiceSubmission() returns error? {
    InvoiceSubmissionResult response = check storecove->createInvoiceSubmission({legalEntityId: legalEntityId(), document: "PEludm9pY2UvPg=="});
    test:assertTrue(response?.guid is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetInvoiceSubmissionEvidence() returns error? {
    InvoiceSubmissionResult submission = check storecove->createInvoiceSubmission({
        legalEntityId: legalEntityId(),
        document: "PEludm9pY2UvPg=="
    });
    InvoiceSubmissionEvidence response = check storecove->getInvoiceSubmissionEvidence(<string>submission?.guid);
    test:assertTrue(response?.status is string);
    test:assertTrue((response?.actions ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateDocumentSubmission() returns error? {
    DocumentSubmissionResult response = check storecove->createDocumentSubmission({
        legalEntityId: legalEntityId(),
        document: {documentType: "invoice"}
    });
    test:assertTrue(response?.guid is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetDocumentSubmissionEvidence() returns error? {
    DocumentSubmissionResult submission = check storecove->createDocumentSubmission({
        legalEntityId: legalEntityId(),
        document: {documentType: "invoice"}
    });
    DocumentSubmissionEvidence response = check storecove->getDocumentSubmissionEvidence(<string>submission?.guid, "sending");
    test:assertTrue(response?.guid is string);
    test:assertTrue((response?.documents ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testPreflightInvoiceRecipient() returns error? {
    PreflightInvoiceRecipientResult response = check storecove->preflightInvoiceRecipient({
        publicIdentifiers: [{scheme: "DE:VAT", id: "DE123456789"}]
    });
    test:assertEquals(response?.code, "ok");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDiscoverReceives() returns error? {
    DiscoveredParticipant response = check storecove->discoverReceives({
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    test:assertEquals(response?.code, "OK");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDiscoverExists() returns error? {
    DiscoveredParticipant response = check storecove->discoverExists({
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    test:assertEquals(response?.code, "OK");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDiscoverIdentifiers() returns error? {
    CountrySpecifications response = check storecove->discoverIdentifiers();
    test:assertTrue((response?.countries ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPurchaseInvoice() returns error? {
    PurchaseInvoice response = check storecove->getPurchaseInvoice("a1b2c3d4-0000-4000-8000-000000000001");
    test:assertTrue(response?.invoiceNumber is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetPurchaseInvoicePackaged() returns error? {
    PurchaseInvoiceUbl response = check storecove->getPurchaseInvoicePackaged("a1b2c3d4-0000-4000-8000-000000000001", "ubl");
    test:assertEquals(response?.guid, "a1b2c3d4-0000-4000-8000-000000000001");
    test:assertTrue(response?.ubl is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateReceivedDocument() returns error? {
    ReceivedDocument response = check storecove->createReceivedDocument(legalEntityId(), {
        document: "PEludm9pY2UvPg==",
        parseStrategy: "rfc822"
    });
    test:assertTrue(response?.guid is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetReceivedDocument() returns error? {
    ReceivedDocument received = check storecove->createReceivedDocument(legalEntityId(), {
        document: "PEludm9pY2UvPg==",
        parseStrategy: "rfc822"
    });
    string guid = <string>received?.guid;
    Transportable response = check storecove->getReceivedDocument(guid, "original");
    test:assertTrue(response?.guid is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetWebhookInstance() returns error? {
    WebhookInstance? response = check storecove->getWebhookInstance();
    test:assertTrue(response is WebhookInstance);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testWebhookInstanceDeletion() returns error? {
    // Webhook instances can't be created through the API; delete the next queued one, if any.
    WebhookInstance? queued = check storecove->getWebhookInstance();
    if queued is () {
        return;
    }
    error? response = storecove->deleteWebhookInstance(<string>queued?.guid);
    test:assertTrue(response is ());
}
