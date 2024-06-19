; This works with AutohotkeyU64.exe Version  1.1.33.00 (https://www.autohotkey.com/download/1.1/AutoHotkey_1.1.31.00.zip)
;------------------------------------------------------------------------------
; Settings
;------------------------------------------------------------------------------
#NoEnv 						; For security
#SingleInstance force
#MaxHotkeysPerInterval 200 	; Allow for many event -  as mouse wheel spins!


; **Micro enhancements:
#If WinActive("Administrator:  micro") or WinActive("micro.exe") or WinActive("Micro") or WinActive("O:\MyProfile\editor\micro.exe")
{

    ; AHK can only do F1-F24
    ; Micro can receive F1-F64
    ; Can't send some keys to micro
        ; CtrlAlt   - All
        ; CtrlShift - Some
    ; Can't bind some keys in micro
        ; Ctrl+#

    ; Paired tokens
        ^2::    Send ""{Left}
        ^9::    Send (){Left}
        ^0::    Send (){Left}
        ; ^5::    Send `%`%{Left}

    ; Odd Keys

        ; New Line Above: CTRL+Enter
        ^Enter:: Send {Home}{Enter}{Up}

        ; New Line Below: Shift+Enter
        +Enter:: Send {End}{Enter}

        ; Escape - send quit
        SC001::Send ^q

        ; Swap Selection Cursor: CTRL-
        ^-:: Send {F24}

        ; Command mode: CTRL+:
        ^;:: Send !{F9}

        ; Lua Mode: CTRL+=
        ^=::Send !{F20}

        ; Shell Mode: CTRL+#
        ^SC02B:: Send ^{F13}

        ; Textfilter Mode: CTRL+@
        ^':: Send !{F9}textfilter{SPACE}

        ; Insert File Dialog : CTRL+I
        ; ctrl+i was sending TAB
        ^i::Send !{F13}

        ; Replace : CTRL+H
        ; ctrl+h was sending Enter
        ^h:: Send {F14}

        ; Find current word: CTRL+*
        ^8::Send {F15}{ENTER}

        ;Select forwards to next match: CTLR+Shift+]
        ^}::Send +{F15}

        ;Select backwards to next match: CTLR+Shift+[
        ^{::Send +{F16}

        ; Go forwards to regex-i match: CTLR+]
        ^]::Send +{F17}

        ; Go backwards to regex-i match: CTLR+[
        ^[::Send +{F18}

        ; Toggle Comments: CTRL+Q
        ^Q::Send !{F19}

        ; Select word: CTRL+Space
        ^space:: Send {F21}

        ; Prev tab/window CTRL-TAB
        ^TAB::Send !{F21}

        ; Autocomplete CTRL+/
        ^SC035:: Send {F23}

    ; CtrlShift Keys
        ; SkipMultiCursor Portage
        ^+P::Send !x

        ; Indent: CTRL+>
        ^+.::Send !.

        ; Outdent: CTRL+<
        ^+,::Send !,

        ; Select word backwards :CTRL+Shift+Space
        ^+space:: Send {F22}

        ; Next tab/window: CTRL+TAB
        ^+TAB::Send !{F22}

        ; Run lua repl: CTRL+=
        ^+=::Send !{F24}


    ; CtrlAlt keys
        ; Prefix All Lines: Ctrl+Alt+[
        ^![::Send {F18}

        ; Postfix All Lines: Ctrl+Alt+]
        ; needs calling twice - don't know why
        ^!]::Send {F19}{F19}

        ; Backup: CTRL+Alt+B
        ^!b:: Send {F13}

        ; FindinFiles CTRL+Alt+F
        ^!f:: Send !{F16}

        ; Makeit: CTRL+Alt+M
        ^!m:: Send !{F14}

        ; runfile: CTRL+Alt+R
        ^!r:: Send !{F18}

        ; Todo: =CTRL+Alt+T
        ^!t:: Send {F17}

        ; Luaexec: CTRL+Alt+=
        ^!=::Send +{F13}

        ; Compsec: CTRL+Alt+#
        ^!SC02B:: Send {F20}


    ; AltShift keys  -  these just work


}

