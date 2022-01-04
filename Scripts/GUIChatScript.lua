
wait(0.1)
			--Oaktin
local Admins = {47934004, 5722435, 30483959, 21386552, -1}
			--melkglas, iiQueenBee, DominusTheDragon, Hunger0Games, PureTrading, IDontHaveAUse, DaVantor, Usering.	
local Mods = {23368983, 59943819, 22605019, 23256227, 19305571, 47373630, 21695994, 31323231}

local ConsoleReminders = 
{"Enjoying the game?  Leave the game a like!  It helps a lot.",
"Don't know how to play the game? Read the tutorial in the main menu.",
"Want to make your player look awesome? Buy some chests! Chests will give you some cool trails and blade skins!",
'Want to upgrade your sword? Go to the "Blade Buffs" section in the shop!',
"Note: You get Gems by leveling up and you get exp by playing in matches!"}
local TablePos = 1
--[[local TweenModule = require(283196118)

local function HandToss(Target)
	repeat wait() until Target.Character:IsDescendantOf(workspace)
	local Character				= Target.Character
	local Torso					= Character:FindFirstChild("Torso")
	local Humanoid				= Character:FindFirstChild("Humanoid")
	if not Torso or not Humanoid then return end
	
	local Voice					= Instance.new("Sound", Torso)
	Voice.Name					= "HandTossed!"
	Voice.SoundId				= "rbxassetid://331329816"
	Voice.Volume				= 1.5
	local SlapSound				= Instance.new("Sound", Torso)
	SlapSound.Name				= "Slap"
	SlapSound.SoundId			= "rbxassetid://146163534"
	
	-- Create pizza
	local Pizza					= Instance.new("Part", Character)
	Pizza.Name					= "Pizza"
	Pizza.Transparency			= 1
	Pizza.CanCollide			= false
	Pizza.FormFactor			= Enum.FormFactor.Custom
	Pizza.Size					= Vector3.new(4, 0.4, 3)
	local PizzaMesh				= Instance.new("SpecialMesh", Pizza)
	PizzaMesh.MeshId			= "http://www.roblox.com/asset/?id=22589477"
	PizzaMesh.TextureId			= "http://www.roblox.com/asset/?id=22589467"
	PizzaMesh.Scale				= Vector3.new(3, 3, 3)
	
	-- Welding
	local Weld					= Instance.new("Motor6D", Pizza)
	Weld.Part0					= Torso
	Weld.Part1					= Pizza
	Weld.C0						= CFrame.new(2.8, 0.5, -2.5) * CFrame.Angles(math.pi/2, 0, math.pi/2)
	
	TweenModule:TweenNumber(Pizza, "Transparency", 0, 1, "outSine")
	Voice:Play()
	wait(3)
	
	-- GET HAND TOSSED >:D
	TweenModule:TweenCFrame(Weld, "C0", CFrame.new(-0.24, 1.1, -0.7) * CFrame.Angles(math.pi/2, 0, 0), 0.25, "inBack")
	SlapSound:Play()
	Humanoid:TakeDamage(100)
	
	-- Clean up
	Weld:Destroy()
	Pizza.Anchored				= true
	TweenModule:TweenNumber(Pizza, "Transparency", 1, 1, "outSine")
	Pizza:Destroy()
end]]

function CreateChatLabel(Player, Rank, PlayersMessage)
	print("create chat label function begin")
	local NameLabel=Instance.new("TextLabel")
	NameLabel.BackgroundColor3 = Color3.new(1,1,1)
	NameLabel.BackgroundTransparency = 1
	NameLabel.BorderColor3 = Color3.new(0,0,0)
	NameLabel.BorderSizePixel = 0
	NameLabel.Name = "ChatLabel"
	NameLabel.Position = UDim2.new(0,0,0,0)
	NameLabel.Size = UDim2.new(0, 500, 0, 20)
	NameLabel.Font = Enum.Font.ArialBold
	NameLabel.FontSize = Enum.FontSize.Size18
	
	if Rank == "Other" then
		if Player:IsInGroup(1200769) then
			NameLabel.Text = "[ROBLOX Admin] "..Player.Name..": "
		end
	elseif Rank == "Normal" then
		NameLabel.Text = Player.Name..": "
	elseif Rank == "Console" then
		NameLabel.Text = "[Console]: "
	else
		NameLabel.Text = "["..Rank.."] "..Player.Name..": "
	end
	NameLabel.TextColor3 = script.ChatColors:FindFirstChild(Rank).Value
	NameLabel.TextStrokeColor3 = Color3.new(0,0,0)
	NameLabel.TextStrokeTransparency = 0.5
	NameLabel.TextTransparency = 0
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.TextYAlignment = Enum.TextYAlignment.Top
	
	local Message = Instance.new("TextLabel")
	Message.BackgroundColor3 = Color3.new(1,1,1)
	Message.BackgroundTransparency = 1
	Message.BorderColor3 = Color3.new(0,0,0)
	Message.BorderSizePixel = 0
	Message.Name = "Message"
	Message.Position = UDim2.new(0,250,0,0)
	Message.Size = UDim2.new(0, 450, 0, 20)
	Message.Font = Enum.Font.ArialBold
	Message.FontSize = Enum.FontSize.Size18
	Message.Text = PlayersMessage
	Message.ClipsDescendants = true
	if Rank == "Console" then
		Message.TextColor3 = script.ChatColors.Console.ConsoleText.Value
	else
		Message.TextColor3 = script.ChatColors.Normal.Value
	end
	Message.TextStrokeColor3 = Color3.new(0,0,0)
	Message.TextStrokeTransparency = 0.5
	Message.TextTransparency = 0
	Message.TextXAlignment = Enum.TextXAlignment.Left
	Message.TextYAlignment = Enum.TextYAlignment.Top
	local MessageValue = Instance.new("IntValue")
	MessageValue.Name = "MessageValue"
	MessageValue.Value = 1
	MessageValue.Parent = NameLabel
	Message.Parent = NameLabel
	for I,C in pairs(game.ReplicatedStorage.GUIChatFolder:GetChildren()) do
		C.MessageValue.Value = C.MessageValue.Value + 1
		if C.MessageValue.Value > 9 then
			C:Destroy()
		end
	end
	NameLabel.Parent = game.ReplicatedStorage.GUIChatFolder
	print("create chat label function end")
end

function FindPlayer(Name) 
	local NameValue = " CommandFailed"
	for _,C in pairs(game.Players:GetPlayers()) do 
		if C.Name:lower():find(Name:lower()) then 
			NameValue = C.Name
		end 
	end 
	
	return NameValue
end

script.ConsoleReminderScript.SendReminder.Changed:connect(function()
	CreateChatLabel("", "Console", ConsoleReminders[TablePos])
	if TablePos == #ConsoleReminders then
		TablePos = 1
	else
		TablePos = TablePos + 1
	end
end)

script.Parent.SaveLoadScript.GameShutdown.Changed:connect(function()
	if script.Parent.SaveLoadScript.GameShutdown.Value == true then
		for i = 1, 10 do
		CreateChatLabel("", "Console", "The game is shutting down because of an update! Rejoin when it does!")
		wait(0.1)
		end
	end
end)

game.Players.PlayerAdded:connect(function(Player) 
	print("added")
	Player.Chatted:connect(function(PlayersMessage)
		print("chatted")
		local IsMod = false
		local IsAdmin = false
		
		Player.PlayersValues.OtherValues.IsModOrAdmin.Value = false
		
		for Index, Child in pairs(Mods) do
			if Player.userId == Child then
			IsMod = true
			Player.PlayersValues.OtherValues.IsModOrAdmin.Value = true
			end
		end
		for Index, Child in pairs(Admins) do
			if Player.userId == Child then
			IsAdmin = true
			Player.PlayersValues.OtherValues.IsModOrAdmin.Value = true
			end
		end
		
		
		
		if (IsAdmin == true or IsMod == true) and PlayersMessage:sub(1,1) == "/" then --Commands
			if PlayersMessage:sub(1,9) == "/commands" then
				CreateChatLabel(Player, "Console", "Mod Commands:  /kick, /mute, /unmute, /kill, /console, /resetgame, /fixlag.")
			elseif PlayersMessage:sub(1,6) == "/kick " then
				local PlayerName = FindPlayer(PlayersMessage:sub(7))
				if PlayerName ~= " CommandFailed" then
					game.Players:FindFirstChild(PlayerName):Kick()
					CreateChatLabel(Player, "Console", Player.Name.." has kicked "..PlayerName..".")
				else
					CreateChatLabel(Player, "Console", Player.Name.." has tried to kick a player.  The command has failed.")
				end
			elseif PlayersMessage:sub(1,6) == "/mute " then
				local PlayerName = FindPlayer(PlayersMessage:sub(7))
				if PlayerName ~= " CommandFailed" then
					local MuteValue = Instance.new("StringValue")
					MuteValue.Name = PlayerName
					MuteValue.Parent = script.MutedPlayers
					CreateChatLabel(Player, "Console", Player.Name.." has muted "..PlayerName.." from the chat.")
				else
					CreateChatLabel(Player, "Console", Player.Name.." has tried to mute a player.  The command has failed")
				end
			elseif PlayersMessage:sub(1,8) == "/unmute " then
				local PlayerName = FindPlayer(PlayersMessage:sub(9))
				if PlayerName ~= " CommandFailed" then
					script.MutedPlayers:FindFirstChild(PlayerName):Destroy()
					CreateChatLabel(Player, "Console", Player.Name.." has unmuted "..PlayerName.." from the chat.")
				else
					CreateChatLabel(Player, "Console", Player.Name.." has tried to unmute a player.  The command has failed.")
				end
			elseif PlayersMessage:sub(1,7) == "/fixlag" then
				game.ServerScriptService.SaveLoadScript.Disabled = true
				game.ServerScriptService.SaveLoadScript.Disabled = false
				CreateChatLabel(Player, "Console", Player.Name.." has reset the save/load script and fixed the lag.")
			elseif PlayersMessage:sub(1,10) == "/teleport " then
				local EndSub = 11
				for i=1,150 do
					if PlayersMessage:sub(EndSub) == nil then
						EndSub = 11
						break
					elseif PlayersMessage:sub(EndSub, EndSub) == ' ' then
						break
					else
						EndSub = EndSub + 1
					end
					wait()
				end 
				
				local PlayerBeingTeleported = FindPlayer(PlayersMessage:sub(11, EndSub - 1))
				local PlayerTeleportedTo =FindPlayer(PlayersMessage:sub(EndSub + 1))
				
				if PlayerBeingTeleported == " CommandFailed" or PlayerTeleportedTo == " CommandFailed" then
					CreateChatLabel(Player, "Console", Player.Name.." has has tried to teleport a player.  The command has failed")

				elseif game.Workspace:FindFirstChild(PlayerBeingTeleported) ~= nil and game.Workspace:FindFirstChild(PlayerBeingTeleported):FindFirstChild("Torso") and game.Workspace:FindFirstChild(PlayerTeleportedTo) ~= nil and game.Workspace:FindFirstChild(PlayerTeleportedTo):FindFirstChild("Torso") then	
					game.Workspace:FindFirstChild(PlayerBeingTeleported).Torso.CFrame = game.Workspace:FindFirstChild(PlayerTeleportedTo).Torso.CFrame
					CreateChatLabel(Player, "Console", Player.Name.." has teleported "..PlayerBeingTeleported.." to "..PlayerTeleportedTo..".")
				end
				elseif PlayersMessage:sub(1,6) == "/kill " then
				local PlayerName = FindPlayer(PlayersMessage:sub(7))
				if PlayerName ~= " CommandFailed" then
					game.Workspace:FindFirstChild(PlayerName).Humanoid.Health = 0
					CreateChatLabel(Player, "Console", Player.Name.." has killed "..PlayerName..".")
				else
					CreateChatLabel(Player, "Console", Player.Name.." has has tried to kill a player.  The command has failed")
				end
			elseif PlayersMessage:sub(1,9) == "/console " then
				CreateChatLabel(Player, "Console", PlayersMessage:sub(10))
			elseif PlayersMessage:sub(1,5) == "/mod " and Player.userId == 47934004 then
				local PlayerName = FindPlayer(PlayersMessage:sub(6))
				if PlayerName ~= " CommandFailed" then
					CreateChatLabel(Player, "Console", Player.Name.." has given "..PlayerName.." a MOD rank.")
					table.insert(Mods, #Mods + 1, game.Players:FindFirstChild(PlayerName).userId)
				else
					CreateChatLabel(Player, "Console", Player.Name.." has tried to mute a player.  The command has failed.")
				end
			elseif PlayersMessage:sub(1,7) == "/unmod " and Player.userId == 47934004 then
				local PlayerName = FindPlayer(PlayersMessage:sub(8))
				local IsAMod = false
				local TablePos = 0
				if PlayerName ~= " CommandFailed" then
					for index,child in pairs(Mods) do
						if child == game.Players:FindFirstChild(PlayerName).userId then
							IsAMod = true
							TablePos = index
						end
					end
				end
				if IsAMod == true then
					CreateChatLabel(Player, "Console", Player.Name.." has removed "..PlayerName.." from being a mod.")
					table.remove(Mods, TablePos)
				else
					CreateChatLabel(Player, "Console", Player.Name.." has tried to unmod a player.  The command failed")
				end
			elseif PlayersMessage:sub(1,8) == "/reward " and IsAdmin == true then
				local EndSub = 9
				for i=1,100 do
					if PlayersMessage:sub(EndSub) == nil then
						EndSub = 9
						break
					elseif PlayersMessage:sub(EndSub, EndSub) == ' ' then
						break
					else
						EndSub = EndSub + 1
					end
					wait()
				end
				
				local PlayerName = FindPlayer(PlayersMessage:sub(EndSub + 1))
				
				if PlayerName ~= " CommandFailed" and game.Players:FindFirstChild(PlayerName).PlayersValues.NumberOwned:FindFirstChild(PlayersMessage:sub(9, EndSub - 1)) ~= nil then	
					if string.sub(PlayersMessage:sub(9, EndSub - 1), 1, 3) == "PET" then
						game.Players:FindFirstChild(PlayerName).PlayersValues.NumberOwned:FindFirstChild(PlayersMessage:sub(9, EndSub - 1)).Value = 1
					else
						game.Players:FindFirstChild(PlayerName).PlayersValues.NumberOwned:FindFirstChild(PlayersMessage:sub(9, EndSub - 1)).Value = game.Players:FindFirstChild(PlayerName).PlayersValues.NumberOwned:FindFirstChild(PlayersMessage:sub(9, EndSub - 1)).Value + 1
					end
					CreateChatLabel(Player, "Console", Player.Name.." has awarded "..PlayersMessage:sub(9, EndSub - 1).." to "..PlayerName..".")
				else
					CreateChatLabel(Player, "Console", "An error has happened awarding "..PlayersMessage:sub(9, EndSub - 1).." to a player.")
				end
			elseif 	PlayersMessage:sub(1,10) == "/handtoss " and IsAdmin == true then
				local PlayerName = FindPlayer(PlayersMessage:sub(11))
				if game.Players:FindFirstChild(PlayerName) ~= nil then
					CreateChatLabel(Player, "Console", Player.Name.." has hand tossed "..PlayerName..".")
					--HandToss(game.Players:FindFirstChild(PlayerName))
				else
					CreateChatLabel(Player, "Console", Player.Name.." has tried to hand toss a player, the command has failed.")
				end
			elseif PlayersMessage:sub(1,10) == "/resetgame" then
				for i = 1,3 do
					CreateChatLabel(Player, "Console", "Reseting the game, this could take a moment...")
					wait(0.5)
				end
				
				game.ServerScriptService.GameScript.Disabled = true
				game.ServerScriptService.GameScript.Disabled = false
				wait(0.2)
				for I, C in pairs(game.Players:GetChildren()) do
					if game.Workspace:FindFirstChild(C.Name) ~= nil then
						game.Workspace:FindFirstChild(C.Name).Humanoid.Health = 0
					end
				end
			else
			end

		elseif PlayersMessage:sub(1,3) == "/e " or script.MutedPlayers:FindFirstChild(Player.Name) ~= nil then 
		else--Normal Chat
			local Rank = ""
			if Player:IsInGroup(1200769) then
				Rank = "Other"
			elseif IsAdmin == true then
				Rank = "Admin"
			elseif IsMod == true then
				Rank = "Mod"
			elseif game:GetService("MarketplaceService"):PlayerOwnsAsset(Player,300517532) then
				Rank = "Gold"
			else
				Rank = "Normal"
			end
		
			local function filterTextObject(unfilteredMessage, fromPlayerId) --Filters Chat
				local filteredMessage = ""
				local textService = game:GetService("TextService")
				local success, errorMessage = pcall(function()
			    	filteredMessage = textService:FilterStringAsync(unfilteredMessage, fromPlayerId)
				end)
				if success then
					print(filteredMessage)
					return filteredMessage
				else
					return "error sending message"
				end
			end
			local filterText = filterTextObject(PlayersMessage, Player.userId)
			
			CreateChatLabel(Player, Rank, filterText.Text)
			
		end
	end)
end)

game.Players.PlayerAdded:connect(function(Player)
		CreateChatLabel(Player, "Console", Player.Name.." has joined the server.")
end)

game.Players.PlayerRemoving:connect(function(Player)
	CreateChatLabel(Player, "Console", Player.Name.." has left the server.")
end)

