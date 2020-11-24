; AHK For Other Devices
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_MyDocuments%  ; Ensures a consistent starting directory.
#SingleInstance, Force
#Persistent
#Include <VMR>

RunWait, C:\Program Files (x86)\VB\Voicemeeter\Voicemeeterpro.exe

voicemeeter := new VMR()
voicemeeter.login()
voicemeeter.command.show(1)
lastWin := WinExist("A")
WinExist("VoiceMeeter")
WinActivate
WinActivate, ahk_id %lastWin%

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

#If VoicemeeterExist()

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
