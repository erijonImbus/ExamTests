*** Settings ***
Resource    ./Imports/imports.resource

*** Variables ***
${DynamicTable_URL}            http://uitestingplayground.com/dynamictable
${BROWSER}                     chrome
${CHROME_CELL}                //span[contains(text(),'Chrome')]
${CHROME_CPU_YELLOW_FLAG}     //p[@class='bg-warning']
${CHROME_CPU_CELL}            //div[span[contains(text(),'Chrome')]]//span[contains(text(),'%')]

*** Keywords ***
Open Browser Dynamic Table
    Open Browser    ${DynamicTable_URL}    ${BROWSER}
    Maximize Browser Window

Close Browser Dynamic Table
    Close All Browsers

Valid Dynamic Table Page
    Page Should Contain    Dynamic Table
    Page Should Contain Element    ${CHROME_CELL}
    Page Should Contain Element    ${CHROME_CPU_YELLOW_FLAG}

Chrome CPU Value Comparisson
   ${CHROME_CPU_CELL_VALUE}    Get Text    ${CHROME_CPU_CELL}
   #Log    ${CHROME_CPU_CELL_VALUE}
   ${CHROME_CPU_YELLOW_FLAG_VALUE}    Get Text    ${CHROME_CPU_YELLOW_FLAG}
   ${FETCHED_TEXT}  Fetch From Right    ${CHROME_CPU_YELLOW_FLAG_VALUE}    :
   #Log      ${FETCHED_TEXT}
   
   Should Be Equal As Strings   ${CHROME_CPU_CELL_VALUE}    ${FETCHED_TEXT.strip()}
    Reload Page
    
    ${CHROME_CPU_CELL_VALUE1}    Get Text    ${CHROME_CPU_CELL}
    #Log    ${CHROME_CPU_CELL_VALUE1}
   ${CHROME_CPU_YELLOW_FLAG_VALUE1}    Get Text    ${CHROME_CPU_YELLOW_FLAG}
   ${FETCHED_TEXT1}  Fetch From Right    ${CHROME_CPU_YELLOW_FLAG_VALUE1}    :
   #Log      ${FETCHED_TEXT1}
    
    Should Be Equal As Strings   ${CHROME_CPU_CELL_VALUE1}    ${FETCHED_TEXT1.strip()}