require("orbwalker")
require("targetSelector")
require("utils")

local API_KEY = "<tu_api_key_aqui>"
local REGION = "na1"
local CHAMPION_DATA_FILE = "champion_data.json"
local MIN_CHAMPION_GAMES = 100

local function getChampionData()
    local summonerName = ObjectManager:GetLocalPlayer().Name
    local url = "https://" .. REGION .. ".api.riotgames.com/lol/summoner/v4/summoners/by-name/" .. summonerName .. "?api_key=" .. API_KEY
    local response = GetUrl(url)
    local summonerData = json.decode(response)
    local summonerId = summonerData.id
    
    url = "https://" .. REGION .. ".api.riotgames.com/lol/spectator/v4/active-games/by-summoner/" .. summonerId .. "?api_key=" .. API_KEY
    response = GetUrl(url)
    local gameData = json.decode(response)
    
    local championData = {}
    for _, participant in ipairs(gameData.participants) do
        local championId = participant.championId
        local championName = GetChampionName(championId)
        local totalGames = getChampionTotalGames(championId)
        
        if totalGames >= MIN_CHAMPION_GAMES then
            table.insert(championData, {
                id = championId,
                name = championName,
                totalGames = totalGames
            })
        end
    end
    
    table.sort(championData, function(a, b) return a.totalGames > b.totalGames end)
    
    SaveFile(CHAMPION_DATA_FILE, json.encode(championData))
end

function OnLoad()
    getChampionData()
end

function OnTick()
    local targetSelector = TargetSelector()
    local target = targetSelector:GetTarget()
    Orbwalker:Orbwalk(target)
end

Callback.Add("Tick", OnTick)
