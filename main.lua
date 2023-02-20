require("orbwalker")
require("targetSelector")
require "utils"

local Orbwalker = {}

function Orbwalker:new(targetSelector)
    local orb = {}
    setmetatable(orb, self)
    self.__index = self

    orb.targetSelector = targetSelector
    orb.lastAttackTime = 0
    orb.lastWindupTime = 0
    orb.windupTime = 0
    orb.range = 0
    orb.projectileSpeed = 0
    orb.minionProjectileSpeed = 0

    return orb
end

function Orbwalker:__attack(target)
    if target then
        Control.Attack(target)
        self.lastAttackTime = Game.GetTime()
    end
end

function Orbwalker:__orbwalk()
    local target = self.targetSelector:GetTarget()
    if target then
        if Game.CanUseSpell(0) == 0 and Game.GetTime() > self.lastWindupTime + self.windupTime then
            local targetDistance = Player.Position:Distance(target.Position)
            if targetDistance <= self.range then
                self:__attack(target)
            elseif self.projectileSpeed > 0 and targetDistance <= self.range + self.projectileSpeed * self.windupTime then
                self:__attack(target)
            end
        end
        Player:MoveTo(target.Position)
    else
        Player:MoveTo(mousePos)
    end
end

function Orbwalker:Tick()
    if Game.GetTime() < self.lastAttackTime + self.windupTime then
        return
    end

    local target = self.targetSelector:GetTarget()
    if target then
        local targetDistance = Player.Position:Distance(target.Position)
        local safeDistance = self.range
        if Player.HasBuff("itemduskbladebuff") then
            safeDistance = self.range + 75
        end
        if targetDistance <= safeDistance then
            self:__orbwalk()
        end
    else
        Player:MoveTo(mousePos)
    end
end

function Orbwalker:OnPreAttack(args)
    local target = args.Target
    if target then
        local targetDistance = Player.Position:Distance(target.Position)
        local safeDistance = self.range
        if Player.HasBuff("itemduskbladebuff") then
            safeDistance = self.range + 75
        end
        if targetDistance > safeDistance then
            args.Process = false
        end
    end
end

function Orbwalker:OnPostAttack(args)
    local target = args.Target
    if target then
        if self.minionProjectileSpeed > 0 and target.IsMinion then
            self.lastWindupTime = Game.GetTime()
            self.windupTime = (self.range + Player.BoundingRadius + target.BoundingRadius) / self.minionProjectileSpeed
        elseif self.projectileSpeed > 0 then
            self.lastWindupTime = Game.GetTime()
            self.windupTime = (self.range + Player.BoundingRadius + target.BoundingRadius) / self.projectile
