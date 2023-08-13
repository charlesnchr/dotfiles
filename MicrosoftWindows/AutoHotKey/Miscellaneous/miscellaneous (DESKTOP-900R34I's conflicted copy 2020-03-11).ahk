; Allow normal CapsLock functionality to be toggled by Alt+CapsLock:
!CapsLock::
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





;;;;  CHARLES ; ;;;;;;

; Youtube enhanced
#Space:: Winset, AlwaysOnTop, Toggle, A

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
		Send,Æ
		Return
}

CapsLock & 7:: Send,{{}
CapsLock & 8:: Send,[
CapsLock & 9:: Send,]
CapsLock & 0:: Send,{}}

^#v:: ;replaces backslashes with forward slashes in a file name that is stored on the clipboard
StringReplace,temp,clipboard,\,/,All
StringReplace,clipboard,temp,Users/%A_UserName%/OneDrive - University of Cambridge,od,All
send %clipboard%
return

 
CapsLock & F1::
IfWinExist, ccCmd
    WinActivate ; use the window found above
else 
{
	cmd := "C:\Users\"
    cmd2 := "\OneDrive - University of Cambridge\6.Programmering\ccCmd\ccCmd.lnk"
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


CapsLock & 2::
IfWinExist, Microsoft To-Do
    WinActivate ; use the window found above
else 
{
	cmd := "C:\Users\"
    cmd2 := "\OneDrive - University of Cambridge\3 Diverse\IT\AutoHotKey\Miscellaneous\Microsoft To-Do.lnk"
    run %cmd%%A_UserName%%cmd2%	
}	
return

CapsLock & 3::
SetTitleMatchMode, 2
IfWinExist, Visual Studio Code
    WinActivate ; use the window found above
else 
{
    Run code ,, Hide
}	
return

CapsLock & 4::
IfWinExist, GitHub Desktop
    WinActivate ; use the window found above
else 
{
	cmd := "C:\Users\"
    cmd2 := "\AppData\Local\GitHubDesktop\GitHubDesktop.exe"
    run %cmd%%A_UserName%%cmd2%	
}		
return


CapsLock & S::
IfWinExist, ahk_exe Spotify.exe
    WinActivate ; use the window found above
return

CapsLock & C::
SetTitleMatchMode, 2
IfWinExist, (C:)
    WinActivate ; use the window found above
else 
{
    Run explorer C:\
}	
return


CapsLock & D::
SetTitleMatchMode, 2
IfWinExist, (Desktop)
    WinActivate ; use the window found above
else 
{
	cmd := "C:\Users\"
    cmd2 := "\Desktop"
    run %cmd%%A_UserName%%cmd2%	
}	
return

CapsLock & F::
SetTitleMatchMode, 2
IfWinExist, (OneDrive - University of Cambridge)
    WinActivate ; use the window found above
else 
{
	cmd := "C:\Users\"
    cmd2 := "\OneDrive - University of Cambridge"
    run %cmd%%A_UserName%%cmd2%	
}	
return


CapsLock & E::
SetTitleMatchMode, 2
IfWinExist, (D:)
    WinActivate ; use the window found above
else 
{
    Run,explorer /root`,`,`:`:{20D04FE0-3AEA-1069-A2D8-08002B30309D}
}	
return


CapsLock & ESC::WinClose, A

CapsLock & W::WinClose, A


CapsLock & Tab::
WinGetClass, ActiveClass, A
WinSet, Bottom,, A
WinActivate, ahk_class %ActiveClass%
; WinGetTitle, ActiveTitle, A
; If ActiveTitle contains Visual Studio Code 
; {
	; WinSet, Bottom,, A
	; WinActivate, ahk_class %ActiveClass%
; }
return



;; Mouse alt window navigation
!XButton1::send !{Up}     ; Alt + Left Mouse Button





;Note +/- 120 seems to be the "default" scroll
CapsLock & t::
vel:=0
Loop, 50000 
{ 
	if stopit = 1
		{
		stopit = 0
		break
		}
Sleep, 50
PostMW(vel)
} 
return

CapsLock & g::
	stopit = 1
return


CapsLock & r::vel+=1
CapsLock & y::vel-=1



PostMW(delta)
{ ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms645617(v=vs.85).aspx
  CoordMode, Mouse, Screen
  MouseGetPos, x, y
  Modifiers := 0x8*GetKeyState("ctrl") | 0x1*GetKeyState("lbutton") | 0x10*GetKeyState("mbutton")
              |0x2*GetKeyState("rbutton") | 0x4*GetKeyState("shift") | 0x20*GetKeyState("xbutton1")
              |0x40*GetKeyState("xbutton2")
  PostMessage, 0x20A, delta << 16 | Modifiers, y << 16 | x ,, A
}









;; Coding etc
;; SC029:: Send, \
;; CapsLock & SC029:: Send, ½

CapsLock & BS::Send,{Del}



;;;;;;;HERUNDER ER NAVIGATION MED CAPSLOCK;;;;;;;;


SetCapsLockState, AlwaysOff

CapsLock & i::
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

CapsLock & j::
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

CapsLock & k::
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