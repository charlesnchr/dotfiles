; Allow normal CapsLock functionality to be toggled by Alt+CapsLock:
#!CapsLock::
    GetKeyState, capsstate, CapsLock, T ;(T indicates a Toggle. capsstate is an arbitrary varible name)
    if capsstate = U
        SetCapsLockState, AlwaysOn
    else
        SetCapsLockState, AlwaysOff
    return



; A function to escape characters like & for use in URLs.
uriEncode(str) {
    f = %A_FormatInteger%
    SetFormat, Integer, Hex
    If RegExMatch(str, "^\w+:/{0,2}", pr)
        StringTrimLeft, str, str, StrLen(pr)
    StringReplace, str, str, `%, `%25, All
    Loop
        If RegExMatch(str, "i)[^\w\.~%/:]", char)
           StringReplace, str, str, %char%, % "%" . SubStr(Asc(char),3), All
        Else Break
    SetFormat, Integer, %f%
    Return, pr . str
}


;;;; Advanced snapping, Github Gist ;;;;;

/**
 * Advanced Window Snap
 * Snaps the Active Window to one of nine different window positions.
 *
 * @author Andrew Moore <andrew+github@awmoore.com>
 * @version 1.0
 */

/**
 * SnapActiveWindow resizes and moves (snaps) the active window to a given position.
 * @param {string} winPlaceVertical   The vertical placement of the active window.
 *                                    Expecting "bottom" or "middle", otherwise assumes
 *                                    "top" placement.
 * @param {string} winPlaceHorizontal The horizontal placement of the active window.
 *                                    Expecting "left" or "right", otherwise assumes
 *                                    window should span the "full" width of the monitor.
 * @param {string} winSizeHeight      The height of the active window in relation to
 *                                    the active monitor's height. Expecting "half" size,
 *                                    otherwise will resize window to a "third".
 */
SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight) {
    WinGet activeWin, ID, A
    activeMon := GetMonitorIndexFromWindow(activeWin)

    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%

    if (winSizeHeight == "half") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/2
    } else if (winSizeHeight == "full") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)
    } else {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/3
    }

    if (winPlaceHorizontal == "left") {
		posX  := MonitorWorkAreaLeft
		width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
    } else if (winPlaceHorizontal == "right") {
		posX  := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
		width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
    } else if (winPlaceHorizontal == "lefttwothird") {
		posX  := MonitorWorkAreaLeft
		width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/3*2
	} else if (winPlaceHorizontal == "leftthird") {
		posX  := MonitorWorkAreaLeft
		width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/3
	} else if (winPlaceHorizontal == "righttwothird") {
		posX  := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft)/3
		width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/3*2
	} else if (winPlaceHorizontal == "rightthird") {
		posX  := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft)/3*2
		width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/3
	} else {
        posX  := MonitorWorkAreaLeft
        width := MonitorWorkAreaRight - MonitorWorkAreaLeft
    }

    if (winPlaceVertical == "bottom") {
        posY := MonitorWorkAreaBottom - height
    } else if (winPlaceVertical == "middle") {
        posY := MonitorWorkAreaTop + height
    } else {
        posY := MonitorWorkAreaTop
    }

    WinMove,A,,%posX%,%posY%,%width%,%height%
}

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }

    return %monitorIndex%
}

; Directional Arrow Hotkeys
#!Up::SnapActiveWindow("top","full","half")
#!Down::SnapActiveWindow("bottom","full","half")
^#!Up::SnapActiveWindow("top","full","third")
^#!Down::SnapActiveWindow("bottom","full","third")

; Numberpad Hotkeys (Landscape)
#!Numpad8::SnapActiveWindow("top","full","half")
#!Numpad2::SnapActiveWindow("bottom","full","half")

; Numberpad Hotkeys (Portrait)
#!E::SnapActiveWindow("full","lefttwothird","full")
#!T::SnapActiveWindow("full","righttwothird","full")

#!I::SnapActiveWindow("top","left","half")
#!O::SnapActiveWindow("top","right","half")
#!K::SnapActiveWindow("bottom","left","half")
#!L::SnapActiveWindow("bottom","right","half")


#!Numpad4::SnapActiveWindow("full","left","full")
#!Numpad6::SnapActiveWindow("full","right","full")
#!Numpad7::SnapActiveWindow("full","leftthird","full")
#!Numpad9::SnapActiveWindow("full","rightthird","full")
#!Numpad5::SnapActiveWindow("full","full","full")


;;;;  CHARLES ; ;;;;;;

; Youtube enhanced
; #Space:: Winset, AlwaysOnTop, Toggle, A

; CapsLock::
; Send !{Space}
; Return

CapsLock & SC027::
{
	if getkeystate("shift") = 0
		Send,æ
	else
		Send,Æ
		Return
}

CapsLock & SC028::
{
	if getkeystate("shift") = 0
		Send,ø
	else
		Send,Ø
		Return
}

CapsLock & SC01A::
{
	if getkeystate("shift") = 0
		Send,å
	else
		Send,Å
		Return
}

CapsLock & v:: ;replaces backslashes with forward slashes in a file name that is stored on the clipboard
StringReplace,temp,clipboard,\,/,All
send %temp%
return


CapsLock & F1::
IfWinExist, ccCmd
    WinActivate ; use the window found above
else
{
	cmd := "C:\Users\"
    cmd2 := "\0main\6.Programmering\ccCmd\ccCmd.lnk"
    run %cmd%%A_UserName%%cmd2%
}
return

CapsLock & F2::
IfWinExist, ccShell
    WinActivate ; use the window found above
return

CapsLock & F3::
IfWinExist, ahk_exe ubuntu.exe
    WinActivate ; use the window found above
return



CapsLock & 1::
Send {f1}
Return

CapsLock & 2::
Send {f2}
Return

CapsLock & 3::
Send {f3}
Return

CapsLock & 4::
   if getkeystate("alt") = 1
        Send,!{f4}
    else
        Send,{f4}
return


CapsLock & 5::
Send {f5}
Return

CapsLock & 6::
Send {f6}
Return

CapsLock & 7::
Send {f7}
Return

CapsLock & 8::
Send {f8}
Return

CapsLock & 9::
Send {f9}
Return

CapsLock & 0::
Send {f10}
Return

CapsLock & -::
Send {f11}
Return

CapsLock & =::
Send {f12}
Return










CapsLock & g::
IfWinExist, ahk_exe Notion.exe
{
	IfWinActive, ahk_exe Notion.exe
	{
		WinMinimize, A
	}
	else
	{
		WinActivate ; use the window found above
		WinSet, Top,, A
	}
}
else
{
	cmd := "C:\Users\"
    cmd2 := "\AppData\Local\Programs\Notion\Notion.exe"
    run %cmd%%A_UserName%%cmd2%
}
return




CapsLock & C::
SetTitleMatchMode, 2
if getkeystate("shift") = 1
IfWinExist, (C:)
{
 	WinActivate ; use the window found above
	WinSet, Top,, A
}
else
{
    Run explorer C:\
}
return


CapsLock & ]::
SetTitleMatchMode, 2
IfWinExist, (0main)
{
 	WinActivate ; use the window found above
	WinSet, Top,, A
}
else
{
	; cmd := "C:\Users\"
    ; cmd2 := "\0main"
    ; run %cmd%%A_UserName%%cmd2%
	run "G:\My Drive\0main"
	Sleep, 100
	Send, +{tab}
}
return

CapsLock & [::
SetTitleMatchMode, 2
if getkeystate("shift") = 1
IfWinExist, (My Drive)
{
 	WinActivate ; use the window found above
	WinSet, Top,, A
}
else
{
	cmd := "G:\My Drive\"
    run %cmd%
	Sleep, 100
	Send, +{tab}
}
return



CapsLock & y::
SetTitleMatchMode, 2
if getkeystate("shift") = 1
IfWinExist, (D:)
{
 	WinActivate ; use the window found above
	WinSet, Top,, A
}
else
{
    Run,explorer /root`,`,`:`:{20D04FE0-3AEA-1069-A2D8-08002B30309D}
}
else
{
	IfWinExist, ahk_exe WindowsTerminal.exe
	{
		IfWinActive, ahk_exe WindowsTerminal.exe
		{
			WinMinimize, A
		}
		else
		{
			WinActivate ; use the window found above
			WinSet, Top,, A
		}
	}
	else
	{
		Send #5 ;; run wt
	}
}
return


CapsLock & ESC::WinClose, A


; AutoHotkey Media Keys
; ^!Space::Send       {Media_Play_Pause}
; ^!Left::Send        {Media_Prev}
; ^!Right::Send       {Media_Next}
; ^!NumpadMult::Send  {Volume_Mute}
; ^!NumpadAdd::Send   {Volume_Up}
; ^!NumpadSub::Send   {Volume_Down}

; media keys

CapsLock & w::
   if getkeystate("shift") = 1
        Send,{Volume_Up}
    else
        Send,{w}
return

CapsLock & s::
SetTitleMatchMode, 2
if getkeystate("shift") = 1
    Send,{Volume_Down}
else
    IfWinExist, Brave
    {
        WinActivate ; use the window found above
        WinSet, Top,, A
    }
    else
    {
        Send #1 ; Run code ,, Hide ; this will be administrator
    }
return

CapsLock & a::
SetTitleMatchMode, 2
if getkeystate("shift") = 1
    Send,{Media_Prev}
else
    IfWinExist, Neovim
    {
        WinActivate ; use the window found above
        WinSet, Top,, A
    }
    else
    {
        Send #3 ; Run code ,, Hide ; this will be administrator
    }
return

CapsLock & d::
SetTitleMatchMode, 2
if getkeystate("shift") = 1
    Send,{Media_Next}
else
    IfWinExist, ahk_class CabinetWClass
    {
        WinActivate
        WinSet, Top,, A
    }
    else
    {
        send #2
    }
return

CapsLock & q::
SetTitleMatchMode, 2
if getkeystate("shift") = 1
    Send,{Media_Play_Pause}
else
	IfWinExist, ahk_exe WindowsTerminal.exe
    {
        WinActivate ; use the window found above
        WinSet, Top,, A
    }
    else
    {
        Send #4 ; Run code ,, Hide ; this will be administrator
    }
return





CapsLock & p::
IfWinActive, ahk_exe SumatraPDF.exe
{
WinMinimize, A
}
else
IfWinExist, ahk_exe SumatraPDF.exe
{
WinActivate ; use the window found above
WinSet, Top,, A
}
return


CapsLock & Tab::
WinGet, ActiveProcess, ProcessName, A
WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%

If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return
Else
	{
		WinGetTitle, FullTitle, A
		WinGetClass, ThisWinClass, A
		WinGet, ThisWinProc, ProcessName, A
		SetTitleMatchMode, 2
		WinGet, WindowsWithSameTitleList, List, ahk_class %ThisWinClass% ahk_exe %ThisWinProc%
		If WindowsWithSameTitleList > 1 ; If several Window of same type (title checking) exist
		{
			WinActivate, % "ahk_id " WindowsWithSameTitleList%WindowsWithSameTitleList%	; Activate next Window
		}
	}
Return

; CapsLock & Tab::
; WinGet, ThisWin, ProcessName, A
; WinSet, Bottom,, A
; WinActivate, ahk_exe %ThisWin%
; return


;; Mouse alt window navigation
!XButton1::send !{Up}     ; Alt + Left Mouse Button

;; CapsLock & r::vel+=1
;; CapsLock & ::vel-=1



PostMW(delta)
{ ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms645617(v=vs.85).aspx
  CoordMode, Mouse, Screen
  MouseGetPos, x, y
  Modifiers := 0x8*GetKeyState("ctrl") | 0x1*GetKeyState("lbutton") | 0x10*GetKeyState("mbutton")
              |0x2*GetKeyState("rbutton") | 0x4*GetKeyState("shift") | 0x20*GetKeyState("xbutton1")
              |0x40*GetKeyState("xbutton2")
  PostMessage, 0x20A, delta << 16 | Modifiers, y << 16 | x ,, A
}



; Hyphen shortcut like mac
+#-:: Send, {—}


;; Coding etc
;; SC029:: Send, \
;; CapsLock & SC029:: Send, ½

CapsLock & BS::Send,^{BS}
CapsLock & \::Send,{Del}



;;;;;;;HERUNDER ER NAVIGATION MED CAPSLOCK;;;;;;;;


SetCapsLockState, AlwaysOff

CapsLock & k::
       if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,{Up}
		else
			Send,!{Up}
	   else
		if getkeystate("alt") = 0
			Send,^{Up}
		else
			Send,!^{Up}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+{Up}
		else
			Send,!+{Up}
	   else
		if getkeystate("alt") = 0
			Send,^+{Up}
		else
			Send,!^+{Up}
return

CapsLock & l::
        if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,{Right}
		else
			Send,!{Right}
	   else
		if getkeystate("alt") = 0
			Send,^{Right}
		else
			Send,!^{Right}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+{Right}
		else
			Send,!+{Right}
	   else
		if getkeystate("alt") = 0
			Send,^+{Right}
		else
			Send,!^+{Right}
return

CapsLock & h::
       if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,{Left}
		else
			Send,!{Left}
	   else
		if getkeystate("alt") = 0
			Send,^{Left}
		else
			Send,!^{Left}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+{Left}
		else
			Send,!+{Left}
	   else
		if getkeystate("alt") = 0
			Send,^+{Left}
		else
			Send,!^+{Left}
return

CapsLock & j::
       if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,{Down}
		else
			Send,!{Down}
	   else
		if getkeystate("alt") = 0
			Send,^{Down}
		else
			Send,!^{Down}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+{Down}
		else
			Send,!+{Down}
	   else
		if getkeystate("alt") = 0
			Send,^+{Down}
		else
			Send,!^+{Down}
return

CapsLock & Space::
	Send,!{Space}

CapsLock & u::
       if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,{Home}
		else
			Send,!{Home}
	   else
		if getkeystate("alt") = 0
			Send,^{Home}
		else
			Send,!^{Home}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+{Home}
		else
			Send,!+{Home}
	   else
		if getkeystate("alt") = 0
			Send,^+{Home}
		else
			Send,!^+{Home}
return

CapsLock & o::
       if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,{End}
		else
			Send,!{End}
	   else
		if getkeystate("alt") = 0
			Send,^{End}
		else
			Send,!^{End}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+{End}
		else
			Send,!+{End}
	   else
		if getkeystate("alt") = 0
			Send,^+{End}
		else
			Send,!^+{End}
return

CapsLock & n::
       if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,^{Left}
		else
			Send,!{Left}
	   else
		if getkeystate("alt") = 0
			Send,^{Left}
		else
			Send,!^{Left}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+^{Left}
		else
			Send,!+{Left}
	   else
		if getkeystate("alt") = 0
			Send,^+{Left}
		else
			Send,!^+{Left}
return

CapsLock & m::
       if getkeystate("shift") = 0
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,^{Right}
		else
			Send,!{Right}
	   else
		if getkeystate("alt") = 0
			Send,^{Right}
		else
			Send,!^{Right}
       else
           if getkeystate("ctrl") = 0
		if getkeystate("alt") = 0
	      		Send,+^{Right}
		else
			Send,!+{Right}
	   else
		if getkeystate("alt") = 0
			Send,^+{Right}
		else
			Send,!^+{Right}
return


; Win+<
#<::
    SendMessage 0x112, 0xF140, 0, , Program Manager  ; Start screensaver
    SendMessage 0x112, 0xF170, 2, , Program Manager  ; Monitor off
    Return

; Win+Shift+å
#+<::
    Run rundll32.exe user32.dll`,LockWorkStation     ; Lock PC
    Sleep 1000
    SendMessage 0x112, 0xF170, 2, , Program Manager  ; Monitor off
    Return

