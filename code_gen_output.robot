*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Ignore SSL Warnings

*** Variables ***
${BASE_URL}    https://virtserver.swaggerhub.com/MetaFactoryBV/PetStore/1.0.0
${AUTH_TOKEN}  Bearer Token

*** Test Cases ***
TC001 Verify successful GET request for pets with limit
    [Documentation]    Preconditions: Pets must exist in the system
    ...                API Endpoint: /pets?limit={limit}
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
        Should Be True    'status' in ${pet}
    END

TC002 Verify GET request for pets with invalid limit parameter
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets?limit={limit}
    ...                Postconditions: Verify the response for invalid parameter
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    limit=-1
    ${response}=    GET On Session    api    /pets    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    400
    ${body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    error
    Should Be Equal    ${body}[error]    Invalid limit parameter

TC003 Verify successful POST request to add a new pet
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the response has valid pet data
    [Tags]    POST    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${body}=    Create Dictionary    id=123    name=Buddy    status=available
    ${response}=    POST On Session    api    /pets    headers=${headers}    json=${body}
    Should Be Equal As Numbers    ${response.status_code}    201
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[id]    123
    Should Be Equal    ${response_body}[name]    Buddy
    Should Be Equal    ${response_body}[status]    available

TC004 Verify POST request with missing required fields
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the response for missing required fields
    [Tags]    POST    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${body}=    Create Dictionary    name=Buddy
    ${response}=    POST On Session    api    /pets    headers=${headers}    json=${body}
    Should Be Equal As Numbers    ${response.status_code}    400
    ${response_body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${response_body}    error
    Should Be Equal    ${response_body}[error]    Missing required fields

TC005 Verify successful GET request for a pet by ID
    [Documentation]    Preconditions: The pet ID must exist in the system
    ...                API Endpoint: /pets/{petId}
    ...                Postconditions: Verify the response has valid pet data
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${pet_id}=    Set Variable    123
    ${response}=    GET On Session    api    /pets/${pet_id}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[id]    123
    Should Be Equal    ${response_body}[name]    Buddy
    Should Be Equal    ${response_body}[status]    available

TC006 Verify GET request for a pet by invalid ID
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets/{petId}
    ...                Postconditions: Verify the response for invalid pet ID
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${pet_id}=    Set Variable    invalid_id
    ${response}=    GET On Session    api    /pets/${pet_id}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    404
    ${response_body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${response_body}    error
    Should Be Equal    ${response_body}[error]    Pet not found

*** Keywords ***
Ignore SSL Warnings
    [Documentation]    Ignore SSL warnings for this test run.
    Evaluate    requests.packages.urllib3.disable_warnings()