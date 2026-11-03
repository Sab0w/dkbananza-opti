@echo off
rem Starts DKBananza Opti at high process priority. Pick the game from the emulator's game list.
start "" /high /D "%~dp0" "%~dp0DKBananzaOpti.exe" %*
