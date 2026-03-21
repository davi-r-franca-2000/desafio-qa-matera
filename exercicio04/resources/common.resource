*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Keywords ***
Create API Session
    Create Session    catfact    ${BASE_URL}    verify=${True}
