Feature: Get cat breeds using /breeds endpoint

  As an API consumer
  I want to retrieve cat breeds
  So that I can use the data according to the requested limit

  # -------------------------
  # HAPPY FLOWS (3)
  # -------------------------

  Scenario: Retrieve breeds without limit parameter
    Given the API endpoint "/breeds" is available
    When I send a GET request to "/breeds"
    Then the response status code should be 200
    And the response body should be a valid JSON
    And the response should contain a paginated list of breeds

  Scenario: Retrieve breeds with a valid limit
    Given the API endpoint "/breeds" is available
    When I send a GET request to "/breeds?limit=5"
    Then the response status code should be 200
    And the response body should be a valid JSON
    And the "data" array should contain at most 5 breeds

  Scenario: Retrieve breeds with limit greater than total records
    Given the API endpoint "/breeds" is available
    When I send a GET request to "/breeds?limit=200"
    Then the response status code should be 200
    And the response body should be a valid JSON
    And the "data" array should contain all available breeds
    And the "total" field should reflect the actual number of breeds in the database

  # -------------------------
  # UNHAPPY FLOWS (3)
  # -------------------------

  Scenario: Retrieve breeds with limit equal to zero
    Given the API endpoint "/breeds" is available
    When I send a GET request to "/breeds?limit=0"
    Then the response status code should be 200 or 400
    And the response body should be a valid JSON
    And the "data" array should be empty or the response should indicate a client error

  Scenario: Retrieve breeds with a negative limit
    Given the API endpoint "/breeds" is available
    When I send a GET request to "/breeds?limit=-1"
    Then the response status code should be 200 or 400
    And the response body should be a valid JSON
    And the response should not expose any server error or stack trace

  Scenario: Retrieve breeds with a non-numeric limit
    Given the API endpoint "/breeds" is available
    When I send a GET request to "/breeds?limit=abc"
    Then the response status code should be 200 or 400
    And the response body should be a valid JSON
    And the response should not expose any server error or stack trace

  # -------------------------
  # SCHEMA / CONTRACT VALIDATION
  # -------------------------

  Scenario: Validate the response schema of the /breeds endpoint
    Given the API endpoint "/breeds" is available
    When I send a GET request to "/breeds"
    Then the response status code should be 200
    And the response body should be a valid JSON
    And the response should contain the pagination fields:
      | field           | type    |
      | current_page    | number  |
      | data            | array   |
      | per_page        | number  |
      | total           | number  |
      | last_page       | number  |
      | first_page_url  | string  |
      | last_page_url   | string  |
      | next_page_url   | string  |
      | prev_page_url   | null    |
      | path            | string  |
      | from            | number  |
      | to              | number  |
    And each object in the "data" array should contain the following fields:
      | field    | type   |
      | breed    | string |
      | country  | string |
      | origin   | string |
      | coat     | string |
      | pattern  | string |

  # -------------------------
  # CONTRACT VALIDATION STRATEGY
  # -------------------------
  #
  # To validate the response schema (API contract) we would:
  #
  # 1. JSON Schema Validation
  #    Define a JSON Schema (.json file) describing the expected structure,
  #    field names, types, and required properties for the /breeds response.
  #    Use a library (e.g. Ajv for JS, jsonschema for Python) to validate
  #    every response against this schema automatically in tests.
  #
  # 2. Required Fields Check
  #    Assert that all mandatory fields (breed, country, origin, coat, pattern)
  #    are present in each breed object and that pagination fields
  #    (current_page, data, total, per_page, last_page) are always returned.
  #
  # 3. Type Validation
  #    Verify that numeric fields (current_page, total, per_page, last_page,
  #    from, to) are integers and string fields (breed, country, origin,
  #    coat, pattern, URLs) are strings or null where applicable.
  #
  # 4. Contract Testing Tools
  #    Integrate a contract testing tool such as Pact or Dredd to
  #    continuously verify that the API responses match the documented
  #    contract (e.g. OpenAPI/Swagger spec), catching breaking changes
  #    early in the CI/CD pipeline.
