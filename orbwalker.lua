Orbwalker = {}
local myHero = myHero

function Orbwalker:Orbwalk(target)
    if CanTarget(target) then
        if IsMelee(myHero) then
            if GetDistanceSqr(myHero, target) < GetTrueAttackRange(myHero) * GetTrueAttackRange(myHero) then
                AttackTarget(target)
            else
                MoveToTarget(target)
            end
        else
            if CanAttack() then
                AttackTarget(target)
            elseif CanMove() then
                MoveToTarget(target)
            end
        end
    else
        if CanMove() then
            MoveToMouse()
        end
    end
end
