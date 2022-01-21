Feature: Tests for breeds API

  Background:
    * url apiUrl
    * header x-api-key = api_key
    * def responseSchema = read('./schemas/response-schema.json')
    * def responseHeadersSchema = read('./schemas/response-headers.json')
    * path '/breeds'

  @breeds
  Scenario: Get the full list of breeds
    When method Get
    Then status 200
    * def size = response.length
    And match  response == '#[]'
    And match size == "#(~~responseHeaders['pagination-count'][0])"
    And match each response == responseSchema.data
    And match responseHeaders == responseHeadersSchema


  @breeds
  Scenario Outline: Get the list of breeds with parameters
    Given param page = <page>
    And param limit = <limit>
    And param order = '<order>'
    When method Get
    Then status 200
    * def size = response.length
    And match  response == '#[]'
    And match size == "#(~~responseHeaders['pagination-limit'][0])"
    And match  size == <limit>
    And match responseHeaders == responseHeadersSchema

    Examples:
      | page | limit | order |
      | 15   | 3     | DESC  |
      | 6    | 7     | ASC   |

  @breeds
  Scenario Outline: Get a breed by name succesfully
    Given param q = '<name>'
    And path '/search'
    When method Get
    Then status 200
    And match  response == '#[]'
    And match response[0].name == '<fullName>'
    And match responseHeaders == responseHeadersSchema

    Examples:
      | name | fullName         |
      | Sib  | Siberian         |
      | Jap  | Japanese Bobtail |
