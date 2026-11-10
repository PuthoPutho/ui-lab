*** Settings ***
Documentation    Keywords for the QuickPizza pages that QP-01 visits.
Library          SeleniumLibrary    timeout=10s
Library          String

*** Variables ***
${URL}             https://quickpizza.grafana.com
${BROWSER}         chrome
${HEADING}         Looking to break out of your pizza routine?
${MAX CALORIES}    xpath://label[contains(.,'Max Calories')]/../input

*** Keywords ***
Open QuickPizza
    [Documentation]    QP-01 step 1. Open the home page.
    Open Browser    ${URL}    ${BROWSER}
    ...    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1600
    Wait Until Element Is Visible    css:h1
    Element Text Should Be    css:h1    ${HEADING}

Turn On Advanced
    [Documentation]    QP-01 step 2. Show the advanced fields.
    Click Element    xpath://label[.//span[normalize-space()='Advanced']]
    Wait Until Page Contains Element    xpath://option[.='Knife']
    Element Should Be Visible    ${MAX CALORIES}
    Element Should Be Visible    css:select
    Element Should Be Visible    id:default-checkbox
    Element Should Be Visible    css:input#pizza-name

Fill In The Pizza Request
    [Documentation]    QP-01 step 3. Type the restrictions and the name.
    [Arguments]    ${calories}    ${tool}    ${name}
    Input Text    ${MAX CALORIES}    ${calories}
    Select From List By Label    css:select    ${tool}
    Select Checkbox    id:default-checkbox
    Input Text    css:input#pizza-name    ${name}
    Textfield Value Should Be    ${MAX CALORIES}    ${calories}
    List Selection Should Be    css:select    ${tool}
    Checkbox Should Be Selected    id:default-checkbox
    Textfield Value Should Be    css:input#pizza-name    ${name}

Ask For A Pizza
    [Documentation]    QP-01 step 4. Click Pizza, Please! and wait.
    Click Button    name:pizza-please
    Wait Until Element Contains    id:recommendations    Name:

Get Recommended Tool
    [Documentation]    Return the tool of the recommended pizza.
    ${line}=    Get Text    xpath://p[starts-with(.,'Tool:')]
    ${tool}=    Remove String    ${line}    Tool:${SPACE}
    RETURN    ${tool}

Get Calories Per Slice
    [Documentation]    Return the calories per slice of the pizza.
    ${line}=    Get Text    xpath://p[starts-with(.,'Calories per slice:')]
    ${calories}=    Remove String    ${line}    Calories per slice:${SPACE}
    RETURN    ${calories}

Recommendation Should Keep The Restrictions
    [Documentation]    QP-01 step 4. Check the name, tool and calories.
    [Arguments]    ${name}    ${excluded tool}    ${max calories}
    Element Should Contain    id:recommendations    Name: ${name}
    ${tool}=    Get Recommended Tool
    Should Not Be Equal    ${tool}    ${excluded tool}
    ${calories}=    Get Calories Per Slice
    Should Be True    ${calories} <= ${max calories}
    RETURN    ${tool}

Rate The Pizza Without Logging In
    [Documentation]    QP-01 step 5. Love it! asks for a login first.
    Click Button    name:rate-5
    Wait Until Element Contains    id:rate-result    Please log in first.

Wait Until The Page Is Ready
    [Documentation]    SvelteKit adds this element when its script runs.
    Wait Until Page Contains Element    id:svelte-announcer

Log In As Admin
    [Documentation]    QP-01 step 6. Sign in on the admin page.
    [Arguments]    ${user}    ${password}
    Go To    ${URL}/admin
    Wait Until The Page Is Ready
    Input Text    id:username    ${user}
    Input Password    id:password    ${password}
    Click Button    css:button[type=submit]
    Wait Until Page Contains    Latest pizza recommendations

Admin List Should Show The Pizza
    [Documentation]    QP-01 step 7. Find the pizza and its tool.
    [Arguments]    ${name}    ${tool}
    Wait Until Page Contains    ${name}
    Element Should Contain    xpath://li[contains(.,'${name}')]    ${tool}
