#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

cut() {
	sendInput, ^+x
}

copy() {
	sendInput, ^+c
}

paste() {
	sendInput, ^+v
}


;; How many lines are in string
lineCount(stringToCheck) {
	ErrorLevel := 0
 	StringReplace, outputVar, stringToCheck, `n, `n, UseErrorLevel
	Return ErrorLevel + 1
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
	;;clear variables, since they aparently retain their values across calls.
	timesToLoop :=
	left :=
	middle :=
	right := 

	;; store old clipboard value, and clear it
	oldClipboard := clipboard
	sleep, 20
	clipboard = 
	sleep, 20

	;; grab any currently selected text, save it, and clear the clipboard	
	cut()
	sleep, 20
	middle := clipboard
	sleep, 20
	clipboard = 
	sleep, 20
	
	;; grab any text to the left of the cursor, save it, and clear the clipboard
	sendInput, {shift}+{home}
	sleep, 20
	cut()
	sleep, 20
	left := clipboard
	sleep, 20
	clipboard = 
	sleep, 20

	;; grab any text to the right of the cursor, save it, and clear the clipboard
	sendInput, {shift}+{end}
	sleep, 20
	cut()
	sleep, 20
	right := clipboard
	sleep, 20
	clipboard =
	sleep, 20

	;; delete the line the text was on. This has a small bug where it won't delete the line at the end of a file.
	sendInput, {delete}
	sleep, 20

	;; move up one line, assemble and output the grabbed text, and add a newline
	sendInput, {up}
	sleep, 40
	sendInput, %left%
	sleep, 40
	clipboard = %middle%
	sleep, 40
	paste()
	sleep, 40
	sendInput, %right%
	sleep, 40
	sendInput, {enter}
	sleep, 40
	sendInput, {left}
	sleep, 40

	;;restore clipboard
	clipboard = %oldClipboard%

	
	sleep, 40
	sendInput, {shift}+{home}
	sleep, 40
	additionalLinesToGrab := lineCount(middle) - 1
	loop, %additionalLinesToGrab% {
		;;msgBox %a_index%
		sendInput, {shift}+{up}
		sleep, 80
	}
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