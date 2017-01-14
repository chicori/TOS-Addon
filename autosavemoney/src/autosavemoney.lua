--アドオン名（大文字）
local addonName = "AUTOSAVEMONEY";
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

function AUTOSAVEMONEY_SAVESETTINGS()
	local cid = session.GetMySession():GetCID();
	g.settingsFileLoc = string.format("../addons/%s/%s.json", addonNameLower, cid);
	acutil.saveJSON(g.settingsFileLoc, g.settings);
	acutil.loadJSON(g.settingsFileLoc, g.settings);
end

function FIRSTLOAD_SETTINGS()
--デフォルト設定
	g.settings = {
		enable = true,
		automode = false,
		thresholdPrice = 100000
		};
	AUTOSAVEMONEY_SAVESETTINGS();
	local firstMsg = info.GetName(session.GetMyHandle()) .. "：アドオン[autosave money]初回起動です。{nl}デフォルト金額に100,000sをセットしました。{nl}[/asm 金額]でキャラ毎の設定ができます。"
	CHAT_SYSTEM(firstMsg);
end

function AUTOSAVEMONEY_ON_INIT(addon, frame)
--設定ファイル保存先
	local cid = session.GetMySession():GetCID();
	g.settingsFileLoc = string.format("../addons/%s/%s.json", addonNameLower, cid);

	g.addon = addon;
	g.frame = frame;

	acutil.slashCommand("/"..addonNameLower, AUTOSAVEMONEY_PROCESS_COMMAND);
	acutil.slashCommand("/asm", AUTOSAVEMONEY_PROCESS_COMMAND);

	local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings);
		if err then
			--設定ファイル読み込み失敗
			FIRSTLOAD_SETTINGS()
		else
			--設定ファイル読み込み成功
			acutil.loadJSON(g.settingsFileLoc, g.settings);
			g.settings = t;
			AUTOSAVEMONEY_SAVESETTINGS();
		end
		g.loaded = true;

	acutil.setupHook(ON_OPEN_ACCOUNTWAREHOUSE_HOOKED, "ON_OPEN_ACCOUNTWAREHOUSE");	
--test:CHAT_SYSTEM(info.GetName(session.GetMyHandle()) .. ":" .. cid .. "/" .. g.settings.thresholdPrice)
end

function AUTOSAVEMONEY_PROCESS_COMMAND(command)
local cmd = "";

	if #command > 0 then
		cmd = table.remove(command, 1);
	else
		local msg = "しきい値設定：[/asm 金額]"
		return ui.MsgBox(msg,"","Nope")
	end

	if cmd == "on" then
	--有効
		g.settings.enable = true;
		CHAT_SYSTEM(string.format("[%s] is enable", addonName));
		AUTOSAVEMONEY_SAVESETTINGS();
		return;
	elseif cmd == "off" then
	--無効
		g.settings.enable = false;
		CHAT_SYSTEM(string.format("[%s] is disable", addonName));
		AUTOSAVEMONEY_SAVESETTINGS();
		return;
	elseif cmd == "autoon" then
		g.settings.automode = true;
		CHAT_SYSTEM(string.format("[%s] is autopayment on", addonName));
		AUTOSAVEMONEY_SAVESETTINGS();
		return;
	elseif cmd == "autooff" then
		g.settings.automode = false;
		CHAT_SYSTEM(string.format("[%s] is autopayment on", addonName));
		AUTOSAVEMONEY_SAVESETTINGS();
		return;
	elseif tonumber(cmd) >= 10000 then
	--しきい値
		g.settings.thresholdPrice = cmd;
		CHAT_SYSTEM(string.format("[%s]設定 %s:しきい値%s%s", addonName, info.GetName(session.GetMyHandle()), GET_MONEY_IMG(14) ,GetCommaedText(cmd)));
		AUTOSAVEMONEY_SAVESETTINGS();
		return;
	elseif tonumber(cmd) >= 1 then
		ui.SysMsg("1,000単位で指定してください")
		return;
	end
  CHAT_SYSTEM(string.format("[%s] Invalid Command", addonName));
end


function ON_OPEN_ACCOUNTWAREHOUSE_HOOKED(frame)
	ui.OpenFrame("accountwarehouse");

	local inputPrice = GET_TOTAL_MONEY();
	local thresholdPrice   = g.settings.thresholdPrice;

	if g.settings.enable == false then
		return;
	end

	if inputPrice >= (thresholdPrice + 1000) then
		local setPrice = math.floor(inputPrice/1000-(thresholdPrice/1000))*1000;
		local frame = ui.GetFrame("accountwarehouse");
		local gBox = GET_CHILD(frame, "gbox");
		local find_name = GET_CHILD(gBox, "moneyInput", "ui::CEditControl");
		find_name:SetText(setPrice);
		
--		local automodeFlg = g.settings.automode;
--		if automodeFlg == true then
--			ACCOUNT_WAREHOUSE_DEPOSIT();
--		end
	end	

	ON_OPEN_ACCOUNTWAREHOUSE_OLD();
end
