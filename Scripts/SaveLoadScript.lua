local RequestWaitTime = 1.5 --Time between each fetch
local FetchLimit = 5 --How many times it will fetch the value if there is an error
local DataStore = game:GetService("DataStoreService")
local BetaUserIds = {64334966, 23368983, 30483959, 21695994, 66652534, 58824243, 69680560, 47373630, 62210483, 68728334, 29023148, 59943819, 4294718, 69598581, 17203484, 29834352,
32219262, 840236, 31323231, 22093650, 40909064, 1805913, 984511, 46798282, 30065257, 39564444, 16161864, 42214859, 49460618, 9130305, 83994518, 28866667, 43613559,
50256931, 20940586, 87356964, 22615297, 59278655, 1961954, 72725368, 8291118, 1852246, 47934004, -1, -2, -3, -4}  
local BannedUsers = {22625417, 8533188}
local NumberOfValues = 0

for I,C in pairs(game.ReplicatedStorage.PlayersValues:GetChildren()) do
	if C.ClassName ~= "Folder" then
		NumberOfValues = NumberOfValues + 1
	end
end

for I,C in pairs(game.ReplicatedStorage.PlayersValues.TwitterCodes:GetChildren()) do
	NumberOfValues = NumberOfValues + 1
end

for I,C in pairs(game.ReplicatedStorage.PlayersValues.NumberOwned:GetChildren()) do
	NumberOfValues = NumberOfValues + 1
end

for I,C in pairs(game.ReplicatedStorage.PlayersValues.Animations:GetChildren()) do
	NumberOfValues = NumberOfValues + 1
end

local PercentageForEachValue = 100 / NumberOfValues


function LoadStats(Player, PlayersKey)
	for i = 1,1 do --Loading Stats
		print("Loading Stats for "..Player.Name)
		for Index, Child in pairs(Player.PlayersValues:GetChildren()) do --Loading miscellaneous stuff (Level stuff, gems, etc.)
			if Child:IsA("IntValue") or Child:IsA("StringValue") then
				for i= 1,FetchLimit do
					local Success, Message = pcall(function()
						Child.Value = DataStore:GetDataStore(Child.Name):GetAsync(PlayersKey)
						Player.PlayersValues.OtherValues.PercentageLoaded.Value = Player.PlayersValues.OtherValues.PercentageLoaded.Value + PercentageForEachValue
					end)
					
					if not Success then
						if i == FetchLimit then --printing error
							print(Child.Name.." did not load properly on "..Player.Name.."'s account. Message: "..Message)
						else
							print("An error has occurred loading: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
						end
						wait(RequestWaitTime)
					else
						print("Finished Loading "..Child.Name.." for "..Player.Name)
						break
					end
				end
			elseif Child.Name == "SwordSwingTime" then
				for i= 1,FetchLimit do
					local Success, Message = pcall(function()
						Child.Value = (DataStore:GetDataStore(Child.Name):GetAsync(PlayersKey) / 10)
						Player.PlayersValues.OtherValues.PercentageLoaded.Value = Player.PlayersValues.OtherValues.PercentageLoaded.Value + PercentageForEachValue
					end)
					
					if not Success then
						if i == FetchLimit then --printing error
							print(Child.Name.." did not load properly on "..Player.Name.."'s account. Message: "..Message)
						else
							print("An error has occurred loading: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
						end
						wait(RequestWaitTime)
					else
						print("Finished Loading "..Child.Name.." for "..Player.Name)
						break
					end
				end
			end
		end
	
		for Index, Child in pairs(Player.PlayersValues.TwitterCodes:GetChildren()) do --Loading Twitter Codes
			for i= 1,FetchLimit do
				local Success, Message = pcall(function()
					local NumberOwnedValue = DataStore:GetDataStore(Child.Name):GetAsync(PlayersKey)
					if NumberOwnedValue ~= nil and (NumberOwnedValue == 1 or NumberOwnedValue == true) then
						Child.Value = NumberOwnedValue
						Player.PlayersValues.OtherValues.PercentageLoaded.Value = Player.PlayersValues.OtherValues.PercentageLoaded.Value + PercentageForEachValue
					end
				end)
				
				if not Success then
					if i == FetchLimit then --printing error
						print(Child.Name.." did not load properly on "..Player.Name.."'s account. Message: "..Message)
					else
						print("An error has occurred loading: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
					end
					wait(RequestWaitTime)
				else
					print("Finished Loading "..Child.Name.." for "..Player.Name)
					break
				end
			end
		end
	
		for Index, Child in pairs(Player.PlayersValues.NumberOwned:GetChildren()) do --Loading Number Owned
			for i= 1,FetchLimit do
				local Success, Message = pcall(function()
					local NumberOwnedValue = DataStore:GetDataStore(Child.Name):GetAsync(PlayersKey)
					if NumberOwnedValue ~= nil and (NumberOwnedValue == true or NumberOwnedValue == 1) then
						Child.Value = 1
						Player.PlayersValues.OtherValues.PercentageLoaded.Value = Player.PlayersValues.OtherValues.PercentageLoaded.Value + PercentageForEachValue
					elseif NumberOwnedValue == nil or NumberOwnedValue == false or NumberOwnedValue == 0 then
						Child.Value = 0 
						Player.PlayersValues.OtherValues.PercentageLoaded.Value = Player.PlayersValues.OtherValues.PercentageLoaded.Value + PercentageForEachValue
					else
						Child.Value = NumberOwnedValue
						Player.PlayersValues.OtherValues.PercentageLoaded.Value = Player.PlayersValues.OtherValues.PercentageLoaded.Value + PercentageForEachValue
					end	
				end)
				
				if not Success then
					if i == FetchLimit then --printing error
						print(Child.Name.." did not load properly on "..Player.Name.."'s account. Message: "..Message)
					else
						print("An error has occurred loading: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
					
					end
					wait(RequestWaitTime)
				else
					print("Finished Loading "..Child.Name.." for "..Player.Name)
					break
				end
			end
		end

		for Index, Child in pairs(Player.PlayersValues.Animations:GetChildren()) do --Loading Animations
			for i= 1,FetchLimit do
				local Success, Message = pcall(function()
					if Child.Name == "ANIMClapping" then
						Child.Value = 1
					else
						Child.Value = DataStore:GetDataStore(Child.Name):GetAsync(PlayersKey)
					end
					Player.PlayersValues.OtherValues.PercentageLoaded.Value = Player.PlayersValues.OtherValues.PercentageLoaded.Value + PercentageForEachValue
				end)
				
				if not Success then
					if i == FetchLimit then --printing error
						print(Child.Name.." did not load properly on "..Player.Name.."'s account. Message: "..Message)
					else
						print("An error has occurred loading: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
					
					end
					wait(RequestWaitTime)
				else
					print("Finished Loading "..Child.Name.." for "..Player.Name)
					break
				end
			end
		end

		print("Finished loading stats for "..Player.Name)
	end
end

function SaveStats(Player, PlayersKey, PlayersValues)
	if PlayersValues.OtherValues.HasLoadedStats.Value == true or (PlayersValues.OtherValues.HasPlayedBefore.Value == false and PlayersValues.OtherValues.HasPlayedBefore.ValueLoaded.Value == true) then --Saving Stats
		print("Saving stats for "..Player.Name)
		for Index, Child in pairs(PlayersValues:GetChildren()) do --Saving miscellaneous stuff (Level stuff, gems, etc.)
			if Child:IsA("IntValue") or Child:IsA("StringValue") then
				for i= 1,FetchLimit do
					local Success, Message = pcall(function()
						DataStore:GetDataStore(Child.Name):SetAsync(PlayersKey, Child.Value)
					end)
					
					if not Success then
						if i == FetchLimit then --printing error
							print(Child.Name.." did not save properly on "..Player.Name.."'s account. Message: "..Message)
						else
							print("An error has occurred saving: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
						end
						wait(RequestWaitTime)
					else
						break
					end
				end
			elseif Child.Name == "SwordSwingTime" then
				for i= 1,FetchLimit do
					local Success, Message = pcall(function()
					DataStore:GetDataStore(Child.Name):SetAsync(PlayersKey, Child.Value * 10)
					end)
					
					if not Success then
						if i == FetchLimit then --printing error
							print(Child.Name.." did not load properly on "..Player.Name.."'s account.")
						else
							print("An error has occurred loading: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
						end
						wait(RequestWaitTime)
					else
						break
					end
				end
			end
		end
		
		for Index, Child in pairs(PlayersValues.TwitterCodes:GetChildren()) do --Saving Twitter Codes
			for i= 1,FetchLimit do
				local Success, Message = pcall(function()
				   DataStore:GetDataStore(Child.Name):SetAsync(PlayersKey, Child.Value)
				end)
				
				if not Success then
					if i == FetchLimit then --printing error
						print(Child.Name.." did not save properly on "..Player.Name.."'s account. Message: "..Message)
					else
						print("An error has occurred saving: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
					end
					wait(RequestWaitTime)
				else
					break
				end
			end
		end
	
		for Index, Child in pairs(PlayersValues.NumberOwned:GetChildren()) do --Saving Number Owned
			for i= 1,FetchLimit do
				local Success, Message = pcall(function()
				   DataStore:GetDataStore(Child.Name):SetAsync(PlayersKey, Child.Value)
				end)
				
				if not Success then
					if i == FetchLimit then --printing error
						print(Child.Name.." did not save properly on "..Player.Name.."'s account. Message: "..Message)
					else
						print("An error has occurred saving: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
					end
					wait(RequestWaitTime)
				else
					break
				end
			end
		end

		for Index, Child in pairs(PlayersValues.Animations:GetChildren()) do --Saving Animations
			for i= 1,FetchLimit do
				local Success, Message = pcall(function()
				   DataStore:GetDataStore(Child.Name):SetAsync(PlayersKey, Child.Value)
				end)
				
				if not Success then
					if i == FetchLimit then --printing error
						print(Child.Name.." did not save properly on "..Player.Name.."'s account. Message: "..Message)
					else
						print("An error has occurred saving: "..Child.Name.." on "..Player.Name.."'s account.  Trying again")
					end
					wait(RequestWaitTime)
				else
					break
				end
			end
		end

		for i= 1,FetchLimit do --Saving HasPlayedBefore
			local Success, Message = pcall(function()
				DataStore:GetDataStore("HasPlayedBefore"):SetAsync(PlayersKey, true)
				PlayersValues.OtherValues.HasPlayedBefore.Value = true
			end)
					
			if not Success then
				if i == FetchLimit then
					print("HasPlayedBefore did not save properly on "..Player.Name.."'s account. Message: "..Message)
				else
					print("An error has occurred saving: HasPlayedBefore on "..Player.Name.."'s account.  Trying again.  The Message is;"..Message)
				end
				wait(RequestWaitTime)
			else
				break
			end
		end
		print("Finished saving stats for "..Player.Name)
	end
end

game.Players.PlayerAdded:connect(function(Player)
	game.ReplicatedStorage.PlayersValues:Clone().Parent = Player
	for i=1,10 do if game.Players:FindFirstChild(Player.Name):FindFirstChild("PlayersValues") ~= nil then break end wait(1) end
	local PlayersKey = "User_"..Player.userId
	
	for i= 1,1 do --Loading HasPlayedBefore value.
		if Player.userId >= 1 then
			for i= 1,FetchLimit do 
			local Success, Message = pcall(function()
				Player.PlayersValues.OtherValues.HasPlayedBefore.Value = DataStore:GetDataStore("HasPlayedBefore"):GetAsync(PlayersKey)
				Player.PlayersValues.OtherValues.HasPlayedBefore.ValueLoaded.Value = true
			end)
					
			if not Success then
				if i == FetchLimit then
					print("HasPlayedBefore did not load properly on "..Player.Name.."'s account.")
				else
					print("An error has occurred loading: HasPlayedBefore on "..Player.Name.."'s account.  Trying again.")
				end
				wait(1)
			else
				print("Finished loading HasPlayedBefore for "..Player.Name)
				break
			end
			end
		end
	end

	for I,C in pairs(BannedUsers) do
		if C == Player.userId then
		Player.PlayersValues.OtherValues.IsBanned.Value = true
		end
	end

	if Player.userId >= 1 and Player.PlayersValues.OtherValues.HasPlayedBefore.Value == true and Player.PlayersValues.OtherValues.IsBanned.Value == false then --Loading/Saving stats
		LoadStats(Player, PlayersKey)
		Player.PlayersValues.OtherValues.PercentageLoaded.Value = 100
		wait(2.5)
		Player.PlayersValues.OtherValues.HasLoadedStats.Value = true
		
	elseif Player.userId >= 1 and Player.PlayersValues.OtherValues.HasPlayedBefore.Value == false and Player.PlayersValues.OtherValues.IsBanned.Value == false then
		print(Player.Name.." has joined for the first time.")
		game:GetService("BadgeService"):AwardBadge(Player.userId, 298654448)
		Player.PlayersValues.OtherValues.PercentageLoaded.Value = 100
		wait(2.5)
		Player.PlayersValues.OtherValues.HasLoadedStats.Value = true
		
	elseif Player.userId < 1 and Player.PlayersValues.OtherValues.IsBanned.Value == false then
		print(Player.Name.." is a guest and will not save or load stats.")
		Player.PlayersValues.OtherValues.PercentageLoaded.Value = 100
		wait(2.5)
		Player.PlayersValues.OtherValues.HasLoadedStats.Value = true
	end	
	wait(2.5)
end)

game.Players.PlayerRemoving:connect(function(Player)
	for i =1,1 do --checking if player is in battle.
		local BattleStorage = game.ReplicatedStorage.BattleStorage
		if BattleStorage.PlayerOne.PlayersName.Value == Player.Name then
		BattleStorage.PlayerOne.Health.Value = 0
		BattleStorage.PlayerOne.Dead.Value = true
		end
		if BattleStorage.PlayerTwo.PlayersName.Value == Player.Name then
		BattleStorage.PlayerTwo.Health.Value = 0
		BattleStorage.PlayerTwo.Dead.Value = true
		end
		if script.Parent.GameScript.PlayersPlaying:FindFirstChild(Player.Name) ~= nil then
			script.Parent.GameScript.PlayersPlaying:FindFirstChild(Player.Name):Destroy()
		end
		if BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:FindFirstChild(Player.Name) ~= nil then
			if BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:FindFirstChild(Player.Name):FindFirstChild("IsJuggernaut") then
			BattleStorage.UniqueRounds.Juggernaut.EndGame.PlayersWin.Value = true
			BattleStorage.UniqueRounds.Juggernaut.EndGame.Value = true
			end
		BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:FindFirstChild(Player.Name):Destroy()
		end
		if BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:FindFirstChild(Player.Name) ~= nil then
			BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:FindFirstChild(Player.Name):Destroy()
		end
		if BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:FindFirstChild(Player.Name) ~= nil then
			BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:FindFirstChild(Player.Name):Destroy()
		end
		if BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:FindFirstChild(Player.Name) ~= nil then
			BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:FindFirstChild(Player.Name):Destroy()
		end
		if BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:FindFirstChild(Player.Name) ~= nil then
			BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:FindFirstChild(Player.Name):Destroy()
			if BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value == Player.Name then
				BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.IsDead.Value = true
			end
		end
		if BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:FindFirstChild(Player.Name) ~= nil then
		BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:FindFirstChild(Player.Name):Destroy()
		end
		if BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:FindFirstChild(Player.Name) ~= nil and BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:FindFirstChild(Player.Name) ~= nil and BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:FindFirstChild(Player.Name) ~= nil then
			if BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:FindFirstChild(Player.Name) ~= nil then
				BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:FindFirstChild(Player.Name):Destroy()
			end
			if BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:FindFirstChild(Player.Name) ~= nil then
				BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:FindFirstChild(Player.Name):Destroy()
			end
			if BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:FindFirstChild(Player.Name) ~= nil then
				BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:FindFirstChild(Player.Name):Destroy()
			end
		end
	end

	SaveStats(Player, "User_"..Player.userId, Player.PlayersValues:Clone())
	wait(8)
end)

script.GameShutdown.Changed:connect(function()
	if script.GameShutdown.Value == true then
		for i=1,5 do print("Game shutting down...") wait() end
		
		for Index, Child in pairs(game.Players:GetChildren()) do
			if Child.userId >= 1 then
			SaveStats(Child, ("User_"..Child.userId), Child.PlayersValues)
			end
		end
		
		for i=1,5 do print("Game shutting down...") wait() end
		wait(3)
		script.GameShutdown.Value = false
	end
end)

game.ReplicatedStorage.Events.SaveStatsTimer.OnServerEvent:connect(function(Player)
	if script.GameShutdown.Value == false and Player.userId >= 1 then
	SaveStats(Player, "User_"..Player.userId, Player.PlayersValues)
	end
end)

