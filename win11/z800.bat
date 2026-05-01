@echo off
cls
echo ======================================================
echo   HP Z800 Windows 11 Automated Setup Prep (v3)
echo ======================================================

echo.
echo [1/4] Applying Registry Bypasses (TPM, CPU, & Network)...
(
echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig]
echo "BypassTPMCheck"=dword:00000001
echo "BypassSecureBootCheck"=dword:00000001
echo "BypassCPUCheck"=dword:00000001
echo "BypassRAMCheck"=dword:00000001
echo "BypassStorageCheck"=dword:00000001
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE]
echo "BypassNRO"=dword:00000001
) > bypass.reg
regedit /s bypass.reg
echo Done.

echo.
echo [2/4] Initializing Disk Selection...
echo list disk > dsktmp.txt
diskpart /s dsktmp.txt
set /p disknum="Enter the DISK NUMBER to WIPE and REPARTITION (e.g., 0): "

echo.
echo [3/4] Wiping Disk %disknum% and creating MBR partitions...
(
echo select disk %disknum%
echo clean
echo convert mbr
echo rem == 1. System Reserved Partition (500MB) ==
echo create partition primary size=500
echo format fs=ntfs quick label="System Reserved"
echo active
echo assign
echo rem == 2. Windows Partition (Remaining space) ==
echo create partition primary
echo format fs=ntfs quick label="Windows"
echo assign
) > dsktmp.txt
diskpart /s dsktmp.txt
del dsktmp.txt
del bypass.reg
echo Done.

echo.
echo [4/4] FINAL REMINDERS:
echo - DISCONNECT Ethernet now.
echo - Choose "Custom: Install Windows only" in the next step.
echo - Select the LARGER partition (labeled Windows) to install to.
echo - "I don't have internet" should now appear in OOBE.
echo.
set /p junk="Prep complete. Press ENTER to close and start install..."
exit
