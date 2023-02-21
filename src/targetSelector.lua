TargetSelector = {}

function TargetSelector:GetTarget()
    local target = nil

    local mode = OrbwalkerModes[Orbwalker.Mode]
    if mode and mode.GetTarget then
        target = mode:GetTarget()
    end

    if not target then
        target = GetTarget(1000)
    end

    return target
end
