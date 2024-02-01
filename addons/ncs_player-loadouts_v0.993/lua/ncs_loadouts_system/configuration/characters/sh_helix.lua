local OBJ = NCS_LOADOUTS.RegisterCharacter("helix")

function OBJ:GetCharacterID(p)
    if not p:GetCharacter() then
        return
    end

    return p:GetCharacter():GetID()
end

function OBJ:OnCharacterLoaded(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("CharacterLoaded", function(char, slot)
        local player = char:GetPlayer()

        if not IsValid(player) then
            return
        end

        local slot = char:GetID()

        CALLBACK(player, slot)
    end)
end

function OBJ:OnCharacterDeleted(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("CharacterDeleted", function(player, char)
        CALLBACK(player, char)
    end)
end

function OBJ:OnCharacterChanged(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("PrePlayerLoadedCharacter", function(client, new, old)
        if not old then
            return
        end

        if new ~= old then
            CALLBACK(client, new:GetID(), old:GetID())
        end
    end)
end