*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Ignore SSL Warnings

*** Variables ***
${BASE_URL}    https://virtserver.swaggerhub.com/MetaFactoryBV/PetStore/1.0.0
${AUTH_TOKEN}  Bearer Token

*** Test Cases ***
TC001 Verify successful GET request for pets with limit parameter
    [Documentation]    Preconditions: The pets must exist in the system
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
    [Documentation]    Preconditions: The pets must exist in the system
    ...                API Endpoint: /pets?limit={limit}
    ...                Postconditions: Verify the response for invalid parameter
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    limit=invalidLimit
    ${response}=    GET On Session    api    /pets    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    400
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body}[error]    Invalid limit parameter

TC003 Verify GET request for pets with missing limit parameter
    [Documentation]    Preconditions: The pets must exist in the system
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the response has valid pets data
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /pets    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${body}=    Set Variable    ${response.json()}
    FOR    ${pet}    IN    @{body}
        Should Be True    'id' in ${pet}
        Should Be True    'name' in ${pet}
        Should Be True    'status' in ${pet}
    END

TC004 Verify successful POST request to create a new pet
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the new pet is created successfully
    [Tags]    POST    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${body}=    Create Dictionary    id=string    name=string    status=string
    ${response}=    POST On Session    api    /pets    headers=${headers}    json=${body}
    Should Be Equal As Numbers    ${response.status_code}    201
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[id]    string
    Should Be Equal    ${response_body}[name]    string
    Should Be Equal    ${response_body}[status]    string

TC005 Verify POST request to create a pet with missing required fields
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the response for missing required fields
    [Tags]    POST    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${body}=    Create Dictionary    name=string
    ${response}=    POST On Session    api    /pets    headers=${headers}    json=${body}
    Should Be Equal As Numbers    ${response.status_code}    400
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[error]    Missing required fields

TC006 Verify POST request to create a pet with invalid data
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets
    ...                Postconditions: Verify the response for invalid data
    [Tags]    POST    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${body}=    Create Dictionary    id=123    name=456    status=invalidStatus
    ${response}=    POST On Session    api    /pets    headers=${headers}    json=${body}
    Should Be Equal As Numbers    ${response.status_code}    400
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[error]    Invalid pet data

TC007 Verify successful GET request for a pet by ID
    [Documentation]    Preconditions: The pet ID must exist in the system
    ...                API Endpoint: /pets/{petId}
    ...                Postconditions: Verify the response has valid pet data
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    petId=validPetId
    ${response}=    GET On Session    api    /pets/${params[petId]}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[id]    validPetId
    Should Be Equal    ${response_body}[name]    string
    Should Be Equal    ${response_body}[status]    string

TC008 Verify GET request for a pet with invalid ID
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets/{petId}
    ...                Postconditions: Verify the response for invalid pet ID
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    petId=invalidPetId
    ${response}=    GET On Session    api    /pets/${params[petId]}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    404
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[error]    Pet not found

TC009 Verify GET request for a pet with missing ID
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pets/{petId}
    ...                Postconditions: Verify the response for missing pet ID
    [Tags]    GET    Pets
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /pets/    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    400
    Dictionary Should Contain Value    ${response.headers}    application/json
    ${response_body}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_body}[error]    Pet ID is required

*** Keywords ***
Ignore SSL Warnings
    [Documentation]    Ignore SSL warnings for this test run.
    Evaluate    requests.packages.urllib3.disable_warnings()