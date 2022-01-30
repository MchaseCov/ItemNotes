local _G = _G
ItemNotes = {}

-- Load note database on login 
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

-- Callback to grab item link for chat message
function ItemNotes:ReturnSetNoteMessage(item, note)
    local note = note
    local item = Item:CreateFromItemID((tonumber(item)))
    item:ContinueOnItemLoad(function()
        local itemLink = item:GetItemLink()
        print("Set " .. itemLink .. " to " .. note)
    end)
end

-- Creates/updates note based on item ID input
function ItemNotes:SetItemNote(item, note)
    if note and #note > 0 then
        ItemNotes:SetNote(item, note)
        ItemNotes:ReturnSetNoteMessage(item, note)
    else
        print("You must type a note!")
    end
end

function ItemNotes:SetNote(item, note)
    if self.db.notes and item then self.db.notes[item] = note end
end

-- Removes item note based on item ID
function ItemNotes:RemoveItemNote(item)
    if self.db.notes and item then
        self.db.notes[item] = nil
        print("Removed note")
    end
end

-- Evaluates first argument of /itemnote <args>
function ItemNotes:NoteCommandHandler(input)
    local _, _, cmd, args = string.find(input, "%s?(%w+)%s?(.*)")
    local _, _, item, note = string.find(args, "%s?(%w+)%s?(.*)")

    if cmd == "add" and args ~= "" then ItemNotes:SetItemNote(item, note) end
    if cmd == "remove" and args ~= "" then ItemNotes:RemoveItemNote(item) end
end

-- Itemnote commands
SLASH_ITEMNOTE1 = "/itemnote"
SLASH_ITEMNOTE2 = "/itemnotes"
SLASH_ITEMNOTE3 = "/inote"
SlashCmdList["ITEMNOTE"] =
    function(input) ItemNotes:NoteCommandHandler(input) end
