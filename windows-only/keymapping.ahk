; Cheatsheet for keymapping:
;   # -> Win
;   ! -> Alt
;   ^ -> Ctrl

; Use CapsLock to exchange the input source.
; WARN: For Chinese users, please DO NOT use Microsoft Pinyin IME
;       but use a third-party Chinese IME.
CapsLock::
{
    SetStoreCapsLockMode False
    Send "#{space}"
}

#!f::WinMaximize "A"  ; Full screeen

!c::^c ; Copy
!v::^v ; Paste
!z::^z ; Undo
!x::^x ; Clip
!f::^f ; Search
!a::^a ; Select all

; Switch tabs
!1::^1
!2::^2
!3::^3
!4::^4
!5::^5

!w::^w   ; Close current tab
!t::^t   ; Create a new tab
!+t::^+t ; Restore the last closed tab

!+::^+   ; Zoom in
!-::^-   ; Zoom out
