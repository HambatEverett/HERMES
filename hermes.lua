settings.define("hermesx", {
    description = "the x of this comp",
    default = 0,
    type = "string",
})
settings.define("hermesz", {
    description = "the z of this comp",
    default = 0,
    type = "string",
})

local pd = peripheral.find("player_detector")
local cb = peripheral.find("chat_box")
local event, username, message, uuid, isHidden, messageUtf8
local tokens = {}
local whitelist = {} -- put whitlisted users here e.g. {["Notch"]=true,["Jeb_"]=true}
local hx = tonumber(settings.get("hermesx"))
local hz = tonumber(settings.get("hermesz"))

if hx == 0 and hz == 0 then
  print("what is the COMPUTERS X VALUE (looking at block x value)")
  settings.set("hermesx",io.read())
  print("what is the COMPUTERS Z VALUE (looking at block z value)")
  settings.set("hermesz",io.read())
  settings.save()
end

local message = {
  {text="-=-=-=- HERMES -=-=-=-\n",color="red"},
  {text="^hermes locate <username> - Tells the sender the location of the username provided.\n", color="yellow"},
  {text="^hermes alerts <dis/ena> - Disables or enables chatbox alerts for players near Hermes.\n", color="yellow"},
  {text="^hermes echo - Debug command that just sends you what you sent\n", color="yellow"},
  {text="-=-=-=-=-=-=-=-=-=-=-",color="red"}
}

local json = textutils.serializeJSON(message)

local function main()
while true do
  event, username, message, uuid, isHidden, messageUtf8 = os.pullEvent("chat")
  for token in string.gmatch(message, "%S+") do
    table.insert(tokens, token)
    print(token)
  end

  if tokens[1] then
  if tokens[1]:lower() == "^hermes" then
    print("someone is trying to use hermes")
    if whitelist[username] then
      print("user is whitelisetd")
      if tokens[2]:lower() == "info" then
        print("sendig infp to "..username)
        cb.sendFormattedMessageToPlayer(json,username,":")
      elseif tokens[2]:lower() == "locate" then
        if tokens[3] then
          if pd.getPlayer(tostring(tokens[3])) then
            print("ok")
            local player = pd.getPlayer(tostring(tokens[3]))
            local distx = math.abs(hx - player.x)
            local distz = math.abs(hz - player.z)
            local distance = math.sqrt((distx ^ 2) + (distz ^ 2))
            print("ok2")
            cb.sendMessageToPlayer(tostring(tokens[3]).." is at "..pd.getPlayer(tostring(tokens[3])).x..", "..pd.getPlayer(tostring(tokens[3])).y..", "..pd.getPlayer(tostring(tokens[3])).z.." ("..math.floor(distance).." blocks away)",username,"HERMES")
            print("ok3")
          else
            cb.sendMessageToPlayer(tostring(tokens[3]).." is offline/doesnt exist. :x:",username,"HERMES")
          end
        else
          cb.sendMessageToPlayer("No player inputted. :x:",username,"HERMES")
        end
      end
    end
  end
  end
  tokens = {}
end
end

main()
