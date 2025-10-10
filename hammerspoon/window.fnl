; half of screen
; hint: option + cmd + arrow keys
(hs.hotkey.bind [:option :cmd] :left
                (fn [] (: (hs.window.focusedWindow) :moveToUnit [0 0 0.5 1])))

(hs.hotkey.bind [:option :cmd] :right
                (fn [] (: (hs.window.focusedWindow) :moveToUnit [0.5 0 0.5 1])))

(hs.hotkey.bind [:option :cmd] :up
                (fn [] (: (hs.window.focusedWindow) :moveToUnit [0 0 1 0.5])))

(hs.hotkey.bind [:option :cmd] :down
                (fn [] (: (hs.window.focusedWindow) :moveToUnit [0 0.5 1 0.5])))

; quarter of screen
; hint: ctrl + option + cmd +
;   [[
;     u i
;     j k
;   ]]
(hs.hotkey.bind [:ctrl :option :cmd] :u
                (fn [] (: (hs.window.focusedWindow) :moveToUnit [0 0 0.5 0.5])))

(hs.hotkey.bind [:ctrl :option :cmd] :i
                (fn []
                  (: (hs.window.focusedWindow) :moveToUnit [0.5 0 0.5 0.5])))

(hs.hotkey.bind [:ctrl :option :cmd] :j
                (fn []
                  (: (hs.window.focusedWindow) :moveToUnit [0 0.5 0.5 0.5])))

(hs.hotkey.bind [:ctrl :option :cmd] :k
                (fn []
                  (: (hs.window.focusedWindow) :moveToUnit [0.5 0.5 0.5 0.5])))

; full screen
; hint: option + cmd + f
(hs.hotkey.bind [:alt :cmd] :f (fn []
                                 (: (hs.window.focusedWindow) :moveToUnit
                                    [0 0 1 1])))

; center screen
; hint: option + cmd + c
(hs.hotkey.bind [:alt :cmd] :c
                (fn [] (: (hs.window.focusedWindow) :centerOnScreen)))
