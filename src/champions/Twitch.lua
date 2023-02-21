
if myHero.charName ~= "Twitch" then return end

local Twitch = {}

-- Load Required Libraries
require('GamsteronPrediction')

-- Combo function
function TwitchCombo()
    local target = GamsteronTargetSelector:GetTarget(850, _G.DAMAGE_TYPE_PHYSICAL)
    if target == nil then return end

    if TwitchQ:IsReady() and myHero.pos:DistanceTo(target.pos) > 400 then
        Control.CastSpell(HK_Q)
    end

    if TwitchE:IsReady() and TwitchE:GetDamage(target) >= target.health then
        Control.CastSpell(HK_E)
    end

    if TwitchR:IsReady() and #GamsteronPrediction:GetEnemyHeroes(850, myHero.pos) >= 2 then
        Control.CastSpell(HK_R)
    end

    if TwitchW:IsReady() and myHero.pos:DistanceTo(target.pos) <= 950 then
        local castPos, hitChance, pos = GamsteronPrediction:GetPrediction(target, TwitchW)
        if hitChance >= 2 then
            Control.CastSpell(HK_W, castPos)
        end
    end
end

-- Harass function
function TwitchHarass()
    local target = GamsteronTargetSelector:GetTarget(950, _G.DAMAGE_TYPE_PHYSICAL)
    if target == nil then return end

    if TwitchQ:IsReady() and myHero.pos:DistanceTo(target.pos) > 400 then
        Control.CastSpell(HK_Q)
    end

    if TwitchW:IsReady() and myHero.pos:DistanceTo(target.pos) <= 950 then
        local castPos, hitChance, pos = GamsteronPrediction:GetPrediction(target, TwitchW)
        if hitChance >= 2 then
            Control.CastSpell(HK_W, castPos)
        end
    end
end

-- Kite function
function TwitchKite(target)
    if myHero.pos:DistanceTo(target.pos) > 350 then
        local moveToPos = myHero.pos:Extended(target.pos, -250)
        Control.Move(moveToPos)
    else
        Control.Move(target.pos)
    end
end

-- OnTick function
function TwitchOnTick()
    if not myHero.dead then
        local target = GamsteronTargetSelector:GetTarget(1400, _G.DAMAGE_TYPE_PHYSICAL)

        if Orbwalker:CanMove() then
            if target and not Orbwalker:IsWindingUp() then
                TwitchKite(target)
            else
                Control.Move(GamsteronGeometry:RandomPoint(myHero.pos, 300))
            end
        end

        if Orbwalker:CanAttack() then
            if target then
                if Orbwalker:ComboMode() then
                    TwitchCombo()
                elseif Orbwalker:HarassMode() then
                    TwitchHarass()
                end
            end
        end
    end
end

-- OnLoad function
    function OnLoad()
        TwitchQ = {Range = 300, IsReady = function () return myHero:GetSpellData(_Q).currentCd == 0 end}
        TwitchW = {Range = 950, Width = 100, Speed = 1400, Delay = 0.25, IsReady = function () return myHero:GetSpellData(_W).currentCd == 0 end}
        TwitchE = {IsReady = function () return myHero:GetSpellData(_E).currentCd == 0 end, GetDamage = function (unit) return 10 + myHero:GetSpellData(_E).level * 20 + myHero.totalDamage * 0.25 + myHero.ap * 0.2 end}
    
        Callback.Add("Tick", function() Tick() end)
    end
    
    -- Tick function
    function Tick()
        if not myHero.dead then
            local target = GetTarget()
    
            if target then
                -- Move to avoid enemy attacks
                MoveAway(target)
    
                -- Attack the target and move automatically after each attack
                Attack(target)
    
                -- Use Q and W to escape or pursue enemies
                UseQ(target)
                UseW(target)
    
                -- Use E to maximize damage on a specific target
                UseE(target)
            end
        end
    end
    
    -- Get the best target
    function GetTarget()
        local target
    
        for i = 1, Game.HeroCount() do
            local hero = Game.Hero(i)
    
            if hero and hero.isEnemy and not hero.dead and hero.visible and hero.isTargetable and ValidTarget(hero, TwitchW.Range) then
                if not target or GetPriority(hero) > GetPriority(target) then
                    target = hero
                end
            end
        end
    
        return target
    end
    
    -- Get the priority of a target
    function GetPriority(target)
        return 1
    end
    
    -- Move away from the target
    function MoveAway(target)
        if myHero.pos:DistanceTo(target.pos) < TwitchQ.Range then
            local movePos = myHero.pos - (target.pos - myHero.pos):Normalized() * 250
            Control.Move(movePos)
        end
    end
    
    -- Attack the target and move automatically after each attack
    function Attack(target)
        if target and IsValid(target) then
            if myHero.attackData.state == STATE_WINDDOWN and myHero.pos:DistanceTo(target.pos) <= myHero.range then
                Control.Attack(target)
            elseif myHero.attackData.state == STATE_WINDDOWN then
                MoveTowards(target)
            end
        end
    end
    
    -- Move towards the target
    function MoveTowards(target)
        local movePos = myHero.pos + (target.pos - myHero.pos):Normalized() * 250
        Control.Move(movePos)
    end
    
    -- Use Q to escape or pursue enemies
    function UseQ(target)
        if TwitchQ.IsReady() then
            if myHero.pos:DistanceTo(target.pos) > TwitchQ.Range then
    
return Twitch
