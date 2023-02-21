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
<<<<<<< HEAD:src/orbwalker.lua
end
=======
end
>>>>>>> 6f3ed1b0c101de30f7149145961af1f635e56e51:orbwalker.lua
