*** Settings ***
Resource    ../Resources/Imports/imports.resource
Test Setup       Open Browser ECommerce
Test Teardown    Close Browser ECommerce


*** Test Cases ***
Adds Products To Cart In ECommerce Platform
    [Tags]    bug
    Set Selenium Speed    0.5s
    Valid ECommerce Home Page
    Select Product1
    Select Product2
    Select Product3
    Select Product4
    Go To Checkout
    Validate Products In Checkoutt
    #Validate That Products Have Been Added To Checkout