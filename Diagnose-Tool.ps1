# iPhone Restore Connection Diagnostiker 2026
Write-Host "--- iPhone Restore Diagnose-Tool v1.2 (2026) ---" -ForegroundColor Cyan

# 1. Check Apple Mobile Device Service
$service = Get-Service -Name "Apple Mobile Device Service" -ErrorAction SilentlyContinue
if ($service.Status -eq "Running") {
    Write-Host "[OK] Apple Mobile Device Service läuft." -ForegroundColor Green
} else {
    Write-Host "[FEHLER] Apple Mobile Device Service nicht gefunden oder gestoppt." -ForegroundColor Red
}

# 2. USB Controller Analyse
Write-Host "`nPrüfe USB-Controller auf Protokoll-Lags (Fehler 1109)..."
$usbControllers = Get-PnpDevice -PresentOnly | Where-Object { $_.Class -eq "USB" }
foreach ($dev in $usbControllers) {
    if ($dev.FriendlyName -like "*USB4*" -or $dev.FriendlyName -like "*Thunderbolt*") {
        Write-Host "[WARNUNG] High-Speed Controller erkannt: $($dev.FriendlyName). Nutzen Sie ggf. einen USB 2.0 Hub." -ForegroundColor Yellow
    }
}

# 3. Log-Analyse Pfad-Check
$logPath = "$env:USERPROFILE\AppData\Local\Apple Computer\Logs\iPhoneUpdater.log"
if (Test-Path $logPath) {
    Write-Host "`n[INFO] Restore-Log gefunden. Prüfen Sie die letzten Zeilen auf 'NAND_FULL' (Fehler 1110)." -ForegroundColor Cyan
}

Write-Host "`nDiagnose abgeschlossen. Besuchen Sie unseren Blog für den Full-Fix."
Pause