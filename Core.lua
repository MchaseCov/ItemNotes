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

function CheckChatForLinks(self, event, arg1, arg2, ...)
    local id = arg1:match("|Hitem:(%d+):")
    if id then
        if ItemNotes.db.notes[id] then
            _, j = string.find(arg1, "]|h|r") -- Index point of the last character of the link
            local part1 = string.sub(arg1, 1, j) -- First half of message up until link
            local part2 = string.sub(arg1, (j + 1), -1) -- Second half of message starting with first character after link
            local noteTip = "[NOTE] " -- Note tooltip to insert
            return false, (part1 .. noteTip .. part2), arg2, ... -- Return false, combined message, author, ...
        end
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", CheckChatForLinks)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", CheckChatForLinks)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", CheckChatForLinks)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CheckChatForLinks)
