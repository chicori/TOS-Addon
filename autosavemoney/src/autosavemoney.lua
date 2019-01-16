local addonName			= "AUTOSAVEMONEY"
local addonNameLower	= string.lower(addonName)
local author			= "CHICORI"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]
local acutil = require('acutil')

CHAT_SYSTEM(string.format("%s.lua is loaded", addonName))
-- アイテムテーブル作成 ----------------------------------------------------------------------
function AUTOSAVEMONEY_ADDITEMTABLE()
	putItemTableT = {}
	putItemTableP = {}

	for i = 7,67 do
		if g.settings[1].teamflg == true then
			if g.settingsCommon[i].teamflg 		== true then table.insert(putItemTableT,g.settingsCommon[i].date) end
			if g.settingsCommon[i].privateflg 	== true then table.insert(putItemTableP,g.settingsCommon[i].date) end
		else
			if g.settings[i].teamflg			== true then table.insert(putItemTableT,g.settings[i].date) end
			if g.settings[i].privateflg			== true then table.insert(putItemTableP,g.settings[i].date) end	
		end
	end
end

-- セーブ -----------------------------------------------------------------------------------
function AUTOSAVEMONEY_PRIVATESAVE()
	-- 個別
		local cid = session.GetMySession():GetCID()
		g.settingsFileLoc = string.format("../addons/%s/%s.json", addonNameLower, cid)
		acutil.saveJSON(g.settingsFileLoc, g.settings)
end

function AUTOSAVEMONEY_COMMONSAVE()
	-- 共通
		g.settingsFileLocCommon = string.format("../addons/%s/%s.json", addonNameLower, "commonsetting")
		acutil.saveJSON(g.settingsFileLocCommon, g.settingsCommon)
end

-- ロード -----------------------------------------------------------------------------------
function AUTOSAVEMONEY_PRIVATELOAD()
	-- 個別
		local cid			= session.GetMySession():GetCID()
		g.settingsFileLoc	= string.format("../addons/%s/%s.json", addonNameLower, cid)
		local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings)
	
		if err then
			AUTOSAVEMONEY_FIRSTLOAD_SETTINGS()
		else
			acutil.loadJSON(g.settingsFileLoc, g.settings)
			g.settings = t
		end
end

function AUTOSAVEMONEY_COMMONLOAD()
	-- 共通
		g.settingsFileLocCommon	= string.format("../addons/%s/%s.json", addonNameLower, "commonsetting")
		local t, err = acutil.loadJSON(g.settingsFileLocCommon, g.settingsCommon)
		
		if err then
			AUTOSAVEMONEY_FIRSTLOAD_COMMONSETTINGS()
		else
			acutil.loadJSON(g.settingsFileLocCommon, g.settingsCommon)
			g.settingsCommon = t
		end
end


--デフォルト設定 --------------------------------------------------------------------------------
function AUTOSAVEMONEY_FIRSTLOAD_SETTINGS()

g.settings = {
	[1]  = {name="Common";			teamflg=true;	privateflg=false;	date =0;		com ="使用設定";		};
	[2]  = {name="CommonItem";		teamflg=true;	privateflg=false;	date =0;		com ="倉庫 設定";		};	--中止
	[3]  = {name="Automode";		teamflg=false;	privateflg=false;	date =0;		com ="自動 入金";		};
	[4]  = {name="Autopay";			teamflg=false;	privateflg=false;	date =0;		com ="自動 出金";		};
	[5]  = {name="Splitprice";		teamflg=false;	privateflg=false;	date =1000;		com ="単位";			};
	[6]  = {name="Thresholdprice";	teamflg=false;	privateflg=false;	date =500000;	com ="基準金額";		};
	[7]  = {name="Talt";			teamflg=false;	privateflg=false;	date =645268;	com ="タルト";			};
	[8]  = {name="Stone";			teamflg=false;	privateflg=false;	date =646045;	com ="女神の祝福石";	};
	[9]  = {name="Piece";			teamflg=false;	privateflg=false;	date =645783;	com ="祝福された欠片";	};
	[10] = {name="Spowder";			teamflg=false;	privateflg=false;	date =649026;	com ="シエラパウダー";	};
	[11] = {name="Npowder";			teamflg=false;	privateflg=false;	date =649025;	com ="ﾆｭｰｸﾙﾊﾟｳﾀﾞｰ";		};
	[12] = {name="Raidstone";		teamflg=false;	privateflg=false;	date =680000;	com ="レイドストーン";	};
	[13] = {name="Cube";			teamflg=false;	privateflg=false;	date =801000;	com ="Lv300キューブ";	};
	[14] = {name="Uench";			teamflg=false;	privateflg=false;	date =699005;	com ="ﾕﾆｰｸｴﾝﾁｬﾝﾄｼﾞｪﾑ";	};
	[15] = {name="Rench";			teamflg=false;	privateflg=false;	date =699004;	com ="ﾚｱｴﾝﾁｬﾝﾄｼﾞｭｴﾙ";	};
	[16] = {name="Opal";			teamflg=false;	privateflg=false;	date =649203;	com ="オパール";		};
	[17] = {name="Obsidian";		teamflg=false;	privateflg=false;	date =649205;	com ="オブシディアン";	};
	[18] = {name="Garnet";			teamflg=false;	privateflg=false;	date =649204;	com ="ガーネット";		};
	[19] = {name="Sapphire";		teamflg=false;	privateflg=false;	date =649216;	com ="サファイア";		};
	[20] = {name="Zircon";			teamflg=false;	privateflg=false;	date =649207;	com ="ジルコン";		};
	[21] = {name="Topaz";			teamflg=false;	privateflg=false;	date =649202;	com ="トパーズ";		};
	[22] = {name="Peridot";			teamflg=false;	privateflg=false;	date =649206;	com ="ペリドット";		};
	[23] = {name="Ruby";			teamflg=false;	privateflg=false;	date =649217;	com ="ルビー";			};
	[24] = {name="GoldING";			teamflg=false;	privateflg=false;	date =645257;	com ="金塊";			};
	[25] = {name="SilverING";		teamflg=false;	privateflg=false;	date =645485;	com ="銀塊";			};
	[26] = {name="Mithril";			teamflg=false;	privateflg=false;	date =649004;	com ="ミスリル鉱石";	};
	[27] = {name="Absidium";		teamflg=false;	privateflg=false;	date =649016;	com ="アブシディウム";	};--クエっぽい？個人倉庫入らないらしい
	[28] = {name="Andesium";		teamflg=false;	privateflg=false;	date =649012;	com ="アンデシウム";	};
	[29] = {name="Arochium";		teamflg=false;	privateflg=false;	date =649015;	com ="アチロニウム";	};
	[30] = {name="Ionium";			teamflg=false;	privateflg=false;	date =649013;	com ="イオニウム";		};
	[31] = {name="Urstar";			teamflg=false;	privateflg=false;	date =649028;	com ="ウルスターﾏｲﾄ";	};
	[32] = {name="Teranium";		teamflg=false;	privateflg=false;	date =645694;	com ="テラニウム";		};
	[33] = {name="Practnium";		teamflg=false;	privateflg=false;	date =649014;	com ="プラクトニウム";	};
	[34] = {name="Fedesium";		teamflg=false;	privateflg=false;	date =649009;	com ="フィデシウム";	};
	[35] = {name="Berinium";		teamflg=false;	privateflg=false;	date =649010;	com ="ベリニウム";		};
	[36] = {name="Vertremin";		teamflg=false;	privateflg=false;	date =649027;	com ="ベルトレミン";	};
	[37] = {name="Porchium";		teamflg=false;	privateflg=false;	date =649011;	com ="ポルチウム";		};
	[38] = {name="Rydia";			teamflg=false;	privateflg=false;	date =647000;	com ="ﾘﾃﾞｨｱの赤い花";	};
	[39] = {name="Drops";			teamflg=false;	privateflg=false;	date =647001;	com ="星が宿った露";	};
	[40] = {name="Black";			teamflg=false;	privateflg=false;	date =647002;	com ="ｼｬｯﾌｪﾝの黒花";	};
	[41] = {name="Lamp";			teamflg=false;	privateflg=false;	date =647003;	com ="星の引導者ﾗﾝﾌﾟ";	};
	[42] = {name="Lens";			teamflg=false;	privateflg=false;	date =647004;	com ="拡張レンズ";		};
	[43] = {name="Arrow";			teamflg=false;	privateflg=false;	date =647005;	com ="渋皮の教訓の矢";	};
	[44] = {name="Candle";			teamflg=false;	privateflg=false;	date =647006;	com ="栄光の燭台";		};
	[45] = {name="Galaxy";			teamflg=false;	privateflg=false;	date =647007;	com ="ﾆｺﾎﾟﾘｽ銀河の玉";	};
	[46] = {name="Pallaine";		teamflg=false;	privateflg=false;	date =647008;	com ="ﾆｺﾎﾟﾘｽﾌｪﾗｲﾝ";		};
	[47] = {name="Royal";			teamflg=false;	privateflg=false;	date =647009;	com ="ﾛｲﾔﾙﾌﾞﾚｰﾄﾞ破片";	};
	[48] = {name="Free1";			teamflg=false;	privateflg=false;	date =0;		com ="フリー1 ";};
	[49] = {name="Free2";			teamflg=false;	privateflg=false;	date =0;		com ="フリー2 ";};
	[50] = {name="Free3";			teamflg=false;	privateflg=false;	date =0;		com ="フリー3 ";};
	[51] = {name="Free4";			teamflg=false;	privateflg=false;	date =0;		com ="フリー4 ";};
	[52] = {name="Free5";			teamflg=false;	privateflg=false;	date =0;		com ="フリー5 ";};
	[53] = {name="Free6";			teamflg=false;	privateflg=false;	date =0;		com ="フリー6 ";};
	[54] = {name="Free7";			teamflg=false;	privateflg=false;	date =0;		com ="フリー7 ";};
	[55] = {name="Free8";			teamflg=false;	privateflg=false;	date =0;		com ="フリー8 ";};
	[56] = {name="Free9";			teamflg=false;	privateflg=false;	date =0;		com ="フリー9 ";};
	[57] = {name="Free10";			teamflg=false;	privateflg=false;	date =0;		com ="フリー10";};
	[58] = {name="Free11";			teamflg=false;	privateflg=false;	date =0;		com ="フリー11";};
	[59] = {name="Free12";			teamflg=false;	privateflg=false;	date =0;		com ="フリー12";};
	[60] = {name="Free13";			teamflg=false;	privateflg=false;	date =0;		com ="フリー13";};
	[61] = {name="Free14";			teamflg=false;	privateflg=false;	date =0;		com ="フリー14";};
	[62] = {name="Free15";			teamflg=false;	privateflg=false;	date =0;		com ="フリー15";};
	[63] = {name="Free16";			teamflg=false;	privateflg=false;	date =0;		com ="フリー16";};
	[64] = {name="Free17";			teamflg=false;	privateflg=false;	date =0;		com ="フリー17";};
	[65] = {name="Free18";			teamflg=false;	privateflg=false;	date =0;		com ="フリー18";};
	[66] = {name="Free19";			teamflg=false;	privateflg=false;	date =0;		com ="フリー19";};
	[67] = {name="Free20";			teamflg=false;	privateflg=false;	date =0;		com ="フリー20";};
};

	AUTOSAVEMONEY_PRIVATESAVE()
	CHAT_SYSTEM(info.GetName(session.GetMyHandle()) .. "：アドオン[autosave money]初回もしくはアップデート後の起動です。{nl}個人設定を初期化しました。")
end
--デフォルト設定 --------------------------------------------------------------------------------
function AUTOSAVEMONEY_FIRSTLOAD_COMMONSETTINGS()
	g.settingsCommon = g.settings

	AUTOSAVEMONEY_COMMONSAVE()
	CHAT_SYSTEM("共通設定を初期化しました。")
end

-- 読み込み --------------------------------------------------------------------------------
function AUTOSAVEMONEY_ON_INIT(addon, frame)

	--ロード：個別
		AUTOSAVEMONEY_PRIVATELOAD()
		AUTOSAVEMONEY_COMMONLOAD()

		g.loaded = true

	--ボタン作成
		local rtCtrl = {
			[1]  = 	{name="ASM_OPENPRIVATE_BTN";	left=509;	frame="accountwarehouse";	msg="OPEN_DLG_ACCOUNTWAREHOUSE";	call="AUTOSAVEMONEY_ACT";};
			[2]  = 	{name="ASM_OPENTEAM_BTN";		left=494;	frame="warehouse";		 	msg="OPEN_DLG_WAREHOUSE";			call="AUTOSAVEITEM_ACT";};
			};

		for i, ver in ipairs(rtCtrl) do
			local frame = ui.GetFrame(rtCtrl[i].frame)
			local asm_setting_btn = frame:CreateOrGetControl("button", rtCtrl[i].name, rtCtrl[i].left, 80, 130, 30);
				asm_setting_btn = tolua.cast(asm_setting_btn, "ui::CButton");
				asm_setting_btn:SetText("自動入庫 設定");
				asm_setting_btn:SetEventScript(ui.LBUTTONDOWN, "AUTOSAVEMONEY_OPEN_SETTING");
				addon:RegisterMsg(rtCtrl[i].msg, rtCtrl[i].call)
	end

end

-- キャラクター倉庫処理 --------------------------------------------------------------------------------
function AUTOSAVEITEM_ACT()
	ReserveScript("AUTOSAVEMONEY_ITEM_TO_CHRWAREHOUSE()" , 0.3);
end

function AUTOSAVEMONEY_ACT()
	AUTOSAVEMONEY_MONEY_TO_WAREHOUSE()
	ReserveScript("AUTOSAVEMONEY_ITEM_TO_WAREHOUSE()" , 0.6);

end

-- 入出金処理 -------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_MONEY_TO_WAREHOUSE(frame)
	local totalMoney = GET_TOTAL_MONEY()
	local splitPrice
	local thresholdPrice
	local setPrice
	local afterMoney

	if g.settings[1].teamflg == true then
		splitPrice		= g.settingsCommon[5].date
		thresholdPrice	= g.settingsCommon[6].date
	else
		splitPrice		= g.settings[5].date
		thresholdPrice	= g.settings[6].date
	end

	local frame			= ui.GetFrame("accountwarehouse")
	local logBox		= GET_CHILD(frame,  "logbox")
	local depBox		= GET_CHILD(logBox, "DepositSkin")
	local setCTRL		= GET_CHILD(depBox, "moneyInput", "ui::CEditControl")
	
	--入金
	if totalMoney >= (thresholdPrice + splitPrice) then
		setPrice = math.floor((totalMoney-thresholdPrice)/splitPrice)*splitPrice
		setCTRL:SetText(setPrice)

		if g.settings[3].teamflg == true then
			ACCOUNT_WAREHOUSE_DEPOSIT(frame)
		
			afterMoney = GET_TOTAL_MONEY()
			if afterMoney ~= totalMoney then
				CHAT_SYSTEM("[自動入金：" .. info.GetName(session.GetMyHandle()).."]"..GetCommaedText(setPrice) .. "シルバー{/}")
			end
		end

	--出金
	elseif (thresholdPrice - splitPrice) >= totalMoney then
		setPrice	= math.floor((thresholdPrice-totalMoney+splitPrice)/splitPrice)*splitPrice
		setCTRL:SetText(setPrice);

		if g.settings[4].teamflg == true then
			ACCOUNT_WAREHOUSE_WITHDRAW(frame)

			afterMoney = GET_TOTAL_MONEY()
			if afterMoney ~= totalMoney then
				CHAT_SYSTEM("[自動出金：" .. info.GetName(session.GetMyHandle()).."]"..GetCommaedText(setPrice) .. "シルバー{/}")
			end
		end
	end	
end

-- アイテム処理 -------------------------------------------------------------------------------------------
function AUTOSAVEMONEY_ITEM_TO_WAREHOUSE_CHECK(itemID,itemCount,itemName,itemIcon,checkFlg)
	local findItem = 0
	local invList  = session.GetInvItemList()
	local index    = invList:Head()
	local count    = session.GetInvItemList():Count() -1
	local printImg

	for i = 0, count do
		local invItem = invList:Element(index)
		local itemObj = GetIES(invItem:GetObject())
		index = invList:Next(index)

		if itemObj.ClassID == itemID then
			findItem = 1
		end
	end

	local warehouseName
	if checkFlg == "T" then
		warehouseName = "チーム倉庫"
	elseif checkFlg == "P" then
		warehouseName = "キャラ倉庫"
	end
		
	if findItem == 0 then
		CHAT_SYSTEM("[自動入庫：".. warehouseName .."]" .. "{img " .. itemIcon .. " 18 18} " .. itemName .. "：" ..itemCount .. "個")
	elseif findItem >= 1 then
		CHAT_SYSTEM("[入庫失敗：".. warehouseName .."]" .. "{img " .. itemIcon .. " 18 18} " .. itemName .. "：" ..itemCount .. "個")

	end

end

local function isPutItemTeam(itemID)
	--チーム倉庫
	for i, putItemID in ipairs(putItemTableT) do
		if itemID == putItemID then
			return true
		end
	end
	
	return false
end

local function isPutItemPrivate(itemID2)
--個人倉庫
	for i, putItemID2 in ipairs(putItemTableP) do
		if itemID2 == putItemID2 then
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
	local delayCount	= 0
	local invList		= session.GetInvItemList()
	local count			= session.GetInvItemList():Count() -1
	local index			= invList:Head()
	local sucCount		= 0

	for i = 0, count do
		local invItem = invList:Element(index)
		local itemObj = GetIES(invItem:GetObject())
		index = invList:Next(index)

		if isPutItemTeam(itemObj.ClassID) then
			ReserveScript( string.format("_AUTOSAVEMONEY_ITEM_TO_WAREHOUSE(\"%s\",%d,\"%s\")",  invItem:GetIESID(), invItem.count,itemObj.Name) , delayCount*0.3)
			delayCount = delayCount + 1
			ReserveScript( string.format("AUTOSAVEMONEY_ITEM_TO_WAREHOUSE_CHECK(%d,%d,\"%s\",\"%s\",\"%s\")",  itemObj.ClassID, invItem.count, itemObj.Name, itemObj.Icon, "T") , delayCount*0.6)
		end
	end

end

function _AUTOSAVEMONEY_ITEM_TO_CHRWAREHOUSE(iesID,count,name)
	local frame2 = ui.GetFrame("warehouse")
	item.PutItemToWarehouse(IT_WAREHOUSE, iesID, count, frame2:GetUserIValue("HANDLE"));
end

function AUTOSAVEMONEY_ITEM_TO_CHRWAREHOUSE(frame)
	local delayCount = 0
	local invList	= session.GetInvItemList()
	local count		= session.GetInvItemList():Count() -1
	local index		= invList:Head()

	for i = 0, count do
		local invItem = invList:Element(index)
		local itemObj = GetIES(invItem:GetObject())
		index = invList:Next(index)

		if isPutItemPrivate(itemObj.ClassID) then
			ReserveScript( string.format("_AUTOSAVEMONEY_ITEM_TO_CHRWAREHOUSE(\"%s\",%d,\"%s\")",  invItem:GetIESID(), invItem.count,itemObj.Name) , delayCount*0.3)
			delayCount = delayCount + 1
			ReserveScript( string.format("AUTOSAVEMONEY_ITEM_TO_WAREHOUSE_CHECK(%d,%d,\"%s\",\"%s\",\"%s\")",  itemObj.ClassID, invItem.count, itemObj.Name, itemObj.Icon, "P") , delayCount*0.6)
		end
	end
end

-- 設定フレーム --------------------------------------------------------------------------
function AUTOSAVEMONEY_OPEN_SETTING(frame)
	local frame = ui.GetFrame("autosavemoney")
	if frame:IsVisible() == 1 then
		ui.CloseFrame("autosavemoney");
		return;
	end

	AUTOSAVEMONEY_OPEN_SETTING_FRAME(frame)

	local autosavemoneyframe = ui.GetFrame("warehouse");
	local asm_opensetting_btn = GET_CHILD_RECURSIVELY(autosavemoneyframe, "ASM_OPENTEAM_BTN", "ui::CButton");
	local x = asm_opensetting_btn:GetGlobalX() + 40;
	local y = asm_opensetting_btn:GetGlobalY() + 50;
	frame:SetOffset(x,y);
	frame:ShowWindow(1);
end

function AUTOSAVEMONEY_CLOSE_SETTING_FRAME()
	ui.CloseFrame("autosavemoney");
end

function AUTOSAVEMONEY_OPEN_SETTING_FRAME(frame)
	local bg_gbox = GET_CHILD(frame, "bg", "ui::CGroupBox");
	local asmmenu_gbox = GET_CHILD(bg_gbox, "asmmenu_gbox", "ui::CGroupBox");
		  asmmenu_gbox = tolua.cast(asmmenu_gbox, "ui::CGroupBox");
		  asmmenu_gbox:SetScrollBar(asmmenu_gbox:GetHeight());

	local asmmenu_list = GET_CHILD(bg_gbox, "asmmenu_gbox", "ui::CGroupBox");
	asmmenu_list = tolua.cast(asmmenu_list, "ui::CGroupBox");

		local rtCtrlBTN		= {}
		local rtCtrlCHKT	= {}
		local rtCtrlCHKP	= {}
		local rtCtrlEDITD	= {}
		local rtCtrlEDITA	= {}
		local rtCtrlLBLT	= {}
		local rtCtrlLBLP	= {}
		local tAdd			= {tchk=false, ptchk=false, body="", com=""}

	--使用設定
	local flowLTWH = {l=25,t=10,w=100}

	for ic = 1,1 do
		rtCtrlBTN[ic]  = {name="ASM_".. g.settings[ic].name .."_BTN";	left=flowLTWH.l;		top=flowLTWH.t;		w=flowLTWH.w;	h=25;	body=g.settings[ic].com;		fnc=""};
		rtCtrlCHKT[ic] = {name="ASM_".. g.settings[ic].name .."_CHKT";	left=flowLTWH.l+146;	top=flowLTWH.t-3;	w=30;			h=30;	body="";						fnc="ASM_TOGGLECHECKT"..ic};
		rtCtrlCHKP[ic] = {name="ASM_".. g.settings[ic].name .."_CHKP";	left=flowLTWH.l+216;	top=flowLTWH.t-3;	w=30;			h=30;	body="";						fnc="ASM_TOGGLECHECKP"..ic};
		rtCtrlLBLT[ic] = {name="ASM_".. g.settings[ic].name .."_LBLT";	left=flowLTWH.l+105;	top=flowLTWH.t+1;	w=30;			h=30;	body="共通";					fnc=""};
		rtCtrlLBLP[ic] = {name="ASM_".. g.settings[ic].name .."_LBLP";	left=flowLTWH.l+175;	top=flowLTWH.t+1;	w=30;			h=30;	body="個別";					fnc=""};
		flowLTWH.t = flowLTWH.t + 30

		--button
			local create_CTRL = asmmenu_list:CreateOrGetControl("button", rtCtrlBTN[ic].name, rtCtrlBTN[ic].left, rtCtrlBTN[ic].top, rtCtrlBTN[ic].w, rtCtrlBTN[ic].h)
			tolua.cast(create_CTRL, "ui::CButton")
			create_CTRL:SetText(rtCtrlBTN[ic].body)

		--check box / team
			create_CTRL	= asmmenu_list:CreateOrGetControl("checkbox", rtCtrlCHKT[ic].name, rtCtrlCHKT[ic].left, rtCtrlCHKT[ic].top, rtCtrlCHKT[ic].w, rtCtrlCHKT[ic].h)
			tolua.cast(create_CTRL, "ui::CCheckBox");
			create_CTRL:SetClickSound("button_click_big");
			create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
			create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
			create_CTRL:SetOverSound("button_over");
			create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrlCHKT[ic].fnc);
			create_CTRL:SetUserValue("NUMBER", 1);

			if g.settings[ic].teamflg == true then
				create_CTRL:SetCheck(1)
			else
				create_CTRL:SetCheck(0)
			end

		--check box / private
			create_CTRL	= asmmenu_list:CreateOrGetControl("checkbox", rtCtrlCHKP[ic].name, rtCtrlCHKP[ic].left, rtCtrlCHKP[ic].top, rtCtrlCHKP[ic].w, rtCtrlCHKP[ic].h)
			tolua.cast(create_CTRL, "ui::CCheckBox");
			create_CTRL:SetClickSound("button_click_big");
			create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
			create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
			create_CTRL:SetOverSound("button_over");
			create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrlCHKP[ic].fnc);
			create_CTRL:SetUserValue("NUMBER", 1);

			if g.settings[ic].teamflg == true then
				create_CTRL:SetCheck(0)
			else
				create_CTRL:SetCheck(1)
			end

		--label
			create_CTRL	= asmmenu_list:CreateOrGetControl("richtext", rtCtrlLBLT[ic].name, rtCtrlLBLT[ic].left, rtCtrlLBLT[ic].top, rtCtrlLBLT[ic].w, rtCtrlLBLT[ic].h)
			tolua.cast(create_CTRL, "ui::CRichText");
			create_CTRL:SetText("{@st43}{s18}" .. rtCtrlLBLT[ic].body .. "{/}");

			create_CTRL	= asmmenu_list:CreateOrGetControl("richtext", rtCtrlLBLP[ic].name, rtCtrlLBLP[ic].left, rtCtrlLBLP[ic].top, rtCtrlLBLP[ic].w, rtCtrlLBLP[ic].h)
			tolua.cast(create_CTRL, "ui::CRichText");
			create_CTRL:SetText("{@st43}{s18}" .. rtCtrlLBLP[ic].body .. "{/}");
	end


	--銀行設定
	flowLTWH = {l=308,t=10,w=100,h=25}
	for icq = 3,4 do
		if g.settings[1].teamflg == true then
			tAdd.tchk = g.settingsCommon[icq].teamflg
			tAdd.com  = g.settingsCommon[icq].com
		else
			tAdd.tchk = g.settings[icq].teamflg
			tAdd.com  = g.settings[icq].com
		end 

		rtCtrlBTN[icq]  = 	{name="ASM_".. g.settings[icq].name .."_BTN";	left=flowLTWH.l;		top=flowLTWH.t;		w=flowLTWH.w;	h=flowLTWH.h;	body=tAdd.com;	fnc=""};
		rtCtrlCHKT[icq] = 	{name="ASM_".. g.settings[icq].name .."_CHKT";	left=flowLTWH.l+101;	top=flowLTWH.t-3;	w=30;			h=30;			body=tAdd.tchk; fnc=""};
		flowLTWH.t = flowLTWH.t + 30

	--button
		local create_CTRL = asmmenu_list:CreateOrGetControl("button", rtCtrlBTN[icq].name, rtCtrlBTN[icq].left, rtCtrlBTN[icq].top, rtCtrlBTN[icq].w, rtCtrlBTN[icq].h)
		tolua.cast(create_CTRL, "ui::CButton")
		create_CTRL:SetEventScript(ui.LBUTTONDOWN, rtCtrlBTN[icq].fnc)
		create_CTRL:SetText(rtCtrlBTN[icq].body)
	--check box / team
		create_CTRL	= asmmenu_list:CreateOrGetControl("checkbox", rtCtrlCHKT[icq].name, rtCtrlCHKT[icq].left, rtCtrlCHKT[icq].top, rtCtrlCHKT[icq].w, rtCtrlCHKT[icq].h)
		tolua.cast(create_CTRL, "ui::CCheckBox");
		create_CTRL:SetClickSound("button_click_big");
		create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
		create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
		create_CTRL:SetOverSound("button_over");
		create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrlCHKT[icq].fnc);
		create_CTRL:SetUserValue("NUMBER", 1);
		if tAdd.tchk == true then
			create_CTRL:SetCheck(1)
		else
			create_CTRL:SetCheck(0)
		end

	end

	flowLTWH = {l=455,t=10,w=92,h=25}
	for icr = 5,6 do
		if g.settings[1].teamflg == true then
			tAdd.com  = g.settingsCommon[icr].com
			tAdd.body = g.settingsCommon[icr].date
		else
			tAdd.com  = g.settings[icr].com
			tAdd.body = g.settings[icr].date
		end 

		rtCtrlBTN[icr]  = 	{name="ASM_".. g.settings[icr].name .."_BTN";	left=flowLTWH.l;	top=flowLTWH.t; w=flowLTWH.w; h=flowLTWH.h; body=tAdd.com;	fnc=""};
		rtCtrlEDITD[icr]  = {name="ASM_".. g.settings[icr].name .."_EDITD"; left=flowLTWH.l+98; top=flowLTWH.t; w=flowLTWH.w; h=flowLTWH.h; body=tAdd.body;	fnc=""};
		flowLTWH.t = flowLTWH.t + 30

		--button
			local create_CTRL = asmmenu_list:CreateOrGetControl("button", rtCtrlBTN[icr].name, rtCtrlBTN[icr].left, rtCtrlBTN[icr].top, rtCtrlBTN[icr].w, rtCtrlBTN[icr].h)
			tolua.cast(create_CTRL, "ui::CButton")
			create_CTRL:SetEventScript(ui.LBUTTONDOWN, rtCtrlBTN[icr].fnc)
			create_CTRL:SetFontName("white_16_ol")
			create_CTRL:SetText(rtCtrlBTN[icr].body)
		--edit box
			create_CTRL = asmmenu_list:CreateOrGetControl("edit", rtCtrlEDITD[icr].name, rtCtrlEDITD[icr].left, rtCtrlEDITD[icr].top, rtCtrlEDITD[icr].w, rtCtrlEDITD[icr].h)
			tolua.cast(create_CTRL, "ui::CEditControl")
			create_CTRL:MakeTextPack()
			create_CTRL:SetTextAlign("center", "center")
			create_CTRL:SetSkinName("systemmenu_vertical")
			create_CTRL:SetFontName("white_16_ol")
			create_CTRL:SetText(rtCtrlEDITD[icr].body)
	end

	-- カテゴリ１//よく使うもの
	flowLTWH = {l=25,t=100,w=143,h=25}
	for ica = 7,47 do
		if g.settings[1].teamflg == true then
			tAdd.tchk = g.settingsCommon[ica].teamflg
			tAdd.pchk = g.settingsCommon[ica].privateflg
			tAdd.com  = g.settingsCommon[ica].com
		else
			tAdd.tchk = g.settings[ica].teamflg
			tAdd.pchk = g.settings[ica].privateflg
			tAdd.com  = g.settings[ica].com
		end 

		rtCtrlBTN[ica]   = {name="ASM_".. g.settings[ica].name .."_BTN";	left=flowLTWH.l;		top=flowLTWH.t;		w=flowLTWH.w;	h=flowLTWH.h;	body=tAdd.com;		fnc=""};
		rtCtrlCHKT[ica]  = {name="ASM_".. g.settings[ica].name .."_CHKT";	left=flowLTWH.l+145;	top=flowLTWH.t-2;	w=30;			h=30;			body=tAdd.tchk;		fnc=""};
		rtCtrlCHKP[ica]  = {name="ASM_".. g.settings[ica].name .."_CHKP";	left=flowLTWH.l+170;	top=flowLTWH.t-2;	w=30;			h=30;			body=tAdd.pchk;	fnc=""};
		flowLTWH.t = flowLTWH.t + 30

	-- category2 / 宝石
		if ica == 15 then
			flowLTWH = {l=240,t=100,w=143,h=25}
		end
	-- category3 / 鉱石
		if ica == 26 then
			flowLTWH = {l=455,t=100,w=143,h=25}
		end
	-- category4 / 380武器素材
		if ica == 37 then
			flowLTWH = {l=670,t=100,w=143,h=25}
		end

	--ボタン
		local create_CTRL = asmmenu_list:CreateOrGetControl("button", rtCtrlBTN[ica].name, rtCtrlBTN[ica].left, rtCtrlBTN[ica].top, rtCtrlBTN[ica].w, rtCtrlBTN[ica].h)
		tolua.cast(create_CTRL, "ui::CButton")
		create_CTRL:SetEventScript(ui.LBUTTONDOWN, rtCtrlBTN[ica].fnc)
		create_CTRL:SetText(rtCtrlBTN[ica].body)

	--check box / team
		local create_CTRL	= asmmenu_list:CreateOrGetControl("checkbox", rtCtrlCHKT[ica].name, rtCtrlCHKT[ica].left, rtCtrlCHKT[ica].top, rtCtrlCHKT[ica].w, rtCtrlCHKT[ica].h)
		tolua.cast(create_CTRL, "ui::CCheckBox");
		create_CTRL:SetClickSound("button_click_big");
		create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
		create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
		create_CTRL:SetOverSound("button_over");
		create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrlCHKT[ica].fnc);
		create_CTRL:SetUserValue("NUMBER", 1);

		if tAdd.tchk == true then
			create_CTRL:SetCheck(1)
		else
			create_CTRL:SetCheck(0)
		end

	--check box / private
		local create_CTRL	= asmmenu_list:CreateOrGetControl("checkbox", rtCtrlCHKP[ica].name, rtCtrlCHKP[ica].left, rtCtrlCHKP[ica].top, rtCtrlCHKP[ica].w, rtCtrlCHKP[ica].h)
		tolua.cast(create_CTRL, "ui::CCheckBox");
		create_CTRL:SetClickSound("button_click_big");
		create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
		create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
		create_CTRL:SetOverSound("button_over");
		create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrlCHKP[ica].fnc);
		create_CTRL:SetUserValue("NUMBER", 1);

		if tAdd.pchk == true then
				create_CTRL:SetCheck(1)
		else
				create_CTRL:SetCheck(0)
		end
	end

		-- category6 / フリー１～１０
		flowLTWH = {l=25,t=455,w=65,h=25}
		for icb = 48,67 do
			if g.settings[1].teamflg == true then
				tAdd.tchk = g.settingsCommon[icb].teamflg
				tAdd.pchk = g.settingsCommon[icb].privateflg
				tAdd.body = g.settingsCommon[icb].date
				tAdd.com  = g.settingsCommon[icb].com
			else
				tAdd.tchk = g.settings[icb].teamflg
				tAdd.pchk = g.settings[icb].privateflg
				tAdd.body = g.settings[icb].date
				tAdd.com  = g.settings[icb].com
			end 

			rtCtrlEDITD[icb] = {name="ASM_".. g.settings[icb].name .."_EDITD";	left=flowLTWH.l;		top=flowLTWH.t;		w=flowLTWH.w;		h=flowLTWH.h;	body=tAdd.body;		fnc="ADD_FREETXT"..icb -47};
			rtCtrlEDITA[icb] = {name="ASM_".. g.settings[icb].name .."_EDITA";	left=flowLTWH.l+70;		top=flowLTWH.t;		w=flowLTWH.w+220;	h=flowLTWH.h;	body=tAdd.com;		fnc="ADD_FREETXT"..icb-47};
			rtCtrlCHKT[icb]  = {name="ASM_".. g.settings[icb].name .."_CHKT";	left=flowLTWH.l+360;	top=flowLTWH.t-4;	w=30;				h=30;			body=tAdd.tchk;		fnc=""};
			rtCtrlCHKP[icb]  = {name="ASM_".. g.settings[icb].name .."_CHKP";	left=flowLTWH.l+385;	top=flowLTWH.t-4;	w=30;				h=30;			body=tAdd.pchk;		fnc=""};
			rtCtrlBTN[icb]   = {name="ASM_".. g.settings[icb].name .."_BTN";	left=flowLTWH.l+328;	top=flowLTWH.t-2;	w=30;				h=flowLTWH.h+2;	body="C";			fnc="ADD_FREETXTCLEAR"..icb -47};
			flowLTWH.t = flowLTWH.t + 30

		-- category7 / フリー１１～２０
			if icb == 57 then
				flowLTWH = {l=455,t=455,w=65,h=25}
			end

	--check box / team
		local create_CTRL	= asmmenu_list:CreateOrGetControl("checkbox", rtCtrlCHKT[icb].name, rtCtrlCHKT[icb].left, rtCtrlCHKT[icb].top, rtCtrlCHKT[icb].w, rtCtrlCHKT[icb].h)
		tolua.cast(create_CTRL, "ui::CCheckBox");
		create_CTRL:SetClickSound("button_click_big");
		create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
		create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
		create_CTRL:SetOverSound("button_over");
		create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrlCHKT[icb].fnc);
		create_CTRL:SetUserValue("NUMBER", 1);
		if tAdd.tchk == true then
			create_CTRL:SetCheck(1)
		else
			create_CTRL:SetCheck(0)
		end


	--check box / private
		create_CTRL	= asmmenu_list:CreateOrGetControl("checkbox", rtCtrlCHKP[icb].name, rtCtrlCHKP[icb].left, rtCtrlCHKP[icb].top, rtCtrlCHKP[icb].w, rtCtrlCHKP[icb].h)
		tolua.cast(create_CTRL, "ui::CCheckBox");
		create_CTRL:SetClickSound("button_click_big");
		create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
		create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
		create_CTRL:SetOverSound("button_over");
		create_CTRL:SetEventScript(ui.LBUTTONUP, rtCtrlCHKP[icb].fnc);
		create_CTRL:SetUserValue("NUMBER", 1);
		if tAdd.pchk == true then
			create_CTRL:SetCheck(1)
		else
			create_CTRL:SetCheck(0)
		end

	--item ID
		create_CTRL = asmmenu_list:CreateOrGetControl("edit", rtCtrlEDITD[icb].name, rtCtrlEDITD[icb].left, rtCtrlEDITD[icb].top, rtCtrlEDITD[icb].w, rtCtrlEDITD[icb].h)
		tolua.cast(create_CTRL, "ui::CEditControl");
		create_CTRL:MakeTextPack();
		create_CTRL:SetTextAlign("center", "center");
		create_CTRL:SetFontName("white_16_ol");
		create_CTRL:SetSkinName("systemmenu_vertical");
		create_CTRL:SetEventScript(ui.DROP,rtCtrlEDITD[icb].fnc)
		create_CTRL:SetText(rtCtrlEDITD[icb].body)

	--item Name
		create_CTRL= asmmenu_list:CreateOrGetControl("edit", rtCtrlEDITA[icb].name, rtCtrlEDITA[icb].left, rtCtrlEDITA[icb].top, rtCtrlEDITA[icb].w, rtCtrlEDITA[icb].h)
		tolua.cast(create_CTRL, "ui::CEditControl");
		create_CTRL:MakeTextPack();
		create_CTRL:SetTextAlign("left", "left");
		create_CTRL:SetFontName("white_16_ol");
		create_CTRL:SetSkinName("systemmenu_vertical");
		create_CTRL:SetEventScript(ui.DROP,rtCtrlEDITD[icb].fnc)
		create_CTRL:SetText(rtCtrlEDITA[icb].body)

	--clear
		local create_CTRL = asmmenu_list:CreateOrGetControl("button", rtCtrlBTN[icb].name, rtCtrlBTN[icb].left, rtCtrlBTN[icb].top, rtCtrlBTN[icb].w, rtCtrlBTN[icb].h)
		tolua.cast(create_CTRL, "ui::CButton")
		create_CTRL:SetEventScript(ui.LBUTTONDOWN, rtCtrlBTN[icb].fnc)
		create_CTRL:SetText(rtCtrlBTN[icb].body)
	end

	create_CTRL = asmmenu_list:CreateOrGetControl("button", "ASM_SAVE_BTN", 700, 35, 165, 30)
	tolua.cast(create_CTRL, "ui::CButton")
	create_CTRL:SetEventScript(ui.LBUTTONDOWN, "ASM_SETTING_SAVE")
	create_CTRL:SetText("保存して終了")

	create_CTRL = asmmenu_list:CreateOrGetControl("button", "ASM_CLOSE_BTN", 700, 0, 165, 30)
	tolua.cast(create_CTRL, "ui::CButton")
	create_CTRL:SetEventScript(ui.LBUTTONDOWN, "AUTOSAVEMONEY_CLOSE_SETTING_FRAME")
	create_CTRL:SetText("保存しないで終了")


	create_CTRL	= asmmenu_list:CreateOrGetControl("richtext", "ASM_CATEGORY1_LBL", 25, 83, 20, 20)
	tolua.cast(create_CTRL, "ui::CRichText");
	create_CTRL:SetText("{@st43}{s12}" .. "■よく使うもの 　     チーム/個別　 ■宝石・鉱石類　　　　チーム/個別　　　　　　　　　　 　　チーム/個別　 ■380武器素材  　　　チーム/個別" .. "{/}");

	create_CTRL	= asmmenu_list:CreateOrGetControl("richtext", "ASM_CATEGORY2_LBL", 25, 438, 20, 20)
	tolua.cast(create_CTRL, "ui::CRichText");
	create_CTRL:SetText("{@st43}{s12}" .. "■フリー　  ※左のID欄に入力 or インベントリからＤ＆Ｄ　　チーム/個別　　　　　　　　　　　　　　　　　　　　　 　　　　　　　　 チーム/個別" .. "{/}");


	local obj_picture = frame:CreateOrGetControl("picture", "ASM_OBJ_PICTURE", 655, 52, 45, 50);
	tolua.cast(obj_picture, "ui::CPicture");
	obj_picture:SetEventScript(ui.DROP,"TESTMSG")
	obj_picture:SetImage("emoticon_0023");

	local title = GET_CHILD(bg_gbox, "title", "ui::CRichText");
	title:SetText("{@st68b}{s18}addon : Autosave Money ver.1.2.7 Settings {/}{/}");
	asmmenu_gbox:ShowWindow(1);

end	

-- 共通設定のトグルチェック --------------------------------------------------------------------
function ASM_TOGGLECHECKT1(frame) ASM_TGGLECHECK(frame, 1,"T","P") end
function ASM_TOGGLECHECKP1(frame) ASM_TGGLECHECK(frame, 1,"P","T") end
function ASM_TOGGLECHECKT2(frame) ASM_TGGLECHECK(frame, 2,"T","P") end
function ASM_TOGGLECHECKP2(frame) ASM_TGGLECHECK(frame, 2,"P","T") end

function ASM_TGGLECHECK(frame,ctrlName,flgA,flgB)
	if GET_CHILD(frame, "ASM_" .. g.settings[ctrlName].name .. "_CHK" .. flgA):IsChecked() == 1 then
		GET_CHILD(frame, "ASM_" .. g.settings[ctrlName].name .. "_CHK" .. flgB):SetCheck(0)
		if flgA == "T" then
			g.settings[ctrlName].teamflg = true
		else
			g.settings[ctrlName].teamflg = false
		end
	elseif GET_CHILD(frame, "ASM_" .. g.settings[ctrlName].name .. "_CHK" .. flgA):IsChecked() == 0 then
		GET_CHILD(frame, "ASM_" .. g.settings[ctrlName].name .. "_CHK" .. flgB):SetCheck(1)
		if flgA == "T" then
			g.settings[ctrlName].teamflg = false
		else
			g.settings[ctrlName].teamflg = true
		end
	end

	if g.settings[1].teamflg == true then
		--ロード：共通設定
			AUTOSAVEMONEY_COMMONLOAD()
			AUTOSAVEMONEY_ADDITEMTABLE()

			for i=7,67 do
				if g.settingsCommon[i].teamflg == true then
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKT"):SetCheck(1)
				else
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKT"):SetCheck(0)
				end

				if g.settingsCommon[i].privateflg == true then
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKP"):SetCheck(1)
				else
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKP"):SetCheck(0)
				end

				if i >= 48 then
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_EDITD"):SetText(g.settingsCommon[i].date)
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_EDITA"):SetText(g.settingsCommon[i].com)
				end
			end
			ui.MsgBox("[共通]設定を読み込みました")

	else
		--ロード：個人設定
			AUTOSAVEMONEY_PRIVATELOAD()
			AUTOSAVEMONEY_ADDITEMTABLE()

			for i=7,67 do
				if g.settings[i].teamflg == true then
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKT"):SetCheck(1)
				else
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKT"):SetCheck(0)
				end

				if g.settings[i].privateflg == true then
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKP"):SetCheck(1)
				else
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_CHKP"):SetCheck(0)
				end

				if i >= 48 then
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_EDITD"):SetText(g.settings[i].date)
					GET_CHILD(frame, "ASM_" .. g.settings[i].name .. "_EDITA"):SetText(g.settings[i].com)
				end
			end
			ui.MsgBox("[個人]設定を読み込みました")
	end

end

--アイテムＩＤと名称を返す
function GET_ITEMID(parent)
	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon()
	local iconInfo = liftIcon:GetInfo()
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());

	local itemID = {Name=obj.Name; ClassID=obj.ClassID;}
	
	return itemID;
end

-- Ｄ＆Ｄ処理 -------------------------------------------------------------------------
function ADD_FREETXT1(frame,parent) EDIT_TXTBOX(frame,parent,1) end
function ADD_FREETXT2(frame,parent) EDIT_TXTBOX(frame,parent,2) end
function ADD_FREETXT3(frame,parent) EDIT_TXTBOX(frame,parent,3) end
function ADD_FREETXT4(frame,parent) EDIT_TXTBOX(frame,parent,4) end
function ADD_FREETXT5(frame,parent) EDIT_TXTBOX(frame,parent,5) end
function ADD_FREETXT6(frame,parent) EDIT_TXTBOX(frame,parent,6) end
function ADD_FREETXT7(frame,parent) EDIT_TXTBOX(frame,parent,7) end
function ADD_FREETXT8(frame,parent) EDIT_TXTBOX(frame,parent,8) end
function ADD_FREETXT9(frame,parent) EDIT_TXTBOX(frame,parent,9) end
function ADD_FREETXT10(frame,parent) EDIT_TXTBOX(frame,parent,10) end
function ADD_FREETXT11(frame,parent) EDIT_TXTBOX(frame,parent,11) end
function ADD_FREETXT12(frame,parent) EDIT_TXTBOX(frame,parent,12) end
function ADD_FREETXT13(frame,parent) EDIT_TXTBOX(frame,parent,13) end
function ADD_FREETXT14(frame,parent) EDIT_TXTBOX(frame,parent,14) end
function ADD_FREETXT15(frame,parent) EDIT_TXTBOX(frame,parent,15) end
function ADD_FREETXT16(frame,parent) EDIT_TXTBOX(frame,parent,16) end
function ADD_FREETXT17(frame,parent) EDIT_TXTBOX(frame,parent,17) end
function ADD_FREETXT18(frame,parent) EDIT_TXTBOX(frame,parent,18) end
function ADD_FREETXT19(frame,parent) EDIT_TXTBOX(frame,parent,19) end
function ADD_FREETXT20(frame,parent) EDIT_TXTBOX(frame,parent,20) end

function EDIT_TXTBOX(frame,parent,editNo)
	local itemID		= GET_ITEMID(parent)
	local bg_gbox		= GET_CHILD(parent:GetTopParentFrame(), "bg", "ui::CGroupBox");
	local asmmenu_list	= GET_CHILD(bg_gbox, "asmmenu_gbox", "ui::CGroupBox");

	local txtBoxName = "ASM_Free".. editNo .. "_EDITD"
	local editName = GET_CHILD(asmmenu_list, txtBoxName, "ui::CEditControl")
	editName:SetText(itemID.ClassID)

	editName = GET_CHILD(asmmenu_list, "ASM_Free" .. editNo .. "_EDITA", "ui::CEditControl")
	editName:SetText(itemID.Name)

end

-- クリア処理 -------------------------------------------------------------------------
function ADD_FREETXTCLEAR1(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,1) end
function ADD_FREETXTCLEAR2(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,2) end
function ADD_FREETXTCLEAR3(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,3) end
function ADD_FREETXTCLEAR4(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,4) end
function ADD_FREETXTCLEAR5(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,5) end
function ADD_FREETXTCLEAR6(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,6) end
function ADD_FREETXTCLEAR7(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,7) end
function ADD_FREETXTCLEAR8(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,8) end
function ADD_FREETXTCLEAR9(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,9) end
function ADD_FREETXTCLEAR10(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,10) end
function ADD_FREETXTCLEAR11(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,11) end
function ADD_FREETXTCLEAR12(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,12) end
function ADD_FREETXTCLEAR13(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,13) end
function ADD_FREETXTCLEAR14(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,14) end
function ADD_FREETXTCLEAR15(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,15) end
function ADD_FREETXTCLEAR16(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,16) end
function ADD_FREETXTCLEAR17(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,17) end
function ADD_FREETXTCLEAR18(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,18) end
function ADD_FREETXTCLEAR19(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,19) end
function ADD_FREETXTCLEAR20(frame,parent) EDIT_TXTBOXCLEAR(frame,parent,20) end

function EDIT_TXTBOXCLEAR(frame,parent,editNo)
	local bg_gbox = GET_CHILD(parent:GetTopParentFrame(), "bg", "ui::CGroupBox");
	local asmmenu_list = GET_CHILD(bg_gbox, "asmmenu_gbox", "ui::CGroupBox");

	local txtBoxName = "ASM_Free".. editNo .. "_EDITD"

	local editName = GET_CHILD(asmmenu_list, txtBoxName, "ui::CEditControl")
	editName:SetText(0)

	editName = GET_CHILD(asmmenu_list, "ASM_Free" .. editNo .. "_EDITA", "ui::CEditControl")
	editName:SetText("フリー"..editNo)

end

--所持金 -------------------------------------------------------------------------
function GET_TOTAL_MONEY()
    local Cron = 0;
    local invItem = session.GetInvItemByName('Vis');
    if invItem ~= nil then
        Cron = invItem.count;
    end

    return Cron;
 end

function ASM_SETTING_CLOSE(frame)
	AUTOSAVEMONEY_CLOSE_SETTING_FRAME()
end

--保存設定 -------------------------------------------------------------------------
function ASM_SETTING_SAVE(frame)

	--共通
	if GET_CHILD(frame, "ASM_".. g.settings[1].name .."_CHKT"):IsChecked() == 1 then
		g.settings[1].teamflg = true
		AUTOSAVEMONEY_PRIVATESAVE()

		for i = 3,67 do
			if i == 5 or i == 6 then
				if tonumber(GET_CHILD(frame, "ASM_".. g.settingsCommon[i].name .."_EDITD"):GetText()) >= 1 then
					g.settingsCommon[i].date	=	tonumber(GET_CHILD(frame, "ASM_".. g.settingsCommon[i].name .."_EDITD"):GetText())
				end
			else
				if GET_CHILD(frame, "ASM_".. g.settingsCommon[i].name .."_CHKT"):IsChecked() == 1 then
					g.settingsCommon[i].teamflg = true
				else
					g.settingsCommon[i].teamflg = false
				end
	
				if i >= 7 then
					if GET_CHILD(frame, "ASM_".. g.settingsCommon[i].name .."_CHKP"):IsChecked() == 1 then
						g.settingsCommon[i].privateflg = true
					else
						g.settingsCommon[i].privateflg = false
					end
				end
				
				if i >= 48 then
					if tonumber(GET_CHILD(frame, "ASM_".. g.settingsCommon[i].name .."_EDITD"):GetText()) >= 0 then
						g.settingsCommon[i].date	= tonumber(GET_CHILD(frame, "ASM_".. g.settingsCommon[i].name .."_EDITD"):GetText())
						g.settingsCommon[i].com		= tostring(GET_CHILD(frame, "ASM_".. g.settingsCommon[i].name .."_EDITA"):GetText())
					end
				end
			end
		end
	
		AUTOSAVEMONEY_COMMONSAVE()
		AUTOSAVEMONEY_ADDITEMTABLE()
		ui.MsgBox("AutosaveMoneyの[共通]設定を保存しました")
		CHAT_SYSTEM("AutosaveMoneyの[共通]設定を保存しました")

	else
	--個別
		for i = 3,67 do
			if i == 5 or i == 6 then
				if tonumber(GET_CHILD(frame, "ASM_".. g.settings[i].name .."_EDITD"):GetText()) >= 1 then
					g.settings[i].date	=	tonumber(GET_CHILD(frame, "ASM_".. g.settings[i].name .."_EDITD"):GetText())
				end
			else

				if GET_CHILD(frame, "ASM_".. g.settings[i].name .."_CHKT"):IsChecked() == 1 then
					g.settings[i].teamflg = true
				else
					g.settings[i].teamflg = false
				end
	
				if i >= 7 then
					if GET_CHILD(frame, "ASM_".. g.settings[i].name .."_CHKP"):IsChecked() == 1 then
						g.settings[i].privateflg = true
					else
						g.settings[i].privateflg = false
					end
				end
				
				if i >= 48 then
					if tonumber(GET_CHILD(frame, "ASM_".. g.settings[i].name .."_EDITD"):GetText()) >= 0 then
						g.settings[i].date	= tonumber(GET_CHILD(frame, "ASM_".. g.settings[i].name .."_EDITD"):GetText())
						g.settings[i].com		= tostring(GET_CHILD(frame, "ASM_".. g.settings[i].name .."_EDITA"):GetText())
					end
				end
			end
		end

		g.settings[1].teamflg = false
		AUTOSAVEMONEY_PRIVATESAVE()
		AUTOSAVEMONEY_ADDITEMTABLE()
		ui.MsgBox("AutosaveMoneyの[個別]設定を保存しました")
		CHAT_SYSTEM("AutosaveMoneyの[個別]設定を保存しました")

	end

	AUTOSAVEMONEY_CLOSE_SETTING_FRAME()
end