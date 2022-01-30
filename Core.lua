local _G = _G
ItemNotesAddon = {}

local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(this, event, ...)
    ItemNotesAddon[event](ItemNotesAddon, ...)
end)

function ItemNotesAddon:PLAYER_LOGIN() self:SetDefaults() end

function ItemNotesAddon:SetDefaults()
    if not ItemNotesDB then

        ItemNotesDB = {notes = {}}

        print("Notes Initialized")
    end
end
