*** Settings ***
Resource    ../Resources/Imports/imports.resource
Test Setup       Open Browser And Navigate To URL
Test Teardown    Close All Browsers

*** Test Cases ***
Add Multiple Products To Cart
    Set Selenium Speed    0.5s
    Add Products To Cart    3  # Adjust this number based on available products
    Navigate To Checkout
    Validate Products In Checkout