*** Settings ***
Documentation    Test case QP-01, A custom pizza reaches the admin list.
Resource         resources/quickpizza.resource
Test Teardown    Close Browser
Library          DateTime

*** Test Cases ***
QP-01 A Custom Pizza Reaches The Admin List
    [Documentation]    A pizza request with restrictions gives a pizza that
    ...    keeps them, rating needs a login, and the admin sees the pizza.
    Open QuickPizza
    Turn On Advanced
    ${stamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    ${name}=    Set Variable    Lab Pizza ${stamp}
    Fill In The Pizza Request    600    Knife    ${name}
    Capture Page Screenshot    qp01-step3-fields.png
    Ask For A Pizza
    ${tool}=    Recommendation Should Keep The Restrictions
    ...    ${name}    Knife    600
    Capture Element Screenshot    id:recommendations    qp01-step4-pizza.png
    Rate The Pizza Without Logging In
    Capture Page Screenshot    qp01-step5-login-needed.png
    Log In As Admin    admin    admin
    Admin List Should Show The Pizza    ${name}    ${tool}
    Capture Page Screenshot    qp01-step7-admin-list.png
