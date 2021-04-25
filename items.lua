local S = minetest.get_translator("magic_compass")



minetest.register_tool("magic_compass:compass", {

  description = S("Magic Compass"),
  inventory_image = "magiccompass_compass.png",
  groups = {oddly_breakable_by_hand = "2"},
  on_place = function() end,
  on_drop = function() end,

  on_use = function(itemstack, user, pointed_thing)
    minetest.show_formspec(user:get_player_name(), "magic_compass:GUI", magic_compass.get_formspec(user:get_player_name()))
  end

})
