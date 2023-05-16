*** Settings ***
Library                         SeleniumLibrary
Library                         CSVLibrary

*** Variables ***

&{Results_Tab} =                STRING = ${site}    STRING = ${impact}
${site} =    www.lemonde.fr
${impact}
# ${chemin} =                     C:\\Users\\AY025171\\Desktop\\Results.csv    
${chemin} =                     ${EXECDIR}\\Results.csv

*** Keywords ***


*** Test Cases ***

Titre
    seleniumlibrary.open browser                    about:blank    chrome
    seleniumlibrary.go to                           https://www.websitecarbon.com/
    seleniumlibrary.input text                      xpath=//input[@id="wgd-cc-url"]   ${site}
    wait until page contains                        Calculate
    sleep                                           5s
    seleniumlibrary.click button                    xpath=//div[@class='field-group new-test__address']/button[@class='new-test-button']
    wait until page contains                        Only
    ${impact} =                                     SeleniumLibrary.get text    xpath=//span[@class='report-carbon__amount highlight']/span/span
    @{donnee} =                                     BuiltIn.create list    ${site}    ${impact}
    CSVLibrary.append to csv file                   ${chemin}    ${donnee}