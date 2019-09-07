local msg_command = "msg"
telegram.register_command(msg_command, function(msg)     
  minetest.chat_send_all(string.sub(msg.text, string.len("\\" .. msg_command .. " ")))
end)

local sound_command = "sound"
telegram.register_command(sound_command, function(msg)
  local sound_name = string.sub(msg.text, string.len("\\" .. sound_command .. " ") + 1)
  minetest.log("action", "[telegram_commands] playing sound \"" .. sound_name .. "\"")
  minetest.sound_play(sound_name, { gain = 1.0 })
end)

minetest.log("action", "[telegram_commands] loaded!")
