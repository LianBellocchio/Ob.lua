require("orbwalker")
require("targetSelector")
require("utils")
local json = require("json")

local api_key = "RGAPI-0da18bab-778e-4c5f-81d5-a15b56aab8dd"

function OnTick()
    local targetSelector = TargetSelector()
    local target = targetSelector:GetTarget()

    local allyChampions = GetAllyChampions()
    local enemyChampions = GetEnemyChampions()

    local priorities = {}
    for i, enemy in ipairs(enemyChampions) do
        local enemyInfo = GetSummonerInfoByName(enemy.name, api_key)
        local totalDamage = enemyInfo.stats.totalDamageDealtToChampions
        local totalGold = enemyInfo.stats.goldEarned
        local priority = totalDamage / totalGold
        priorities[enemy.name] = priority
    end

    local sortedPriorities = SortTableByValue(priorities, "desc")
    local enemyToAttack = nil
    for i, enemy in ipairs(sortedPriorities) do
        if CanTarget(target) and target.name == enemy then
            enemyToAttack = target
            break
        end

        for j, champion in ipairs(enemyChampions) do
            if champion.name == enemy then
                enemyToAttack = champion
                break
            end
        end

        if enemyToAttack then
            break
        end
    end

    if enemyToAttack then
        Orbwalker:Orbwalk(enemyToAttack)
    else
        Orbwalker:Orbwalk(target)
    end
end

Callback.Add("Tick", OnTick)
