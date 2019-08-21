local modpath = minetest.get_modpath("server_sounds")
local soundsdir = modpath.."/sounds"
local soundfiles = minetest.get_dir_list(soundsdir)
local logmessage = "Found sound files:"
for _,file in pairs(soundfiles) do
  logmessage = logmessage .. " " .. file
end

minetest.log("action", "[server_sounds] " .. logmessage)
minetest.log("action", "[server_sounds] loaded!")

