#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$maindir = Get-Location #Localiza o diretório do sistema
$horadel = Get-content ("$maindir" + "\config\guarda.txt") -Raw

#Procura data e hora para nomeação do arquivo de backup
$datadel = (Get-Date).AddDays($horadel) #Identifica a idade máxima do arquivo de backup já presente no diretório
$datahora = Get-Date -Format "yyyy-MM-dd_hh:mm" #Hora formatada em Dia-Mês-Ano para nome do backup
$datahoralog = Get-Date -Format "yyyy/MM/dd HH:mm:ss" #Hora formatada em Dia-Mês-Ano para registro de log

#Variáveis de diretórios principais
$bkpdir = Get-content ("$maindir" + "\config\destino.txt") -Raw #Local do diretório principal onde serão salvos os backups, ex.: Z:\*pasta*
$sourcedir = Get-content ("$maindir" + "\config\origem.txt") -Raw #Diretório fonte dos arquivos à serem salvos em backup, ex.: C:\Users\*usuário*\*pasta*

#Diretório dos arquivos de log
$logdir = "$maindir" + "\logs" + "\" + $datahora + ".log"

#Local do diretório alternativo caso o diretório principal esteja indisponível, ex.: Z:\*pasta*
$bkplocal = "$maindir" + "\bkplocal"

#Rastreamento de diretórios
$caminho = Test-Path $($bkpdir) #Testa a conectividade do diretório principal
$bkpdirscan = Get-ChildItem -Recurse -Path ($bkpdir + "\" + $datahora) #Variável para detectar a pasta do diretório criada no dia e seus conteudos
$bkplocalscan = Get-ChildItem -Recurse -Path ($bkplocal + "\" + $datahora) #Variável para detectar a pasta do local criada no dia e seus conteudos

#Variável para apagar dados do diretório alternativo
$bkplocalcontent = "$bkplocal" + "\*"
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
function RegLog {
    #Função para registro de atividades no arquivo de log
    param ([string]$loginput)
    Add-Content $logdir -value ($datahoralog + ": " + $loginput)
}
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$novodir = Join-Path -Path $bkplocal -ChildPath $datahora #Cria atributo com a  data e hora como nome
$detectnamedir = Test-Path ($novodir) #Detecta o atributo de nome no diretório

#Se NÃO houver backup neste dia
if ($detectnamedir -eq $false) {
    New-Item -Path $novodir -ItemType Directory #Transfira o objeto em pasta com o nome da variável datahora
    Copy-Item $sourcedir -Destination $novodir -Recurse -Force #Copia TODOS os arquivos mantendo o aninhamento

    #Deleta a pasta onde se localiza o backup mais antigo que a data máxima
    Get-ChildItem -Path $bkplocalcontent -Recurse | Where-Object { ($_.CreationTime -lt $datadel) } | Remove-Item -Recurse -Confirm:$false
    RegLog "Backup feito no diretório local em: $($bkplocal)" #Registro em log
    Write-Host "Backup feito no diretório local em: $($bkplocal)" #Notificação em terminal
}
else {
    #Se houver backup neste dia
    RegLog 'O backup já foi executado neste dia' #Registro em log
    Write-Host 'O backup já foi executado neste dia' #Notificação em terminal
}  
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
if ($caminho -eq $true) {
    $test = Test-Path ($bkpdirscan)
    Write-Host "$test"
    if (Compare-Object $bkpdirscan $bkplocalscan or $bkpdirscan -eq == $Error) {
        Copy-Item $bkplocalcontent -Destination $bkpdir -Recurse -Force #Copia TODOS os arquivos mantendo o aninhamento

        #Remoção de pastas
        #Remove todas as pastas locais após a cópia para a pasta de origem
        Get-ChildItem -Path $bkplocal -Recurse -Exclude appdata | Remove-Item -Recurse -Confirm:$false 
    
        #Deleta a pasta onde se localiza o backup mais antigo que a data máxima
        Get-ChildItem -Path $bkpdir -Recurse | Where-Object { ($_.CreationTime -lt $datadel) } | Remove-Item -Recurse -Confirm:$false
    
        RegLog "Backups locais movidos para diretório principal em: $($bkpdir)" #Registro em log
        Write-Host "Backups locais movidos para diretório principal em: $($bkpdir)" #Notificação em terminal
    }
    else {
        #Remoção de pastas
        #Remove todas as pastas locais após a cópia para a pasta de origem
        Get-ChildItem -Path $bkplocal -Recurse | Remove-Item -Recurse -Confirm:$false 
    
        #Deleta a pasta onde se localiza o backup mais antigo que a data máxima
        Get-ChildItem -Path $bkpdir -Recurse | Where-Object { ($_.CreationTime -lt $datadel) } | Remove-Item -Recurse -Confirm:$false
    
        RegLog "A pasta de hoje no diretório principal em: $($bkpdir) já existe, apagando arquivos antigos" #Registro em log
        Write-Host "A pasta de hoje no diretório principal em: $($bkpdir) já existe, apagando arquivos antigos" #Notificação em terminal
    }
    
}
else {
    RegLog "Diretório principal indisponível, backup feito apenas no diretório alternativo em: $($bkplocal)" #Registro em log
    Write-Host "Diretório principal indisponível, backup feito apenas no diretório alternativo em: $($bkplocal)" #Notificação em terminal
}
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-