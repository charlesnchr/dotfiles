#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance

SetCapsLockState, AlwaysOff

; #InstallKeybdHook

;-------------------------------------------------------
; AUTO EXECUTE SECTION FOR INCLUDED SCRIPTS
; Scripts being included need to have their auto execute
; section in a function or subroutine which is then
; executed below.
;-------------------------------------------------------
Gosub, gui_autoexecute
;-------------------------------------------------------
; END AUTO EXECUTE SECTION
return
;-------------------------------------------------------

; Load the GUI code
#Include %A_ScriptDir%\GUI\GUI.ahk

; General settings
#Include %A_ScriptDir%\Miscellaneous\miscellaneous.ahk


~*LControl::
if !State {
  State := (GetKeyState("Alt", "P") || GetKeyState("Shift", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
  ; For some reason, this code block gets called repeatedly when LControl is kept pressed.
  ; Hence, we need a guard around StartTime to ensure that it doesn't keep getting reset.
  ; Upon startup, StartTime does not exist thus this if-condition is also satisfied when StartTime doesn't exist.
  if (StartTime = "") {
    StartTime := A_TickCount
  }
}
return

$~LControl Up::
elapsedTime := A_TickCount - StartTime
if (  !State
   && (A_PriorKey = "LControl")
   && (elapsedTime <= 300)) {
  Send {Esc}
}
State     := 0
; We can reset StartTime to 0. However, setting it to an empty string allows it to be used right after first run
StartTime := ""
return

; Toggle CapsLock if both LControl+RControl are pressed
~LControl & RControl::Send {CapsLock Down}
