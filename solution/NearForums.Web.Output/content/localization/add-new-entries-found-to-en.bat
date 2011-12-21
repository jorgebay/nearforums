@echo off
POGenerator.exe add -f=..\..\.. -p=en-us.po 
:: > "%temp%\po-changes.txt"
:: start /w notepad++ "%temp%\po-changes.txt"
:: del "%temp%\po-changes.txt"
exit