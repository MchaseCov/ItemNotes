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
