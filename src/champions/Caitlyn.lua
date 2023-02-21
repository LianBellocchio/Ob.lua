if myHero.charName ~= "Caitlyn" then return end

local Q = {Range = 1250, Width = 90, Delay = 0.625, Speed = 2200}
local E = {Range = 800}

local LastQ = 0
local LastE = 0

function OnTick()
    local target = GetTarget()

    if IsKeyDown(32) then
        DoCombo(target)
    elseif IsKeyDown(86) then
        DoLastHit(target)
    elseif IsKeyDown(67) then
        DoHarass(target)
    end
end

function DoCombo(target)
    if target then
        if myHero.pos:DistanceTo(target.pos) < E.Range and CanCast(_E) and LastE + 1.5 < Game.Timer() then
            CastSkillShot(_E, target.pos)
            LastE = Game.Timer()
        end

        if myHero.pos:DistanceTo(target.pos) < Q.Range and CanCast(_Q) and LastQ + 1.5 < Game.Timer() then
            local prediction = GetLinearAOEPrediction(target, Q)
            if prediction.HitChance >= 2 then
                CastSkillShot(_Q, prediction.CastPosition)
                LastQ = Game.Timer()
            end
        end
    end

    Orbwalk(target)
end

function DoHarass(target)
    if target then
        if myHero.pos:DistanceTo(target.pos) < Q.Range and CanCast(_Q) and LastQ + 1.5 < Game.Timer() then
            local prediction = GetLinearAOEPrediction(target, Q)
            if prediction.HitChance >= 2 then
                CastSkillShot(_Q, prediction.CastPosition)
                LastQ = Game.Timer()
            end
        end
    end

    Orbwalk(target)
end

function DoLastHit(target)
    if target and target.isMinion and target.isEnemy then
        if myHero.pos:DistanceTo(target.pos) < Q.Range and CanCast(_Q) and LastQ + 1.5 < Game.Timer() then
            local prediction = GetLinearAOEPrediction(target, Q)
            if prediction.HitChance >= 2 then
                CastSkillShot(_Q, prediction.CastPosition)
                LastQ = Game.Timer()
            end
        end
    end

    Orbwalk(target)
end

function Orbwalk(target)
    if target then
        if myHero.pos:DistanceTo(target.pos) < myHero.range then
            Attack(target)
            MoveTo(nil)
        else
            MoveTo(target.pos)
        end
    else
        MoveTo(nil)
    end
end
