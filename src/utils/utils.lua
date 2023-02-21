function GetAllyChampions()
    local allyChampions = {}
    for i = 1, Game.HeroCount() do
        local hero = Game.Hero(i)
        if hero.isAlly and not hero.isMe then
            table.insert(allyChampions, hero)
        end
    end
    return allyChampions
end

function GetEnemyChampions()
    local enemyChampions = {}
    for i = 1, Game.HeroCount() do
        local hero = Game.Hero(i)
        if hero.isEnemy then
            table.insert(enemyChampions, hero)
        end
    end
    return enemyChampions
end

function CanTarget(obj)
    return obj and obj.valid and obj.isVisible and not obj.isDead
end

