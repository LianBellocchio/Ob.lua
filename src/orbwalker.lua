local orbwalker = {}

function orbwalker:AttackTarget(target)
    if target and GetDistance(myHero, target) <= myHero.range then
        if CanAttack() then
            IssueAttack(target)
        end
    end
end

function orbwalker:MoveToMouse()
    MoveTo(mousePos.x, mousePos.z)
end

function orbwalker:CanAttack()
    return GetTickCount() > lastAttack + attackDelay + 20
end

function orbwalker:GetMyHeroObject()
    return myHero
end

function orbwalker:GetEnemyHeroes()
    local _enemyHeroes = GetEnemyHeroes()
    local result = {}
    for i, enemy in ipairs(_enemyHeroes) do
        if enemy and enemy.valid and enemy.visible and enemy.dead == false then
            table.insert(result, enemy)
        end
    end
    return result
end

function orbwalker:GetTarget()
    local target = nil
    local maxPriority = 0

    for i, enemy in ipairs(enemyHeroes) do
        local priority = GetTargetPriority(enemy)

        if priority > maxPriority and GetDistance(myHero, enemy) <= myHero.range then
            maxPriority = priority
            target = enemy
        end
    end

    return target
end

function orbwalker:AttackTarget(target)
    if target and GetDistance(myHero, target) <= myHero.range then
        if CanAttack() then
            IssueAttack(target)
        end
    end
end

function orbwalker:MoveToMouse()
    MoveTo(mousePos.x, mousePos.z)
end

function orbwalker:CanAttack()
    return GetTickCount() > lastAttack + attackDelay + 20
end

function orbwalker:GetMyHeroObject()
    return myHero
end

-- Additional logic to prioritize low health enemies
function orbwalker:GetLowHealthEnemyTarget()
    local target = nil
    local lowestHealth = 1000

    for i, enemy in ipairs(enemyHeroes) do
        local priority = GetTargetPriority(enemy)
        local health = enemy.health
        if priority > 0 and health > 0 and health < lowestHealth and GetDistance(myHero, enemy) <= myHero.range then
            lowestHealth = health
            target = enemy
        end
    end

    return target
end

-- Additional logic to prioritize dying enemies
function orbwalker:GetDyingEnemyTarget()
    local target = nil
    local lowestHealthPercent = 100

    for i, enemy in ipairs(enemyHeroes) do
        local priority = GetTargetPriority(enemy)
        local healthPercent = enemy.health / enemy.maxHealth * 100

        if priority > 0 and healthPercent < lowestHealthPercent and enemy.dead == false and enemy.visible then
            lowestHealthPercent = healthPercent
            target = enemy
        end
    end

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

