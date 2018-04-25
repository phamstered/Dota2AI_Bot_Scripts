--
function OnEnd()

end

function GetDesire()
    local timeLeft = checkBountySpawnTimeRemain()
    local npcBot = GetBot();
    local bounty, distance = closestBounty(npcBot, RUNE_BOUNTY_1, RUNE_BOUNTY_3)
    -- print(timeLeft, distance)
    if  timeLeft < 30 then
        return 1.0
    elseif  distance < 5000 then
        return 1.0
    else
        return 0
    end
end

function Think()
    local npcBot = GetBot();
    -- Radiant offlane Bounty RUNE_BOUNTY_1
    -- Radiant safelane Bounty RUNE_BOUNTY_3
    local bounty, distance = closestBounty(npcBot, RUNE_BOUNTY_1, RUNE_BOUNTY_3)
    checkBounty(npcBot, bounty)
end

function checkBountySpawnTimeRemain()
    local dt = DotaTime()
    local minsPassed = math.floor( dt / 60)
    return (minsPassed + 2 - minsPassed % 2) * 60 - dt
end

function closestBounty(bot, bt1, bt2)
    -- return cloest bounty and its location
    local d1 = getBotToBountyRuneDistanceSqr(bot, bt1)
    local d2 = getBotToBountyRuneDistanceSqr(bot, bt2)
    if d1 < d2 then
        return bt1, d1
    else
        return bt2, d2
    end
end

function getBotToBountyRuneDistanceSqr(bot, bounty)
    -- RUNE_STATUS_UNKNOWN  RUNE_STATUS_AVAILABLE RUNE_STATUS_MISSING
    local runeStatus = GetRuneStatus(bounty)
    -- print(bounty, runeStatus)
    local INF = 100000000
    if not runeStatus == RUNE_STATUS_AVAILABLE then
        return INF
    else
        local runeLoc = GetRuneSpawnLocation(bounty)
        return GetUnitToLocationDistanceSqr(bot, runeLoc)
    end
end


function checkBounty(npcBot, bounty)
    local runeLoc = GetRuneSpawnLocation(bounty)
    npcBot:Action_MoveToLocation(runeLoc)
    local runeStatus = GetRuneStatus(bounty)
    if runeStatus == RUNE_STATUS_AVAILABLE then
        npcBot:Action_PickUpRune(bounty)
        return true
    end
    return false
end
