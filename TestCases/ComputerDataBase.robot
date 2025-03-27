*** Settings ***
Resource         ../Resources/Imports/imports.resource
Test Setup       Open Computer DB Browser
Test Teardown    Close All Browsers

*** Variables ***
${URL_DB}        https://computer-database.gatling.io/computers
${BROWSER_DB}    chrome

*** Test Cases ***
Tabular Of Scraped Computer Data
    [Documentation]    Scraped computer data from the website and loging it as a nested dictionary.
    [Tags]    smoke    work01
    ${Computers}          Get Computer Data
    Log Computer Data     &{Computers}
    Log    ${Computers}

*** Keywords ***
Open Computer DB Browser
    Open Browser With Chrome Headless    ${URL_DB}
    Maximize Browser Window

Close Computer DB Browser
    Close All Browsers

Get Computer Data
    [Documentation]    Extract computer data from the table and return it as a dictionary.
    ${Rows}    Get Element Count    //table[@class='computers zebra-striped']/tbody/tr
    ${Computers}    Create Dictionary
    FOR    ${i}    IN RANGE    1    ${Rows}+1
        ${Computer_Name}    Get Text    //table[@class='computers zebra-striped']/tbody/tr[${i}]/td[1]/a
        ${Introduced}       Get Text    //table[@class='computers zebra-striped']/tbody/tr[${i}]/td[2]
        ${Discontinued}     Get Text    //table[@class='computers zebra-striped']/tbody/tr[${i}]/td[3]
        ${Company}          Get Text    //table[@class='computers zebra-striped']/tbody/tr[${i}]/td[4]
        &{Details}          Create Dictionary    introduced=${Introduced}    discontinued=${Discontinued}    company=${Company}
        Set To Dictionary    ${Computers}    ${Computer_Name}    ${Details}
    END
    RETURN    ${Computers}

Log Computer Data
    [Documentation]    Log the computer data.
    [Arguments]    &{Computers}
    FOR    ${Cn}    ${Dt}    IN    &{Computers}
        Log    ${cn}: ${Dt}
    END
