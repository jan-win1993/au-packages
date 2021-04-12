#NoEnv
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 1  ; A windows's title must start with the specified WinTitle to be a match.
SetControlDelay 0  
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Windows Security - Would you like to install this device software?
; TAP-Windows Provider V9 Network adapters (OpenVPN Technologies, Inc.)
winTitle1 = Windows%A_Space%Security
WinWait, %winTitle1% ahk_class #32770, , 30
Sleep, 1000
ControlClick, Button1, %winTitle1% ahk_class #32770,,,NA