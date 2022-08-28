#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#n::Run Notepad
return


CapsLock & x:: Send,// TeXForm // CopyToClipboard {Shift down}{Enter}{Shift up}

; STYRES AF SETPOINT
;WheelLeft::
;WinMinimize,A
;return
;WheelRight::
;Send !{F4}
;return



CapsLock & 7:: Send,{{}
CapsLock & 8:: Send,[
CapsLock & 9:: Send,]
CapsLock & 0:: Send,{}}

½:: Send, \

CapsLock & BS::Send,{Del}

*CapsLock::SetCapsLockState, AlwaysOff
!CapsLock::SetCapsLockState, On





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



;;;; VISUAL STUDIO

CapsLock & s::
	Send +{F10}
	Send {Up 11}
return


;;; sublime

CapsLock & r::
	winactivate Cmder
	Send {Up}
	Send {Enter}
return




;;; SPOTIFY

CapsLock & Space::
{ 
 WinGetTitle, wintit
 Winactivate, ahk_exe spotify.exe
 Send, {Space}
 Sleep 50
 Send,{AltDown}{Esc}{AltUp}
 WinActivate, wintit
 return
} 

CapsLock & Up::
{ 
 WinGetTitle, wintit
 Winactivate, ahk_exe spotify.exe
 Send, {CtrlDown}{Up}{CtrlUp}
 Sleep 50
 Send,{AltDown}{Esc}{AltUp}
 WinActivate, wintit
 return
}

CapsLock & Down::
{ 
 WinGetTitle, wintit
 Winactivate, ahk_exe spotify.exe
 Send, {CtrlDown}{Down}{CtrlUp}
 Sleep 50
 Send,{AltDown}{Esc}{AltUp}
 WinActivate, wintit
 return
}

CapsLock & Left::
{ 
 WinGetTitle, wintit
 Winactivate, ahk_exe spotify.exe
 Send, {CtrlDown}{Left}{CtrlUp}
 Sleep 50
 Send,{AltDown}{Esc}{AltUp}
 WinActivate, wintit
 return
}

CapsLock & Right::
{ 
 WinGetTitle, wintit
 Winactivate, ahk_exe spotify.exe
 Send, {CtrlDown}{Right}{CtrlUp}
 Sleep 50
 Send,{AltDown}{Esc}{AltUp}
 WinActivate, wintit
 return
}