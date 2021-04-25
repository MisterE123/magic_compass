magic_compass = {}
local version = "1.4.0-dev"

dofile(minetest.get_modpath("magic_compass") .. "/SETTINGS.lua")

dofile(minetest.get_modpath("magic_compass") .. "/callbacks.lua")
dofile(minetest.get_modpath("magic_compass") .. "/deserializer.lua")
dofile(minetest.get_modpath("magic_compass") .. "/formspec.lua")
dofile(minetest.get_modpath("magic_compass") .. "/items.lua")
dofile(minetest.get_modpath("magic_compass") .. "/player_manager.lua")

minetest.log("action", "[MAGIC COMPASS] Mod initialised, running version " .. version)
