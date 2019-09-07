local msg_command = "msg"
telegram.register_command(msg_command, function(msg)     
  minetest.chat_send_all(string.sub(msg.text, string.len("\\" .. msg_command .. " ")))
end)

minetest.log("action", "[telegram_commands] loaded!")
