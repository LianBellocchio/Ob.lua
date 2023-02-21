local Orbwalker = {}

local targetSelector = require("targetSelector")

Orbwalker.lastAttackTime = 0

function Orbwalker:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Orbwalker:attack(target)
  if target and target.isEnemy and target.isTargetable and target.isVisible and not target.isDead then
    if os.clock() - self.lastAttackTime > 1 / myHero.attackSpeed then
      Control.Attack(target)
      self.lastAttackTime = os.clock()
    end
  end
end

function Orbwalker:move()
  if not Control.IsKeyDown(HK_TCO) then
    Control.Move(mousePos)
  end
end

function Orbwalker:orbwalk(target)
  if target and target.isEnemy and target.isTargetable and target.isVisible and not target.isDead then
    local distance = myHero.pos:DistanceTo(target.pos)
    local extraTime = 0.1
    if myHero.activeSpell.valid and myHero.activeSpell.startTime ~= 0 and myHero.activeSpell.name ~= "SummonerTeleport" then
      extraTime = myHero.activeSpell.windUpTime - (os.clock() - myHero.activeSpell.startTime)
      if extraTime < 0 then extraTime = 0 end
    end
    if os.clock() - self.lastAttackTime > extraTime + 1 / myHero.attackSpeed and distance < myHero.range + myHero.boundingRadius + target.boundingRadius then
      Control.Attack(target)
      self.lastAttackTime = os.clock()
    else
      self:move()
    end
  else
    self:move()
  end
end

function Orbwalker:OrbwalkHeroes()
  local target = targetSelector:GetTarget(1000)
  if target and target.isEnemy then
    local healthPercentage = target.health / target.maxHealth
    local distance = myHero.pos:DistanceTo(target.pos)
    if distance < myHero.range + myHero.boundingRadius + target.boundingRadius and healthPercentage < 0.5 then
      self:attack(target)
    elseif distance < 1000 and healthPercentage < 0.2 then
      self:attack(target)
    else
      self:orbwalk(target)
    end
  else
    self:move()
  end
end

return Orbwalker
