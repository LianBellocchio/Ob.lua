require("orbwalker")
require("targetSelector")
require("utils")

function OnTick()
    local targetSelector = TargetSelector()
    local target = targetSelector:GetTarget()
    Orbwalker:Orbwalk(target)
    UseSpells()
end

Callback.Add("Tick", OnTick)
