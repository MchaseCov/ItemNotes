local _G = _G
ItemNotes = {}

local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent",
                function(this, event, ...) ItemNotes[event](ItemNotes, ...) end)

function ItemNotes:PLAYER_LOGIN()
    self:SetDefaults()
    self.db = ItemNotesDB
end

function ItemNotes:SetDefaults()
    if not ItemNotesDB then

        ItemNotesDB = {notes = {}}

        print("Notes Initialized")
    end
end

function ItemNotes:SetNoteHandler(input)
    local _, _, item, note = string.find(input, "%s?(%w+)%s?(.*)")

    if note and #note > 0 then
        ItemNotes:SetNote(item, note)
    else
        print("You must type a note!")
    end
end

function ItemNotes:SetNote(item, note)
    if self.db.notes and item then
        self.db.notes[item] = note
        print("Set " .. item .. " to " .. note)
    end
end

SLASH_ADDNOTE1 = "/itemnoteadd"
SlashCmdList["ADDNOTE"] = function(msg) ItemNotes:SetNoteHandler(msg) end
