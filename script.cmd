@echo off
echo ========================================================
echo   Creare structura directoare si fisiere pentru site
echo ========================================================
echo.

:: 1. Crearea folderului principal
echo [1] Creez folderul principal 'documente'...
if not exist "documente" mkdir "documente"

:: 2. Crearea subfolderelor pentru fiecare materie
echo [2] Creez subfolderele pentru materii...
if not exist "documente\com-date" mkdir "documente\com-date"
if not exist "documente\microunde" mkdir "documente\microunde"
if not exist "documente\comutatie" mkdir "documente\comutatie"
if not exist "documente\retele" mkdir "documente\retele"
if not exist "documente\teoria-transmisiunii" mkdir "documente\teoria-transmisiunii"
if not exist "documente\radioreleu" mkdir "documente\radioreleu"
if not exist "documente\optice" mkdir "documente\optice"

:: 3. Crearea fisierelor dummy (goale) pentru a nu avea erori 404 pe site la testare
echo [3] Generez fisierele de test in directoarele aferente...

:: Fisiere pentru 'Comunicații de date'
echo Acesta este un fisier de test PDF. > "documente\com-date\curs1.pdf"
echo Acesta este un fisier de test DOCX. > "documente\com-date\lab1.docx"
echo Acesta este un fisier de test PNG. > "documente\com-date\schema.png"
echo Acesta este un cod sursa de test. > "documente\com-date\cod.txt"

:: Fisiere pentru 'Microunde'
echo Acesta este un fisier de test PDF pentru Microunde. > "documente\microunde\curs1.pdf"
echo Acesta este un fisier de test PDF cu formule. > "documente\microunde\formule.pdf"

echo.
echo ========================================================
echo   GATA! Structura a fost generata cu succes.
echo   Poti gasi folderele in aceeasi locatie cu acest script.
echo ========================================================
pause