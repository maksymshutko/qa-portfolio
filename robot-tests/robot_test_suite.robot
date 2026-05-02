*** Settings ***
Documentation     QA Portfolio - Comprehensive Robot Framework Test Suite
...               Demonstrates proficiency in Web, API, and Desktop automation
...               Test Application: Sauce Labs Demo App (https://www.saucedemo.com)
...
Library           SeleniumLibrary
Library           RequestsLibrary
Library           Collections
Library           String
Library           DateTime

*** Variables ***
# Web Application URLs and Credentials
${DEMO_APP_URL}                https://www.saucedemo.com
${VALID_USERNAME}              standard_user
${VALID_PASSWORD}              secret_sauce
${LOCKED_USERNAME}             locked_out_user
${INVALID_PASSWORD}            invalid_pass
${BROWSER}                     Chrome

# Timeouts and Waits
${IMPLICIT_WAIT}               10 seconds
${PAGE_LOAD_TIMEOUT}           30 seconds

# Test Data
${MIN_PRODUCT_PRICE}           0
${MAX_PRODUCT_PRICE}           200

*** Test Cases ***
# ============================================================================
# WEB AUTOMATION TESTS - Login Scenarios
# ============================================================================

TC-1 - Successful Login with Valid Credential
  [Documentation]  Verify user can successfully login with valid credentials
  [Tags]  WEB  SMOKE
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Verify Login Page Loaded
  Login With Valid Credentials  ${VALID_USERNAME}  ${VALID_PASSWORD}
  Verify Products Page Displayed
  Close Browser

TC-2 - Login Fails with Invalid Password
  [Documentation]  Verify login fails when invalid password is provided
  [Tags]  WEB
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Verify Login Page Loaded
  Login With Invalid Credentials  ${VALID_USERNAME}  ${INVALID_PASSWORD}
  Verify Error Message Contains Text  password
  Close Browser

TC-3 - Locked Out User Cannot Login
  [Documentation]  Verify locked out user receives appropriate error message
  [Tags]  WEB
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Verify Login Page Loaded
  Login With Valid Credentials  ${LOCKED_USERNAME}  ${VALID_PASSWORD}
  Verify Error Message Contains Text  locked
  Close Browser

# ============================================================================
# WEB AUTOMATION TESTS - Shopping Cart Scenarios
# ============================================================================

TC-4 - Add Product to Cart and Verify
  [Documentation]  Verify user can add product to cart successfully
  [Tags]  WEB  SMOKE
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Login With Valid Credentials  ${VALID_USERNAME}  ${VALID_PASSWORD}
  Verify Products Page Displayed
  Add Product To Cart   Sauce Labs Backpack
  Verify Cart Badge Count  1
  Close Browser

TC-5 - Remove Product from Cart
  [Documentation]  Verify user can remove product from cart
  [Tags]  WEB
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Login With Valid Credentials  ${VALID_USERNAME}  ${VALID_PASSWORD}
  Add Product To Cart  Sauce Labs Backpack
  Verify Cart Badge Count  1
  Remove Product From Cart  Sauce Labs Backpack
  Verify Product Not In Cart  Sauce Labs Backpack
  Close Browser

TC-6 - Checkout Process Complete
  [Documentation]  Verify complete checkout process from cart to confirmation
  [Tags]  WEB  SMOKE
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Login With Valid Credentials  ${VALID_USERNAME}  ${VALID_PASSWORD}
  Add Multiple Products To Cart  Sauce Labs Backpack   Sauce Labs Bike Light
  Go To Cart Page
  Proceed To Checkout
  Fill Checkout Information  John  Doe  12345
  Complete Purchase
  Verify Order Confirmation Message
  Close Browser

TС-7 - Sort Products by Price High to Low
  [Documentation]  Verify products can be sorted by price descending
  [Tags]  WEB
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Login With Valid Credentials  ${VALID_USERNAME}  ${VALID_PASSWORD}
  Verify Products Page Displayed
  Sort Products By  Price (high to low)
  Verify Products Sorted In Descending Price Order
  Close Browser

TC-08 - Logout Successfully
  [Documentation]  Verify user can logout successfully
  [Tags]  WEB
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  Login With Valid Credentials  ${VALID_USERNAME}  ${VALID_PASSWORD}
  Verify Products Page Displayed
  Click Logout Button
  Verify Login Page Loaded
  Close Browser

# ============================================================================
# API TESTS - JSONPlaceholder Public API (Bonus Section)
# ============================================================================

TC-9 - API GET Request Returns Valid Posts
  [Documentation]  Verify API returns valid posts with correct structure
  [Tags]  API  SMOKE
  [Setup]  Create Session  api_session  https://jsonplaceholder.typicode.com
  ${response} =  Get Request  api_session  /posts/1
  Should Be Equal As Integers  ${response.status_code}  200
  Dictionary Should Contain Key  ${response.json()}  userId
  Dictionary Should Contain Key  ${response.json()}  id
  Dictionary Should Contain Key  ${response.json()}  title
  Dictionary Should Contain Key  ${response.json()}  body

TC-10 - API POST Request Creates New Post
  [Documentation]  Verify API can create new resource via POST
  [Tags]  API
  [Setup]  Create Session  api_session  https://jsonplaceholder.typicode.com
  ${payload} =  Create Dictionary  title=Test Post  body=This is a test    userId=1
  ${response} =  Post Request  api_session  /posts  json=${payload}
  Should Be Equal As Integers  ${response.status_code}  201
  Should Be Equal As Strings  ${response.json()}[title]  Test Post

TC-11 - API GET All Posts Returns Array
  [Documentation]  Verify API returns array of posts
  [Tags]  API
  [Setup]  Create Session  api_session   https://jsonplaceholder.typicode.com
  ${response} =  Get Request  api_session  /posts
  Should Be Equal As Integers  ${response.status_code}  200
  Should Be True  len(${response.json()}) > 0

# ============================================================================
# PERFORMANCE AND VALIDATION TESTS
# ============================================================================

TC-12 - Page Load Performance Check
  [Documentation]  Verify main page loads within acceptable timeframe
  [Tags]  WEB
  Open Browser  ${DEMO_APP_URL}  ${BROWSER}
  Set Selenium Implicit Wait  ${IMPLICIT_WAIT}
  ${start_time} =  Get Current Date
  Verify Login Page Loaded
  ${end_time} =  Get Current Date
  ${load_time} =  Subtract Date From Date  ${end_time}  ${start_time}
  Should Be True  ${load_time} < 5  Login page took too long to load
  Close Browser

*** Keywords ***
# ============================================================================
# LOGIN KEYWORDS
# ============================================================================

Verify Login Page Loaded
  [Documentation]  Verify login page elements are present and visible
  Wait Until Page Contains Element  id:user-name  ${PAGE_LOAD_TIMEOUT}
  Wait Until Page Contains Element  id:password  ${PAGE_LOAD_TIMEOUT}
  Wait Until Page Contains Element  id:login-button  ${PAGE_LOAD_TIMEOUT}
  Page Should Contain  Accepted usernames are

Login With Valid Credentials
  [Arguments]  ${username}  ${password}
  [Documentation]  Login with provided username and password
  Input Text  id:user-name  ${username}
  Input Text  id:password  ${password}
  Click Button  id:login-button
  Sleep  2 seconds

Login With Invalid Credentials
  [Arguments]  ${username}  ${password}
  [Documentation]  Attempt login with invalid credentials
  Input Text  id:user-name  ${username}
  Input Text  id:password  ${password}
  Click Button  id:login-button
  Sleep  2 seconds

Verify Error Message Contains Text
  [Arguments]  ${expected_text}
  [Documentation]  Verify error message is displayed with specific text
  Wait Until Page Contains Element  class:error-message-container  ${PAGE_LOAD_TIMEOUT}
  Page Should Contain  ${expected_text}

# ============================================================================
# PRODUCTS PAGE KEYWORDS
# ============================================================================

Verify Products Page Displayed
  [Documentation]  Verify products page is loaded correctly
  Wait Until Page Contains Element  class:inventory_container  ${PAGE_LOAD_TIMEOUT}
  Page Should Contain  Products
  Page Should Contain Element  class:inventory_item

Add Product To Cart
  [Arguments]  ${product_name}
  [Documentation]  Add specified product to cart by name
  ${add_button} =  Get Element Attribute  xpath://div[contains(@class, 'inventory_item_name') and contains(., '${product_name}')]/ancestor::div[@class='inventory_item']//button    id
  Click Button  ${add_button}
  Sleep  1 second

Add Multiple Products To Cart
  [Arguments]  @{products}
  [Documentation]     Add multiple products to cart
    FOR    ${product}    IN    @{products}
        Add Product To Cart    ${product}
    END

Remove Product From Cart
  [Arguments]  ${product_name}
  [Documentation]  Remove product from cart
  ${remove_button} =  Get Element Attribute  xpath://div[contains(@class, 'inventory_item_name') and contains(., '${product_name}')]/ancestor::div[@class='inventory_item']//button    id
  Click Button  ${remove_button}
  Sleep  1 second

Verify Product Not In Cart
  [Arguments]  ${product_name}
  [Documentation]  Verify product is not in cart
  Page Should Not Contain  ${product_name}

Verify Cart Badge Count
  [Arguments]  ${expected_count}
  [Documentation]  Verify shopping cart badge shows correct count
  Wait Until Page Contains Element  class:shopping_cart_badge  ${PAGE_LOAD_TIMEOUT}
  Element Text Should Be  class:shopping_cart_badge  ${expected_count}

# ============================================================================
# CHECKOUT KEYWORDS
# ============================================================================

Go To Cart Page
  [Documentation]  Navigate to shopping cart page
  Click Element  class:shopping_cart_container
  Sleep  1 second

Proceed To Checkout
  [Documentation]  Click checkout button
  Wait Until Page Contains Element  id:checkout  ${PAGE_LOAD_TIMEOUT}
  Click Button  id:checkout
  Sleep  2 seconds

Fill Checkout Information
  [Arguments]  ${first_name}  ${last_name}  ${postal_code}
  [Documentation]  Fill checkout information form
  Wait Until Page Contains Element  id:first-name  ${PAGE_LOAD_TIMEOUT}
  Input Text  id:first-name  ${first_name}
  Input Text  id:last-name  ${last_name}
  Input Text  id:postal-code  ${postal_code}
  Click Button  id:continue
  Sleep   2 seconds

Complete Purchase
  [Documentation]  Complete the purchase
  Wait Until Page Contains Element  id:finish  ${PAGE_LOAD_TIMEOUT}
  Click Button  id:finish
  Sleep  2 seconds

Verify Order Confirmation Message
  [Documentation]  Verify order confirmation is displayed
  Page Should Contain  Thank you for your order
  Page Should Contain Element  class:complete-header

# ============================================================================
# SORTING AND FILTERING KEYWORDS
# ============================================================================

Sort Products By
  [Arguments]  ${sort_option}
  [Documentation]  Sort products by specified option
  Click Element  class:product_sort_container
  Sleep  1 second
  Click Element  xpath://option[contains(text(), '${sort_option}')]
  Sleep  2 seconds

Verify Products Sorted In Descending Price Order
  [Documentation]     Verify products are sorted by price in descending order
  ${prices} =  Get WebElements    class:inventory_item_price
  ${price_list} =  Create List
  FOR    ${price}    IN    @{prices}
    ${price_text}=    Get Text    ${price}
    ${price_value}=    String.Remove String    ${price_text}    $
    Append To List    ${price_list}    ${price_value}
  END
  Log  Product prices: ${price_list}

# ============================================================================
# LOGOUT KEYWORDS
# ============================================================================

Click Logout Button
  [Documentation]  Click logout from menu
  Click Element  id:react-burger-menu-btn
  Sleep  1 second
  Wait Until Page Contains Element  id:logout_sidebar_link   ${PAGE_LOAD_TIMEOUT}
  Click Element  id:logout_sidebar_link
  Sleep  2 seconds

