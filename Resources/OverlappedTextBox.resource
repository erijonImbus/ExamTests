*** Settings ***
Resource    ./Imports/imports.resource


*** Variables ***
${Overlapped_URL}            http://uitestingplayground.com/overlapped
${BROWSER}        chrome

${ID_TEXTBOX}         //input[@id = 'id']
${NAME_TEXTBOX}       //input[@id='name']
${SUBJECT_ELEMENT}    //input[@id='subject']
${ID_VALUE}        ID12345
${NAME_VALUE}      FILAN


*** Keywords ***
Open Browser Overlapped TextBox
    Open Browser    ${Overlapped_URL}    ${BROWSER}
    Maximize Browser Window

Close Browser Overlapped TextBox
    Close All Browsers

Valid Overlapped TextBox Page
    Page Should Contain    Overlapped Element
    Page Should Contain Element    ${ID_TEXTBOX}
    Page Should Contain Element    ${NAME_TEXTBOX}

Fill ID And Name Textboxs With Data
    [Arguments]    ${id}=${ID_VALUE}    ${name}=${NAME_VALUE}
    Input Text    ${ID_TEXTBOX}    ${id}
    Sleep    5s
    Scroll Element Into View    ${SUBJECT_ELEMENT}
    Input Text    ${NAME_TEXTBOX}    ${name}
    Sleep    5s

