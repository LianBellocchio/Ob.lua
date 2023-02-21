if myHero.charName ~= "KogMaw" then return end

local Q = {Range = 1175, Width = 80, Delay = 0.25, Speed = 1650}
local W = {Range = myHero.range + myHero.boundingRadius + 50}
local E = {Range = 1200, Width = 120, Delay = 0.25, Speed = 1350}
local R = {Range = 2200, Width = 225, Delay = 0.85, Speed = math.huge}

function KogMawDraw()
    if not myHero.dead then
        if Menu.Drawings.Q:Value() and Ready(_Q) then DrawCircle(myHero.pos, Q.Range, 1, DrawColor(255, 0, 191, 255)) end
        if Menu.Drawings.W:Value() and Ready(_W) then DrawCircle(myHero.pos, myHero.range + myHero.boundingRadius + 50, 1, DrawColor(255, 65, 105, 225)) end
        if Menu.Drawings.E:Value() and Ready(_E) then DrawCircle(myHero.pos, E.Range, 1, DrawColor(255, 30, 144, 255)) end
        if Menu.Drawings.R:Value() and Ready(_R) then DrawCircle(myHero.pos, R.Range, 1, DrawColor(255, 0, 0, 255)) end
    end
end

function KogMawCombo()
    local target = TargetSelector:GetTarget(Q.Range, 1)
    if target and IsValid(target) then
        if Menu.Combo.Q:Value() and Ready(_Q) and myHero.pos:DistanceTo(target.pos) <= Q.Range then
            local castPos, hitChance = GetPred(target, Q.Speed, Q.Delay)
            if hitChance >= Menu.Prediction.QH:Value() then
                Control.CastSpell(HK_Q, castPos)
            end
        end
        if Menu.Combo.W:Value() and Ready(_W) and myHero.pos:DistanceTo(target.pos) <= W.Range then
            Control.CastSpell(HK_W)
        end
        if Menu.Combo.E:Value() and Ready(_E) and myHero.pos:DistanceTo(target.pos) <= E.Range then
            local castPos, hitChance = GetPred(target, E.Speed, E.Delay)
            if hitChance >= Menu.Prediction.EH:Value() then
                Control.CastSpell(HK_E, castPos)
            end
        end
        if Menu.Combo.R:Value() and Ready(_R) and myHero.pos:DistanceTo(target.pos) <= R.Range then
            local castPos, hitChance = GetPred(target, R.Speed, R.Delay)
            if hitChance >= Menu.Prediction.RH:Value() then
                Control.CastSpell(HK_R, castPos)
            end
        end
    end
end

function KogMawClear()
    local minions = _G.SDK.ObjectManager:GetEnemyMinions(1200)
    for i, minion in ipairs(minions) do
        if IsValid(minion) and myHero.pos:DistanceTo(minion.pos) <= Q.Range and Menu.Clear.Q:Value() and Ready(_Q) then
            Control.CastSpell(HK_Q, minion)
            break
        end
    end
end

function KogMawHarass()
    local target = TargetSelector:GetTarget(Q.Range, 1)
    if target and IsValid(target) then
        if Menu.Harass.Q:Value() and Ready(_Q) and myHero.pos:DistanceTo(target.pos) <= Q.Range then
            local castPos, hitChance = GetPred(target, Q.Speed, Q.Delay)
            if hitChance >= Menu.Harass.QHC:Value() then
                Control.CastSpell(HK_Q, castPos)
            end
        end

        if Menu.Harass.W:Value() and Ready(_W) and myHero.pos:DistanceTo(target.pos) <= W.Range then
            Control.CastSpell(HK_W)
        end
    end
end

function KogMawCombo()
    local target = TargetSelector:GetTarget(Q.Range, 1)
    if target and IsValid(target) then
        if Menu.Combo.Q:Value() and Ready(_Q) and myHero.pos:DistanceTo(target.pos) <= Q.Range then
            local castPos, hitChance = GetPred(target, Q.Speed, Q.Delay)
            if hitChance >= Menu.Combo.QHC:Value() then
                Control.CastSpell(HK_Q, castPos)
            end
        end

        if Menu.Combo.W:Value() and Ready(_W) and myHero.pos:DistanceTo(target.pos) <= W.Range then
            Control.CastSpell(HK_W)
        end

        if Menu.Combo.E:Value() and Ready(_E) and myHero.pos:DistanceTo(target.pos) <= E.Range then
            local castPos, hitChance = GetPred(target, E.Speed, E.Delay)
            if hitChance >= Menu.Combo.EHC:Value() then
                Control.CastSpell(HK_E, castPos)
            end
        end

        if Menu.Combo.R:Value() and Ready(_R) and myHero.pos:DistanceTo(target.pos) <= R.Range and CountEnemiesAround(target.pos, R.Width) >= Menu.Combo.RCount:Value() then
            Control.CastSpell(HK_R, target)
        end
    end
end

function KogMawTick()
    if _G.JustEvade and _G.JustEvade:Evading() then return end
    if myHero.dead or Game.IsChatOpen() or myHero.isChanneling then return end

    if Orbwalker:Mode() == "Clear" then
        KogMawClear()
    elseif Orbwalker:Mode() == "Harass" then
        KogMawHarass()
    elseif Orbwalker:Mode() == "Combo" then
        KogMawCombo()
    end
end
