local addonName = "CHECKBLESSEDSHARD"
local addonNameLower = string.lower(addonName)
local author = "CHICORI"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

local acutil = require('acutil')
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName))

function CHECKBLESSEDSHARD_ON_INIT(addon, frame)

	g.addon = addon
	g.frame = frame

	addon:RegisterMsg('OPEN_DLG_WAREHOUSE', 'CHECK_CHECKBLESSEDSHARD')
end

function CHECK_CHECKBLESSEDSHARD()

	local findItem = 645783 --ID:Blessed Shard

	local invList  = session.GetInvItemList()
	local index    = invList:Head()
	local count    = session.GetInvItemList():Count() -1

	for i = 0, count do
		local invItem = invList:Element(index)
		index = invList:Next(index)

		local itemObj = GetIES(invItem:GetObject())

		if itemObj.ClassID == findItem then
			local itemMsg = {
							icon = "{img " .. itemObj.Icon .. " 30 30} "
							,name = itemObj.Name
							,msg  = "を所持しています。"
							}
		
			ui.MsgBox(string.format("%s%s%s",itemMsg.icon
											,itemMsg.name
											,itemMsg.msg))
			break
		end
	end
end
