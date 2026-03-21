*** Settings ***
Documentation    Unhappy-path tests for the Cat Facts API GET /breeds endpoint.
Resource         ../resources/breeds_api.resource

*** Test Cases ***
Retrieve breeds with limit zero
    [Documentation]    GET /breeds?limit=0 should return 200 or 400 without server errors.
    [Tags]    unhappy
    Given the breeds endpoint is available
    When I send a GET request to breeds with param "limit" value "0"
    Then the response status code should not be a server error
    And the response should not expose server errors

Retrieve breeds with negative limit
    [Documentation]    GET /breeds?limit=-1 should not cause a server error or expose stack traces.
    [Tags]    unhappy
    Given the breeds endpoint is available
    When I send a GET request to breeds with param "limit" value "-1"
    Then the response status code should not be a server error
    And the response should not expose server errors

Retrieve breeds with non-numeric limit
    [Documentation]    GET /breeds?limit=abc should not cause a server error or expose internals.
    [Tags]    unhappy
    Given the breeds endpoint is available
    When I send a GET request to breeds with param "limit" value "abc"
    Then the response status code should not be a server error
    And the response should not expose server errors

# --- Data-Driven: invalid limit values via Template ---

Invalid limit values should not cause server errors
    [Documentation]    Data-driven test validating multiple invalid limit values.
    [Tags]    unhappy    data-driven
    [Template]    Validate Invalid Limit Does Not Cause Server Error
    0
    -1
    -100
    abc
    !@#
    99999