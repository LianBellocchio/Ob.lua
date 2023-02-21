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

-- Load required libraries
local orb = module.load("orb")
local ts = module.internal("TS")
local menu = module.load("menu")

-- Initialize menu
local Menu = menu.new("Orbwalker", 200)

-- Add submenus for targeting options
local TargetSelector = Menu:addSubMenu("Target Selector")
local EnemyMinions = TargetSelector:addSubMenu("Enemy Minions")
local JungleMinions = TargetSelector:addSubMenu("Jungle Minions")
local OtherUnits = TargetSelector:addSubMenu("Other Units")

-- Targeting options
local priorityTable = {
    ["Champ"] = 5,
    ["Normal"] = 1,
    ["Siege"] = 2,
    ["Super"] = 3,
    ["Melee"] = 4
}

EnemyMinions:addHeader("Priority Table")
for name, priority in pairs(priorityTable) do
    EnemyMinions:addSlider(name, name, priority, 1, 5, 1)
end

JungleMinions:addSlider("Priority", "Priority", 2, 1, 5, 1)

OtherUnits:addToggle("Prioritize champions", "prioritizeChampions", true)

-- Draw options
local DrawOptions = Menu:addSubMenu("Draw Options")
DrawOptions:addToggle("Draw range", "drawRange", true)

-- Initialize target selector
local enemyMinionSelector = ts.get_selector(function(unit) return unit.isEnemy and unit.type == Obj_AI_Minion end)
local jungleMinionSelector = ts.get_selector(function(unit) return unit.isEnemy and unit.type == Obj_AI_Jungle end)
local otherSelector = ts.get_selector(function(unit) return unit.isEnemy and (unit.type == Obj_AI_Hero or unit.type == Obj_AI_Turret or unit.type == Obj_AI_Structure) end)

-- Initialize local variables
local lastAttack = 0
local lastMove = 0
local mode = ""
local target = nil

-- Orbwalking function
local function Orbwalk()
    if target == nil then return end
    if orb.core.can_attack() then
        orb.core.attack(target)
        lastAttack = game.time()
    elseif orb.core.can_move() then
        local movePos = target.pos:lerp(player.pos, -0.1)
        orb.core.move(movePos)
        lastMove = game.time()
    end
end

-- Main function
    local function Main()
        local targetMode = ""
        if orb.menu.combat then
            if orb.menu.hybrid then
                targetMode = "Mixed"
            else
                targetMode = "Combo"
            end
        else
            if orb.menu.lasthit then
                targetMode = "LastHit"
            elseif orb.menu.laneclear then
                targetMode = "LaneClear"
            elseif orb.menu.jungleclear then
                targetMode = "JungleClear"
            end
        end
    
        if targetMode ~= "" then
            local targetSelector = GetTargetSelector(targetMode)
            target = targetSelector:GetTarget()
        else
            target = nil
        end
    
        Orbwalk()
<<<<<<< HEAD:src/main.lua
    end
=======
    end
>>>>>>> 6f3ed1b0c101de30f7149145961af1f635e56e51:main.lua
