--アドオン名（大文字）
local addonName		= "AUTOSAVEMONEY"
local addonNameLower	= string.lower(addonName)
local author		= "CHICORI"

--アドオン内で使用する領域を作成。以下、ファイル内のスコープではグローバル変数gでアクセス可
_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

--ライブラリ読み込み
local acutil = require('acutil')

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName))

--セーブ ------------------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_SAVESETTINGS()
	local cid		= session.GetMySession():GetCID()
	g.settingsFileLoc	= string.format("../addons/%s/%s.json", addonNameLower, cid)
	acutil.saveJSON(g.settingsFileLoc, g.settings)
end

--デフォルト設定 -----------------------------------------------------------------------------------------------------------------
function FIRSTLOAD_SETTINGS()
	g.settings = {
		enable			= true,		--使用可否
		automode		= false,	--自動入金
		autopay			= false,	--自動出金
		autotalt		= false,	--自動タルト
		splitprice		= 1000,		--単位
		thresholdprice		= 100000,	--入出金しきい値
		inputitem1		= "",		--
		inputitem2		= "",		--
		inputitem3		= "",		--
		inputitem4		= "",		--
		inputitem5		= "",		--
		lptfollow1		= "",		--
		lptfollow2		= "",		--
		lptfollow3		= "",		--
		lptfollow4		= "",		--
		lptfollow5		= ""		--
		};

	local firstMsg = info.GetName(session.GetMyHandle()) .. "：アドオン[autosave money]初回起動です。{nl}デフォルト金額に100,000をセットしました。"
	CHAT_SYSTEM(firstMsg)
end

-- 読み込み処理 -----------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_ON_INIT(addon, frame)
	--設定ファイル保存先
	local cid		= session.GetMySession():GetCID()
	g.settingsFileLoc	= string.format("../addons/%s/%s.json", addonNameLower, cid)

	local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings)
	if err then
		FIRSTLOAD_SETTINGS()
	else
		acutil.loadJSON(g.settingsFileLoc, g.settings)
		g.settings = t
	end

	if tonumber(g.settings.thresholdPrice) ~= nil then
		FIRSTLOAD_SETTINGS()
		CHAT_SYSTEM("※アップデートに伴い初期化しました")
	end

	AUTOSAVEMONEY_SAVESETTINGS()
	g.loaded = true

	addon:RegisterMsg('OPEN_DLG_ACCOUNTWAREHOUSE', 'AUTOSAVEMONEY_ACT')

end


-- 処理いろいろ -----------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_ACT()
	if g.settings.enable == false then
		return;
	end

	local totalMoney	= GET_TOTAL_MONEY()
	local thresholdPrice	= g.settings.thresholdprice
	local splitPrice	= g.settings.splitprice

	local frame		= ui.GetFrame("accountwarehouse")
	local logBox		= GET_CHILD(frame, "logbox")
	local depBox		= GET_CHILD(logBox, "DepositSkin")
	local setCTRL		= GET_CHILD(depBox, "moneyInput", "ui::CEditControl")
	local setPrice

	--入金
	if totalMoney >= (thresholdPrice + splitPrice) then
		if g.settings.automode == true then
			setPrice = math.floor((totalMoney-thresholdPrice)/splitPrice)*splitPrice
			setCTRL: SetText(setPrice);
			ACCOUNT_WAREHOUSE_DEPOSIT(frame)
			CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."："..GetCommaedText(setPrice) .. "シルバーを自動入金しました{/}")
		end

	--自動出金
	elseif (thresholdPrice - splitPrice) >= totalMoney then
		if g.settings.autopay == true then
			setPrice = math.floor((thresholdPrice-totalMoney+splitPrice)/splitPrice)*splitPrice
			setCTRL:SetText(setPrice);
			ACCOUNT_WAREHOUSE_WITHDRAW(frame)
			CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."："..GetCommaedText(setPrice) .. "シルバーを自動出金しました{/}")
		end
	end	

	--自動タルト入庫
	if g.settings.autotalt == true then
		AUTOSAVEMONEY_TALT_TO_WAREHOUSE(frame, 1)
	end


	AUTOSAVEMONEY_CREATE_CTRL()


end
--dofile("../data/addon_d/autosavemoney/autosavemoney.lua");


-- タルト入庫 --------------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TALT_TO_WAREHOUSE(frame, automode)
	local findItem = 645268									--ID:タルト
	local invList  = session.GetInvItemList()
	local count    = session.GetInvItemList():Count() -1
	local index    = invList:Head()

	for i = 0, count do
		local invItem = invList:Element(index)
		index = invList:Next(index)

		local itemObj = GetIES(invItem:GetObject())

		if itemObj.ClassID == findItem then
			item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invItem:GetIESID(), invItem.count, frame:GetUserIValue("HANDLE"));

			if automode == 1 then
				CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."：タルト"..invItem.count.. "個を自動入庫しました{/}")
			else
				--*************** 要空き枠確認 ***************
				--CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."：タルト"..invItem.count.. "個を入庫しました{/}")
			end	

			break
		end
	end

end


-- チェックボックス：入金 --------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TOGGLECHECK_AUTOMODE(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.automode = true
	else
		g.settings.automode = false
	end
	AUTOSAVEMONEY_SAVESETTINGS()
end

-- チェックボックス：出金 --------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TOGGLECHECK_AUTOPAY(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.autopay = true
	else
		g.settings.autopay = false
	end
	AUTOSAVEMONEY_SAVESETTINGS()
end


-- チェックボックス：タルト ------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TOGGLECHECK_AUTOTALT(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.autotalt = true
	else
		g.settings.autotalt = false
	end
	AUTOSAVEMONEY_SAVESETTINGS()
end


-- 設定登録 ------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_SETTING(frame)
	local thresholdPrice	= GET_CHILD(frame, "ASM_SAVE_TXT1"):GetText()
	local splitPrice	= GET_CHILD(frame, "ASM_SAVE_TXT2"):GetText()

	if tonumber(thresholdPrice) >= 1000 then
		g.settings.thresholdprice	= thresholdPrice
		g.settings.splitprice		= splitPrice

		CHAT_SYSTEM(string.format("[%s]設定 %s:しきい値%s%s", addonName, info.GetName(session.GetMyHandle()), GET_MONEY_IMG(14) ,GetCommaedText(thresholdPrice)))
		AUTOSAVEMONEY_SAVESETTINGS()
		ui.MsgBox(string.format("[%s]設定しました。{nl} {nl}%s{nl} {nl}しきい値%s%s/単元%s%s", addonName, info.GetName(session.GetMyHandle()), GET_MONEY_IMG(14) ,GetCommaedText(thresholdPrice),GET_MONEY_IMG(14),GetCommaedText(splitPrice)))
	end
end


-- 未完成 ************************************************
function AUTOSAVEMONEY_SELECT_ALLITEM()
	local frame	= ui.GetFrame("accountwarehouse")
	local gbox	= frame:GetChild("gbox")
	local slotset	= gbox:GetChild("slotset")

	for i = 1, 2 do
		local slotname = slotset:GetChild("slot" .. i)
		AUTO_CAST(slotname);
	    	slotname:Select(1, 1)			-- Select(enable, count)?
		CHAT_SYSTEM(tostring(slotname))
	end
end

--未完成 ************************************************
function AUTOSAVEMONEY_CLEAR_ALLITEM()
	local frame	= ui.GetFrame("accountwarehouse")
	local gbox	= frame:GetChild("gbox")
	local slotset	= gbox:GetChild("slotset")

	local aObj		= GetMyAccountObj();
	local maxcountWH	= aObj.MaxAccountWarehouseCount + aObj.AccountWareHouseExtend

	for i = 1, maxcountWH do
	    local slotname	= slotset:GetChild("slot" .. i)
		AUTO_CAST(slotname);
	    slotname:Select(0, 1)
		CHAT_SYSTEM(tostring(slotset))
	end
end


-- 設定コントロールの作成 -------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_CREATE_CTRL()
	local frame		= ui.GetFrame("accountwarehouse")
	local rtCtrl = {
		[1]  = {name="ASM_SAVE_BTN1"	; type="button"  ; left= 25; top=710; w=80; h=30; body="ASM設定"		; fnc="AUTOSAVEMONEY_SETTING"};
		[2]  = {name="ASM_SAVE_TXT1"	; type="edit"    ; left=110; top=710; w=80; h=30; body= g.settings.thresholdprice	; fnc=""};
	
		[3]  = {name="ASM_SAVE_BTN2"	; type="button"  ; left= 25; top=675; w=80; h=30; body="単元設定"		; fnc="AUTOSAVEMONEY_SETTING"};
		[4]  = {name="ASM_SAVE_TXT2"	; type="edit"    ; left=110; top=675; w=80; h=30; body= g.settings.splitprice		; fnc=""};
	
		[5]  = {name="ASM_AUTOMODE_LBL"	; type="richtext"; left=200; top=717; w= 35; h=35; body="自動入金"		; fnc=""};
		[6]  = {name="ASM_AUTOMODE_CBX"	; type="checkbox"; left=280; top=712; w= 30; h=30; body=""				; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOMODE"};
	
		[7]  = {name="ASM_AUTOPAY_LBL"	; type="richtext"; left=315; top=717; w= 35; h=35; body="出金"			; fnc=""};
		[8]  = {name="ASM_AUTOPAY_CBX"	; type="checkbox"; left=360; top=712; w= 30; h=30; body=""				; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOPAY"};
		
		[9]  = {name="ASM_AUTOTALT_LBL"	; type="richtext"; left=395; top=717; w= 35; h=35; body="タルト"		; fnc=""};
		[10] = {name="ASM_AUTOTALT_CBX"	; type="checkbox"; left=455; top=712; w= 30; h=30; body=""				; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOTALT"};
	
		[11] = {name="ASM_TALTIN_BTN"	; type="button"  ; left=533; top=715; w= 95; h=25; body="タルト手動"	; fnc="AUTOSAVEMONEY_TALT_TO_WAREHOUSE"};
--		[12] = {name="ASM_ALLSELECT_BTN"; type="button"  ; left=470; top=530; w=100; h=53; body="全選択"		; fnc="AUTOSAVEMONEY_SELECT_ALLITEM"};
--		[13] = {name="ASM_ALLCLEAR_BTN"	; type="button"  ; left=585; top=530; w= 45; h=53; body="解除"			; fnc="AUTOSAVEMONEY_CLEAR_ALLITEM"};

		};

		for i, ver in ipairs(rtCtrl) do
			local create_CTRL	= frame:CreateOrGetControl(rtCtrl[i].type, rtCtrl[i].name, rtCtrl[i].left, rtCtrl[i].top, rtCtrl[i].w, rtCtrl[i].h)
			local rtFontName	= "white_16_ol"
	
			if rtCtrl[i].type == "button" then
				tolua.cast(create_CTRL, "ui::CButton")
				create_CTRL:SetEventScript(ui.LBUTTONDOWN, rtCtrl[i].fnc)
				create_CTRL:SetText(rtCtrl[i].body)
		
			elseif rtCtrl[i].type == "edit" then
				tolua.cast(create_CTRL, "ui::CEditControl");
				create_CTRL:MakeTextPack();
				create_CTRL:SetTextAlign("center", "center");
				create_CTRL:SetFontName(rtFontName);
				create_CTRL:SetSkinName("systemmenu_vertical");
				create_CTRL:SetText(rtCtrl[i].body)
		
			elseif rtCtrl[i].type == "richtext" then
				tolua.cast(create_CTRL, "ui::CRichText");
				create_CTRL:SetFontName(rtFontName);
				create_CTRL:SetText("{@st43}{s18}" .. rtCtrl[i].body .. "{/}");
		
			elseif rtCtrl[i].type == "checkbox" then
				tolua.cast(create_CTRL, "ui::CCheckBox");
				create_CTRL:SetClickSound("button_click_big");
				create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
				create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
				create_CTRL:SetOverSound("button_over");
				create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrl[i].fnc);
				create_CTRL:SetUserValue("NUMBER", 1);
				create_CTRL:SetCheck(0);
			end
	
			--初期値のロード
			if rtCtrl[i].name == "ASM_AUTOMODE_CBX" then
				if g.settings.automode == true then					--入金
					create_CTRL:SetCheck(1);
				end
			elseif rtCtrl[i].name == "ASM_AUTOPAY_CBX" then
				if g.settings.autopay == true then					--出金
					create_CTRL:SetCheck(1);
				end
			elseif rtCtrl[i].name == "ASM_AUTOTALT_CBX" then
				if g.settings.autotalt == true then					--タルト
					create_CTRL:SetCheck(1);
				end
			end
		end
end
--dofile("../data/addon_d/autosavemoney/autosavemoney.lua");
