*** Settings ***
Library    SeleniumLibrary 


*** Variables ***
#Settings variables
${URL}    https://www.kabum.com.br    #Variável de acesso para o site 
${Browser}    chrome    #Navegador usado 

#Test Data
${Search}    Notebook    #O que será pesquisado 
${zip_code}    60050150    #CEP real para teste 

#Elements 
${search_field}                    //input[@id="input-busca"]    #Locator do campo de busca 
${first_element}                   (//img[@class="imageCard"])[1]    #Pega o primeiro elemento da pesquisa
${id_zipcode}                      //input[@id="inputCalcularFrete"]    #Locator do campo de CEP
${button_ok}                       //button[@id="botaoCalcularFrete"]    #Locator do Botão OK do modal de CEP
${icon_close}                      //div[@data-testid="btnClose"]    #Locator do botão X do modal de CEP 
${button_buy}                      //*[@id="blocoValores"]/div[2]/div[2]/button    #Locator do botão Comprar (esse locator é dinâmico, pois o seu valor tem um Hash que muda constantemente. Assim, pegando pelo o caminho direto corre menos riscos de quebrar a aplicação)
${radio_warranty}                  //input[@name="garantia"][@type="radio"][@value="4041279"]    #Locator do radio button da garantia +12
${button_shopping_cart}            //*[@id="__next"]/div[1]/div[2]/div/div[2]/div/div[3]/div/button[2]    #Locator do botão de Ir para o Carrinho (da mesma forma, ele é dinâmico e muda. Para evitar erros, pega o caminho direto)
#${validation_action}               //button[@id="buttonRemover"]    #
${first_element_name}              //*[@id="listing"]/div[3]/div/div/div[2]/div/main/div[1]/a/div/button/div/h2/span    #Pega a descrição do primeiro elemento. Servirá para fazer a validação final do teste
${validation_item}                 //*[@id="sellersContainer"]/div/div/div/div/div[1]/div/div[1]/div[1]/a    #Pega a descrição do item que foi colocado no carrinho, para ser comparado no final do teste.


*** Keywords ***

I access the site kabum 
    Open Browser    ${URL}    ${Browser}    #Abre a URL no Chrome 

I search for Notebook 
    Input Text    ${search_field}    ${Search}    #Acessa o campo de pesquisa e digita Notebook
    Press Keys    ${search_field}    ENTER       #Aperta o botão Enter após a pesquisa 

I select the first product
    Wait Until Element Is Visible   ${first_element}    #Espera que o elemento esteja presente na tela para continuar o teste e evitar que a sua velocidade cause erros
    ${product_name}    Get Text    ${first_element_name}    #Cria uma variável e configura seu valor para a descrição do elemento achado 
    Set Global Variable    ${product_name}    #Fará com que a variável seja global e possa ser usada futuramente no teste
    Click Element   ${first_element}    #Clica no primeiro elemento

enter the zip code and print the availables freight values 
    Input Text    ${id_zipcode}    ${zip_code}    #Vai no campo de CEP e digita o CEP criado nas Variáveis 
    Click Element    ${button_ok}    #Clica no botão OK
    Sleep    3s    #Espera 3 segundos para que as opções sejam carredas na tela 

close the front options screen 
    Click Element    ${icon_close}    #Fecha o modal 

click buy 
    Wait Until Element Is Visible    ${button_buy}       #Espera que o botão COMPRAR esteja visível na tela  
    Click Element    ${button_buy}    #Clica no botão COMPRAR

Select warranty +12 months 
    Wait Until Element Is Visible    ${radio_warranty}    #Espera que a opção de garantia seja carregada na tela 
    Sleep    3s    #Por atraso no carregamento, espera 3 segundos. É preciso estudar cenários para funcionais para entender o que acarreta esse atraso
    Click Element    ${radio_warranty}    #Clica na opção +12

click on go to cart 
    Wait Until Element Is Visible    ${button_shopping_cart}    #Espera que o botão IR PARA O CARRINHO apareça na tela 
    Click Element    ${button_shopping_cart}    #Clica no botão 

validate that the product is in the shopping cart 
    Element Text Should Be    ${validation_item}    ${product_name}    #A validação final. Verifica se a descrição do elemento escolhido é a mesma descrição do item que está no carrinho
    Close Browser


*** Test Cases ***
Scenario 1: Shopping automation 
    Given I access the site kabum 
    And I search for Notebook 
    And I select the first product 
    And enter the zip code and print the availables freight values 
    And close the front options screen 
    And click buy 
    And Select warranty +12 months 
    And click on go to cart
    Then validate that the product is in the shopping cart  



