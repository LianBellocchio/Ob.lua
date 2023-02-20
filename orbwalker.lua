local Orbwalker = {}

function Orbwalker:__init()
  self.lastAttack = 0
  self.lastMove = 0
  self.lastTarget = nil
end

function Orbwalker:Tick()
  local target = self:GetTarget()
  self:Orbwalk(target)
end

function Orbwalker:GetTarget()
  local target = self.lastTarget
  if not target or target.isDead or not target.isVisible or not target.isTargetable or GetDistance(target.pos) > player.attackRange + player.boundingRadius * 2 then
    target = nil
    for i = 1, Game.HeroCount() do
      local hero = Game.Hero(i)
      if hero and hero.isEnemy and not hero.isDead and hero.isVisible and hero.isTargetable and GetDistance(hero.pos) <= player.attackRange + player.boundingRadius * 2 then
        if target == nil then
          target = hero
        else
          if hero.health < target.health then
            target = hero
          end
        end
      end
    end
  end
  return target
end

function Orbwalker:Orbwalk(target)
  if target and target.isEnemy then
    if self.lastAttack + player.attackDelay - GetLatency() / 2 < Game.Timer() then
      if player:Attack(target) then
        self.lastAttack = Game.Timer()
      end
    elseif self.lastMove + 0.1 - GetLatency() / 2 < Game.Timer() then
      player:MoveTo(mousePos)
      self.lastMove = Game.Timer()
    end
  else
    player:MoveTo(mousePos)
  end
end

Orbwalker:__init()
Callback.Add("Tick", function() Orbwalker:Tick() end)

return Orbwalker
