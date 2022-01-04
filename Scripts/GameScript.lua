
--Varibles

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalValues = ReplicatedStorage.GlobalValues
local NumberOfBattleSongs = 6
local BattleWinReward = 20
local TurnimateWinReward = 200

local ExpRoundOneBattle = 40
local ExpRoundTwoBattle = 25
local ExpRoundThreeBattle = 10
local ExpTournamentWin = 25
local LastWinner = ""

script.Parent.ResetableFunctions.Disabled = true
script.Parent.ResetableFunctions.Disabled = false
script.PlayersPlaying:ClearAllChildren()
if game.ReplicatedStorage:FindFirstChild("BattleStorage") ~= nil then
	game.ReplicatedStorage.BattleStorage:Destroy()
end
if game.Workspace:FindFirstChild("Map") ~= nil then
	game.Workspace.Map:Destroy()
end
script.BattleStorage:Clone().Parent = game.ReplicatedStorage
wait(15)

function TeleportPlayerToArena(Player, Side, GiveBlade, NotifyErrors, GiveArrow, ArrowColor3) -------------------------------------------------------
	local RandomSidePart = nil 
	
	if Side ~= nil and Side == "Side1" then --Picking what side.
		RandomSidePart = game.Workspace.PlayLobby.GameTeleportParts.SideOne:GetChildren()[math.random(1,#game.Workspace.PlayLobby.GameTeleportParts.SideOne:GetChildren())]
	elseif Side ~= nil and Side == "Side2" then
		RandomSidePart = game.Workspace.PlayLobby.GameTeleportParts.SideTwo:GetChildren()[math.random(1,#game.Workspace.PlayLobby.GameTeleportParts.SideTwo:GetChildren())]
	elseif  Side ~= nil and Side == "Side3" then
		RandomSidePart = game.Workspace.PlayLobby.GameTeleportParts.SideThree:GetChildren()[math.random(1,#game.Workspace.PlayLobby.GameTeleportParts.SideThree:GetChildren())]
	end
	
	
	game.Workspace:FindFirstChild(Player.Name).Torso.CFrame = RandomSidePart.CFrame
	game.Workspace:FindFirstChild(Player.Name).Humanoid.Sit = false

	if GiveBlade ~= nil and GiveBlade == true then
			game.ServerStorage.Swords.DefultBlade:Clone().Parent = game.Players:FindFirstChild(Player.Name).Backpack
	end
	if GiveArrow ~= nil and GiveArrow == true then
		local NewArrowGui = game.ReplicatedStorage.ArrowGui:Clone()
		NewArrowGui.Arrow.ImageColor3 = ArrowColor3
		NewArrowGui.Parent = game.Workspace:FindFirstChild(Player.Name).Head
	end
	if (game.Workspace:FindFirstChild(Player.Name) == nil or game.Players:FindFirstChild(Player.Name) == nil) and NotifyErrors ~= nil and NotifyErrors == true then
		GlobalValues.GlobalLabel.Value = "An error has occured when teleporting "..Player.Name.."."
		wait(2.5)
	end
end

function TeleportPlayerToLobby(Player, RemoveBlade, RemoveArrow, GiveBells, BellAmount, GiveExp, ExpAmount)
	if game.Workspace:FindFirstChild(Player.Name) ~= nil then
		local TeleportPart = game.Workspace.PlayLobby.TeleportParts:GetChildren()[math.random(1,#game.Workspace.PlayLobby.TeleportParts:GetChildren())]
		game.Workspace:FindFirstChild(Player.Name).Torso.CFrame = TeleportPart.CFrame
		game.Workspace:FindFirstChild(Player.Name).Humanoid.MaxHealth = 100
		game.Workspace:FindFirstChild(Player.Name).Humanoid.Health = 100
	end
	if RemoveBlade ~= nil and RemoveBlade == true then
		for i=1,10 do --Removing Blades
			if game.Players:FindFirstChild(Player.Name)~= nil and game.Players:FindFirstChild(Player.Name).Backpack:FindFirstChild("DefultBlade") ~= nil then
				game.Players:FindFirstChild(Player.Name).Backpack:FindFirstChild("DefultBlade"):Destroy()
			elseif game.Workspace:FindFirstChild(Player.Name) ~= nil and game.Workspace:FindFirstChild(Player.Name):FindFirstChild("DefultBlade") ~= nil then
				game.Workspace:FindFirstChild(Player.Name):FindFirstChild("DefultBlade").AnimationScript.RemoveSword.Value = true
			elseif game.Players:FindFirstChild(Player.Name)~= nil and game.Players:FindFirstChild(Player.Name).Backpack:FindFirstChild("DefultBlade") == nil and game.Workspace:FindFirstChild(Player.Name) ~= nil and game.Workspace:FindFirstChild(Player.Name):FindFirstChild("DefultBlade") == nil then
				break
			end
		wait(0.1)
		end
	end
	if RemoveArrow ~= nil and RemoveArrow == true and game.Workspace:FindFirstChild(Player.Name) ~= nil and game.Workspace:FindFirstChild(Player.Name).Head:FindFirstChild("ArrowGui") ~= nil then
		game.Workspace:FindFirstChild(Player.Name).Head.ArrowGui:Destroy()
	end
	if GiveBells ~= nil and GiveBells == true then
		local BellValue = Instance.new("IntValue")
		BellValue.Name = Player.Name.."BellsToAdd"
		BellValue.Value = BellAmount
		BellValue.Parent = game.ReplicatedStorage.BellsToAddFolder
	end
	if GiveExp ~= nil and GiveExp == true then
		local ExpValue = Instance.new("IntValue")
		ExpValue.Name = Player.Name.."ExpToAdd"
		ExpValue.Value = ExpAmount
		ExpValue.Parent = game.ReplicatedStorage.ExpToAddFolder
	end
end

function PlaySongs(WhoToPlayFor, WhatSong)
	if WhoToPlayFor == "All Players" then
		game.ReplicatedStorage.Events.PlaySoundEvent:FireAllClients(WhatSong)
	else
		game.ReplicatedStorage.Events.PlaySoundEvent:FireClient(WhoToPlayFor, WhatSong)
	end
end

function StopSongs(WhoToStopFor, WhatSong, Transition)
	if WhoToStopFor == "All Players" then
		game.ReplicatedStorage.Events.StopSoundEvent:FireAllClients(WhatSong, Transition)
	else
		game.ReplicatedStorage.Events.StopSoundEvent:FireClient(WhoToStopFor, WhatSong, Transition)
	end
end

while true do
--[[Setting up a normal game.]]
	for i=1,1 do
	GlobalValues.GlobalLabel.Value = "The game is about to start!  Use this time to buy things in the shop or hangout!"
	for i = 1,15 do
		wait(1)
		GlobalValues.TimerTime.Value = 15 - i
	end
	if game.Workspace:FindFirstChild("Map") ~= nil then
		game.Workspace.Map:Destroy()
	end
	if #game.ServerStorage.Maps:GetChildren() == 0 then
		for I,C in pairs(game.ServerStorage.UsedMaps:GetChildren()) do
			C.Parent = game.ServerStorage.Maps
		end
	end
	local NewRandomMap = game.ServerStorage.Maps:GetChildren()[math.random(1,#game.ServerStorage.Maps:GetChildren())]
	local MapClone = NewRandomMap:Clone()
	NewRandomMap.Parent = game.ServerStorage.UsedMaps
	MapClone.Name = "Map"
	MapClone.Parent = game.Workspace
	
	GlobalValues.GlobalLabel.Value = "The game is starting, make sure that you put your settings on 'Play' to be in the battle!"
	wait(4)
	GlobalValues.GlobalLabel.Value = "The server is loading a map this should take no longer than two mintues."
	repeat wait() until #game.Workspace.Map:GetChildren() == #NewRandomMap:GetChildren()

	for i=1,1 do --Making a list of all of the players that will be battling before the game accually starts.
		for Index,Child in pairs(game.Players:GetChildren()) do
			if Child:FindFirstChild("PlayersValues") ~= nil and Child.PlayersValues.OtherValues.IsPlaying.Value == true and Child.PlayersValues.OtherValues.HasLoadedStats.Value == true then
			local PlayersValue = Instance.new("BoolValue")
			PlayersValue.Name = Child.Name
			PlayersValue.Parent = script.PlayersPlaying
			end
		wait()
		end
	end
	GlobalValues.GlobalLabel.Value = "Setting up the game..."
	end
	
--Start of a normal round
	if #script.PlayersPlaying:GetChildren() >= 4 then
		local Rounds = 1 --Must be outside the loop.
		while true do
				local OddPlayer = nil
				
				while true do --The loop where the ONE ROUND is exicuted.
					PlayerOne = nil
					PlayerTwo = nil
					NumberOfPlayersFought = 0
					
					if #script.PlayersPlaying:GetChildren() % 2 == 1 and OddPlayer == nil then --If there is an odd man out this will run.Selecting the random O dd Man Out and moving him to the next round.
						OddPlayer = script.PlayersPlaying:GetChildren()[math.random(1,#script.PlayersPlaying:GetChildren())]
						GlobalValues.GlobalLabel.Value = "Since we have an odd number of players we can't match up "..OddPlayer.Name.." to a fight so he will move on to the next round."
						OddPlayer.Value = true
						wait(4)
					end
					-- Checking if everyone has fought that round.  If not this will just go on like normal.
					for Index,Child in pairs(script.PlayersPlaying:GetChildren()) do
						if Child.Value == true then
						NumberOfPlayersFought = NumberOfPlayersFought + 1
						end
					end
						
					if NumberOfPlayersFought == #script.PlayersPlaying:GetChildren() then
						NumberOfPlayersFought = 0
						wait(0.5)
						break
					elseif #script.PlayersPlaying:GetChildren() - NumberOfPlayersFought == 1 and OddPlayer ~= nil then -- if a player leaves it will match up with the odd player.
						OddPlayer.Value = false
						GlobalValues.GlobalLabel.Value = OddPlayer.Name.." has found a player to fight!  They will fight soon."
						OddPlayer = nil
						NumberOfPlayersFought = NumberOfPlayersFought - 1
						wait(5)
					else
						NumberOfPlayersFought = 0
					end
					
					for i=1,1 do --Selecting Two Players To Fight
						print("Finding players to battle..")
						while true do
							wait()
							if #script.PlayersPlaying:GetChildren() == 0 or #script.PlayersPlaying:GetChildren() == 1 or NumberOfPlayersFought - #script.PlayersPlaying:GetChildren() == 1 or NumberOfPlayersFought - #script.PlayersPlaying:GetChildren() == 1 then
								break
							end	
							
							local RandomPlayer = script.PlayersPlaying:GetChildren()[math.random(1,#script.PlayersPlaying:GetChildren())]
							
							if RandomPlayer.Value == false and PlayerOne == nil then
							PlayerOne = RandomPlayer
							script.PlayersPlaying:FindFirstChild(RandomPlayer.Name).Value = true --Setting the value to true so game knows they fought
							elseif RandomPlayer.Value == false and PlayerTwo == nil then
							PlayerTwo = RandomPlayer
							script.PlayersPlaying:FindFirstChild(PlayerTwo.Name).Value = true --Setting the value to true so game knows they fought
							break
							end
						end
					end
					
					if #script.PlayersPlaying:GetChildren() == 0 or #script.PlayersPlaying:GetChildren() == 1 or NumberOfPlayersFought - #script.PlayersPlaying:GetChildren() == 1 or NumberOfPlayersFought - #script.PlayersPlaying:GetChildren() == 1 then
						break
					end	
					
					for i=1,1 do --Teleport players
						GlobalValues.GlobalLabel.Value = "This match: "..PlayerOne.Name.." V.S. "..PlayerTwo.Name.."!"
						wait(3.5)
						
						local Success, Message = pcall(TeleportPlayerToArena, PlayerOne, "Side1", true, true)
						if not Success then
							GlobalValues.GlobalLabel.Value = "An error has occured when teleporting "..PlayerOne.Name.."."
							print("Failed to teleport player one.  Message: "..Message)
							if script.PlayersPlaying:FindFirstChild(PlayerOne.Name) then
								script.PlayersPlaying:FindFirstChild(PlayerOne.Name):Destroy()
							end
							wait(2.5)
						else
							game.ReplicatedStorage.BattleStorage.PlayerOne.PlayersName.Value = PlayerOne.Name
						end

						local Success, Message = pcall(TeleportPlayerToArena, PlayerTwo, "Side2", true, true)
						if not Success then
							GlobalValues.GlobalLabel.Value = "An error has occured when teleporting "..PlayerTwo.Name.."."
							print("Failed to teleport player one.  Message: "..Message)
							if script.PlayersPlaying:FindFirstChild(PlayerTwo.Name) then
								script.PlayersPlaying:FindFirstChild(PlayerTwo.Name):Destroy()
							end
							wait(2.5)
						else
							game.ReplicatedStorage.BattleStorage.PlayerTwo.PlayersName.Value = PlayerTwo.Name
						end
					end
					
					
					for i=1,1 do --Battle.
						local RandomSong = math.random(1, NumberOfBattleSongs)
						local BattleStorage = game:GetService("ReplicatedStorage").BattleStorage
						GlobalValues.TimerTime.Value = 45

						local Success, Message = pcall(PlaySongs, game.Players:FindFirstChild(PlayerOne.Name), "GAME_BattleSong"..RandomSong)
						if not Success then
							print("Failed to play music.  Message: "..Message)
						end
						
						local Success, Message = pcall(PlaySongs, game.Players:FindFirstChild(PlayerTwo.Name), "GAME_BattleSong"..RandomSong)
						if not Success then
							print("Failed to play music.  Message: "..Message)
						end
						
						
						for i=1,45 do --Timer loop when the battle is taking place.
							if i <= 5 then
								GlobalValues.GlobalLabel.Value = "You have 45 seconds!  Good luck!"
							else
								GlobalValues.GlobalLabel.Value = "A match is in progress ("..PlayerOne.Name.." V.S. "..PlayerTwo.Name..")..."
							end
							wait(1)
							GlobalValues.TimerTime.Value = 45 - i
							if (BattleStorage.PlayerOne.Health.Value <= 0 or BattleStorage.PlayerOne.Dead.Value == true) and (BattleStorage.PlayerTwo.Health.Value <= 0 or BattleStorage.PlayerTwo.Dead.Value == true) then
							--Both Players die
								local ExpLabelAmount = 0
								print("Both Players Died.")
								for i = 1,1 do
									local OutValueOne = Instance.new("StringValue")
									OutValueOne.Name = "Out"
									OutValueOne.Parent = script.PlayersPlaying:FindFirstChild(PlayerOne.Name)
									
									local OutValueTwo = Instance.new("StringValue")
									OutValueTwo.Name = "Out"
									OutValueTwo.Parent = script.PlayersPlaying:FindFirstChild(PlayerTwo.Name)
								end
								if Rounds == 1 then
									ExpLabelAmount = ExpRoundOneBattle
								elseif Rounds == 2 then
									ExpLabelAmount = ExpRoundTwoBattle
								elseif Rounds == 3 then
									ExpLabelAmount = ExpRoundThreeBattle
								end
								if ExpLabelAmount == 0 then
									GlobalValues.GlobalLabel.Value = "Both players have died and will not move onto the next round."
								else
									GlobalValues.GlobalLabel.Value = "Both players have died and will not move onto the next round.  Both players will receive "..ExpLabelAmount.." experience."
								end
								break
							
							elseif (BattleStorage.PlayerOne.Health.Value <= 0 or BattleStorage.PlayerOne.Dead.Value == true) or game.Players:FindFirstChild(PlayerOne.Name) == nil then
							--PlayerTwo wins
								local ExpLabelAmount = 0
								print(PlayerTwo.Name.." wins.")
								local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(PlayerTwo.Name), "GAME_BattleSong"..RandomSong, "HightenFadeOut")
								if not Success then
									print("Failed to stop music.  Message: "..Message)
								end
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(PlayerTwo.Name), true, false, true, BattleWinReward)
								if not Success then
									print("Failed to teleport player one.  Message: "..Message)
								end
								if game.Players:FindFirstChild(PlayerOne.Name) ~= nil then
									local OutValue = Instance.new("StringValue")
									OutValue.Name = "Out"
									OutValue.Parent = script.PlayersPlaying:FindFirstChild(PlayerOne.Name)
								end
								if Rounds == 1 then
									ExpLabelAmount = ExpRoundOneBattle
								elseif Rounds == 2 then
									ExpLabelAmount = ExpRoundTwoBattle
								elseif Rounds == 3 then
									ExpLabelAmount = ExpRoundThreeBattle
								end
								if ExpLabelAmount == 0 then
									GlobalValues.GlobalLabel.Value = PlayerTwo.Name.." has won that match and will move onto the next round."
								else
									GlobalValues.GlobalLabel.Value = PlayerTwo.Name.." has won that match and will move onto the next round.  Both players will receive "..ExpLabelAmount.." experience."
								end
								break
								
							elseif (BattleStorage.PlayerTwo.Health.Value <= 0 or BattleStorage.PlayerTwo.Dead.Value == true) or game.Players:FindFirstChild(PlayerTwo.Name) == nil then
							--PlayerOne wins
								local ExpLabelAmount = 0
								print(PlayerOne.Name.." wins.")
								local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(PlayerOne.Name), "GAME_BattleSong"..RandomSong, "HightenFadeOut")
								if not Success then
									print("Failed to stop music.  Message: "..Message)
								end
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(PlayerOne.Name), true, false, true, BattleWinReward)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								
								if game.Players:FindFirstChild(PlayerTwo.Name) ~= nil then
									local OutValue = Instance.new("StringValue")
									OutValue.Name = "Out"
									OutValue.Parent = script.PlayersPlaying:FindFirstChild(PlayerTwo.Name)
								end
								if Rounds == 1 then
									ExpLabelAmount = ExpRoundOneBattle
								elseif Rounds == 2 then
									ExpLabelAmount = ExpRoundTwoBattle
								elseif Rounds == 3 then
									ExpLabelAmount = ExpRoundThreeBattle
								end
								if ExpLabelAmount == 0 then
									GlobalValues.GlobalLabel.Value = PlayerOne.Name.." has won that match and will move onto the next round."
								else
									GlobalValues.GlobalLabel.Value = PlayerOne.Name.." has won that match and will move onto the next round.  Both players will receive "..ExpLabelAmount.." experience."
								end
								break
								
							elseif i >= 45 then
							--Timer runs out
								local ExpLabelAmount = 0
								print("The Timer Has Ran Out.")
								
								local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(PlayerTwo.Name), "GAME_BattleSong"..RandomSong, "DeepenFadeOut")
								if not Success then
									print("Failed to stop music.  Message: "..Message)
								end
								local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(PlayerOne.Name), "GAME_BattleSong"..RandomSong, "DeepenFadeOut")
								if not Success then
									print("Failed to stop music.  Message: "..Message)
								end
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(PlayerOne.Name), true)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(PlayerTwo.Name), true)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								
								for i=1,1 do --Putting the out value in the player
									local OutValue1 = Instance.new("StringValue")
									OutValue1.Name = "Out"
									OutValue1.Parent = script.PlayersPlaying:FindFirstChild(PlayerTwo.Name)
									
									local OutValue = Instance.new("StringValue")
									OutValue.Name = "Out"
									OutValue.Parent = script.PlayersPlaying:FindFirstChild(PlayerOne.Name)
								end
								if Rounds == 1 then
									ExpLabelAmount = ExpRoundOneBattle
								elseif Rounds == 2 then
									ExpLabelAmount = ExpRoundTwoBattle
								elseif Rounds == 3 then
									ExpLabelAmount = ExpRoundThreeBattle
								end
								if ExpLabelAmount == 0 then
									GlobalValues.GlobalLabel.Value = "The timer has run out and both players will not move onto the next round."
								else
									GlobalValues.GlobalLabel.Value = "The timer has run out and both players will not move onto the next round.  Both players will receive "..ExpLabelAmount.." experience."
								end
								break
								
							end
						end


						if Rounds == 1 then --Adding the exp
							local ExpToAddOne = Instance.new("IntValue")	
							ExpToAddOne.Name = PlayerOne.Name.."ExpToAdd"
							ExpToAddOne.Value = ExpRoundOneBattle
							ExpToAddOne.Parent = game.ReplicatedStorage.ExpToAddFolder
							
							local ExpToAddTwo = Instance.new("IntValue")	
							ExpToAddTwo.Name = PlayerTwo.Name.."ExpToAdd"
							ExpToAddTwo.Value = ExpRoundOneBattle
							ExpToAddTwo.Parent = game.ReplicatedStorage.ExpToAddFolder
						elseif Rounds == 2 then
							local ExpToAddOne = Instance.new("IntValue")	
							ExpToAddOne.Name = PlayerOne.Name.."ExpToAdd"
							ExpToAddOne.Value = ExpRoundTwoBattle
							ExpToAddOne.Parent = game.ReplicatedStorage.ExpToAddFolder
							
							local ExpToAddTwo = Instance.new("IntValue")	
							ExpToAddTwo.Name = PlayerTwo.Name.."ExpToAdd"
							ExpToAddTwo.Value = ExpRoundTwoBattle
							ExpToAddTwo.Parent = game.ReplicatedStorage.ExpToAddFolder
						elseif Rounds == 3 then
							local ExpToAddOne = Instance.new("IntValue")	
							ExpToAddOne.Name = PlayerOne.Name.."ExpToAdd"
							ExpToAddOne.Value = ExpRoundThreeBattle
							ExpToAddOne.Parent = game.ReplicatedStorage.ExpToAddFolder
							
							local ExpToAddTwo = Instance.new("IntValue")	
							ExpToAddTwo.Name = PlayerTwo.Name.."ExpToAdd"
							ExpToAddTwo.Value = ExpRoundThreeBattle
							ExpToAddTwo.Parent = game.ReplicatedStorage.ExpToAddFolder
						end
						
						game.ReplicatedStorage.BattleStorage.PlayerOne.PlayersName.Value = ""
						game.ReplicatedStorage.BattleStorage.PlayerTwo.PlayersName.Value = ""
						game.ReplicatedStorage.BattleStorage.PlayerOne.Health.Value = 100
						game.ReplicatedStorage.BattleStorage.PlayerTwo.Health.Value = 100
						game.ReplicatedStorage.BattleStorage.PlayerOne.Dead.Value = false
						game.ReplicatedStorage.BattleStorage.PlayerTwo.Dead.Value = false
						GlobalValues.TimerTime.Value = 0
						wait(6.5)
					end
				end

				for i=1,1 do--Remove the players that have an "Out" Value in them when all of the players have fought.
					for Index, Child in pairs(script.PlayersPlaying:GetChildren()) do
						if Child:FindFirstChild("Out") ~= nil then
						Child:Destroy()
						else
						Child.Value = false
						end
					end
				end
				print("Round "..Rounds.." is over")
				
				if #script.PlayersPlaying:GetChildren() == 1 then --Announcing winner
					wait(2)--removing this will mess up the bells being awarded
					local Winner = script.PlayersPlaying:GetChildren()[1]
					
						if LastWinner == Winner.Name then --if player wins twice in a row it will not give that player more exp
							GlobalValues.GlobalLabel.Value =  Winner.Name.." has won the tournament and will receive 200 bells.  "..Winner.Name.." has won twice in a row and will not recieve extra experience"
						else
							GlobalValues.GlobalLabel.Value =  Winner.Name.." has won the tournament and will receive 200 bells and 25 experience"
							local ExpToAdd = Instance.new("IntValue")	
							ExpToAdd.Name = Winner.Name.."ExpToAdd"
							ExpToAdd.Value = ExpTournamentWin
							ExpToAdd.Parent = game.ReplicatedStorage.ExpToAddFolder
						end
					local BellsToAdd = Instance.new("IntValue")
					BellsToAdd.Name = Winner.Name.."BellsToAdd"
					BellsToAdd.Value = TurnimateWinReward
					BellsToAdd.Parent = game.ReplicatedStorage.BellsToAddFolder

					LastWinner = Winner.Name
					Winner:Destroy()
					game.Workspace.Map:Destroy()
					print("Winner is chosen.  The winner is: "..Winner.Name)
					wait(10)
					break
				elseif #script.PlayersPlaying:GetChildren() == 0 then
					GlobalValues.GlobalLabel.Value = "Everyone died and there is no winner to the tournament.  A new tournament is starting soon."
					LastWinner = ""
					game.Workspace.Map:Destroy()
					wait(10)
					break
				else
					GlobalValues.GlobalLabel.Value = "Round "..Rounds.." is over"
					Rounds = Rounds + 1
					wait(10)
				end
		end
	
	elseif #script.PlayersPlaying:GetChildren() < 4 then
		GlobalValues.GlobalLabel.Value = "Sadly this game needs to have at least 4 people to have their settings as 'Play' to start. Invite your friends!"
		script.PlayersPlaying:ClearAllChildren()
		game.Workspace.Map:Destroy()
		repeat wait()until #game.Players:GetChildren() >= 4
	end --]]

--Setting up a unique game.
	for i = 1,3 do
		local RandomSpecialRound = script.UniqueRounds:GetChildren()[math.random(1, #script.UniqueRounds:GetChildren())]
		if RandomSpecialRound.Name == "2v2v2" and #game.Players:GetChildren() < 6 then
			repeat
				RandomSpecialRound = script.UniqueRounds:GetChildren()[math.random(1, #script.UniqueRounds:GetChildren())]
				wait()
			until RandomSpecialRound ~= "2v2v2" or #game.Players:GetChildren() >= 6
		end
		for i=1,1 do 
		GlobalValues.GlobalLabel.Value = "The unique game is about to start!  Use this time to buy things in the shop or hangout!"
		for i = 1,15 do
			wait(1)
			GlobalValues.TimerTime.Value = 15 - i
		end
		if game.Workspace:FindFirstChild("Map") ~= nil then
			game.Workspace.Map:Destroy()
		end
		if #game.ServerStorage.Maps:GetChildren() == 0 then
			for I,C in pairs(game.ServerStorage.UsedMaps:GetChildren()) do
				C.Parent = game.ServerStorage.Maps
			end
		end
		local NewRandomMap = game.ServerStorage.Maps:GetChildren()[math.random(1,#game.ServerStorage.Maps:GetChildren())]
		local MapClone = NewRandomMap:Clone()
		NewRandomMap.Parent = game.ServerStorage.UsedMaps
		MapClone.Name = "Map"
		MapClone.Parent = game.Workspace
		
		
		GlobalValues.GlobalLabel.Value = "The game is starting, make sure that you put your settings on 'Play' to be in the battle!"
		wait(4)
		GlobalValues.GlobalLabel.Value = "The server is loading a map this should take no longer than two mintues."
		repeat wait() until #game.Workspace.Map:GetChildren() == #NewRandomMap:GetChildren()
		GlobalValues.GlobalLabel.Value = "This map is made by "..game.Workspace.Map.Values.CreatorName.Value
		end
	
	--Start of a unique round.
		for i=1,1 do
			if RandomSpecialRound.Name == "Juggernaut" then
					for Index,Child in pairs(game.Players:GetChildren()) do
						if Child.PlayersValues.OtherValues.IsPlaying.Value == true and Child.PlayersValues.OtherValues.HasLoadedStats.Value == true and  game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:FindFirstChild(Child.Name) == nil then
						local PlayersValue = Instance.new("BoolValue")
						PlayersValue.Name = Child.Name
						PlayersValue.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying
						end
					end
					if #game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren() < 4 then
						GlobalValues.GlobalLabel.Value = "We don't have enough players for juggernaut, invite your friends!"
						wait(10)
						repeat wait() until #game.Players:GetChildren() >= 4
						break
					end
					GlobalValues.GlobalLabel.Value = "This unique round is called Juggernaut, one player will be choosen and will be put in the map to kill all of the other players playing."
					wait(5)
					local RandomJuggernaut = game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren()[math.random(1,#game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren())]
					local JuggernautValue = Instance.new("BoolValue")
					JuggernautValue.Name = "IsJuggernaut"
					JuggernautValue.Value = false
					JuggernautValue.Parent = RandomJuggernaut
					GlobalValues.GlobalLabel.Value = RandomJuggernaut.Name.." is the Juggernaut.  For the Juggernaut to win he needs to kill all of the other players.  For the players to win they need kill the Juggernaut."
					wait(5)
					for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren()) do
						if game.Workspace:FindFirstChild(Child.Name) ~= nil and Child:FindFirstChild("IsJuggernaut") ~= nil then
							game.Workspace:FindFirstChild(Child.Name).Humanoid.MaxHealth = (#game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren() - 1) * 100
							game.Workspace:FindFirstChild(Child.Name).Humanoid.Health = game.Workspace:FindFirstChild(Child.Name).Humanoid.MaxHealth
							local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side1", true, false, true, Color3.new(1,1,1))
							if not Success then
								print("Failed to teleport juggernaut.  Message: "..Message)
								if Child:FindFirstChild("IsJuggernaut") ~= nil then
									game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.PlayersWin.Value = true
									game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.Value = true
								end
								Child:Destroy()
							end
							
						elseif game.Workspace:FindFirstChild(Child.Name) ~= nil and Child:FindFirstChild("IsJuggernaut") == nil then
							local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side2", true, false)
							if not Success then
								print("Failed to teleport player.  Message: "..Message)
							end
							game.Workspace:FindFirstChild(Child.Name).Humanoid.Health = 100
							
						elseif game.Workspace:FindFirstChild(Child.Name) == nil then
							if Child:FindFirstChild("IsJuggernaut") ~= nil then
							game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.PlayersWin.Value = true
							game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.Value = true
							end
							Child:Destroy()
						end
					wait()
					end
					local NumPlayersPlaying = #game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren()
					local RandomBattleSong = math.random(1,NumberOfBattleSongs)
					local Success, Message = pcall(PlaySongs, "All Players", "GAME_BattleSong"..RandomBattleSong)
					if not Success then
						print("Failed to play music.  Message: "..Message)
					end
					
					for i=1,(NumPlayersPlaying * 20) do --Timer loop when the battle is taking place.
						GlobalValues.GlobalLabel.Value = "Juggernaut is in progress...("..RandomJuggernaut.Name.." is the Juggernaut)"
						wait(1)
						GlobalValues.TimerTime.Value = (NumPlayersPlaying * 20) - i
						if game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.Value == true and game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.PlayersWin.Value == true then
							--Players win
							GlobalValues.GlobalLabel.Value = "The Juggernaut has lost!  All of the players that have survived will get 200 Bells!"
							for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren()) do
								if Child:FindFirstChild("IsJuggernaut") == nil then
									local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, false, true, 200)
									if not Success then
										print("Failed to teleport to lobby.  Message: "..Message)
									end
									local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(Child.Name), "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
									if not Success then
										print("Failed to stop music.  Message: "..Message)
									end
								else
									local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, true)
									if not Success then
										print("Failed to teleport to lobby.  Message: "..Message)
									end
									
									local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(Child.Name), "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
									if not Success then
										print("Failed to stop music.  Message: "..Message)
									end
								end
								Child:Destroy()
							end
							wait(6)
							break
						
						elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren() == 1 and game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren()[1]:FindFirstChild("IsJuggernaut") ~= nil then	
							--Juggernaut Wins 
							GlobalValues.GlobalLabel.Value = "The Juggernaut has won!  The Juggernaut will be given 750 bells and 200 experience!"
							for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren()) do
								if Child.Value == false and Child:FindFirstChild("IsJuggernaut") ~= nil then
									local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, true, true, 750, 200)
									if not Success then
										print("Failed to teleport to lobby.  Message: "..Message)
									end
									local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(Child.Name), "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
									if not Success then
										print("Failed to stop music.  Message: "..Message)
									end
								else
									local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true)
									if not Success then
										print("Failed to teleport to lobby.  Message: "..Message)
									end
									local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(Child.Name), "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
									if not Success then
										print("Failed to stop music.  Message: "..Message)
									end
								end		
								Child:Destroy()
								end
							wait(6)
							break
						elseif i == (NumPlayersPlaying * 20) then
							GlobalValues.GlobalLabel.Value = "The timer has run out!  No one wins."
							for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.PlayersPlaying:GetChildren()) do
								local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(Child.Name), "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
								if not Success then
									print("Failed to stop music.  Message: "..Message)
								end
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, true)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								Child:Destroy()
							end
							wait(6)
							break
						end 
					end
						
					GlobalValues.GlobalLabel.Value = "This unique round is over!"
					game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.Value = false
					game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.JuggernautWins.Value = false
					game.ReplicatedStorage.BattleStorage.UniqueRounds.Juggernaut.EndGame.PlayersWin.Value = false
					game.Workspace.Map:Destroy()
					wait(2.5)
			end
			if RandomSpecialRound.Name == "TwoTeamsMatch" then
					game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.AllPlayersPlaying:ClearAllChildren()
					for Index,Child in pairs(game.Players:GetChildren()) do
						if Child.PlayersValues.OtherValues.IsPlaying.Value == true and Child.PlayersValues.OtherValues.HasLoadedStats.Value == true then
						local PlayersValue = Instance.new("BoolValue")
						PlayersValue.Name = Child.Name
						PlayersValue.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.AllPlayersPlaying
						end
					end
					if #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.AllPlayersPlaying:GetChildren() < 4 then
						GlobalValues.GlobalLabel.Value = "We don't have enough players for this unique round, invite your friends!"
						wait(10)
						repeat wait() until #game.Players:GetChildren() >= 4
						break
					end
					GlobalValues.GlobalLabel.Value = "This unique round is called Two Big Teams, all the players will be split into two big teams and will fight until there is one team left."
					wait(6)
					GlobalValues.GlobalLabel.Value = "Making the teams... This should take no longer then a minute."
					
					for i = 1, #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.AllPlayersPlaying:GetChildren() do
						local RandomPlayer = game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.AllPlayersPlaying:GetChildren()[math.random(1, #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.AllPlayersPlaying:GetChildren())]
						if i % 2 == 1 and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:FindFirstChild(RandomPlayer.Name) == nil and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:FindFirstChild(RandomPlayer.Name) == nil then
							RandomPlayer.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne
						elseif i % 2 == 0  and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:FindFirstChild(RandomPlayer.Name) == nil and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:FindFirstChild(RandomPlayer.Name) == nil then
							RandomPlayer.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo
						else
							RandomPlayer:Destroy()
						end
					wait()
					end
					
					for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:GetChildren()) do
						if game.Workspace:FindFirstChild(Child.Name) ~= nil and game.Players:FindFirstChild(Child.Name) ~= nil then
							local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side1", true, false, true, Color3.new(200/255, 0, 0))
							if not Success then
								print("Failed to teleport player.  Message: "..Message)
								Child:Destroy()
							end
						else
							Child:Destroy()
						end
					end
					for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:GetChildren()) do
						if game.Workspace:FindFirstChild(Child.Name) ~= nil and game.Players:FindFirstChild(Child.Name) ~= nil then
							local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side2", true, false, true, Color3.new(0, 110/255, 1))
							if not Success then
								print("Failed to teleport player.  Message: "..Message)
								Child:Destroy()
							end
						else
							Child:Destroy()
						end
					end
					local RandomBattleSong = math.random(1,NumberOfBattleSongs)
					local Success, Message = pcall(PlaySongs, "All Players", "GAME_BattleSong"..RandomBattleSong)
					if not Success then
						print("Failed to play music.  Message: "..Message)
					end
					
					for i=1,150 do --Timer loop when the battle is taking place.
						GlobalValues.GlobalLabel.Value = "A two team match is in progress..."
						wait(1)
						GlobalValues.TimerTime.Value = 150 - i
						if i == 150 then --Checking if team won or lost or not.
							GlobalValues.GlobalLabel.Value = "The timer has run out and no one wins!"
							for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:GetChildren()) do
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, true)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								Child:Destroy()
							end
							for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:GetChildren()) do
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, true)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								Child:Destroy()
							end
							local Success, Message = pcall(StopSongs, "All Players", "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
							if not Success then
								print("Failed to stop music.  Message: "..Message)
							end
							break
							
						elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:GetChildren() == 0 then --Team Two Wins
							GlobalValues.GlobalLabel.Value = "Team blue wins! All of the players that have survived will receive 200 bells!"
							for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:GetChildren()) do
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, true, true, 200)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(Child.Name),  "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
								if not Success then
									print("Failed to stop music.  Message: "..Message)
								end
							end
							break
							
						elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:GetChildren() == 0 then --Team One Wins
							GlobalValues.GlobalLabel.Value = "Team red wins! All of the players that have survived will receive 200 bells!"
							for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:GetChildren()) do
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(Child.Name), true, true, true, 200)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
								local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(Child.Name),  "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
								if not Success then
									print("Failed to stop music.  Message: "..Message)
								end
							end
							break
							
						end	
					end
					wait(7)
					GlobalValues.GlobalLabel.Value = "This unique round is over!"
					game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.AllPlayersPlaying:ClearAllChildren()
					game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamOne:ClearAllChildren()
					game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoBigTeams.TeamTwo:ClearAllChildren()		
					game.Workspace.Map:Destroy()
					wait(2.5)
			end
			if RandomSpecialRound.Name == "FreeForAll" then
				for Index,Child in pairs(game.Players:GetChildren()) do
					if Child.PlayersValues.OtherValues.IsPlaying.Value == true and Child.PlayersValues.OtherValues.HasLoadedStats.Value == true and game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:FindFirstChild(Child.Name) == nil then
					local PlayersValue = Instance.new("BoolValue")
					PlayersValue.Name = Child.Name
					PlayersValue.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying
					end
				end
				if #game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren() < 4 then
					GlobalValues.GlobalLabel.Value = "We don't have enough players for a free for all round, invite your friends!"
					wait(10)
					repeat wait() until #game.Players:GetChildren() >= 4
					break
				end
				GlobalValues.GlobalLabel.Value = "This unique round is called free for all, everyone will be put inside of the arena and will fight until there is one person standing."
				wait(5)
				for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren()) do
					local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side"..(Index % 3) + 1, true, false, false)
					if not Success then
						print("Failed to teleport player.  Message: "..Message)
						Child:Destroy()
					end
				wait()
				end
				local NumPlayersPlaying = #game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren()
				local RandomBattleSong = math.random(1,NumberOfBattleSongs)
				local Success, Message = pcall(PlaySongs, "All Players", "GAME_BattleSong"..RandomBattleSong)
				if not Success then
					print("Failed to play music.  Message: "..Message)
				end


				for i = 1, 10 * NumPlayersPlaying do
					GlobalValues.GlobalLabel.Value = "A free for all round is in progress..."
					GlobalValues.TimerTime.Value = 10 * NumPlayersPlaying - i
					wait(1)	
					if i == 10 * NumPlayersPlaying then
						GlobalValues.GlobalLabel.Value = "The timer has run out and no one wins!"
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren()) do
							local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, false)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end
						end
						local Success, Message = pcall(StopSongs, "All Players",  "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
						if not Success then
							print("Failed to stop music.  Message: "..Message)
						end
						wait(4)
						break
					elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren() == 1 and game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren() ~= nil then
						local WinnerName = game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren()[1].Name
						GlobalValues.GlobalLabel.Value = WinnerName.." has won the free for all round and will be awarded 1000 bells and 250 experience."
						local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(WinnerName),  "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
						if not Success then
							print("Failed to stop music.  Message: "..Message)
						end
						
						local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(WinnerName), true, false, true, 1000, true, 250)
						if not Success then
							print("Failed to teleport to lobby.  Message: "..Message)
						end
						wait(4)
						break
					elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:GetChildren() == 0 then
						GlobalValues.GlobalLabel.Value = "Everyone has died and no one has won this unique round."
						wait(4)
						break
					end
				end
				GlobalValues.GlobalLabel.Value = "This unique round is over!"
				game.ReplicatedStorage.BattleStorage.UniqueRounds.FreeForAll.PlayersPlaying:ClearAllChildren()	
				game.Workspace.Map:Destroy()
				wait(2.5)
		end
			if RandomSpecialRound.Name == "KillTheCarrier" then
				for Index,Child in pairs(game.Players:GetChildren()) do
					if Child.PlayersValues.OtherValues.IsPlaying.Value == true and Child.PlayersValues.OtherValues.HasLoadedStats.Value == true and game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:FindFirstChild(Child.Name) == nil then
					local PlayersValue = Instance.new("BoolValue")
					PlayersValue.Name = Child.Name
					PlayersValue.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying
					end
				end
				if #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren() < 4 then
					GlobalValues.GlobalLabel.Value = "We don't have enough players for a kill the carrier round, invite your friends!"
					wait(10)
					repeat wait() until #game.Players:GetChildren() >= 4
					break
				end
				GlobalValues.GlobalLabel.Value = "There will be one person selected randomly, he will be named the carrier.  The longer he is alive the bigger the reward the carrier gets."
				wait(6.5)
				GlobalValues.GlobalLabel.Value = "If you are the carrier then try to stay alive for as long as possible!"
				wait(3.5)
				local RandomCarrier = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()[math.random(1,#game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren())]
				local RandomBattleSong = math.random(1,NumberOfBattleSongs)
				
				for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()) do
					local TelePlayer = false
					if Child.Name == RandomCarrier.Name then
						local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side1", false, false, true, Color3.new(1,1,1))
						if not Success then
							print("Failed to teleport player.  Message: "..Message)
							Child:Destroy()
						end
					else
						local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side2", true, false)
						if not Success then
							print("Failed to teleport player.  Message: "..Message)
							Child:Destroy()
						end
					end

				wait()
				end
				local NumPlayersPlaying = #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()
				local CurrentCarrier = RandomCarrier.Name
				wait(0.5)
				game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value = 0
				game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.IsDead.Value = false
				game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value = RandomCarrier.Name
				local Success, Message = pcall(PlaySongs, "All Players", "GAME_BattleSong"..RandomBattleSong)
				if not Success then
					print("Failed to play music.  Message: "..Message)
				end


				for i = 1,12 * NumPlayersPlaying do
					GlobalValues.TimerTime.Value = 12 * NumPlayersPlaying - i
					game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value + 1
					GlobalValues.GlobalLabel.Value = "Kill "..RandomCarrier.Name..".  He has been the carrier for "..game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value.." seconds!"
					wait(1)
					if i == 12 * NumPlayersPlaying then
						local BellValue = Instance.new("IntValue")
						BellValue.Name = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value.."BellsToAdd"
						BellValue.Value = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value * #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()
						BellValue.Parent = game.ReplicatedStorage.BellsToAddFolder
						GlobalValues.GlobalLabel.Value = "The timer has ran out and all of the remaining players will recieve 125 bells and the last carrier will get "..(game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value * #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren() * 3).." bells!"
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()) do
							if C.Name ~= game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value then
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true, true, 125)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
							else
								local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true)
								if not Success then
									print("Failed to teleport to lobby.  Message: "..Message)
								end
							end
						end
						local Success, Message = pcall(StopSongs, "All Players",  "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
						if not Success then
							print("Failed to stop music.  Message: "..Message)
						end
						wait(5)
						break
						
					elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren() == 1 then
						local BellValue = Instance.new("IntValue")
						BellValue.Name = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value.."BellsToAdd"
						BellValue.Value = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value * #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()
						BellValue.Parent = game.ReplicatedStorage.BellsToAddFolder
						GlobalValues.GlobalLabel.Value = "There is one player remaining and he will get 250 bells and the last carrier will get "..game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value * #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren().." bells."
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()) do
							if C.Name ~= game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value then
							local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true, true, 250)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end							
							local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(C.Name),  "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
							if not Success then
								print("Failed to stop music.  Message: "..Message)
							end
							else
								
							local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end	
							local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(C.Name),  "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
							if not Success then
								print("Failed to stop music.  Message: "..Message)
							end
							end
						end
						wait(5)
						break
						
					elseif game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.IsDead.Value == true then
						local BellValue = Instance.new("IntValue")
						BellValue.Name = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value.."BellsToAdd"
						BellValue.Value = (game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value * #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()) * 3
						BellValue.Parent = game.ReplicatedStorage.BellsToAddFolder
						GlobalValues.GlobalLabel.Value = "The carrier has died and has received "..((game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value * #game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()) * 3).." bells."
						wait(3.5)
						RandomCarrier = game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren()[math.random(1,#game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:GetChildren())]
						GlobalValues.GlobalLabel.Value = "The new carrier is "..RandomCarrier.Name.."."
						game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value = 0
						game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.IsDead.Value = false
						game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value = RandomCarrier.Name
						for i=1,10 do --Removing blade from carrier
							if game.Players:FindFirstChild(RandomCarrier.Name)~= nil and game.Players:FindFirstChild(RandomCarrier.Name).Backpack:FindFirstChild("DefultBlade") ~= nil then
								game.Players:FindFirstChild(RandomCarrier.Name).Backpack:FindFirstChild("DefultBlade"):Destroy()
							elseif game.Workspace:FindFirstChild(RandomCarrier.Name) ~= nil and game.Workspace:FindFirstChild(RandomCarrier.Name):FindFirstChild("DefultBlade") ~= nil then
								game.Workspace:FindFirstChild(RandomCarrier.Name):FindFirstChild("DefultBlade").AnimationScript.RemoveSword.Value = true
							elseif game.Players:FindFirstChild(RandomCarrier.Name)~= nil and game.Players:FindFirstChild(RandomCarrier.Name).Backpack:FindFirstChild("DefultBlade") == nil and game.Workspace:FindFirstChild(RandomCarrier.Name) ~= nil and game.Workspace:FindFirstChild(RandomCarrier.Name):FindFirstChild("DefultBlade") == nil then
								break
							end
							wait(0.1)
						end
						if game.Workspace:FindFirstChild(RandomCarrier.Name) then
							local NewArrowGui = game.ReplicatedStorage.ArrowGui:Clone()
							NewArrowGui.Arrow.ImageColor3 = Color3.new(1,1,1)
							NewArrowGui.Parent = game.Workspace:FindFirstChild(RandomCarrier.Name).Head
						end
						wait(2)
					end
				end
				
				game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.SecondsAlive.Value = 0
				game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.IsDead.Value = false
				game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.CurrentCarrier.Value = ""
				game.ReplicatedStorage.BattleStorage.UniqueRounds.KillTheCarrier.PlayersPlaying:ClearAllChildren()
				GlobalValues.GlobalLabel.Value = "This unique round is over!"
				wait(2.5)
			end
			if RandomSpecialRound.Name == "TimeBomb" then
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:ClearAllChildren()
				for Index,Child in pairs(game.Players:GetChildren()) do
					if Child.PlayersValues.OtherValues.IsPlaying.Value == true and Child.PlayersValues.OtherValues.HasLoadedStats.Value == true and game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:FindFirstChild(Child.Name) == nil then
					local PlayersValue = Instance.new("BoolValue")
					PlayersValue.Name = Child.Name
					PlayersValue.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying
					end
				end
				if #game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren() < 4 then
					GlobalValues.GlobalLabel.Value = "We don't have enough players for a time bomb round, invite your friends!"
					wait(10)
					repeat wait() until #game.Players:GetChildren() >= 4
					break
				end
				GlobalValues.GlobalLabel.Value = "One person will have the time bomb and if that player has that bomb when the timer is up the player dies."
				wait(5)
				GlobalValues.GlobalLabel.Value = "If you have the time bomb then try to hand it off to someone else by attacking them.  You can't hand off the bomb to the person that gave it to you."
				wait(5)
				local RandomPersonWithBomb = game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren()[math.random(1,#game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren())]
				for Index, Child in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren()) do
					local TelePlayer = false
					if Child.Name == RandomPersonWithBomb.Name then
						local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side1", true, false, true, Color3.new(1,1,1))
						if not Success then
							print("Failed to teleport player.  Message: "..Message)
							Child:Destroy()
						end
					else
						local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(Child.Name), "Side2", false, false)
						if not Success then
							print("Failed to teleport player.  Message: "..Message)
							Child:Destroy()
						end
					end
				wait()
				end
				local NumPlayersPlaying = #game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren()
				
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.RoundInProgress.Value = true
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value = RandomPersonWithBomb.Name
				
	
				for i = 1, NumPlayersPlaying - 3 do	
					local Success, Message = pcall(PlaySongs, "All Players", "GAME_TimeBombMusic"..(i % 2) + 1)
					if not Success then
						print("Failed to play music.  Message: "..Message)
					end
					
					for i = 1,15 do
						GlobalValues.TimerTime.Value = 15 - i
						GlobalValues.GlobalLabel.Value = "The time bomb will go off in:"
						wait(1)
						if i == 15 and game.Workspace:FindFirstChild(game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value) ~= nil then
							if game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:FindFirstChild(game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value) ~= nil then
								game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:FindFirstChild(game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value):Destroy()
							end
							local NewExplosion = Instance.new("Explosion")
							NewExplosion.BlastPressure = 1200000
							NewExplosion.BlastRadius = 20
							NewExplosion.DestroyJointRadiusPercent = 0
							NewExplosion.Position = game.Workspace:FindFirstChild(game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value).Torso.Position
							NewExplosion.Parent = game.Workspace
							game.Workspace:FindFirstChild(game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value).Humanoid.Health = 0
							wait(2)
						end
					end	
					if #game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren() <= 3 then --Stops game if 3 or less players are left.
						break
					end

					local RandomPersonWithBomb = game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren()[math.random(1,#game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren())]
					game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.LastTagedPerson.Value = ""
					game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value = ""
					GlobalValues.GlobalLabel.Value = RandomPersonWithBomb.Name.." has the new time bomb!"
					wait(2.5)
					game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value = RandomPersonWithBomb.Name
				end
				wait(3)
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.RoundInProgress.Value = false
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.Value = ""
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayerWithBomb.LastTagedPerson.Value = ""
				for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TimeBomb.PlayersPlaying:GetChildren()) do
					local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true, true, 300, true, 50)
					if not Success then
						print("Failed to teleport to lobby.  Message: "..Message)
					end
					C:Destroy()
				end
				game.Workspace.Map:Destroy()
				GlobalValues.GlobalLabel.Value = "All of the remaining players will get 300 bells and 50 experience!"
				wait(5)
				
				GlobalValues.GlobalLabel.Value = "This unique round is over!"
				wait(2.5)
			end
			if RandomSpecialRound.Name == "2v2v2" then
				for Index,Child in pairs(game.Players:GetChildren()) do
					if Child.PlayersValues.OtherValues.IsPlaying.Value == true and Child.PlayersValues.OtherValues.HasLoadedStats.Value == true then
					local PlayersValue = Instance.new("BoolValue")
					PlayersValue.Name = Child.Name
					PlayersValue.Parent = game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.PlayersPlaying
					end
				end
				if #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.PlayersPlaying:GetChildren() < 6 then
					GlobalValues.GlobalLabel.Value = "We don't have enough players for this unique round (6 players needed), invite your friends!"
					wait(10)
					repeat wait() until #game.Players:GetChildren() >= 6
					break
				end
				GlobalValues.GlobalLabel.Value = "In this unique round there will be three teams of two people, the last team standing wins."
				wait(6)
				GlobalValues.GlobalLabel.Value = "Setting up teams..."
				
				local RandomPlayer
				for i = 1,6 do --Setting up teams
					repeat
						wait()
						RandomPlayer = game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.PlayersPlaying:GetChildren()[math.random(1,#game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.PlayersPlaying:GetChildren())]
					until game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:FindFirstChild(RandomPlayer.Name) == nil and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:FindFirstChild(RandomPlayer.Name) == nil and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:FindFirstChild(RandomPlayer.Name) == nil
			  		if i == 1 or i == 2 then
					RandomPlayer.Parent =  game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne
					elseif i == 3 or i == 4 then
					RandomPlayer.Parent =  game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo
					elseif i == 5 or i == 6 then
					RandomPlayer.Parent =  game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree
					end
				end
				if game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren()[1] ~= nil and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren()[2] ~= nil then
					GlobalValues.GlobalLabel.Value = "Red team: "..game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren()[1].Name.." and "..game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren()[2].Name
					wait(3.3)
				end
				if game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren()[1] ~= nil and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren()[2] ~= nil then
					GlobalValues.GlobalLabel.Value = "Blue team: "..game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren()[1].Name.." and "..game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren()[2].Name
					wait(3.3)
				end
				if game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren()[1] ~= nil and game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren()[2] ~= nil then
					GlobalValues.GlobalLabel.Value = "Green team: "..game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren()[1].Name.." and "..game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren()[2].Name
					wait(3.3)
				end
				GlobalValues.GlobalLabel.Value = "Setting up game..."
				for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren()) do
					local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(C.Name), "Side1", true, false, true, Color3.new(200/255, 0, 0))
					if not Success then
						print("Failed to teleport Player.  Message: "..Message)
						C:Destroy()
					end
				end
				for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren()) do
					local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(C.Name), "Side2", true, false, true, Color3.new(0, 0, 200/255))
					if not Success then
						print("Failed to teleport Player.  Message: "..Message)
						C:Destroy()
					end
				end
				for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren()) do
					local Success, Message = pcall(TeleportPlayerToArena, game.Players:FindFirstChild(C.Name), "Side3", true, false, true, Color3.new(0, 200/255, 0))
					if not Success then
						print("Failed to teleport Player.  Message: "..Message)
						C:Destroy()
					end
				end
				local RandomBattleSong = math.random(1,NumberOfBattleSongs)
				local Success, Message = pcall(PlaySongs, "All Players", "GAME_BattleSong"..RandomBattleSong)
				if not Success then
					print("Failed to play music.  Message: "..Message)
				end
				
				
				for i = 1,90 do
					GlobalValues.GlobalLabel.Value = "A unique round is in progress..."
					wait(1)
					GlobalValues.TimerTime.Value = 90 - i
					if i == 90 then 
						--Timer ran out.
						GlobalValues.GlobalLabel.Value = "The timer has ran out and no one wins."
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren()) do
							local Success, Message = pcall(game.Players:FindFirstChild(C.Name), true, true)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end
						end
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren()) do
							local Success, Message = pcall(game.Players:FindFirstChild(C.Name), true, true)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end
						end
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren()) do
							local Success, Message = pcall(game.Players:FindFirstChild(C.Name), true, true)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end
						end
						local Success, Message = pcall(StopSongs, "All Players",  "GAME_BattleSong"..RandomBattleSong, "DeepenFadeOut")
						if not Success then
							print("Failed to stop music.  Message: "..Message)
						end
						break
						
					elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren() == 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren() == 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren() == 0 then
						--All Players have died.
						GlobalValues.GlobalLabel.Value = "All the players have died and no team wins."
						break
						
					elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren() == 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren() == 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren() > 0 then
						--Team One Wins.
						GlobalValues.GlobalLabel.Value = "The red team wins!  Each player on the red team will get 250 bells."
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren()) do
							local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true, true, 250)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end
							local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(C.Name),  "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
							if not Success then
								print("Failed to stop music.  Message: "..Message)
							end
						end
						break
						
					elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren() == 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren() > 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren() == 0 then 
						--Team Two Wins.
						GlobalValues.GlobalLabel.Value = "The blue team wins!  Each player on the blue team will get 250 bells."
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren()) do
							local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true, true, 250)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end
							local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(C.Name),  "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
							if not Success then
								print("Failed to stop music.  Message: "..Message)
							end
						end
						break
						
					elseif #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren() > 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:GetChildren() == 0 and #game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:GetChildren() == 0 then
						--Team Three Wins.
						GlobalValues.GlobalLabel.Value = "The green team wins!  Each player on the green team will get 250 bells."
						for I,C in pairs(game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:GetChildren()) do
							local Success, Message = pcall(TeleportPlayerToLobby, game.Players:FindFirstChild(C.Name), true, true, true, 250)
							if not Success then
								print("Failed to teleport to lobby.  Message: "..Message)
							end
							local Success, Message = pcall(StopSongs, game.Players:FindFirstChild(C.Name),  "GAME_BattleSong"..RandomBattleSong, "HightenFadeOut")
							if not Success then
								print("Failed to stop music.  Message: "..Message)
							end
						end
						break
						
					end
				end
				game.Workspace:FindFirstChild("Map"):Destroy()
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.PlayersPlaying:ClearAllChildren()
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamOne:ClearAllChildren()
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamTwo:ClearAllChildren()
				game.ReplicatedStorage.BattleStorage.UniqueRounds.TwoVSTwoVSTwo.TeamThree:ClearAllChildren()
				wait(5)
				GlobalValues.GlobalLabel.Value = "This unique round is over!"
				wait(2.5)
			end
		end
	end
--]]
end







