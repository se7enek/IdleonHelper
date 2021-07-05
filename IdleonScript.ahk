;@Ahk2Exe-SetName IdleonHelper
;@Ahk2Exe-SetDescription SizeSaver and FishingHelper for Idleon
;@Ahk2Exe-SetVersion 1.0.0-beta
;@Ahk2Exe-SetCopyright Copyright (c) 2021`, se7en
;@Ahk2Exe-SetOrigFilename IdleonHelper.ahk

;@Ahk2Exe-AddResource bottomright.png
;@Ahk2Exe-AddResource topleft.png
;@Ahk2Exe-AddResource overlay2.png


;#Warn
;#NoTrayIcon
#Persistent
#SingleInstance, Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen


TargetWindow = legends-of-idleon
file = settings.ini

Menu, Tray, NoStandard
Menu, Tray, Icon, %A_ScriptName%
Menu, Tray, Add, Start Legends of Idleon, BStart
Menu, Tray, Add
Menu, Tray, Add, Fishing MiniGame Helper, BFishing
Menu, Tray, Add
Menu, Tray, Add, Save Current Position, BSavePos
Menu, Tray, Add, Windows Autostart, BAutostart
Menu, Tray, Add
Menu, Tray, Add, Reload, BReload
Menu, Tray, Add, Exit, BExit
Menu, Tray, Tip, RightClick for settings

ifExist, %file% 
{
	IniRead, AutoStart, %file%, LegendsOfIdleon, AutoStart
	IniRead, PosY, %file%, LegendsOfIdleon, PosY
}
else
	AutoStart := False
	
If(AutoStart == True)
	Menu, Tray, Check, Windows AutoStart

If(PosY != "ERROR")
	Menu, Tray, Insert, Windows Autostart, Restore Saved Position, BLoadPos
	

Gui, 69: +LastFound
hWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "NewWindow" )
return

NewWindow( wParam,lParam )
{
	global
	If (wParam = 1)
	{
		NewID := lParam
		WinGetTitle, Title, ahk_id %NewID% 
		WinGetClass, Class, ahk_id %NewID%
		If Title =
		{
			sleep 2000
    		WinGetTitle, Title, ahk_id %NewID%
    		WinGetClass, Class, ahk_id %NewID%
		}

;;	If Title != %TargetWindow2%
;;		MsgBox, %Title%
        If Title = %TargetWindow%
		{
			Idleon = %NewID%
			ifExist, %file%
			{
				IniRead, PosX, %file%, LegendsOfIdleon, PosX
				IniRead, PosY, %file%, LegendsOfIdleon, PosY
				IniRead, Width, %file%, LegendsOfIdleon, Width
				IniRead, Height, %file%, LegendsOfIdleon, Height
				IniRead, Maximized, %file%, LegendsOfIdleon, Maximized
				
				If(PosX != "ERROR")
				{
					If Maximized == True
						WinMaximize, ahk_id %NewID%
					else
						WinMove, ahk_id %NewID%,, PosX, PosY, Width, Height
						
				}
			}
			return 1 
		}
		return 1
    }
}
Return

BStart:
Run, steam://rungameid/1476970
Return

BLoadPos:
ifExist, %file%
{
	IniRead, PosX, %file%, LegendsOfIdleon, PosX
	IniRead, PosY, %file%, LegendsOfIdleon, PosY
	IniRead, Width, %file%, LegendsOfIdleon, Width
	IniRead, Height, %file%, LegendsOfIdleon, Height
	IniRead, Maximized, %file%, LegendsOfIdleon, Maximized
				
	If(PosX != "ERROR")
	{
		If Maximized == True
			WinMaximize, ahk_id %Idleon%
		else
			WinMove, ahk_id %Idleon%,, PosX, PosY, Width, Height
						
	}
} else {
ToolTip, Saved settings not found.
Sleep, 2000
ToolTip
}
Return

F10::
BSavePos:

WinGetPos, PosX, PosY, Width, Height, "ahk_id %Idleon%"
WinGet, Maximized, MinMax , "ahk_id %Idleon%"

If(PosX)
{ 
TooltipSave := "Settings Saved."
IniWrite, %Maximized%, %file%, LegendsOfIdleon, Maximized
IniWrite, %PosX%, %file%, LegendsOfIdleon, PosX
IniWrite, %PosY%, %file%, LegendsOfIdleon, PosY
IniWrite, %Width%, %file%, LegendsOfIdleon, Width
IniWrite, %Height%, %file%, LegendsOfIdleon, Height
} else {
TooltipSave := "Game not found."
}
ToolTip, %TooltipSave%, 1s
Sleep,2000
ToolTip
Return

BAutostart:
Menu, Tray, ToggleCheck, Windows AutoStart
AutoStart := !AutoStart
TooltipAutostart := AutoStart ? "Tool will now`nstart with Windows" : "Tool won't be`nstarting with Windows"

ToolTip, %TooltipAutostart%, 1s
Sleep,2000
ToolTip

If(AutoStart)
	RegWrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Run,AHK1,%A_ScriptFullPath%
else
	RegWrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Run,AHK1,0

IniWrite, %AutoStart%, %file%, LegendsOfIdleon, AutoStart
Return

BFishing:
{
	CoordMode, Mouse, Screen
	ToolTip
	Gui, 60: +Toolwindow -Caption +AlwaysOnTop +LastFound
	Gui, 60: Color, A0A0A0
	Gui, 60: +0x800000
	Gui, 60: Font, s28 c2690ad, Microsoft Sans Serif
	Gui, 60: Add, Text, x10 y0, Set-up MiniGame Area
	Gui, 60: Font, s18 Black, Times New Roman
	Gui, 60: Add, Text, x10 y50, 1. Click on Top-Left corner `nof minigame, like on image:
	Gui, 60: Add, Picture, x93 y120, topleft.png
	Gui, 60: Add, Text, x10 y240, 2. Click on Bottom-Right corner `nof minigame, like on image:
	Gui, 60: Add, Picture, x93 y310, bottomright.png
	Gui, 60: Add, Text, x10 y430, 3. Right Click anywhere to hide overlay.
	Gui, 60: Add, Button, x125 y500 w150 h50 gCloseGui, I Understand
	Gui, 60: Show, % "x" . A_ScreenWidth/2-200 . "y" A_ScreenHeight/2-300 . "h600 w400", Information
	WinWaitClose, Information

	InSetup := 1
	TooltipInfo := "Click top-left area of minigame"
	GetCoords(x,y)
	TL := [x,y]
	TooltipInfo := "Click bottom-right area of minigame"
	GetCoords(x,y)
	BR := [x,y]

	Box(TL[1],TL[2],BR[1],BR[2])
	;MsgBox, % "X: " TL[1] "-" BR[1] "`nY: " TL[2] "-" BR[2]
}
Return

CloseGui:
Gui, 60: Submit
Gui, 60: Destroy
Return

Check:
ToolTip, %TooltipInfo%
Return


GetCoords(ByRef x, ByRef y){
static null := {}
SetTimer, Check, 20
HotKey, LButton, % null, On
KeyWait, LButton, D
KeyWait, LButton
HotKey, LButton, Off
SetTimer, Check, Off
ToolTip
MouseGetPos, x, y
}
Return


Box(OX1, OY1, OX2, OY2)
{
	WinGetPos, WX, WY, WW, WH, A
	Color = Black
	Opacity := 200 ; 0-255
	Width := OX2 - OX1
	Height := OY2 - OY1

	Gui 1:color, Green
	Gui 1:+ToolWindow +Lastfound -SysMenu -Caption +AlwaysOnTop

	Gui 1:color, EEAA99
	Gui 1:+ToolWindow +Lastfound -SysMenu -Caption +AlwaysOnTop
	x := OX1
	y := OY1
	w := Width
	h := Height

	Gui 1: Add, Picture, x0 y0 w%w% h%h%, overlay2.png
	Gui 1:Show, x%x% y%y% w%w% h%h% NA
	GUI_ID := WinExist()
	WinSet, Transparent, 200        , % "ahk_id " . GUI_ID
	WinSet, ExStyle    , ^0x00000020, % "ahk_id " . GUI_ID
	WinSet, TransColor, EEAA99




	Gui 81:color, %Color%
	Gui 81:+ToolWindow +Lastfound -SysMenu -Caption +AlwaysOnTop

	x := WX
	y := WY
	w := OX2 - WX
	h := OY1 - WY 
	Gui 81:Show, x%x% y%y% w%w% h%h% NA
	GUI_ID := WinExist()
	WinSet, Transparent, %Opacity%        , % "ahk_id " . GUI_ID
	WinSet, ExStyle    , ^0x00000020, % "ahk_id " . GUI_ID

	Gui 82:color, %Color%
	Gui 82:+ToolWindow +Lastfound -SysMenu -Caption +AlwaysOnTop

	x := OX2
	w := WX + WW - OX2
	h := OY2 - WY ;;OY2
	Gui 82:Show, x%x% y%y% w%w% h%h% NA
	GUI_ID := WinExist()
	WinSet, Transparent, %Opacity%         , % "ahk_id " . GUI_ID
	WinSet, ExStyle    , ^0x00000020, % "ahk_id " . GUI_ID

	Gui 83:color, %Color%
	Gui 83:+ToolWindow +Lastfound -SysMenu -Caption +AlwaysOnTop

	x := OX1
	y := OY2
	h := WY + WH - OY2
	w := WX + WW - OX1
	Gui 83:Show, x%x% y%y% w%w% h%h% NA
	GUI_ID := WinExist()
	WinSet, Transparent, %Opacity%         , % "ahk_id " . GUI_ID
	WinSet, ExStyle    , ^0x00000020, % "ahk_id " . GUI_ID

	Gui 84:color, %Color%
	Gui 84:+ToolWindow +Lastfound -SysMenu -Caption +AlwaysOnTop

	x := WX
	y := OY1
	w := OX1 - WX
	h := WY + WH - OY1 ;; wysokosc OD OY1 DO WY+WH
	Gui 84:Show, x%x% y%y% w%w% h%h% NA
	GUI_ID := WinExist()
	WinSet, Transparent, %Opacity%         , % "ahk_id " . GUI_ID
	WinSet, ExStyle    , ^0x00000020, % "ahk_id " . GUI_ID
}
Return

~RButton::
{
	Gui 1:destroy
	Gui 81:destroy
	Gui 82:destroy
	Gui 83:destroy
	Gui 84:destroy
}
Return

F6::
BReload:
Reload

BExit:
ExitApp







