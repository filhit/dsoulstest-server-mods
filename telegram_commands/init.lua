local ie = minetest.request_insecure_environment()
local configurationMessage = "Mod telegram_commands requires insecure environment. Add secure.trusted_mods = telegram_commands to minetest.conf"
assert(ie, configurationMessage)
local shutdown_threshold = 10
local chat_id = minetest.settings:get("telegram.chatid")

local function get_command_args(command, msg)
  return string.sub(msg.text, string.len("\\" .. command .. " ") + 1)
end

local msg_command = "msg"
telegram.register_command(msg_command, function(msg)     
  minetest.chat_send_all(get_command_args(msg_command, msg))
end)

local sound_command = "sound"
telegram.register_command(sound_command, function(msg)
  local sound_name = get_command_args(sound_command, msg)
  minetest.log("action", "[telegram_commands] playing sound \"" .. sound_name .. "\"")
  minetest.sound_play(sound_name, { gain = 1.0 })
end)

local shutdown_command = "shutdown"
telegram.register_command(shutdown_command, function(msg)
  local seconds_ago = ie.os.time() - msg.date
  if seconds_ago < shutdown_threshold then
    minetest.log("action", "[telegram_commands] received command to shut down " .. seconds_ago .. " seconds ago. Shutting down.")
    local message = get_command_args(shutdown_command, msg)
    if message then
      minetest.request_shutdown(message)
    end
    ie.os.execute("/usr/bin/sudo /sbin/shutdown now")
  else
    minetest.log("action", "[telegram_commands] received command to shut down " .. seconds_ago .. " seconds ago. The message is stale. Ignoring.")
  end
end)

minetest.register_chatcommand("where", {
  privs = {
      shout = true,
  },
  func = function(name, param)
    local player = minetest.get_player_by_name(name)
    if player then
      local pos = player:get_pos()
      local message = "<" .. name .. ">: " .. pos.x .. ", " .. pos.y .. ", " .. pos.z
      if param then
        message = message .. " " .. param
      end
      if chat_id then
        telegram.send_message(chat_id, message)
      end
      return true, message
    end
    return false
  end
})

minetest.log("action", "[telegram_commands] loaded!")
