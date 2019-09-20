local ie = minetest.request_insecure_environment()
local http = minetest.request_http_api()
local configurationMessage = "Mod server_shutdown requires insecure environment. Add secure.trusted_mods = server_shutdown to minetest.conf"
assert(ie, configurationMessage)
assert(http, configurationMessage)

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
      ie.os.execute("/home/filhit/dsoulstest-server/shutdown.sh")
    else
      minetest.log("warning", "[server_shutdown] Noone is playing. Shutting down in " .. loopsLeft * loopInterval .. " seconds.")
      loopsLeft = loopsLeft - 1
    end
  else
    loopsLeft = loopsWithNooneBeforeShutdown
  end
end

local function callback()
end

local function reportPlayersCount()
  http.fetch({
    url = "https://minetest.westeurope.cloudapp.azure.com:30001",
    post_data = minetest.write_json({
      players = getPlayersCount()
    })
  }, callback)
end

local function loop()
  countAndShutdown()
  reportPlayersCount()
  minetest.after(loopInterval, loop)
end

minetest.log("action", "[server_shutdown] loaded!")
loop()
