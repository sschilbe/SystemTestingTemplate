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
Library  TestingBot.py

Test Setup  Open test browser
Test Teardown  Run keywords     Signout     Close test browser

*** Variables ***

${CREDENTIALS}  # INSERT CREDENTIALS FROM TESTINGBOT #
${ROOT_URL}     # PUT URL FOR YOUR WEBSITE #
${LOGIN_URL}    ${ROOT_URL}/login
${LOGOUT_URL}   ${ROOT_URL}/logout
${HOME_URL}     ${ROOT_URL}/index
${id}           # INSERT UNIQUE ID FOR THIS PROJECT

*** Keywords ***

Open test browser
	Open browser  about:  chrome
	...  remote_url=http://${CREDENTIALS}@hub.testingbot.com/wd/hub
	...  desired_capabilities=browserName:${BROWSER},version:${VERSION},platform:${PLATFORM}

Close test browser
	...  Report TestingBot status
    ...  ${id}
	...  ${SUITE_NAME} | ${TEST_NAME}
	...  ${TEST_STATUS}  ${CREDENTIALS}
	Close all browsers

Sign In
    [Arguments]     ${username}     ${password}
    Go To           ${LOGIN_URL}
    Input Text      username        ${username}
    Input Text      password        ${password}
    Click Button    submit
    
Sign Out 
    Go To           ${LOGOUT_URL}

*** Test Cases ***

Sanity Test
    [Tags]  Validation
    Go to   ${ROOT_URL}
	Page should contain  Please log in to access this page.

A user should be able to sign in with valid username and password
    Sign In  Seth Schilbe  password
    ${url}=     Get Location
    Should be Equal     ${url}     ${HOME_URL}

A user shouldn't be able to sign in with invalid username
    Sign In     hello  password
    ${url}=     Get Location
    Should be Equal     ${url}     ${LOGIN_URL}

A user shouldn't be able to sign in with invalid password
    Sign In  Seth Schilbe  this_is_wrong
    ${url}=     Get Location
    Should be Equal     ${url}     ${LOGIN_URL}
