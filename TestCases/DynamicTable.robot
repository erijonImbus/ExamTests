*** Settings ***
Resource    ../Resources/Imports/imports.resource
Test Setup       Open Browser Dynamic Table
Test Teardown    Close Browser Dynamic Table


*** Test Cases ***
Compare Chrome CPU-s Values For Equality
    [Tags]    smoke
    Valid Dynamic Table Page
    Chrome CPU Value Comparisson
    Sleep    3s