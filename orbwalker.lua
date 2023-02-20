local orbwalker = {}

function orbwalker:__init()
self.lastAttack = 0
self.lastMove = 0
self.lastTarget = nil
self.attackRange = player.attackRange + player.boundingRadius * 2
end

function orbwalker:Tick()
local target = self:GetTarget()
self:Orbwalk(target)
end

function orbwalker:GetTarget()
local target = self.lastTarget
if not target or target.isDead or not target.isVisible or not target.isTargetable or GetDistance(target.pos) > self.attackRange then
target = nil
for i = 1, Game.HeroCount() do
local hero = Game.Hero(i)
if hero and hero.isEnemy and not hero.isDead and hero.isVisible and hero.isTargetable and GetDistance(hero.pos) <= self.attackRange then
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
self.lastTarget = target
return target
end

function orbwalker:Orbwalk(target)
if target and target.isEnemy then
if self.lastAttack + player.attackDelay * 1000 - GetLatency() / 2 < GetTickCount() then
if player:CanAttack(target) then
player:Attack(target)
self.lastAttack = GetTickCount()
end
elseif self.lastMove + 0.1 - GetLatency() / 2 < Game.Timer() then
player:MoveTo(mousePos)
self.lastMove = Game.Timer()
end
else
player:MoveTo(mousePos)
end
end

orbwalker:__init()
Callback.Add("Tick", function() orbwalker:Tick() end)
