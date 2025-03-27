*** Settings ***
Resource    ./Imports/imports.resource


*** Variables ***
${URL}            http://uitestingplayground.com/progressbar
${BROWSER}        chrome
${START_BUTTON}    //button[@id='startButton']
${STOP_BUTTON}     //button[@id='stopButton']
${PROGRESS_BAR}    //div[@id='progressBar']

*** Keywords ***
Open Browser Progress Bar
    Open Browser With Chrome Headless    ${URL}
    Maximize Browser Window

Close Browser Proggres Bar
    Close All Browsers

Valid Progress Bar Page
    Page Should Contain    Progress Bar
    Page Should Contain Element    ${START_BUTTON}
    Page Should Contain Element    ${STOP_BUTTON}
    Page Should Contain Element    ${PROGRESS_BAR}

Click Start Button And Stop Button At 75Percent
    Click Element    ${START_BUTTON}
    Wait Until Element Contains    ${PROGRESS_BAR}       75%    timeout=55s
    #Sleep    30s
    Click Element    ${STOP_BUTTON}
    
    
    