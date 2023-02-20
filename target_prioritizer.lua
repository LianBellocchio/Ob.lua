local TargetPrioritizer = {}

function TargetPrioritizer:GetPriority(target)
  if target.type == Obj_AI_Hero then
    -- Prioritize enemy champions based on their health percentage
    if target.health < 0.2 * target.maxHealth then
      return 5
    elseif target.health < 0.4 * target.maxHealth then
      return 4
    elseif target.health < 0.6 * target.maxHealth then
      return 3
    elseif target.health < 0.8 * target.maxHealth then
      return 2
    else
      return 1
    end
  elseif target.type == Obj_AI_Minion then
    -- Prioritize jungle monsters over lane minions
    if target.isJungle then
      return 2
    else
      return 1
    end
  elseif target.type == Obj_AI_Plant then
    -- Prioritize plants last
    return 0
  else
    -- Prioritize other types of objects last
    return -1
  end
end

function TargetPrioritizer:CompareTargets(a, b)
  local priorityA = self:GetPriority(a)
  local priorityB = self:GetPriority(b)

  if priorityA == priorityB then
    return a.health < b.health
  else
    return priorityA > priorityB
  end
end

return TargetPrioritizer
