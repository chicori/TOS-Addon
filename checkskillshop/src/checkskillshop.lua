--アドオン名（大文字）
local addonName = "CHECKSKILLSHOP";
local addonNameUpper = string.upper(addonName);
local addonNameLower = string.lower(addonName);
--作者名
local author = "CHICORI";

--アドオン内で使用する領域を作成。以下、ファイル内のスコープではグローバル変数gでアクセス可
_G["ADDONS"] = _G["ADDONS"] or {};
_G["ADDONS"][author] = _G["ADDONS"][author] or {};
_G["ADDONS"][author][addonNameUpper] = _G["ADDONS"][author][addonNameUpper] or {};
local g = _G["ADDONS"][author][addonNameUpper];

--設定ファイル保存先
g.settingsFileLoc = string.format("../addons/%s/settings.json", addonNameLower);

--ライブラリ読み込み
local acutil = require('acutil');

--デフォルト設定
if not g.loaded then
	g.settings = {
	--有効/無効
	automode = "off"
  };
end

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName));

function CHECKSKILLSHOP_SAVE_SETTINGS()
	acutil.saveJSON(g.settingsFileLoc, g.settings);
end



function CHECKSKILLSHOP_ON_INIT(addon, frame)
	g.addon = addon;
	g.frame = frame;

	acutil.slashCommand("/"..addonNameLower, CHECKSKILLSHOP_PROCESS_COMMAND);
	acutil.slashCommand("/css", CHECKSKILLSHOP_PROCESS_COMMAND);

	if not g.loaded then
		local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings);
		if err then
		 --設定ファイル読み込み失敗時処理
			CHAT_SYSTEM(string.format("[%s] cannot load setting files", addonName));
		else
		--設定ファイル読み込み成功時処理
			g.settings = t;
		end
		g.loaded = true;
	end

	--設定ファイル保存処理
	CHECKSKILLSHOP_SAVE_SETTINGS();
	acutil.setupHook(BUY_BUFF_AUTOSELL_HOOKED, "BUY_BUFF_AUTOSELL");

end

function CHECKSKILLSHOP_PROCESS_COMMAND(command)
	local cmd = "";

	if #command > 0 then
		cmd = table.remove(command, 1);
	else
		local msg = "on/off/self"
		return ui.MsgBox(msg,"","Nope")
	end

	if cmd == "on" then
		--有効
		g.settings.automode = "on";
		CHAT_SYSTEM(string.format("[%s] automode on", addonName));
		CHECKSKILLSHOP_SAVE_SETTINGS();
		return;
	elseif cmd == "off" then
		--無効
		g.settings.automode = "off";
		CHAT_SYSTEM(string.format("[%s] automode off", addonName));
		CHECKSKILLSHOP_SAVE_SETTINGS();
		return;
	elseif cmd == "self" then
		--無効
		g.settings.automode = "self";
		CHAT_SYSTEM(string.format("[%s] automode self", addonName));
		CHECKSKILLSHOP_SAVE_SETTINGS();
		return;
	end
	CHAT_SYSTEM(string.format("[%s] Invalid Command", addonName));
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


	local msg = "{nl} {nl}" .. ClMsg("ReallyBuy?")
	local skillPrice = GetCommaedText(itemInfo.price);
	local skillName  = sklObj.Name;
	local skillImage   = "{img icon_" .. sklObj["Icon"] .. " 60 60}　";
	local relationSkill = {
	[1] = {Name = "サクラメント";   buffID = 100; sklID = 40205; Lv=10};
	[2] = {Name = "アスパーション"; buffID = 146; sklID = 40201; Lv=15};
	[3] = {Name = "ブレッシング";   buffID = 147; sklID = 40203; Lv=15};
	};
	
	local skl_i		= 0;
	local tblMax    = table.maxn(relationSkill);

	--価格チェック
	if itemInfo.price >= 10000 then
		skillPrice = "{#FF6347}{ol}【価格確認】{/}{/}" .. skillPrice;
		msg = "{nl} {nl} {nl} {nl}{#FF6347}{ol}価格の桁が違うような・・・？{nl} {nl}本当に購入しますか？{/}{/}{nl} {nl} ";
	end

	--色変え
	local skillLv = string.format(" Lv%s{nl} {nl}",itemInfo.level)

	if 9 >= itemInfo.level then
		skillLv = "{#FF6347}{ol}" .. skillLv .. "{/}{/}";
--	elseif itemInfo.level >=15 then
--		skillLv = "{#98FB98}{ol}" .. skillLv .. "{/}{/}";	
	end


	--上書き確認
	local handle = session.GetMyHandle();
	local buffCount = info.GetBuffCount(handle);

	for i = 0, buffCount - 1 do
		local buff = info.GetBuffIndexed(handle, i);
		for skl_i = 1, tblMax do
			if buff.buffID == relationSkill[skl_i].buffID then
				if sklObj.ClassID == relationSkill[skl_i].sklID then
					if g.settings.automode == "off" then
						ui.MsgBox(skillImage .. relationSkill[skl_i].Name .. "{nl} {nl} {nl}既に付与されています。")
						return;
					elseif g.settings.automode == "self" then
						local delSkl = string.format("RERIGHTMSG(%d, %d, %d, %d, %d)",buff.buffID, frame:GetUserIValue("HANDLE"), index, cnt, sellType);
						ui.MsgBox(skillImage .. relationSkill[skl_i].Name .. "{nl} {nl} {nl}既に付与されています。{nl} {nl}{#98FB98}{ol}バフを解除しますか？{/}{/}", delSkl, "None")
						return;
					elseif g.settings.automode == "on" then
						local delSkl = string.format("RERIGHTMSG(%d, %d, %d, %d, %d)",buff.buffID, frame:GetUserIValue("HANDLE"), index, cnt, sellType);
						ui.MsgBox(skillImage .. skillName .. skillLv .. "{nl}" ..  skillPrice .. "シルバーです。{nl} {nl}{#98FB98}{ol}バフを解除して更新しますか？{/}{/}", delSkl, "None")
						return;
					end

				break;
				end
			end
		end
	end

	ui.MsgBox(skillImage .. skillName .. skillLv .. "{nl}" ..  skillPrice .. "シルバーです。{nl}" ..msg, strscp, "None");

end

function RERIGHTMSG(buffID,hundle,index,cnt,sellType)
	packet.ReqRemoveBuff(buffID);
	
	-- ここはディレイ入れても安定しない。
	if g.settings.automode == "on" then
		EXEC_BUY_AUTOSELL(hundle, index, cnt, sellType);
	end
end
