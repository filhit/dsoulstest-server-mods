local ie = minetest.request_insecure_environment()
assert(ie, "Mod server_shutdown requires insecure environment. Add secure.trusted_mods = server_shutdown to minetest.conf")

local loopInterval = 60
local loopsWithNooneBeforeShutdown = 15

local loopsLeft = loopsWithNooneBeforeShutdown

local function getPlayersCount()
  local result = 0;
  for _, player in ipairs(minetest.get_connected_players()) do
    result = result + 1
  end
  return result
end

local function countAndShutdown()
  if getPlayersCount() == 0 then
    if loopsLeft == 0 then
      minetest.log("action", "[server_shutdown] Noone is playing. Shutting down.")
      ie.os.execute("/sbin/shutdown now")
    else
      minetest.log("warning", "[server_shutdown] Noone is playing. Shutting down in " .. loopsLeft * loopInterval .. " seconds.")
      loopsLeft = loopsLeft - 1
    end
  else
    loopsLeft = loopsWithNooneBeforeShutdown
  end
end

local function loop()
  countAndShutdown()
  minetest.after(loopInterval, loop)
end

minetest.after(loopInterval, loop)
minetest.log("action", "[server_shutdown] loaded!")
