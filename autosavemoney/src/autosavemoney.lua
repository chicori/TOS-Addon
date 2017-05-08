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
end

function FIRSTLOAD_SETTINGS()
--デフォルト設定
	g.settings = {
		enable = true,
		automode = false,
		thresholdPrice = 100000
		};
	AUTOSAVEMONEY_SAVESETTINGS();
	local firstMsg = info.GetName(session.GetMyHandle()) .. "：アドオン[autosave money]初回起動です。{nl}デフォルト金額に100,000をセットしました。{nl}[/asm 金額]でキャラ毎の設定ができます。"
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
			FIRSTLOAD_SETTINGS()
		else
			acutil.loadJSON(g.settingsFileLoc, g.settings);
			g.settings = t;
			AUTOSAVEMONEY_SAVESETTINGS();
		end
		g.loaded = true;

	addon:RegisterMsg('OPEN_DLG_ACCOUNTWAREHOUSE', 'AUTOSAVEMONEY_SET');
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
	elseif tonumber(cmd) >= 1000 then
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


function AUTOSAVEMONEY_SET(frame)
	local inputPrice = GET_TOTAL_MONEY();
	local thresholdPrice   = g.settings.thresholdPrice;

	if g.settings.enable == false then
		return;
	end

	if inputPrice >= (thresholdPrice + 1000) then
		local setPrice = math.floor(inputPrice/1000-(thresholdPrice/1000))*1000;
		local frame = ui.GetFrame("accountwarehouse");
		local logBox = GET_CHILD(frame, "logbox");
		local depBox = GET_CHILD(logBox, "DepositSkin")
		local find_name = GET_CHILD(depBox, "moneyInput", "ui::CEditControl");
		find_name:SetText(setPrice);
		
		local automode = g.settings.automode;
		if automode == true then
			ACCOUNT_WAREHOUSE_DEPOSIT(frame)
		end
	end	
--dofile("../data/addon_d/autosavemoney/autosavemoney.lua");

	if g.settings.enable == true then
		local whframe = ui.GetFrame("accountwarehouse");
		local save_button = whframe:CreateOrGetControl("button", "AUTOSAVEMONEY_SAVE_BUTTON",25, 710, 80, 30);
		tolua.cast(save_button, "ui::CButton");
		save_button:SetFontName("white_16_ol");
		save_button:SetEventScript(ui.LBUTTONDOWN, "AUTOSAVEMONEY_SETTING");
		save_button:SetText("ASM設定");
		
		local save_text = whframe:CreateOrGetControl("edit", "AUTOSAVEMONEY_SAVE_TEXT",110, 710, 80, 30);
		tolua.cast(save_text, "ui::CEditControl");
		save_text:MakeTextPack();
		save_text:SetTextAlign("center", "center");
		save_text:SetFontName("white_16_ol");
		save_text:SetSkinName("systemmenu_vertical");
		save_text:SetText(thresholdPrice)


		local automode_lbl = whframe:CreateOrGetControl("richtext", "AUTOSAVEMONEY_AUTOMODE_LBL",200, 715, 35, 35);
		tolua.cast(automode_lbl, "ui::CRichText");
		automode_lbl:SetFontName("white_16_ol");
		automode_lbl:SetText("{@st43}{s18}" .. "自動入金" .. "{/}");

		local automode_cbx = whframe:CreateOrGetControl("checkbox", "AUTOSAVEMONEY_AUTOMODE_CBX",280, 710, 35, 35);
		tolua.cast(automode_cbx, "ui::CCheckBox");
		automode_cbx:SetClickSound("button_click_big");
		automode_cbx:SetAnimation("MouseOnAnim",  "btn_mouseover");
		automode_cbx:SetAnimation("MouseOffAnim", "btn_mouseoff");
		automode_cbx:SetOverSound("button_over");
		automode_cbx:SetEventScript(ui.LBUTTONUP, "AUTOSAVEMONEY_TOGGLECHECK");
		automode_cbx:SetUserValue("NUMBER", 1);
	end



end
--dofile("../data/addon_d/autosavemoney/autosavemoney.lua");

function AUTOSAVEMONEY_TOGGLECHECK(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.automode = true;
	else
		g.settings.automode = false;
	end
	AUTOSAVEMONEY_SAVESETTINGS();
end

function AUTOSAVEMONEY_SETTING()
	local frame = ui.GetFrame("accountwarehouse");
	local txtBox = GET_CHILD(frame, "AUTOSAVEMONEY_SAVE_TEXT"):GetText()

	if tonumber(txtBox) >= 1000 then
		g.settings.thresholdPrice = txtBox;

		CHAT_SYSTEM(string.format("[%s]設定 %s:しきい値%s%s", addonName, info.GetName(session.GetMyHandle()), GET_MONEY_IMG(14) ,GetCommaedText(txtBox)));
		AUTOSAVEMONEY_SAVESETTINGS();
		ui.MsgBox(string.format("[%s]設定しました。{nl} {nl}%s:しきい値%s%s", addonName, info.GetName(session.GetMyHandle()), GET_MONEY_IMG(14) ,GetCommaedText(txtBox)))
	end
end
