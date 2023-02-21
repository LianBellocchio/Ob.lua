require("orbwalker")
require("targetSelector")
require("utils")

-- Variables
local enemyHeroes = {}
local myHero = {}
local target = nil

-- Functions
function OnTick()
    GetEnemies()
    GetMyHero()

    if #enemyHeroes > 0 and myHero.dead == false then
        target = GetTarget()

        if target ~= nil and target.visible and target.dead == false then
            AttackTarget(target)
        else
            MoveToMouse()
        end
    end
end

function GetEnemies()
    enemyHeroes = {}
    local _enemyHeroes = GetEnemyHeroes()
    for i, enemy in ipairs(_enemyHeroes) do
        if enemy and enemy.valid and enemy.visible and enemy.dead == false then
            table.insert(enemyHeroes, enemy)
        end
    end
end
function GetMyHero()
    myHero = GetMyHeroObject()
end
