(local slowQuit {:delay 1 :timer nil :alert nil})

(set slowQuit.onKeyDown
     (fn [self]
       (let [app (hs.application.frontmostApplication)]
         (tset self :timer
               (hs.timer.doAfter self.delay (fn [] (app:kill) (self:reset))))
         (tset self :alert
               (hs.alert.show (.. "Hold ⌘+Q to quit " (app:name) self.delay))))))

(set slowQuit.reset (fn [self] (hs.alert.closeSpecific self.alert)
                      (tset self :timer nil)
                      (tset self :alert nil)))

(set slowQuit.onKeyUp
     (fn [self]
       (if (self.timer:running)
           (do
             (self.timer:stop)
             (self:reset)
             (hs.alert.show :Canceled 0.25)))))

(hs.hotkey.bind [:cmd] :q #(slowQuit:onKeyDown) #(slowQuit:onKeyUp))

slowQuit
