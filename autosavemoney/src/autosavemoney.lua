--writさんありがとう！

--アドオン名（大文字）
local addonName			= "AUTOSAVEMONEY"
local addonNameLower	= string.lower(addonName)
local author			= "CHICORI"

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
	local cid			= session.GetMySession():GetCID()
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
		autostone		= false,	--自動女神の祝福石
		autopiece		= false,	--自動祝福された欠片
		autonpowder		= false,	--自動ニュークルパウダー
		autospowder		= false,	--自動シエラパウダー
		splitprice		= 1000,		--単位
		thresholdprice	= 100000,	--入出金しきい値
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
	local cid			= session.GetMySession():GetCID()
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

	AUTOSAVEMONEY_MONEY_TO_WAREHOUSE()

	AUTOSAVEMONEY_ITEM_TO_WAREHOUSE()

	AUTOSAVEMONEY_CREATE_CTRL()
end

function AUTOSAVEMONEY_MONEY_TO_WAREHOUSE(frame)

	local totalMoney		= GET_TOTAL_MONEY()
	local thresholdPrice	= g.settings.thresholdprice
	local splitPrice		= g.settings.splitprice

	local frame				= ui.GetFrame("accountwarehouse")
	local logBox			= GET_CHILD(frame, "logbox")
	local depBox			= GET_CHILD(logBox, "DepositSkin")
	local setCTRL			= GET_CHILD(depBox, "moneyInput", "ui::CEditControl")
	local setPrice


	--入金
	if totalMoney >= (thresholdPrice + splitPrice) then
		setPrice	= math.floor((totalMoney-thresholdPrice)/splitPrice)*splitPrice
		setCTRL		: SetText(setPrice)

		if g.settings.automode == true then
			ACCOUNT_WAREHOUSE_DEPOSIT(frame)
			CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."："..GetCommaedText(setPrice) .. "シルバーを自動入金しました{/}")
		end
	--自動出金
	elseif (thresholdPrice - splitPrice) >= totalMoney then
		setPrice	= math.floor((thresholdPrice-totalMoney+splitPrice)/splitPrice)*splitPrice
		setCTRL		: SetText(setPrice);

		if g.settings.autopay == true then
			ACCOUNT_WAREHOUSE_WITHDRAW(frame)
			CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."："..GetCommaedText(setPrice) .. "シルバーを自動出金しました{/}")
		end
	end	
end

--dofile("../data/addon_d/autosavemoney/autosavemoney.lua");


--local putItemTable = {645268,646045,645783,649025,649026}

local function isPutItem(itemID)
putItemTable = {}

	if g.settings.autotalt == true then		--たると
		table.insert(putItemTable,645268)
	end
	if g.settings.autopiece == true then	--祝福欠片
		table.insert(putItemTable,645783)
	end
	if g.settings.autostone == true then	--祝福石
		table.insert(putItemTable,646045)
	end
	if g.settings.autonpowder == true then	--ニュークルパウダー
		table.insert(putItemTable,649025)
	end
	if g.settings.autospowder == true then	--シエラパウダー
		table.insert(putItemTable,649026)
	end
	
	for i,putItemID in ipairs(putItemTable) do
		if itemID == putItemID then
			return true
		end
	end
	return false
end

function _AUTOSAVEMONEY_ITEM_TO_WAREHOUSE(iesID,count,name)
	local frame = ui.GetFrame("accountwarehouse")
	item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesID, count, frame:GetUserIValue("HANDLE"));
end

function AUTOSAVEMONEY_ITEM_TO_WAREHOUSE(frame)
	local delayCount = 0
	local invList  = session.GetInvItemList()
	local count    = session.GetInvItemList():Count() -1
	local index    = invList:Head()

	for i = 0, count do
		local invItem = invList:Element(index)
		index = invList:Next(index)

		local itemObj = GetIES(invItem:GetObject())

		if isPutItem(itemObj.ClassID) then
			ReserveScript( string.format("_AUTOSAVEMONEY_ITEM_TO_WAREHOUSE(\"%s\",%d,\"%s\")",  invItem:GetIESID(), invItem.count,itemObj.Name) , delayCount*0.3);
			delayCount = delayCount + 1
		end
	end
end


-- タルト手動入庫 --------------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TALT_TO_WAREHOUSE(frame)
--645268　たると

	local findItem = 645268
	local invitem = session.GetInvItemByType(findItem) 

	if invitem then
		item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invitem:GetIESID(), invitem.count, frame:GetUserIValue("HANDLE"));
		CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."：タルト"..invitem.count.. "個を入庫しました。{/}")
    end
end
-- 祝福の欠片手動入庫 --------------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_PIECE_TO_WAREHOUSE(frame)
--645783　欠片石

	local findItem = 645783
	local invitem = session.GetInvItemByType(findItem) 

	if invitem then
		item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invitem:GetIESID(), invitem.count, frame:GetUserIValue("HANDLE"));
		CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."：祝福された欠片"..invitem.count.. "個を入庫しました。{/}")
    end
end
-- 祝福石手動入庫 --------------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_STONE_TO_WAREHOUSE(frame)
--646045　祝福石

	local findItem = 646045
	local invitem = session.GetInvItemByType(findItem) 

	if invitem then
		item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invitem:GetIESID(), invitem.count, frame:GetUserIValue("HANDLE"));
		CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."：女神の祝福石"..invitem.count.. "個を入庫しました。{/}")
    end
end
-- ニュークルパウダー手動入庫 --------------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_NPOWDER_TO_WAREHOUSE(frame)
--649025　ニュークルパウダー

	local findItem = 649025
	local invitem = session.GetInvItemByType(findItem) 

	if invitem then
		item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invitem:GetIESID(), invitem.count, frame:GetUserIValue("HANDLE"));
		CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."：ニュークルパウダー"..invitem.count.. "個を入庫しました。{/}")
    end
end
-- シエラパウダー手動入庫 --------------------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_SPOWDER_TO_WAREHOUSE(frame)
--649026　シエラパウダー

	local findItem = 649026
	local invitem = session.GetInvItemByType(findItem) 

	if invitem then
		item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invitem:GetIESID(), invitem.count, frame:GetUserIValue("HANDLE"));
		CHAT_SYSTEM(info.GetName(session.GetMyHandle()).."：シエラパウダー"..invitem.count.. "個を入庫しました。{/}")
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

-- チェックボックス：女神の祝福石 ------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TOGGLECHECK_AUTOSTONE(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.autostone = true
	else
		g.settings.autostone = false
	end
	AUTOSAVEMONEY_SAVESETTINGS()
end

-- チェックボックス：祝福された欠片 ------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TOGGLECHECK_AUTOPIECE(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.autopiece = true
	else
		g.settings.autopiece = false
	end
	AUTOSAVEMONEY_SAVESETTINGS()
end

-- チェックボックス：ニュークルパウダー ------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TOGGLECHECK_AUTONPOWDER(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.autonpowder = true
	else
		g.settings.autonpowder = false
	end
	AUTOSAVEMONEY_SAVESETTINGS()
end

-- チェックボックス：シエラパウダー ------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_TOGGLECHECK_AUTOSPOWDER(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings.autospowder = true
	else
		g.settings.autospowder = false
	end
	AUTOSAVEMONEY_SAVESETTINGS()
end

-- 設定登録 ------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_SETTING(frame)
	local thresholdPrice	= GET_CHILD(frame, "ASM_SAVE_TXT1"):GetText()
	local splitPrice		= GET_CHILD(frame, "ASM_SAVE_TXT2"):GetText()

	if tonumber(thresholdPrice) >= 1000 then
		g.settings.thresholdprice	= thresholdPrice
		g.settings.splitprice		= splitPrice

		CHAT_SYSTEM(string.format("[%s]設定 %s:しきい値%s%s", addonName, info.GetName(session.GetMyHandle()), GET_MONEY_IMG(14) ,GetCommaedText(thresholdPrice)))
		AUTOSAVEMONEY_SAVESETTINGS()
		ui.MsgBox(string.format("[%s]設定しました。{nl} {nl}%s{nl} {nl}しきい値%s%s/単元%s%s", addonName, info.GetName(session.GetMyHandle()), GET_MONEY_IMG(14) ,GetCommaedText(thresholdPrice),GET_MONEY_IMG(14),GetCommaedText(splitPrice)))
	end
end

-- 設定コントロールの作成 -------------------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_CREATE_CTRL()
	local frame		= ui.GetFrame("accountwarehouse")
	local rtCtrl = {
		[1]  = {name="ASM_SAVE_BTN1"		; type="button"  ; left= 25; top=710; w=80; h=30; body="ASM設定"			; fnc="AUTOSAVEMONEY_SETTING"};
		[2]  = {name="ASM_SAVE_TXT1"		; type="edit"    ; left=110; top=710; w=80; h=30; body= g.settings.thresholdprice	; fnc=""};
	
		[3]  = {name="ASM_SAVE_BTN2"		; type="button"  ; left= 25; top=675; w=80; h=30; body="単元設定"			; fnc="AUTOSAVEMONEY_SETTING"};
		[4]  = {name="ASM_SAVE_TXT2"		; type="edit"    ; left=110; top=675; w=80; h=30; body= g.settings.splitprice		; fnc=""};
	
		[5]  = {name="ASM_AUTOMODE_LBL"		; type="richtext"; left=200; top=717; w= 35; h=35; body="自動入金"			; fnc=""};
		[6]  = {name="ASM_AUTOMODE_CBX"		; type="checkbox"; left=280; top=712; w= 30; h=30; body=""					; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOMODE"};
	
		[7]  = {name="ASM_AUTOPAY_LBL"		; type="richtext"; left=315; top=717; w= 35; h=35; body="出金"				; fnc=""};
		[8]  = {name="ASM_AUTOPAY_CBX"		; type="checkbox"; left=360; top=712; w= 30; h=30; body=""					; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOPAY"};

		[9]  = {name="ASM_AUTOINVITE_LBL"	; type="richtext"; left=492; top=565; w= 120; h=25; body="自動 / 手動入庫"	; fnc=""};

		[10] = {name="ASM_AUTOSPOWDER_CBX"	; type="checkbox"; left=500; top=588; w= 30; h=30; body=""					; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOSPOWDER"};
		[11] = {name="ASM_AUTONPOWDER_CBX"	; type="checkbox"; left=500; top=618; w= 30; h=30; body=""					; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTONPOWDER"};
		[12] = {name="ASM_AUTOPIECE_CBX"	; type="checkbox"; left=500; top=648; w= 30; h=30; body=""					; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOPIECE"};
		[13] = {name="ASM_AUTOSTONE_CBX"	; type="checkbox"; left=500; top=678; w= 30; h=30; body=""					; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOSTONE"};
		[14] = {name="ASM_AUTOTALT_CBX"		; type="checkbox"; left=500; top=708; w= 30; h=30; body=""					; fnc="AUTOSAVEMONEY_TOGGLECHECK_AUTOTALT"};

		[15] = {name="ASM_SPOWDERIN_BTN"	; type="button"  ; left=530; top=590; w= 105; h=25; body="シエラ"			; fnc="AUTOSAVEMONEY_SPOWDER_TO_WAREHOUSE"};
		[16] = {name="ASM_NPOWDERIN_BTN"	; type="button"  ; left=530; top=620; w= 105; h=25; body="ニュークル"		; fnc="AUTOSAVEMONEY_NPOWDER_TO_WAREHOUSE"};
		[17] = {name="ASM_PIECEIN_BTN"		; type="button"  ; left=530; top=650; w= 105; h=25; body="祝福の欠片"		; fnc="AUTOSAVEMONEY_PIECE_TO_WAREHOUSE"};
		[18] = {name="ASM_STONEIN_BTN"		; type="button"  ; left=530; top=680; w= 105; h=25; body="祝福石"			; fnc="AUTOSAVEMONEY_STONE_TO_WAREHOUSE"};
		[19] = {name="ASM_TALTIN_BTN"		; type="button"  ; left=530; top=710; w= 105; h=25; body="タルト"			; fnc="AUTOSAVEMONEY_TALT_TO_WAREHOUSE"};

		};
--dofile("../data/addon_d/autosavemoney/autosavemoney.lua");

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
			elseif rtCtrl[i].name == "ASM_AUTOSTONE_CBX" then
				if g.settings.autostone == true then					--女神の祝福石
					create_CTRL:SetCheck(1);
				end
			elseif rtCtrl[i].name == "ASM_AUTOPIECE_CBX" then
				if g.settings.autopiece == true then					--祝福された欠片
					create_CTRL:SetCheck(1);
				end
			elseif rtCtrl[i].name == "ASM_AUTONPOWDER_CBX" then
				if g.settings.autonpowder == true then					--ニュークルパウダー
					create_CTRL:SetCheck(1);
				end
			elseif rtCtrl[i].name == "ASM_AUTOSPOWDER_CBX" then
				if g.settings.autospowder == true then					--シエラパウダー
					create_CTRL:SetCheck(1);
				end

			end
		end
end
--dofile("../data/addon_d/autosavemoney/autosavemoney.lua");
