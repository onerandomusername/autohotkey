; AHK For Other Devices
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_MyDocuments%  ; Ensures a consistent starting directory.
#SingleInstance, Force
#Persistent
#Include <VMR>
Menu, Tray, Tip , Essential Shortcuts (D)

SetCapsLockState, AlwaysOff

OnExit("ExitFunc", -1)

lastWin := WinExist("A")
global voicemeeterProcess := 0
If (!VoicemeeterExist()) {
	RunWait, C:\Program Files (x86)\VB\Voicemeeter\Voicemeeterpro.exe
}
voicemeeter := new VMR()
voicemeeter.login()

If (!voicemeeterProcess) {
	switch (voicemeeter.getType())
	{
		Case 1:
		voicemeeterProcess := "voicemeeter.exe"
		Case 2:
		voicemeeterProcess := "voicemeeterpro.exe"
		Case 3:
		voicemeeterProcess := "voicemeeter8x64.exe" 
		Default:
		Throw, Exception("Invalid Voicemeeter", -1)
	}
}



voicemeeter.command.show(1)
lastWin := WinExist("A")
WinExist("VoiceMeeter")
WinActivate
WinActivate, ahk_id %lastWin%


return 



CapsLock::
SetCapsLockState % GetKeyState("CapsLock", "T") ? "AlwaysOff" : "AlwaysOn"
return

CapsLock & s::Send, {ctrl down}{shift down}``{shift up}{ctrl up}
CapsLock & f::Send, {ctrl down}{alt down}{shift down}``{shift up}{alt up}d{ctrl up}

VoicemeeterExist(){
	Process, exist, voicemeeterpro.exe ; banana, v2
	If (ErrorLevel)
		return true
	Process, exist, voicemeeter.exe ; normal, v1
	If (ErrorLevel)
		return true
	Process, exist, voicemeeter8x64.exe ; potato, v3, in 64 bit
	If (ErrorLevel)
		return true
	Process, exist, voicemeeter8.exe ; potato, v3, 32 bit
	If (ErrorLevel)
		return true
	return false
}


#If WinActive("ahk_exe explorer.exe")
*Mbutton::
Send, {Rbutton}{Down}{Right}{Up}{Enter}
return



#If VoicemeeterExist()

CapsLock & a::
KeyWait, a, T0.3
IF (ErrorLevel == 1) {
	voicemeeterWinClose := !WinExist("ahk_exe" voicemeeterProcess)
	IF (!WinActive("ahk_exe" voicemeeterProcess)) {
		lastWin := WinExist("A")
		voicemeeter.command.show(1)
		sleep, 50
		WinActivate, VoiceMeeter
	}
	Keywait, a
	If (voicemeeterWinClose)
		voicemeeter.command.show(0)
	else
		Send, #{down}
	voicemeeterWinClose := false
}
else
{
	IF (!WinActive("ahk_exe" voicemeeterProcess)) {
		If (!WinExist("ahk_exe" voicemeeterProcess))
			voicemeeterWinClose := true
		else
			voicemeeterWinClose := false
		lastWin := WinExist("A")
		voicemeeter.command.show(1)
		sleep, 50
		WinActivate, % "ahk_exe" voicemeeterProcess
	}
	else
	{
		If (voicemeeterWinClose)
			voicemeeter.command.show(0)
		else
			Send, #{down}
		voicemeeterWinClose := false
		
	}
	Keywait, a
}
return

Volume_Mute::voicemeeter.bus[1].mute := -1
Volume_Up::voicemeeter.bus[1].gain += 2
Volume_Down::voicemeeter.bus[1].gain -= 2


^Volume_Mute::
globalMute := !globalMute
if (globalMute) {
	busMutes := Array()
	for i, bus in voicemeeter.bus {
		busMutes.Push(bus.mute)
		bus.mute := 1
	}
}
else
{
	for i, bus in voicemeeter.bus
		if (!(bus.mute < busMutes[i]))
		bus.mute := busMutes[i]
}
return

ExitFunc() {
SetCapsLockState, Off
}
