###########################################################
#
# Brief: System level test to verify the functionality of 
#        login
# Author: Schilbe, Seth
# Date: 2018-10-05
#
###########################################################
*** Settings ***
Documentation   A test suite with various tests for login.
    ...         The test suite assumes there is already a
    ...         user present in the database  

Library  Selenium2Library
Library  TestingBot

Test Setup  Open test browser
Test Teardown  Run keywords     Signout     Close test browser

*** Variables ***

${CREDENTIALS}  2122e75ff30e9d779ef243512bd9af23:47c920ba52c79428dc35680245a22a04
${ROOT_URL}     https://swe4103-seminar.herokuapp.com/
${LOGIN_URL}    ${ROOT_URL}sessions/login
${LOGOUT_URL}   ${ROOT_URL}sessions/logout
${HOME_URL}     ${ROOT_URL}sessions/home

*** Keywords ***

Open test browser
	Open browser  about:  chrome
	...  remote_url=http://${CREDENTIALS}@hub.testingbot.com/wd/hub
	...  desired_capabilities=browserName:${BROWSER},version:${VERSION},platform:${PLATFORM}

Close test browser
	...  Report TestingBot status
	...  ${SUITE_NAME} | ${TEST_NAME}
	...  ${TEST_STATUS}  ${CREDENTIALS}
	Close all browsers

Sign In
    [Arguments]     ${email}        ${password}
    Go To           ${LOGIN_URL}
    Input Text      email           ${email}
    Input Text      login_password  ${password}
    Click Button    commit
    
Sign Out 
    Go To           ${LOGOUT_URL}

*** Test Cases ***

Simple Test
    [Tags]  Validation
    Go to   ${ROOT_URL}
	Page should contain  Soccer League Manager

A user should be able to sign in with valid email and password
    Sign In  seth.schilbe@gmail.com  password
    ${url}=     Get Location
    Should be Equal     ${url}     ${HOME_URL}

A user shouldn't be able to sign in with invalid email
    Sign In     hello  password
    ${url}=     Get Location
    Should be Equal     ${url}     ${LOGIN_URL}

A user shouldn't be able to sign in with invalid password
    Sign In  seth.schilbe@gmail.com  this_is_wrong
    ${url}=     Get Location
    Should be Equal     ${url}     ${LOGIN_URL}
