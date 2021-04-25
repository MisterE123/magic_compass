magic_compass.items = {}

local S = minetest.get_translator("magic_compass")

local locations_dir = minetest.get_modpath("magic_compass") .. "/locations"
local locations_content = minetest.get_dir_list(locations_dir)

for _, file_name in pairs(locations_content) do

  -- estrapolo le info dal file
  local file = io.open(locations_dir .. "/" .. file_name, "r")
  local data = string.split(file:read("*all"), "\n")

  file:close()

  local i_ID = string.match(file_name, "(%d+)_")
  local i_desc = data[1]
  local i_texture = data[2]
  local i_pos = data[3]
  local i_cooldown
  local i_privileges
  local i_hide

  if data[4] and tonumber(data[4]) ~= -1 then
    i_cooldown = tonumber(data[4])
  end

  if data[5] then
    i_privileges = data[5]
  end

  if data[6] and data[6] == "HIDE" then
    i_hide = true
  end

  -- creo l'oggetto
  minetest.register_tool("magic_compass:" .. i_ID, {

    description = S(i_desc),
    inventory_image = i_texture,
    groups = {not_in_creative_inventory = 1, oddly_breakable_by_hand = 2}

  })

  magic_compass.items[tonumber(i_ID)] = {desc = i_desc, pos = i_pos, cooldown = i_cooldown, privs = i_privileges, hide = i_hide}

end
