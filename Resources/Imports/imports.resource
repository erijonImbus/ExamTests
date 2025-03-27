*** Settings ***

Resource    ../ProgressBar.resource
Resource    ../OverlappedTextBox.resource
Resource    ../DynamicTable.resource
Resource    ../ECommercePlatform.resource
Resource    ../ECommerceTest.resource

Library    Screenshot
Library    SeleniumLibrary
Library    Collections
Library    String
Library    OperatingSystem

*** Variables ***
${USER_DATA_DIR}    ${TEMP_DIR}/chrome_user_data
${TEMP_DIR}         /tmp   # You can adjust this path as per your environment or use tempfile in Robot Framework

*** Keywords ***
Set Chrome Headless Options
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    #Call Method    ${chrome_options}    add_argument    --user-data-dir=${USER_DATA_DIR}
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    [Return]    ${chrome_options}

Open Browser With Chrome Headless
    [Arguments]    ${URL}
    ${chrome_options}=    Set Chrome Headless Options
    Open Browser    ${URL}    chrome    options=${chrome_options}
    Maximize Browser Window

Open Browser Progress Bar Headless
    [Arguments]    ${URL}
    ${chrome_options}=    Set Chrome Headless Options
    Open Browser    ${URL}    chrome    options=${chrome_options}
    Maximize Browser Window


