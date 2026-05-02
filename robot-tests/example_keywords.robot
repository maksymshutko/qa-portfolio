*** Settings ***
Documentation    Example test suite for Sauce Labs Demo App
...              This file can be imported for additional tests

Library          SeleniumLibrary
Library          RequestsLibrary


*** Variables ***
${BASE_URL}      https://www.saucedemo.com
${INVALID_USER}  invalid_username
${ANOTHER_USER}  problem_user


*** Keywords ***
Custom Keyword Example
    [Documentation]    This keyword can be reused across projects
    Log    Custom keyword ready for extension

