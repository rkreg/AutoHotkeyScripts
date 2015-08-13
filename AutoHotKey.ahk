#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

cut() {
	send, ^+x
}

copy() {
	send, ^+c
}

paste() {
	send, ^+v
}



;; Delete a line with ctrl+y (yank)
^y::
	send, {home}
	send, {shift}+{end}
	send, {delete}
	sleep, 20
	send, {delete}
return

;; Duplicate a line with ctrl+d. It doesn't work super well if you duplicate quickly.
^d::
	;; store old clipboard value, and clear it
	oldClipboard := clipboard
	sleep, 20
	clipboard = 
	sleep, 20

	send, {home}
	sleep, 20
	send, {shift}+{end}
	sleep, 20
	copy()
	sleep, 20
	send, {end}
	sleep, 20
	send, {enter}
	sleep, 20
	paste()
	sleep, 20

	;;restore clipboard
	sleep, 20
	clipboard = %oldClipboard%
return

;; Move line(s) up
^+Up::
	;; store old clipboard value, and clear it
	oldClipboard := clipboard
	clipboard = 

	;; grab any currently selected text, save it, and clear the clipboard	
	send, ^+x
	middle := clipboard
	clipboard = 
	
	;; grab any text to the left of the cursor, save it, and clear the clipboard
	send, {shift}+{home}
	send, ^+x
	left := clipboard
	clipboard = 

	;; grab any text to the right of the cursor, save it, and clear the clipboard
	send, {shift}+{end}
	send, ^+x
	right := clipboard
	clipboard =

	;; delete the line the text was on. This has a small bug where it won't delete the line at the end of a file.
	send, {delete}

	;; move up one line, assemble and output the grabbed text, and add a newline
	;; send, {up}%left%%middle%%right%{enter}
	send, {up}
	send, %left%
	send, %middle%
	send, %right%
	;;send, {enter}
	;;send, {left}

	;;restore clipboard
	clipboard = %oldClipboard%
return

;; Move line(s) down

;; Numpad on right hand with left alt as modifier
<!m::Send {Numpad1}
<!,::Send {Numpad2}
<!.::Send {Numpad3}
<!j::Send {Numpad4}
<!k::Send {Numpad5}
<!l::Send {Numpad6}
<!u::Send {Numpad7}
<!i::Send {Numpad8}
<!o::Send {Numpad9}
<!space::Send {Numpad0}
<!alt::Send {NumpadDot} ;;this is for the t530 keyboard