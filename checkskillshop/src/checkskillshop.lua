--アドオン名（大文字）
local addonName = "CHECKSKILLSHOP";
local addonNameLower = string.lower(addonName);
--作者名
local author = "CHICORI";

--アドオン内で使用する領域を作成。以下、ファイル内のスコープではグローバル変数gでアクセス可
_G["ADDONS"] = _G["ADDONS"] or {};
_G["ADDONS"][author] = _G["ADDONS"][author] or {};
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {};
local g = _G["ADDONS"][author][addonName];

--ライブラリ読み込み
local acutil = require('acutil');

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName));

function CHECKSKILLSHOP_ON_INIT(addon, frame)
	g.addon = addon;
	g.frame = frame;

	acutil.setupHook(BUY_BUFF_AUTOSELL_HOOKED, "BUY_BUFF_AUTOSELL");
end

function BUY_BUFF_AUTOSELL_HOOKED(ctrlSet, btn)

    local frame = ctrlSet:GetTopParentFrame();
    local sellType = frame:GetUserIValue("SELLTYPE");
    local groupName = frame:GetUserValue("GROUPNAME");
    local index = ctrlSet:GetUserIValue("INDEX");
    local itemInfo = session.autoSeller.GetByIndex(groupName, index);
    local buycount =  GET_CHILD(ctrlSet, "price");
    if itemInfo == nil then
        return;
    end

    local cnt = 1;
    if buycount ~= nil then
        cnt = buycount:GetNumber();
    end

    local totalPrice = itemInfo.price * cnt;
    local myMoney = GET_TOTAL_MONEY();
    if totalPrice > myMoney or  myMoney <= 0 then
        ui.SysMsg(ClMsg("NotEnoughMoney"));
        return;
    end

    local sklObj = GetClassByType("Skill", itemInfo.classID);
    local strscp = string.format( "EXEC_BUY_AUTOSELL(%d, %d, %d, %d)", frame:GetUserIValue("HANDLE"), index, cnt, sellType);
    local msg = ClMsg("ReallyBuy?")
	local skillPrice = itemInfo.price;
	local skillName  = sklObj.Name;
	local skillLv    = " Lv" .. itemInfo.level .. "{nl} {nl}";
	local skillImage   = "{img icon_" .. sklObj["Icon"] .. " 60 60}　";

	--色変え
	if 9 >= itemInfo.level then
		skillLv = "{#FF6347}{ol}" .. skillLv .. "{/}{/}";
--	elseif itemInfo.level >=15 then
--		skillLv = "{#98FB98}{ol}" .. skillLv .. "{/}{/}";	
	end

	--価格チェック
	if itemInfo.price >= 10000 then
		skillPrice = "{#FF6347}{ol}【価格確認】{/}{/}" .. GetCommaedText(skillPrice);
		msg = "{nl} {nl} {nl} {nl}{#FF6347}{ol}価格の桁が違うような・・・？{nl} {nl}本当に購入しますか？{/}{/}{nl} {nl} ";
	    ui.MsgBox(skillImage .. skillName .. skillLv .. "{nl}" ..  skillPrice .. "シルバーです。{nl}" ..msg, strscp, "None");
	else
		skillPrice = GetCommaedText(skillPrice);
	    ui.MsgBox(skillImage .. skillName .. skillLv .. "{nl}" ..  skillPrice .. "シルバーです。{nl}" ..msg, strscp, "None");
	end

end