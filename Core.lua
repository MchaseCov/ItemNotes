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
function ItemNotes:ReturnNoteMessage(itemid)
    local item = Item:CreateFromItemID((tonumber(itemid)))
    item:ContinueOnItemLoad(function()
        local itemLink = item:GetItemLink()
        print(itemLink .. ": " .. self.db.notes[itemid])
    end)
end

-- Creates/updates note based on item ID input
function ItemNotes:SetItemNote(item, note)
    if note and #note > 0 then
        ItemNotes:SetNote(item, note)
        ItemNotes:ReturnNoteMessage(item, note)
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

-- Fetches item note
function ItemNotes:FetchItemNote(item)
    if self.db.notes[item] then
        ItemNotes:ReturnNoteMessage(item)
    else
        print("No note saved for that item.")
    end
end

-- Evaluates first argument of /itemnote <args>
function ItemNotes:NoteCommandHandler(input)
    local _, _, cmd, args = string.find(input, "%s?(%w+)%s?(.*)")
    local _, _, item, note = string.find(args, "%s?(%w+)%s?(.*)")

    if args ~= "" then
        if cmd == "add" then ItemNotes:SetItemNote(item, note) end
        if cmd == "remove" then ItemNotes:RemoveItemNote(item) end
        if cmd == "fetch" then ItemNotes:FetchItemNote(item) end
    else
        if cmd == "help" then print("Help menu placeholder") end
    end
end

-- Itemnote commands
SLASH_ITEMNOTE1 = "/itemnote"
SLASH_ITEMNOTE2 = "/itemnotes"
SLASH_ITEMNOTE3 = "/inote"
SlashCmdList["ITEMNOTE"] =
    function(input) ItemNotes:NoteCommandHandler(input) end
