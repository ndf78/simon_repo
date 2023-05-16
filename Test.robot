*** Settings ***

Library                         SeleniumLibrary
Library                         Collections
Library                         CSVLibrary
Library                         ScreenCapLibrary

*** Variables ***
${BROWSER} =                    chrome
${BROWSER2} =                   firefox
${url} =                        https://www.ausy.fr/
${url2} =                       https://www.websitecarbon.com/
${site}
${impact}
&{Results_Tab} =                STRING = ${site}    STRING = ${impact}
@{liste_site}
# ${chemin} =                     C:\\Users\\AY025171\\Desktop\\Results.csv
${chemin} =                     ${EXECDIR}\\Results.csv

*** Test Cases ***
Test 1
    [Documentation]    Ce test simule la consultation d'une offre sur le site d'Ausy
    [Tags]  Usual
    ScreenCapLibrary.Start Video Recording    alias=none    name=${TEST NAME}    fps=None    size_percentage=1    embed=True    embed_width=100px    monitor=2
    # Debut du test
    Connexion au site
    Récupérer l'adresse du site
    Acces aux solutions
    Récupérer l'adresse du site
    Acces aux offres
    Récupérer l'adresse du site
    Consulter les offres
    Récupérer l'adresse du site
    Récupérer l'impact des pages consultées
    Sleep    time_=5
    ScreenCapLibrary.Stop Video Recording

*** Keywords ***

Connexion au site
    seleniumlibrary.open browser                        about:blank    ${BROWSER}
    seleniumlibrary.go to                               ${url}
    seleniumlibrary.wait until element is visible       id=onetrust-accept-btn-handler
    seleniumlibrary.click button                        id=onetrust-accept-btn-handler
    seleniumlibrary.wait until page contains            ausy, tech with personality

Acces aux solutions
    seleniumlibrary.click link                          xpath=//li[@class="navigation__menu-item"]/a[contains(@href, '/fr/nos-solutions/')]
    seleniumlibrary.wait until page contains            innover et transformer

Acces aux offres
    seleniumlibrary.click link                          xpath=//li[@class="navigation__menu-item"]/a[contains(@href, '/fr/carrieres/')]
    seleniumlibrary.wait until page contains            prêt à relever de nouveaux challenges ?

Consulter les offres
    seleniumlibrary.input text                          id=search-keyword    Testeur
    seleniumlibrary.click button                        xpath=//div[contains(@class, "form-group hidden--until-l")]/button[contains(@class, "button bluex-button--preloader button--filled button--m")]
    seleniumlibrary.wait until page contains            emplois trouvés

Récupérer l'adresse du site
    ${site} =                                           SeleniumLibrary.get location
    BuiltIn.log                                         ${site}
    Collections.append to list                          ${liste_site}    ${site}

Récupérer l'impact des pages consultées
    FOR                                                 ${site}    IN    @{liste_site}
        seleniumlibrary.open browser                    about:blank    ${BROWSER}
        seleniumlibrary.go to                           ${url2}
        seleniumlibrary.input text                      xpath=//input[@id="wgd-cc-url"]   ${site}
        wait until page contains                        Calculate
        sleep                                           5s
        seleniumlibrary.click button                    xpath=//div[@class='field-group new-test__address']/button[@class='new-test-button']
        wait until page contains                        Only
        ${impact} =                                     SeleniumLibrary.get text    xpath=//span[@class='report-carbon__amount highlight']/span/span
        @{donnee} =                                     BuiltIn.create list    ${site}    ${impact}
        CSVLibrary.append to csv file                   ${chemin}    ${donnee}
        CSVLibrary.append to csv file
    END