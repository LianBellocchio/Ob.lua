require("orbwalker")
require("targetSelector")

function OnTick()
    local targetSelector = TargetSelector()
    local target = targetSelector:GetTarget()
    Orbwalker:Orbwalk(target)
end

Callback.Add("Tick", OnTick)
