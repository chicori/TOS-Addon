local addonName = "AUTOSAVEMONEY";
local addonNameLower = string.lower(addonName);
local author = "CHICORI";

_G["ADDONS"] = _G["ADDONS"] or {};
_G["ADDONS"][author] = _G["ADDONS"][author] or {};
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {};
local g = _G["ADDONS"][author][addonName];

local acutil = require('acutil');

CHAT_SYSTEM(string.format("%s.lua is loaded", addonName));

function AUTOSAVEMONEY_ON_INIT(addon, frame)
	g.addon = addon;
	g.frame = frame;
	acutil.setupHook(ON_OPEN_ACCOUNTWAREHOUSE_HOOKED, "ON_OPEN_ACCOUNTWAREHOUSE");	
end


function ON_OPEN_ACCOUNTWAREHOUSE_HOOKED(frame)
    ui.OpenFrame("accountwarehouse");

	local inputPrice = GET_TOTAL_MONEY();
	if inputPrice >= 110000 then
		local setPrice = math.floor(inputPrice/10000-10)*10000;
		local frame = ui.GetFrame("accountwarehouse");
		local gBox = GET_CHILD(frame, "gbox");
		local find_name = GET_CHILD(gBox, "moneyInput", "ui::CEditControl");
		find_name:SetText(setPrice);
	end	
end
