--[[
    ORBWALKER
    Este módulo se encarga de hacer orbwalking, es decir, de controlar la posición del campeón para atacar a los enemigos.
]]

-- Load required libraries
local orb = module.load("orb")
local ts = module.internal("TS")
local menu = module.load("menu")
local draw = module.load("drawing")
local damage = module.load("damage")

-- Create module object
local Orbwalker = {}

-- Declare variables
local attack_target = nil
local last_attack_target = nil
local last_attack_time = 0
local last_move_time = 0

-- Create menu
menu.register(
    "orbwalker",
    "Orbwalker",
    function()
        menu.label("Orbwalker Settings")
        menu.keybind("combo_key", "Combo Key", "SPACE")
        menu.keybind("harass_key", "Harass Key", "C")
        menu.keybind("last_hit_key", "Last Hit Key", "X")
        menu.keybind("lane_clear_key", "Lane Clear Key", "V")
        menu.checkbox("draw_aa_range", "Draw AA Range", true)
    end
)

-- Set target selector
local target_selector = ts.get_selector()

-- Define target selector callbacks
target_selector.on_select_target = function(selected_target)
    attack_target = selected_target
end

target_selector.on_unselect_target = function(unselected_target)
    if attack_target == unselected_target then
        attack_target = nil
    end
end

-- Define functions
local function get_attack_range()
    return orb.data.range + orb.data.extra_range
end

local function get_target_health(target)
    local health = target.health
    if target.shieldAD > 0 then
        health = health + target.shieldAD
    end
    if target.shieldAP > 0 then
        health = health + target.shieldAP
    end
    return health
end

local function get_attack_damage(target)
    return damage.calc_auto_attack_damage(player, target)
end

local function can_attack()
    if game.time() < last_attack_time + orb.data.windup then
        return false
    end
    if not player.is_attack_ready then
        return false
    end
    return true
end

local function can_move()
    if game.time() < last_move_time + orb.data.animation then
        return false
    end
    return true
end

local function attack(target)
    if not target or not target.is_alive or not player.is_alive then
        return
    end
    if not can_attack() then
        return
    end
    if player.path.server_pos:dist(target.pos) > get_attack_range() then
        return
    end
    if last_attack_target ~= target then
        player:attack(target)
        last_attack_target = target
        last_attack_time = game.time()
    end
end

local function move(target_pos)
    if not target_pos or not player.is_alive then
        return
    end
    if not can_move() then
        return
    end
    player:move(target_pos)
    last_move_time = game.time()
end

<<<<<<< HEAD
-- orbwalking while moving forward or backward
function orbwalk(target)
    if target and target.valid and target.visible and target.isTargetable and not target.isDead and target.health > 0 then
      if not myHero.isAttacking and not myHero.isMoving then
        if target.pos:dist(myHero.pos) < myHero.range + myHero.boundingRadius + target.boundingRadius then
          attack(target)
        else
          move(target.pos)
        end
      elseif myHero.isMoving then
        if target.pos:dist(myHero.pos) < myHero.range + myHero.boundingRadius + target.boundingRadius then
          stopMovement()
          attack(target)
        else
          move(target.pos)
        end
      elseif myHero.isAttacking then
        if GetTickCount() > lastAttack + myHero.attackDelay + attackOffset then
          stopAttack()
        end
      end
    else
      stopMovement()
    end
  
    -- backward movement
    if IsKeyDown(0x41) then -- A key
      local angle = Vector(target.pos - myHero.pos):normalized()
      local targetPos = myHero.pos - angle * myHero.range
      if myHero.pos:dist(target.pos) > 2 * myHero.range then
        move(targetPos)
      end
    end
  
    -- forward movement
    if IsKeyDown(0x44) then -- D key
      local angle = Vector(target.pos - myHero.pos):normalized()
      local targetPos = myHero.pos + angle * myHero.range
      move(targetPos)
    end
  end
  

local lastHitKey = string.byte("V")
local comboKey = string.byte("space")
local harassKey = string.byte("C")

local isLastHit = false
local isCombo = false
local isHarass = false

function OnUpdate()
  if input.IsKeyDown(lastHitKey) then
    isLastHit = true
    isCombo = false
    isHarass = false
  elseif input.IsKeyDown(comboKey) then
    isCombo = true
    isLastHit = false
    isHarass = false
  elseif input.IsKeyDown(harassKey) then
    isHarass = true
    isLastHit = false
    isCombo = false
  else
    isLastHit = false
    isCombo = false
    isHarass = false
  end
end
=======
    return target
function orbwalker:Orbwalk(target)
    if target and target.isEnemy then
        if self:CanAttack() then
            orb.core.attack(target)
            self.lastAttack = game.time
        elseif self:CanMove() and self:ShouldMove() then
            local position = self:GetOrbwalkingPosition(target)
            if position then
                orb.core.move(position)
            end
        end
    end
end

function orbwalker:ShouldMove()
    -- Don't move if the target is a structure (e.g. turret, inhibitor)
    if target and target.isStructure then
        return false
    end
    
    -- Don't move if the target is in range and we're not trying to last hit
    if target and orb.core.can_attack() then
        return false
    end

    -- Move to the last hit position if we're trying to last hit
    if self.mode == "LastHit" then
        local position = self:GetLastHitPosition()
        if position then
            return true
        end
    end

    -- Move to the orbwalking position for the target
    local position = self:GetOrbwalkingPosition(target)
    return position ~= nil
end

function orbwalker:GetLastHitPosition()
    local minionList = self:GetLastHitMinions()
    if #minionList > 0 then
        local minion = minionList[1]
        local predictedDamage = self:GetPredictedDamage(minion)
        if predictedDamage >= minion.health then
            return minion.pos
        end
    end
    return nil
end

function orbwalker:GetLastHitMinions()
    local minions = objManager.minions
    local result = {}
    for i = 0, minions.size[TEAM_ENEMY] - 1 do
        local minion = minions[TEAM_ENEMY][i]
        if self:IsValidLastHitMinion(minion) then
            table.insert(result, minion)
        end
    end
    table.sort(result, function(a, b) return a.health < b.health end)
    return result
end

function orbwalker:IsValidLastHitMinion(minion)
    return minion.isTargetable and minion.isEnemy and not minion.isDead and minion.health > 0 and orb.core.can_attack() and self:GetDistance(minion) <= orbwalker.data.autoAttackRange
end

function orbwalker:GetPredictedDamage(target)
    local damage = player.baseAttackDamage + player.flatPhysicalDamageMod
    local critChance = player.critChance / 100
    local critDamage = 2
    if player.critChance == 0 then
        critDamage = 1
    end
    damage = damage * critChance * critDamage + damage * (1 - critChance)
    return damage
end

>>>>>>> c22482423dd83ea60da2f5d872411e8f6b6cf15e
