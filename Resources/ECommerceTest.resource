*** Settings ***
Resource    ./Imports/imports.resource

*** Variables ***
${URLi}                     https://www.demoblaze.com/
${BROWSER}                  chrome
${PRODUCT_TITLE_XPATH}      //h4[@class='card-title']
${ADD_TO_CART_XPATH}        //a[text()='Add to cart']
${CART_XPATH}               //a[text()='Cart']
${PLACE_ORDER_BUTTON_XPATH}  //button[contains(text(), 'Place Order')]
${CHECKOUT_PRODUCT_NAMES_XPATH}     //tr[@class='success']//td[2]

*** Keywords ***
Open Browser And Navigate To URL
    Open Browser With Chrome Headless    ${URLi}
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//a[contains(text(), 'Home')]

Add Products To Cart
    [Arguments]    ${number_of_products}
    ${products}    Get WebElements   ${PRODUCT_TITLE_XPATH}
    ${total_products}    Get Length    ${products}
    Log    Found ${total_products} products
    Run Keyword If    ${number_of_products} < ${total_products}    Fail    Requested more products than available
        FOR    ${i}    IN RANGE    ${number_of_products}
            ${current_product}    Get WebElement    ${PRODUCT_TITLE_XPATH}[${i}]
            Wait Until Page Contains Element    ${current_product}
            Click Element    ${current_product}
            Wait Until Element Is Visible    xpath=${ADD_TO_CART_XPATH}
            Click Element    xpath=${ADD_TO_CART_XPATH}
            Handle Alert
            Go To    ${URLi}
        END

Navigate To Checkout
    Click Element    xpath=${CART_XPATH}
    Wait Until Element Is Visible    xpath=${PLACE_ORDER_BUTTON_XPATH}

Validate Products In Checkout
    ${product_names}    Get WebElements    xpath=${CHECKOUT_PRODUCT_NAMES_XPATH}
    Should Not Be Empty    ${product_names}
    FOR    ${product}    IN    @{product_names}
        ${name}    Get Text    ${product}
        Log    Is in Cart: ${name}
    END

Go Back
    Go Back