*** Settings ***
Documentation    Contract / schema validation tests for the Cat Facts API GET /breeds endpoint.
Resource         ../resources/breeds_api.resource

*** Test Cases ***
Validate breeds response JSON schema
    [Documentation]    Validates the full response against the JSON Schema defined in global_variables.py.
    [Tags]    contract
    Given the breeds endpoint is available
    When I send a GET request to breeds
    Then the response status code should be "200"
    And the response body should be valid JSON
    And the response should match the breeds JSON schema

Validate breed object field types
    [Documentation]    Verifies that every field in each breed object is a string.
    [Tags]    contract
    Given the breeds endpoint is available
    When I send a GET request to breeds
    Then the response status code should be "200"
    And the response body should be valid JSON
    And each breed object should have the required fields
    And all breed fields should be strings
