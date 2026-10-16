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

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateLegalEntity() returns error? {
    LegalEntity response = check storecove->createLegalEntity({
        partyName: "Acme Trading GmbH",
        line1: "Hauptstrasse 12",
        city: "Berlin",
        zip: "10115",
        country: "DE"
    });
    test:assertTrue(response?.id is int);
    test:assertEquals(response?.partyName, "Acme Trading GmbH");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetLegalEntity() returns error? {
    LegalEntity response = check storecove->getLegalEntity(1001);
    test:assertEquals(response?.id, 1001);
    test:assertTrue(response?.partyName is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateLegalEntity() returns error? {
    LegalEntity response = check storecove->updateLegalEntity(1001, {partyName: "Acme Trading GmbH", city: "Munich"});
    test:assertEquals(response?.id, 1001);
    test:assertEquals(response?.city, "Munich");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteLegalEntity() returns error? {
    LegalEntity created = check storecove->createLegalEntity({
        partyName: "Acme Trading GmbH",
        line1: "Hauptstrasse 12",
        city: "Berlin",
        zip: "10115",
        country: "DE"
    });
    int createdId = <int>created?.id;
    error? response = storecove->deleteLegalEntity(createdId);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreatePeppolIdentifier() returns error? {
    PeppolIdentifier response = check storecove->createPeppolIdentifier(1001, {
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    test:assertEquals(response?.identifier, "DE123456789");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdatePeppolIdentifier() returns error? {
    PeppolIdentifier response = check storecove->updatePeppolIdentifier(1001, "iso6523-actorid-upis", "FR:CTC", "123456789", {
        annuaire: {routingCodeLabel: "Accounts payable"}
    });
    test:assertEquals(response?.scheme, "FR:CTC");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeletePeppolIdentifier() returns error? {
    PeppolIdentifier created = check storecove->createPeppolIdentifier(1001, {
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    error? response = storecove->deletePeppolIdentifier(1001, <string>created?.superscheme, <string>created?.scheme, <string>created?.identifier);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateAdditionalTaxIdentifier() returns error? {
    AdditionalTaxIdentifier response = check storecove->createAdditionalTaxIdentifier(1001, {
        country: "DE",
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    test:assertTrue(response?.id is int);
    test:assertEquals(response?.identifier, "DE123456789");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAdditionalTaxIdentifier() returns error? {
    AdditionalTaxIdentifier response = check storecove->getAdditionalTaxIdentifier(1001, 2001);
    test:assertEquals(response?.id, 2001);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateAdditionalTaxIdentifier() returns error? {
    AdditionalTaxIdentifier response = check storecove->updateAdditionalTaxIdentifier(1001, 2001, {identifier: "DE987654321"});
    test:assertEquals(response?.identifier, "DE987654321");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteAdditionalTaxIdentifier() returns error? {
    AdditionalTaxIdentifier created = check storecove->createAdditionalTaxIdentifier(1001, {
        country: "DE",
        superscheme: "iso6523-actorid-upis",
        scheme: "DE:VAT",
        identifier: "DE123456789"
    });
    error? response = storecove->deleteAdditionalTaxIdentifier(1001, <int>created?.id);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateInvoiceSubmission() returns error? {
    InvoiceSubmissionResult response = check storecove->createInvoiceSubmission({legalEntityId: 1001, document: "PEludm9pY2UvPg=="});
    test:assertTrue(response?.guid is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetInvoiceSubmissionEvidence() returns error? {
    InvoiceSubmissionEvidence response = check storecove->getInvoiceSubmissionEvidence("0c9d8e7f-6a5b-4c3d-9e2f-1a0b9c8d7e6f");
    test:assertTrue(response?.status is string);
    test:assertTrue((response?.actions ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateDocumentSubmission() returns error? {
    DocumentSubmissionResult response = check storecove->createDocumentSubmission({
        legalEntityId: 1001,
        document: {documentType: "invoice"}
    });
    test:assertTrue(response?.guid is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetDocumentSubmissionEvidence() returns error? {
    DocumentSubmissionEvidence response = check storecove->getDocumentSubmissionEvidence("5f8c1c0e-3b0a-4a53-9d0e-2d6f1b7a9c11", "sending");
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
    ReceivedDocument response = check storecove->createReceivedDocument(1001, {
        document: "PEludm9pY2UvPg==",
        parseStrategy: "rfc822"
    });
    test:assertTrue(response?.guid is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetReceivedDocument() returns error? {
    Transportable response = check storecove->getReceivedDocument("9a8b7c6d-5e4f-4a3b-8c2d-1e0f9a8b7c6d", "original");
    test:assertEquals(response?.guid, "9a8b7c6d-5e4f-4a3b-8c2d-1e0f9a8b7c6d");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetWebhookInstance() returns error? {
    WebhookInstance? response = check storecove->getWebhookInstance();
    test:assertTrue(response is WebhookInstance);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testWebhookInstanceDeletion() returns error? {
    error? response = storecove->deleteWebhookInstance("3d2c1b0a-9f8e-4d7c-8b6a-5f4e3d2c1b0a");
    test:assertTrue(response is ());
}
