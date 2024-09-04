#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
##Barras decorativas
$decor = "=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$maindir = Get-Location
$dirorigem = "$maindir" + "\config\origem.txt" #Cria o arquivo de configuração
$dirdestino = "$maindir" + "\config\destino.txt" #Cria o arquivo de configuração
$dirguarda = "$maindir" + "\config\guarda.txt" #Cria o arquivo de configuração

$datahora = Get-Date -Format "yyyy-MM-dd" #Hora formatada em Dia-Mês-Ano para nome do backup
$datahoralog = Get-Date -Format "yyyy/MM/dd HH:mm:ss" #Hora formatada em Dia-Mês-Ano para registro de log
$logdir = "$maindir" + "\logs" + "\" + $datahora + ".log" #Cria o arquivo de log do sistema
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
function RegLog {
    #Função para registro de atividades no arquivo de log
    param ([string]$loginput)
    Add-Content $logdir -value ($datahoralog + ": " + $loginput)
}

function Menu {
    #Função de exibição do menu
    Write-Host $decor 
    Write-Host = "Selecione uma das alternativas abaixo:"
    Write-Host $decor

    #1-4: Opções do menu
    Write-Host = "[1]: Alterar origem do Backup" 
    Write-Host = "[2]: Alterar destino do Backup"
    Write-Host = "[3]: Alterar tempo de guarda do backup"
    Write-Host = "[4]: Alterar todos os campos"
    Write-Host = "[5]: Sair" #5: Sair do menu
    Write-Host $decor
}

function UserConfirm {
    #Função de confirmação da escolha do usuário
    Write-Host $decor 
    Write-Host = "Deseja continuar configurando?:"
    Write-Host $decor
    Write-Host = "[1]: Continuar"   #Continuar a configuração, retorna a função Menu
    Write-Host = "[2]: Sair"        #Termina a configuração, encerra o processo
    Write-Host $decor    
}
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
do {
    #Execução principal do Script
    Menu
    $useroption = Read-Host "Digite" #Input do usuário para uma das opções exibidas
    switch ($useroption) {
        '1' {
            #Primeira Opção
            Clear-Host #Limpa a exibição da tela
            Write-Host $decor
            $dirinput = Read-Host "Digite o novo local de origem do backup" #Input do valor a ser gravado
            Write-Host $decor
            $dirfile = "$dirorigem" #Variável apontando para o destino do arquivo de configuração
            $dirtest = Test-Path $dirinput #Teste de conectividade do diretório especificado
            if ($dirtest -eq $true) {
                #Se o caminho especificado existir/estiver disponível
                Clear-Content $dirfile #limpa as informações anteriores do arquivo
                Add-Content $dirfile -value ($dirinput) -NoNewline #Adiciona os dados especificados sem adicionar linha final.
                Write-Host "Alterando caminho de origem para: $dirinput" #Registro em terminal
                Write-Host $decor
                RegLog "Alterando caminho de origem para: $dirinput" #Registro em Log
                Start-Sleep -Seconds 1

                UserConfirm
                $UserConfirmInput = Read-Host "Digite"
                switch ($UserConfirmInput) {
                    '1'{
                        Menu
                    } '2' {
                        Write-Host "Encerrando Processo."
                        Exit
                    }
                }
            }
            elseif ($dirtest -eq $false) {
                #Se o caminho apontado NÃO existir/estiver disponível
                Write-Host "Caminho indicado indisponível, por favor tente novamente" #Registro em terminal
            }
            
        } '2' {
            Clear-Host  #Limpa a exibição da tela
            Write-Host $decor
            $dirinput = Read-Host "Digite o novo local de destino do backup" #Input do valor a ser gravado
            Write-Host $decor
            $dirfile = "$dirdestino" #Variável apontando para o destino do arquivo de configuração
            $dirtest = Test-Path $dirinput #Teste de conectividade do diretório especificado
            if ($dirtest -eq $true) {
                #Se o caminho especificado existir/estiver disponível
                Clear-Content $dirfile #limpa as informações anteriores do arquivo
                Add-Content $dirfile -value ($dirinput) -NoNewline #Adiciona os dados especificados sem adicionar linha final.
                Write-Host "Alterando caminho de destino para: $dirinput" #Registro em terminal
                Write-Host $decor
                RegLog "Alterando caminho de destino para: $dirinput" #Registro em Log
                Start-Sleep -Seconds 1
                
                UserConfirm
                $UserConfirmInput = Read-Host "Digite"
                switch ($UserConfirmInput) {
                    '1'{
                        Menu
                    } '2' {
                        Write-Host "Encerrando Processo."
                        Exit
                    }
                }
            }
            elseif ($dirtest -eq $false) {
                #Se o caminho apontado NÃO existir/estiver disponível
                Write-Host "Caminho indicado indisponível, por favor tente novamente" #Registro em terminal
            }

        } '3' {
            Clear-Host #Limpa a exibição da tela
            Write-Host $decor
            $dirinput = Read-Host "Digite o novo tempo de guarda do backup (SOMENTE NUMERAIS NEGATIVOS)" #Input do valor a ser gravado
            Write-Host $decor
            $dirfile = "$dirguarda" #Variável apontando para o destino do arquivo de configuração
            Clear-Content $dirfile #limpa as informações anteriores do arquivo
            Add-Content $dirfile -value ($dirinput) -NoNewline #Adiciona os dados especificados sem adicionar linha final.
            Write-Host "Alterando caminho de guarda para $dirinput dias" #Registro em terminal
            Write-Host $decor
            RegLog "Alterando caminho de guarda para $dirinput dias" #Registro em Log
            Start-Sleep -Seconds 1
            
            UserConfirm
            $UserConfirmInput = Read-Host "Digite"
            switch ($UserConfirmInput) {
                '1'{
                    Menu
                } '2' {
                    Write-Host "Encerrando Processo."
                    Exit
                }
            }

        } '4' {
            Clear-Host #Limpa a exibição da tela
            $dirfile1 = "$dirorigem" #Variável apontando para o destino do arquivo de configuração
            Write-Host $decor
            $dirinput1 = Read-Host "Digite o novo local de origem do backup" #Input do valor a ser gravado
            $dirtest1 = Test-Path $dirinput1 #Teste de conectividade do diretório especificado
            if ($dirtest1 -eq $true) {
                Clear-Content $dirfile1 #limpa as informações anteriores do arquivo
                Add-Content $dirfile1 -value ($dirinput1) -NoNewline #Adiciona os dados especificados sem adicionar linha final.
                Write-Host "Alterando caminho de origem para: $dirinput1" #Registro em terminal
                Write-Host $decor
                RegLog "Alterando caminho de origem para: $dirinput1" #Registro em Log
            }
            elseif ($dirtest -eq $false) {
                Write-Host "Caminho de origem indisponível." #Registro em terminal
                Write-Host $decor
            }
            
            $dirinput2 = Read-Host "Digite o novo local de destino do backup" #Input do valor a ser gravado
            $dirtest2 = Test-Path $dirinput2
            $dirfile2 = "$dirdestino"

            if ($dirtest2 -eq $true) {
                Clear-Content $dirfile2 #limpa as informações anteriores do arquivo
                Add-Content $dirfile2 -value ($dirinput2) -NoNewline #Adiciona os dados especificados sem adicionar linha final.
                Write-Host "Alterando caminho de destino para: $dirinput2" #Registro em terminal
                Write-Host $decor
                RegLog "Alterando caminho de destino para: $dirinput2" #Registro em Log
            }
            elseif ($dirtest -eq $false) {
                Write-Host "Caminho de destino indisponível." #Registro em terminal
                Write-Host $decor
            }

            $dirfile3 = "$dirguarda"

            $dirinput3 = Read-Host "Digite o novo tempo em dias de guarda do backup (SOMENTE NUMERAIS NEGATIVOS)" #Input do valor a ser gravado
            Clear-Content $dirfile3 #limpa as informações anteriores do arquivo
            Add-Content $dirfile3 -value ($dirinput3) -NoNewline #Adiciona os dados especificados sem adicionar linha final.
            Write-Host "Alterando tempo de guarda para $dirinput3 dias" #Registro em terminal
            Write-Host $decor
            RegLog "Alterando tempo de guarda para $dirinput3 dias" #Registro em Log

            Write-Host "Saindo..." #Registro em terminal
            Write-Host $decor
            Start-Sleep -Seconds 1
            
            UserConfirm
            $UserConfirmInput = Read-Host "Digite"
            switch ($UserConfirmInput) {
                '1'{
                    Menu
                } '2' {
                    Write-Host "Encerrando Processo."
                    Exit
                }
            }

        } '5' {
            Clear-Host #Limpa a exibição da tela
            Write-Host "Saindo do setup..." #Registro em terminal
            Write-Host $decor
            Start-Sleep -Seconds 1
            return
        }
    }
}
until ($useroption -eq '5') #Comando de saída quando o usuário selecionar a opção "5"
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-