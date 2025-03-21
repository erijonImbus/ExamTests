*** Settings ***
Resource    ../Resources/Imports/imports.resource
Test Setup       Open Browser Overlapped TextBox 
Test Teardown    Close Browser Overlapped TextBox


*** Test Cases ***
Enter Data To Overlapped Elements
    Valid Overlapped TextBox Page
    Fill ID And Name Textboxs With Data
    
    