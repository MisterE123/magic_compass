local function start_cooldown() end

-- on_cooldown non viene creato in automatico al login, bensì al primo utilizzo di un oggetto con cooldown.
-- Questo perché si potrebbero avere zero oggetti con cooldown, creando tabelle inutili
local on_cooldown = {}    -- KEY: player name; VALUE: {items, on, cooldown}
local S = minetest.get_translator("magic_compass")



minetest.register_on_player_receive_fields(function(player, formname, fields)

  if formname ~= "magic_compass:GUI" then return end

  if fields.EMPTY or fields.quit or fields.key_up or fields.key_down then return end

  local ID = string.match(dump(fields), "%d+")
  local item = magic_compass.items[tonumber(ID)]
  local p_name = player:get_player_name()

  -- se non ha i permessi, annullo
  if item.privs and not minetest.check_player_privs(p_name, minetest.string_to_privs(item.privs, ", ")) then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] This location is not available for you at the moment!")))
    minetest.sound_play("magiccompass_teleport_deny", {
      to_player = p_name
    })
    return end

  -- se è in cooldown, annullo
  if item.cooldown and on_cooldown[p_name] and on_cooldown[p_name][ID] then
    minetest.chat_send_player(p_name, minetest.colorize("#e6482e", S("[!] You can't reteleport to this location so quickly! (seconds remaining: @1)",  on_cooldown[p_name][ID])))
    minetest.sound_play("magiccompass_teleport_deny", {
      to_player = p_name
    })
    return end

  -- se non passa gli eventuali callback, annullo
  for _, callback in ipairs(magic_compass.registered_on_use) do
    if not callback(player, ID, item.desc, item.pos) then
      minetest.sound_play("magiccompass_teleport_deny", {
        to_player = p_name
      })
      return
    end
  end

  -- teletrasporto
  player:set_pos(minetest.string_to_pos(item.pos))
  minetest.sound_play("magiccompass_teleport", {
    to_player = p_name
  })

  -- eventuali callback dopo l'uso
  for _, callback in ipairs(magic_compass.registered_on_after_use) do
    callback(player, ID, item.desc, item.pos)
  end

  -- eventuale cooldown
  if item.cooldown then

    if not on_cooldown[p_name] then
      on_cooldown[p_name] = {}
    end

    -- lo imposto
    on_cooldown[p_name][ID] = item.cooldown

    -- e lo avvio
    run_cooldown(p_name, ID)
  end
end)



function run_cooldown(p_name, ID)
  on_cooldown[p_name][ID] = on_cooldown[p_name][ID] -1
  if on_cooldown[p_name][ID] == 0 then
    on_cooldown[p_name][ID] = nil
  else
    minetest.after(1, function()
      run_cooldown(p_name, ID)
    end)
  end
end
