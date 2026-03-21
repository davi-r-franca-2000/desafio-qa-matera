*** Settings ***
Documentation    Happy-path tests for the Cat Facts API GET /breeds endpoint.
Resource         ../resources/breeds_api.resource

*** Test Cases ***
Retrieve breeds without parameters
    [Documentation]    GET /breeds returns 200, valid JSON, and a paginated list of breeds.
    [Tags]    happy
    Given the breeds endpoint is available
    When I send a GET request to breeds
    Then the response status code should be "200"
    And the response body should be valid JSON
    And the response should contain pagination fields
    And the data array should not be empty
    And each breed object should have the required fields

Retrieve breeds with a valid limit
    [Documentation]    GET /breeds?limit=5 returns 200 and at most 5 breeds in the data array.
    [Tags]    happy
    Given the breeds endpoint is available
    When I send a GET request to breeds with param "limit" value "5"
    Then the response status code should be "200"
    And the response body should be valid JSON
    And the data array should contain at most "5" items
    And each breed object should have the required fields

Retrieve breeds with limit greater than total records
    [Documentation]    GET /breeds?limit=200 returns all available breeds and total reflects the actual count.
    [Tags]    happy
    Given the breeds endpoint is available
    When I send a GET request to breeds with param "limit" value "200"
    Then the response status code should be "200"
    And the response body should be valid JSON
    And the data array should contain all available breeds
    And the total field should reflect the actual number of breeds
