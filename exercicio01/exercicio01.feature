Feature: User search with filters

  As a system user
  I want to filter users
  So that I can view results based on defined criteria

  # -------------------------
  # HAPPY FLOWS
  # -------------------------

  Scenario: Filter users by valid person type
    Given the user is on the user search screen
    And there are users registered for the selected type
    When the user selects a valid person type "X"
    And clicks the "Filter" button
    Then the system should display only users of the selected type

  Scenario: Filter users by existing name
    Given the user is on the user search screen
    And there is a user with name "X"
    When the user enters "X" in the Name field
    And clicks the "Filter" button
    Then the system should display users matching the given name

  Scenario: Filter users by existing email
    Given the user is on the user search screen
    And there is a user with email "X"
    When the user enters "X" in the Email field
    And clicks the "Filter" button
    Then the system should display the user corresponding to the given email

  Scenario: Filter users by valid combination of type and name
    Given the user is on the user search screen
    And there is a user with name "X" associated with person type "X"
    When the user selects "X" in the Person type field
    And enters "X" in the Name field
    And clicks the "Filter" button
    Then the system should display only users matching both filters

  Scenario: Filter users with minimum valid name length
    Given the user is on the user search screen
    And there is a user with the minimum valid name length
    When the user enters a name with the minimum accepted length in the Name field
    And clicks the "Filter" button
    Then the system should execute the search successfully
    And display matching results

  Scenario: Filter users without any filter applied
    Given the user is on the user search screen
    And there are registered users in the system
    When the user leaves all filter fields empty
    And clicks the "Filter" button
    Then the system should display all registered users

  # -------------------------
  # UNHAPPY FLOWS 
  # -------------------------

  Scenario: Filter users by non-existing name
    Given the user is on the user search screen
    When the user enters "X_nonexistent" in the Name field
    And clicks the "Filter" button
    Then the system should return no results

  Scenario: Filter users by non-existing email
    Given the user is on the user search screen
    When the user enters "X_nonexistent" in the Email field
    And clicks the "Filter" button
    Then the system should return no results

  Scenario: Filter users with invalid email format
    Given the user is on the user search screen
    When the user enters "X_invalid" in the Email field
    And clicks the "Filter" button
    Then the system should display a validation error message
    And should not execute the search

  Scenario: Filter users with invalid combination of type and name
    Given the user is on the user search screen
    And there is a user with name "X" associated with person type "Y"
    When the user selects a person type different from "Y"
    And enters "X" in the Name field
    And clicks the "Filter" button
    Then the system should return no results

  Scenario: Filter users with name exceeding maximum length
    Given the user is on the user search screen
    When the user enters a name exceeding the maximum allowed length in the Name field
    And clicks the "Filter" button
    Then the system should block the invalid input or display an error
    And should not execute an inconsistent search