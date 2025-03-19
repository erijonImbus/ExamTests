*** Settings ***
Resource    ../Resources/Imports/imports.resource
Test Setup       Open Browser Progress Bar  
Test Teardown    Close Browser Proggres Bar
*** Variables ***


*** Test Cases ***
Test Progress Bar Start/Stop At 75 Percentage 
    Valid Progress Bar Page
    Click Start Button And Stop Button At 75Percent
    
    