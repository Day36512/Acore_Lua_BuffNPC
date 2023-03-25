local NPCID = 400117 
local ANNOUNCE_MODULE = true
local BUFF_BY_LEVEL = true
local BUFF_CURE_RES = true
local BUFF_NUM_PHRASES = 3
local BUFF_NUM_WHISPERS = 3
local BUFF_MESSAGE_TIMER = 60000
local BUFF_EMOTE_SPELL = 44940



local phrases = {
    "Stay strong, adventurer!",
    "Go forth and conquer!",
    "May these blessings guide you on your journey!"
}


local whispers = {
    "You have been blessed, %s!",
    "May these buffs aid you in battle, %s!",
    "Best of luck, %s!"
}

local function Replace(str, from, to)
    str = string.gsub(str, from, to)
    return str
end

local function PickWhisper(Name)
    local WhisperNum = math.random(1, #whispers)
    local whisper = whispers[WhisperNum]
    local randMsg = Replace(whisper, "%%s", Name)
    return randMsg
end

local function PickPhrase()
    local PhraseNum = math.random(1, #phrases)
    local phrase = phrases[PhraseNum]
    return phrase
end

local function OnGossipSelect(event, player, creature, sender, intid)
    local PlayerName = player:GetName()
    local PlayerLevel = player:GetLevel()

    
    local vecBuffs = {48162, 43223, 48469, 48470, 48170, 43002}

    
    if BUFF_CURE_RES and player:HasAura(15007) then
        player:RemoveAura(15007)
        creature:SendUnitSay("The aura of death has been lifted from you " .. PlayerName .. ". Watch yourself out there!", 0, player)
    end

if PlayerLevel >= 1 and PlayerLevel < 10 then
    player:CastSpell(player, 21562, true) 
    player:CastSpell(player, 1126, true)  
    player:CastSpell(player, 27683, true) 
elseif PlayerLevel >= 10 and PlayerLevel < 20 then
    player:CastSpell(player, 21562, true) 
    player:CastSpell(player, 1126, true)  
    player:CastSpell(player, 27683, true) 
elseif PlayerLevel >= 20 and PlayerLevel < 30 then
    player:CastSpell(player, 21562, true) 
    player:CastSpell(player, 1126, true)  
    player:CastSpell(player, 27683, true) 
    player:CastSpell(player, 13326, true) 
elseif PlayerLevel >= 30 and PlayerLevel < 40 then
    player:CastSpell(player, 21562, true) 
    player:CastSpell(player, 25898, true) 
    player:CastSpell(player, 1126, true)  
    player:CastSpell(player, 27681, true) 
    player:CastSpell(player, 27683, true) 
    player:CastSpell(player, 13326, true) 
elseif PlayerLevel >= 40 and PlayerLevel < 50 then
    player:CastSpell(player, 21562, true) 
    player:CastSpell(player, 48469, true) 
    player:CastSpell(player, 27681, true) 
    player:CastSpell(player, 48170, true) 
    player:CastSpell(player, 13326, true) 
elseif PlayerLevel >= 50 and PlayerLevel < 60 then
    player:CastSpell(player, 48162, true) 
    player:CastSpell(player, 43223, true) 
    player:CastSpell(player, 48469, true) 
    player:CastSpell(player, 48074, true) 
    player:CastSpell(player, 48170, true) 
   player:CastSpell(player, 36880, true) 
elseif PlayerLevel >= 60 and PlayerLevel < 70 then
    player:CastSpell(player, 48162, true) 
    player:CastSpell(player, 43223, true) 
    player:CastSpell(player, 48469, true) 
    player:CastSpell(player, 48074, true) 
    player:CastSpell(player, 48170, true) 
    player:CastSpell(player, 36880, true) 
elseif PlayerLevel >= 70 and PlayerLevel < 80 then
    player:CastSpell(player, 48162, true) 
    player:CastSpell(player, 43223, true) 
    player:CastSpell(player, 48469, true) 
    player:CastSpell(player, 48074, true) 
    player:CastSpell(player, 48170, true) 
    player:CastSpell(player, 36880, true) 
else
for _, buff in ipairs(vecBuffs) do
    player:CastSpell(player, buff, true)
end
end


    creature:SendUnitWhisper(PickWhisper(PlayerName), 0, player)
    creature:PerformEmote(71) 
    player:GossipComplete()
end

local function OnGossipHello(event, player, creature)
    player:GossipMenuAddItem(0, "Buff me!", 1, 1)
    player:GossipSendMenu(1, creature)
end

local function OnLogin(event, player)
    if ANNOUNCE_MODULE then
        player:SendBroadcastMessage("This server is running the |cff4CFF00BufferNPC |rmodule.")
    end
end

RegisterPlayerEvent(3, OnLogin)
RegisterCreatureGossipEvent(NPCID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPCID, 2, OnGossipSelect)

local function OnTimerEmote(eventID, delay, pCall, creature)
    creature:PerformEmote(BUFF_EMOTE_COMMAND)
    creature:SendUnitSay(PickPhrase(), 0)
    creature:RegisterEvent(OnTimerEmote, BUFF_MESSAGE_TIMER, 1)
end

local function OnSpawn(event, creature)
    creature:RegisterEvent(OnTimerEmote, BUFF_MESSAGE_TIMER, 1)
    if BUFF_EMOTE_SPELL ~= 0 then
        creature:AddAura(BUFF_EMOTE_SPELL, creature)
    end
end

local eventId = CreateLuaEvent(OnTimerEmote, BUFF_MESSAGE_TIMER, 1)
if eventId then
    RegisterCreatureEvent(NPCID, 5, OnSpawn)
end
