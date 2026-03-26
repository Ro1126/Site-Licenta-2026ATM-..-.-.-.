# Script pentru scanarea fisierelor din "documente/" si generarea datelor pentru site
$FisierIesire = "date_materii.js"

# Definim structura de baza a materiilor si folderele pe care trebuie sa le scaneze.
# Folosim coduri ASCII (entitati HTML) pentru diacritice si emoji-uri pentru a asigura 
# compatibilitatea 100% la executia in PowerShell, indiferent de formatul de encodare al fisierului.
$MateriiConfig = @(
    @{ id="com-date"; titlu="Comunica&#539;ii de date"; icon="&#128225;"; culoare="bg-blue-500"; folder="com-date" },
    @{ id="microunde"; titlu="Microunde"; icon="&#127754;"; culoare="bg-cyan-600"; folder="microunde" },
    @{ id="comutatie"; titlu="Sisteme de comuta&#539;ie telefonic&#259; &#537;i multiplexare"; icon="&#9742;&#65039;"; culoare="bg-indigo-500"; folder="comutatie" },
    @{ id="retele"; titlu="Re&#539;ele &#537;i protocoale de comunica&#539;ii"; icon="&#127760;"; culoare="bg-emerald-500"; folder="retele" },
    @{ id="teoria-transmisiunii"; titlu="Teoria transmisiunii informa&#539;iei"; icon="&#128202;"; culoare="bg-violet-500"; folder="teoria-transmisiunii" },
    @{ id="radioreleu"; titlu="Sisteme de comunica&#539;ii radioreleu &#537;i via satelit"; icon="&#128640;"; culoare="bg-orange-500"; folder="radioreleu" },
    @{ id="optice"; titlu="Sisteme de comunica&#539;ii optice"; icon="&#128161;"; culoare="bg-amber-400"; folder="optice" }
)

$Rezultat = @()

Write-Host "Incep scanarea folderelor din 'documente'..." -ForegroundColor Cyan

foreach ($m in $MateriiConfig) {
    $ListaFisiere = @()
    # Determinam calea relativa catre folder
    $CaleaCatreFolder = Join-Path "documente" $m.folder

    if (Test-Path $CaleaCatreFolder) {
        $FisiereGasite = Get-ChildItem -Path $CaleaCatreFolder -File
        foreach ($f in $FisiereGasite) {
            $ext = $f.Extension.ToLower()
            
            # Determinam tipul fisierului pe baza extensiei pentru a afisa iconita corecta pe site
            $tip = "txt"
            if ($ext -match "\.pdf$") { $tip = "pdf" }
            elseif ($ext -match "\.docx?$") { $tip = "doc" }
            elseif ($ext -match "\.(png|jpe?g|gif|svg)$") { $tip = "img" }

            # Calea catre fisier (asa cum o citeste browserul)
            $linkWeb = "documente/$($m.folder)/$($f.Name)"

            $ListaFisiere += @{
                nume = $f.Name
                link = $linkWeb
                tip = $tip
            }
        }
    }

    # Construim obiectul final pentru materie
    $Rezultat += @{
        id = $m.id
        titlu = $m.titlu
        icon = $m.icon
        culoare = $m.culoare
        fisiere = $ListaFisiere
    }
}

# Convertim array-ul generat in format JSON
$JsonString = $Rezultat | ConvertTo-Json -Depth 5 -Compress

# Decodam eventualele caractere Unicode pentru ca diacriticele (daca mai exista) sa fie afisate corect
$JsonString = [System.Text.RegularExpressions.Regex]::Unescape($JsonString)

# Construim continutul JS (atasam datele la fereastra browserului)
$ContinutJs = "window.materii = $JsonString;"

# Rezolvam calea corecta de scriere
$CaleaCurenta = $PSScriptRoot
if (-not $CaleaCurenta) { $CaleaCurenta = (Get-Location).Path }
$CaleaFisieruluiJs = Join-Path $CaleaCurenta $FisierIesire

# Salvam fisierul fortand UTF-8
[System.IO.File]::WriteAllText($CaleaFisieruluiJs, $ContinutJs, [System.Text.Encoding]::UTF8)

Write-Host "SUCCES: A fost generat sau actualizat fisierul '$FisierIesire'!" -ForegroundColor Green
Write-Host "Daca totul este in regula, da commit schimbarilor in GitHub." -ForegroundColor Yellow
Start-Sleep -Seconds 5