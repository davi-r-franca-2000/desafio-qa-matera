*** Settings ***
Resource      common.resource
Variables     ../variables/global_variables.py
Library       Collections
Library       String
Library       json_schema_validator.py
Library       breeds_data_utils.py

*** Variables ***
${RESPONSE}       ${EMPTY}
${JSON_BODY}      ${EMPTY}
${FILTERED}       ${EMPTY}
${SORTED_NAMES}   ${EMPTY}
${UNIQUE_VALUES}  ${EMPTY}
${UPPER_NAMES}    ${EMPTY}
${FIELD_COUNTS}   ${EMPTY}

*** Keywords ***
# --------------- Given ---------------

the breeds endpoint is available
    Create API Session

# --------------- When ----------------

I send a GET request to breeds
    ${resp}=    GET On Session    catfact    ${BREEDS_ENDPOINT}    expected_status=any
    Set Test Variable    ${RESPONSE}    ${resp}

I send a GET request to breeds with param "${param}" value "${value}"
    ${params}=    Create Dictionary    ${param}=${value}
    ${resp}=    GET On Session    catfact    ${BREEDS_ENDPOINT}    params=${params}    expected_status=any
    Set Test Variable    ${RESPONSE}    ${resp}

# --------------- Then ----------------

the response status code should be "${status}"
    ${expected}=    Convert To Integer    ${status}
    Should Be Equal As Integers    ${RESPONSE.status_code}    ${expected}

the response status code should not be a server error
    Should Be True    ${RESPONSE.status_code} < 500    API returned server error: ${RESPONSE.status_code}

the response body should be valid JSON
    ${json}=    Set Variable    ${RESPONSE.json()}
    Set Test Variable    ${JSON_BODY}    ${json}

the response should contain pagination fields
    Dictionary Should Contain Key    ${JSON_BODY}    current_page
    Dictionary Should Contain Key    ${JSON_BODY}    data
    Dictionary Should Contain Key    ${JSON_BODY}    per_page
    Dictionary Should Contain Key    ${JSON_BODY}    total
    Dictionary Should Contain Key    ${JSON_BODY}    last_page

the data array should not be empty
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${length}=    Get Length    ${data}
    Should Be True    ${length} > 0

the data array should contain at most "${limit}" items
    ${expected}=    Convert To Integer    ${limit}
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${length}=    Get Length    ${data}
    Should Be True    ${length} <= ${expected}

each breed object should have the required fields
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    FOR    ${breed}    IN    @{data}
        Dictionary Should Contain Key    ${breed}    breed
        Dictionary Should Contain Key    ${breed}    country
        Dictionary Should Contain Key    ${breed}    origin
        Dictionary Should Contain Key    ${breed}    coat
        Dictionary Should Contain Key    ${breed}    pattern
    END

all breed fields should be strings
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    FOR    ${breed}    IN    @{data}
        Should Be String    ${breed}[breed]
        Should Be String    ${breed}[country]
        Should Be String    ${breed}[origin]
        Should Be String    ${breed}[coat]
        Should Be String    ${breed}[pattern]
    END

the data array should contain all available breeds
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${data_length}=    Get Length    ${data}
    ${total}=    Get From Dictionary    ${JSON_BODY}    total
    Should Be Equal As Integers    ${data_length}    ${total}

the total field should reflect the actual number of breeds
    ${total}=    Get From Dictionary    ${JSON_BODY}    total
    Should Be True    ${total} > 0

the response should match the breeds JSON schema
    Validate JSON Schema    ${RESPONSE.text}    ${BREED_SCHEMA}

the response should not expose server errors
    Should Be True    ${RESPONSE.status_code} < 500    API returned server error: ${RESPONSE.status_code}
    ${body}=    Convert To String    ${RESPONSE.text}
    Should Not Contain    ${body}    stack trace
    Should Not Contain    ${body}    Traceback
    Should Not Contain    ${body}    Exception
    Should Not Contain    ${body}    Internal Server Error

Validate Invalid Limit Does Not Cause Server Error
    [Arguments]    ${limit_value}
    Given the breeds endpoint is available
    When I send a GET request to breeds with param "limit" value "${limit_value}"
    Then the response status code should not be a server error
    And the response should not expose server errors

# ---- Desafio Adicional (Opcao C) ---- #
# Keywords abaixo utilizam a biblioteca Python breeds_data_utils.py
# para manipulacao de strings e listas da resposta da API.

I send a GET request to breeds with all results
    ${params}=    Create Dictionary    limit=200
    ${resp}=    GET On Session    catfact    ${BREEDS_ENDPOINT}    params=${params}    expected_status=any
    Set Test Variable    ${RESPONSE}    ${resp}
    ${json}=    Set Variable    ${resp.json()}
    Set Test Variable    ${JSON_BODY}    ${json}

I filter breeds by "${field}" equal to "${value}"
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${result}=    Filter Breeds By Field    ${data}    ${field}    ${value}
    Set Test Variable    ${FILTERED}    ${result}

the filtered list should only contain breeds with "${field}" equal to "${value}"
    FOR    ${breed}    IN    @{FILTERED}
        ${actual}=    Set Variable    ${breed}[${field}]
        ${actual_lower}=    Convert To Lower Case    ${actual}
        ${expected_lower}=    Convert To Lower Case    ${value}
        Should Be Equal    ${actual_lower}    ${expected_lower}
    END

the filtered list should not be empty
    ${length}=    Get Length    ${FILTERED}
    Should Be True    ${length} > 0

I sort the breed names alphabetically
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${result}=    Get Breed Names Sorted    ${data}
    Set Test Variable    ${SORTED_NAMES}    ${result}

the breed names should be in alphabetical order
    ${length}=    Get Length    ${SORTED_NAMES}
    Should Be True    ${length} > 1
    ${expected}=    Copy List    ${SORTED_NAMES}
    Sort List    ${expected}
    Lists Should Be Equal    ${SORTED_NAMES}    ${expected}

I extract unique values for "${field}"
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${result}=    Get Unique Values    ${data}    ${field}
    Set Test Variable    ${UNIQUE_VALUES}    ${result}

the unique values list should not be empty
    ${length}=    Get Length    ${UNIQUE_VALUES}
    Should Be True    ${length} > 0

I format breed names to uppercase
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${result}=    Format Breed Names Upper    ${data}
    Set Test Variable    ${UPPER_NAMES}    ${result}

all breed names should be uppercase
    FOR    ${name}    IN    @{UPPER_NAMES}
        ${expected}=    Convert To Upper Case    ${name}
        Should Be Equal    ${name}    ${expected}
    END

I count breeds by "${field}"
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${result}=    Count Breeds By Field    ${data}    ${field}
    Set Test Variable    ${FIELD_COUNTS}    ${result}

the sum of counts should equal the total breeds
    ${data}=    Get From Dictionary    ${JSON_BODY}    data
    ${total_breeds}=    Get Length    ${data}
    ${values}=    Get Dictionary Values    ${FIELD_COUNTS}
    ${sum}=    Evaluate    sum(${values})
    Should Be Equal As Integers    ${sum}    ${total_breeds}
