*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Ignore SSL Warnings

*** Variables ***
${BASE_URL}    https://petstore.swagger.io/v1
${AUTH_TOKEN}  Bearer Token

*** Test Cases ***
TC001 Verify successful GET request for pets with limit parameter
    [Documentation]    Preconditions: The system should have pets available
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the response has valid pets data
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    limit=10
    ${response}=    GET On Session    api    /pets    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${body}=    Set Variable    ${response.json()}
    FOR    ${pet}    IN    @{body}
        Should Be True    'id' in ${pet}
        Should Be True    'name' in ${pet}
    END

TC002 Verify GET request for pets with invalid limit parameter
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the response for invalid parameter
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    limit=invalid
    ${response}=    GET On Session    api    /pets    headers=${headers}    params=${params}
    ${status_code}=    Set Variable    ${response.status_code}
    ${body}=    Set Variable    ${response.json()}
    Log    Response status: ${status_code}
    Log    Response body: ${body}
    Run Keyword If    ${status_code} == 400    Should Be Equal    ${body}[message]    Invalid limit value
    Run Keyword If    ${status_code} != 400    Fail    Expected status code 400 but got ${status_code}

*** Keywords ***
Ignore SSL Warnings
    [Documentation]    Ignore SSL warnings for this test run.
    Evaluate    requests.packages.urllib3.disable_warnings()