*** Settings ***
Documentation    Desafio Adicional (Opcao C) – Manipulacao de Strings/Listas da Resposta.
...              Testes que utilizam a biblioteca Python customizada breeds_data_utils.py
...              para filtrar, formatar e agregar dados da lista de breeds.
Resource         ../resources/breeds_api.resource

*** Test Cases ***
Filter breeds by coat type
    [Documentation]    Filtra breeds por coat=Short e verifica que todos os resultados possuem esse coat.
    [Tags]    extra
    Given the breeds endpoint is available
    When I send a GET request to breeds with all results
    And I filter breeds by "coat" equal to "Short"
    Then the filtered list should not be empty
    And the filtered list should only contain breeds with "coat" equal to "Short"

Filter breeds by country
    [Documentation]    Filtra breeds por country=United Kingdom e valida os resultados.
    [Tags]    extra
    Given the breeds endpoint is available
    When I send a GET request to breeds with all results
    And I filter breeds by "country" equal to "United Kingdom"
    Then the filtered list should not be empty
    And the filtered list should only contain breeds with "country" equal to "United Kingdom"

Get breed names sorted alphabetically
    [Documentation]    Obtem todos os nomes de racas ordenados e verifica a ordenacao.
    [Tags]    extra
    Given the breeds endpoint is available
    When I send a GET request to breeds with all results
    And I sort the breed names alphabetically
    Then the breed names should be in alphabetical order

Get unique coat types
    [Documentation]    Extrai os valores unicos do campo coat e verifica que a lista nao esta vazia.
    [Tags]    extra
    Given the breeds endpoint is available
    When I send a GET request to breeds with all results
    And I extract unique values for "coat"
    Then the unique values list should not be empty

Format breed names to uppercase
    [Documentation]    Formata todos os nomes de racas em uppercase e valida a formatacao.
    [Tags]    extra
    Given the breeds endpoint is available
    When I send a GET request to breeds with all results
    And I format breed names to uppercase
    Then all breed names should be uppercase

Count breeds by country
    [Documentation]    Conta quantas racas existem por pais e verifica que a soma bate com o total.
    [Tags]    extra
    Given the breeds endpoint is available
    When I send a GET request to breeds with all results
    And I count breeds by "country"
    Then the sum of counts should equal the total breeds
