	; AHK For Other Devices
	#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
	; #Warn  ; Enable warnings to assist with detecting common errors.
	SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
	SetWorkingDir %A_MyDesktop%  ; Ensures a consistent starting directory.
	#SingleInstance, Force
	#Persistent
	#NoTrayIcon
	
	If (!InStr(FileExist(A_WorkingDir . "\AutoHotkey"), "D"))
		FileCreateDir, % A_WorkingDir . "\AutoHotkey"
	If (!InStr(FileExist(A_WorkingDir . "\AutoHotkey\Lib"), "D"))
		FileCreateDir, % A_WorkingDir . "\AutoHotkey\Lib"
		
		
	vmrPath := A_WorkingDir . "\AutoHotkey\Lib\VMR.ahk"
	UrlDownloadToFile, https://raw.githubusercontent.com/onerandomusername/VMR.ahk/master/VMR.ahk, %vmrPath%
	
	
	scriptPath := A_WorkingDir . "\AutoHotkey\Win10-D-ahk.ahk"
	UrlDownloadToFile, % "https://raw.githubusercontent.com/onerandomusername/autohotkey/main/remotes/WIN10-D/Essential%20Shortcuts.ahk", %scriptPath%
	
	
	
	Run, %scriptPath%
	
	ExitApp
	
	return
	
	internetConnected(url:="http://github.com"){
	return, !(!dllCall("Wininet.dll\InternetCheckConnection","Str",url,"Uint",1,"Uint",0))
	}
