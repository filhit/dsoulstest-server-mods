local modpath = minetest.get_modpath("server_sounds")
local soundsdir = modpath.."/sounds"
local soundfiles = minetest.get_dir_list(soundsdir)
minetest.log("minetest_sounds loaded")
for _,file in pairs(soundfiles) do
  minetest.log(file)
end

