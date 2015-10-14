function init()
	VoteCounter_YES = 0
	VoteCounter_NO = 0

	print("sv_votekick - Initialize complete")
end
init()

function getplayersname(sender, text, teamChat)
	players = player:GetAll()

	util.AddNetworkString("name_sendtoclient")
	net.Start("name_sendtoclient")
		net.WriteString(sender:Nick())
		net.WriteTable(players)
	net.Broadcast()
end

function votecounting()
	VoteYESorNO = net.ReadString()

	if VoteYESorNO == "YES" then
		VoteCounter_YES = VoteCounter_YES + net.ReadInt(2)
	elseif VoteYESorNO == "NO" then
		VoteCounter_NO  = VoteCounter_NO + net.ReadInt(2)
	end

	util.AddNetworkString("VoteCountedReturn")
	net.Start("VoteCountedReturn")
		net.WriteInt(VoteCounter_YES, 4)
		net.WriteInt(VoteCounter_NO, 4)
	net.Broadcast()
end

function vote_result()
	if VoteCounter_NO < VoteCounter_YES then
		PrintMessage(HUD_PRINTCENTER, "Vote passed! Player kicking...")
		timer.Simple(1, function() PrintMessage(HUD_PRINTCENTER, "Vote passed! Player kicking...") end)
		local kickplayername = net.ReadString()

		for i, n in pairs(players) do
			local name = string.sub(tostring(players[i]), 12, string.find(tostring(players[i]), "]", 11, true) - 1)
			if name == kickplayername then
				n:Kick()
			end
		end
	else
		PrintMessage(HUD_PRINTCENTER, "Vote not passed!")
		timer.Simple(1, function() PrintMessage(HUD_PRINTCENTER, "Vote not passed!") end)
	end
end

util.AddNetworkString("VOTED")
util.AddNetworkString("VOTE_END")
net.Receive("VOTED",  votecounting)
net.Receive("VOTE_END", vote_result)
hook.Add("PlayerSay", "getsay", getplayersname)
-- Debug
concommand.Add("init_sv", init)