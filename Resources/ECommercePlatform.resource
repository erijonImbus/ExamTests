*** Settings ***
Resource    ./Imports/imports.resource

*** Variables ***
${ECommerce_URL}            https://www.demoblaze.com/
${BROWSER}                  chrome
${NAVBAR_CONTAINER}         //div[@id="navbarExample"]

${PRODUCT1}    //a[@class='hrefch' and contains(text(), 'Samsung galaxy s6')]
${PRODUCT2}    //a[@class='hrefch' and contains(text(), 'Nokia lumia 1520')]
${PRODUCT3}    //a[@class='hrefch' and contains(text(), 'Nexus 6')]
${PRODUCT4}    //a[@class='hrefch' and contains(text(), 'Samsung galaxy s7')]    
${PRODUCT5}    //a[@href='prod.html?idp_=5']
${PRODUCT6}    //a[@href='prod.html?idp_=6']
${PRODUCT7}    //a[@href='prod.html?idp_=7']
${PRODUCT8}    //a[@href='prod.html?idp_=8']
${PRODUCT9}    //a[@href='prod.html?idp_=9']

${GO_TO_CART}            //a[@id='cartur']
${PLACE_ORDER_BUTTON}    //button[contains(text(), 'Place Order')]
${PRODUCTS_TABLE}    //div[@class='table-responsive']

#@{ALL_PRODUCTS}    ${PRODUCT1}    ${PRODUCT2}    ${PRODUCT3}    ${PRODUCT4}    ${PRODUCT5}    ${PRODUCT6}    ${PRODUCT7}    ${PRODUCT8}    ${PRODUCT9}

${ADD_TO_CART}    //a[contains(text(), 'Add to cart')]
*** Keywords ***
Open Browser ECommerce
    Open Browser With Chrome Headless    ${ECommerce_URL}
    Maximize Browser Window

Close Browser ECommerce
    Close All Browsers

Valid ECommerce Home Page
    Page Should Contain    PRODUCT STORE
    Page Should Contain Element    ${NAVBAR_CONTAINER}

Select Product1
   Click Element    ${PRODUCT1}
   Click Element    ${ADD_TO_CART}
   Handle Alert    ACCEPT
   Go To    ${ECommerce_URL}

Select Product2
   Click Element    ${PRODUCT2}
   Click Element    ${ADD_TO_CART}
   Handle Alert    ACCEPT
   Go To    ${ECommerce_URL}

Select Product3
   Click Element    ${PRODUCT3}
   Click Element    ${ADD_TO_CART}
   Handle Alert    ACCEPT
   Go To    ${ECommerce_URL}

Select Product4
   Click Element    ${PRODUCT4}
   Click Element    ${ADD_TO_CART}
   Handle Alert    ACCEPT
   Go To    ${ECommerce_URL}

Go To Checkout
    Click Element    //a[@id='cartur']
    Wait Until Page Contains Element    ${PLACE_ORDER_BUTTON}
    Sleep     3s


Validate That Products Have Been Added To Checkout
    ${ALL_PRODUCTS_IN_CART}    Get Text    ${PRODUCTS_TABLE}
    FOR    ${element}    IN    ${ALL_PRODUCTS_IN_CART}
        Log    ${element}
    END
    @{ALL_PRODUCTS_IN_CART}    Should Contain    container    item

Validate Products In Checkoutt
    ${product_names}    Get WebElements    //tr[@class='success']//td[2]
    Should Not Be Empty    ${product_names}
    FOR    ${product}    IN    @{product_names}
        ${name}    Get Text    ${product}
        Log    Is in Cart: ${name}
    END 




