function init()
	VoteCounter_YES = 0
	VoteCounter_NO = 0
	
	print("sv_votekick - Initialize compleate")
end
init()

function getplayersname(sender, text, teamChat)
	util.AddNetworkString("name_sendtoclient")
	net.Start("name_sendtoclient")
		net.WriteString(sender:Nick())
		net.WriteTable(player:GetAll())
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

util.AddNetworkString("VOTED")
net.Receive("VOTED",  votecounting)
hook.Add("PlayerSay", "getsay", getplayersname)
-- Debug
concommand.Add("init_sv", init)