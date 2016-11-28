CHAT_SYSTEM("MARKET SHOW LEVEL JP v1.0.4 Ex loaded!");

local itemSymbol = {
    [0] = "",  		-- Normal
    [1] = "×",		-- 0.50 over
    [2] = "▲",		-- 0.60 over
    [3] = "●",		-- 0.80 over
    [4] = "★",		-- 0.90 over
    [5] = "☆",		-- 1.00 over
};

local propList = {};
propList.MHP           = {name = "HP";	max = 2283;	vcolor="FFD700"; visibleFlg=1; pNo =  5;};	-- visibleFlag = 1表示 0非表示
propList.RHP           = {name = "HPR";	max = 56;	vcolor="FFD700"; visibleFlg=1; pNo = 15;};
propList.MSP           = {name = "SP";	max = 447;	vcolor="6495ED"; visibleFlg=1; pNo = 16;};
propList.RSP           = {name = "SPR ";max = 42;	vcolor="6495ED"; visibleFlg=1; pNo =  6;};
propList.PATK          = {name = "物攻";max = 126;	vcolor="FF6347"; visibleFlg=1; pNo =  7;};
propList.ADD_MATK      = {name = "魔攻";max = 126;	vcolor="DA70D6"; visibleFlg=1; pNo =  8;};
propList.ADD_DEF       = {name = "物防";max = 110;	vcolor="CD853F"; visibleFlg=1; pNo =  1;};
propList.ADD_MDEF      = {name = "魔防";max = 110;	vcolor="DDA0DD"; visibleFlg=1; pNo =  2;};
propList.ADD_MHR       = {name = "増幅";max = 126;	vcolor="DA70D6"; visibleFlg=1; pNo =  9;};
propList.CRTATK        = {name = "ｸﾘ攻";max = 189;	vcolor="98FB98"; visibleFlg=1; pNo = 10;};
propList.CRTHR         = {name = "ｸﾘ発";max = 14;	vcolor="98FB98"; visibleFlg=1; pNo = 11;};
propList.CRTDR         = {name = "ｸﾘ抵";max = 14;	vcolor="98FB98"; visibleFlg=1; pNo = 96;};
propList.BLK           = {name = "ブロ";max = 14;	vcolor="B0C4DE"; visibleFlg=1; pNo = 13;};
propList.ADD_HR        = {name = "命中";max = 14;	vcolor="B0C4DE"; visibleFlg=1; pNo = 97;};
propList.ADD_DR        = {name = "回避";max = 14;	vcolor="B0C4DE"; visibleFlg=1; pNo = 98;};
propList.ADD_FIRE      = {name = "炎攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 26;};
propList.ADD_ICE       = {name = "氷攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 27;};
propList.ADD_POISON    = {name = "毒攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 28;};
propList.ADD_LIGHTNING = {name = "雷攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 29;};
propList.ADD_EARTH     = {name = "地攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 30;};
propList.ADD_SOUL      = {name = "霊攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 31;};
propList.ADD_HOLY      = {name = "聖攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 32;};
propList.ADD_DARK      = {name = "闇攻";max = 99;	vcolor="FED0E0"; visibleFlg=1; pNo = 33;};
propList.RES_FIRE      = {name = "炎防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 18;};
propList.RES_ICE       = {name = "氷防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 19;};
propList.RES_POISON    = {name = "毒防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 20;};
propList.RES_LIGHTNING = {name = "雷防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 21;};
propList.RES_EARTH     = {name = "地防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 22;};
propList.RES_SOUL      = {name = "霊防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 23;};
propList.RES_HOLY      = {name = "聖防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 24;};
propList.RES_DARK      = {name = "闇防";max = 84;	vcolor="BDB76B"; visibleFlg=1; pNo = 25;};
propList.MSPD          = {name = "移動";max = 1;	vcolor="FFFFFF"; visibleFlg=1; pNo =  4;};
propList.SR            = {name = "広攻";max = 1;	vcolor="FFFFFF"; visibleFlg=1; pNo =  3;};
propList.SDR           = {name = "広防";max = 4;	vcolor="FFFFFF"; visibleFlg=1; pNo = 99;};
propList.ADD_EL1 = {name = "属攻";max = 99;	vcolor="FED0E0"; visibleFlg=0; pNo = 100;};
propList.ADD_EL2 = {name = "属攻";max = 198;	vcolor="FED0E0"; visibleFlg=0; pNo = 101;};
propList.ADD_EL3 = {name = "属攻";max = 297;	vcolor="FED0E0"; visibleFlg=0; pNo = 102;};


local jobList = {};
propList.MHP           = {name = "HP";	max = 2283;	vcolor="FFD700"; visibleFlg=1; pNo =  5;};	-- visibleFlag = 1表示 0非表示
propList.RHP           = {name = "HPR";	max = 56;	vcolor="FFD700"; visibleFlg=1; pNo = 15;};
propList.MSP           = {name = "SP";	max = 447;	vcolor="6495ED"; visibleFlg=1; pNo = 16;};
propList.RSP           = {name = "SPR ";max = 42;	vcolor="6495ED"; visibleFlg=1; pNo =  6;};
propList.PATK          = {name = "物攻";max = 126;	vcolor="FF6347"; visibleFlg=1; pNo =  7;};
propList.ADD_MATK      = {name = "魔攻";max = 126;	vcolor="DA70D6"; visibleFlg=1; pNo =  8;};
propList.ADD_DEF       = {name = "物防";max = 110;	vcolor="CD853F"; visibleFlg=1; pNo =  1;};
propList.ADD_MDEF      = {name = "魔防";max = 110;	vcolor="DDA0DD"; visibleFlg=1; pNo =  2;};
propList.ADD_MHR       = {name = "増幅";max = 126;	vcolor="DA70D6"; visibleFlg=1; pNo =  9;};
















function MARKETSHOWLEVEL_ON_INIT(addon, frame)
	_G["ON_MARKET_ITEM_LIST"] = ON_MARKET_ITEM_LIST_HOOKED;
end


function GetGemInfo(itemObj)
	local gemInfo = "";
	local fn = GET_FULL_NAME_OLD or GET_FULL_NAME;

	local socketId;
	local rstLevel;
	local gemName;
	local exp;
	local color="";
	local gemStr="";

	for i = 0, 4 do

		socketId = itemObj["Socket_Equip_" .. i];
		rstLevel = itemObj["Socket_JamLv_" .. i];
		exp = itemObj["SocketItemExp_" .. i];

--643501

		if socketId > 0 then
			if #gemInfo > 0 then
				gemInfo = gemInfo..",";
			end

			local obj = GetClassByType("Item", socketId);
			gemName = fn(obj);
			local gemLevel = 0;

			if exp >= 27014700 then
				gemLevel = 10;
			elseif exp >= 5414700 then
				gemLevel = 9;
			elseif exp >= 1094700 then
				gemLevel = 8;
			elseif exp >= 230700 then
				gemLevel = 7;
			elseif exp >= 57900 then
				gemLevel = 6;
			elseif exp >= 14700 then
				gemLevel = 5;
			elseif exp >= 3900 then
				gemLevel = 4;
			elseif exp >= 1200 then
				gemLevel = 3;
			elseif exp >= 300 then
				gemLevel = 2;
			else
				gemLevel = 1;
			end

			if gemLevel <= rstLevel then
				gemInfo = gemInfo .. "{#FF7F50}{ol}Lv" .. gemLevel .. ":" .. GET_ITEM_IMG_BY_CLS(obj, 22) .. "{/}{/}";
			else
				gemInfo = gemInfo .. "{#FFFFFF}{ol}Lv" .. gemLevel .. ":" .. GET_ITEM_IMG_BY_CLS(obj, 22) .. "{/}{/}";
			end

		end
	end


	if #gemInfo > 0 then
		gemInfo = "{nl}" .. gemInfo;
	end

	return gemInfo;

end

function GetHatProp(itemObj)
	local prop = "";
	local propNo1 = 0;
	local propNo2 = 0;
	local propNo3 = 0;
	local propTmp1 = "";
	local propTmp2 = "";
	local propTmp3 = "";
	local elAtk1 = 0;
	local elAtk2 = 0;
	local elAtk3 = 0;
	local elAtks = ""; 
	local elFlgs = 0;
	local elMax = 0;


	for i = 1 , 3 do
		local propName	= "";
		local propValue = 0;
		local propTmp	="";
		local propNameStr = "HatPropName_"..i;
		local propValueStr = "HatPropValue_"..i;
		if itemObj[propValueStr] ~= 0 and itemObj[propNameStr] ~= "None" then

			propName = itemObj[propNameStr];
			propValue = itemObj[propValueStr];

			propValueSymboled = GetItemValueSymbol(propName, propValue, propList[propName].max);
			propTmp = "{#" .. propList[propName].vcolor .. "}" .. propList[propName].name .. propValue .. propValueSymboled .. " {/}";
			if propList[propName].visibleFlg == "0" then propTmp = "" end;

			-- ３つのtmpに振り分け
			if i==1 then
				propNo1 , propTmp1 = propList[propName].pNo , propTmp;
				if propList[propName].max==99 then elAtk1 , elFlgs = propValue , 1 end;
			elseif i==2 then
				propNo2 , propTmp2 = propList[propName].pNo , propTmp;
				if propList[propName].max==99 then elAtk2 , elFlgs = propValue , elFlgs+2 end;
			elseif i==3 then
				propNo3 , propTmp3 = propList[propName].pNo , propTmp;
				if propList[propName].max==99 then elAtk3 , elFlgs = propValue , elFlgs+4 end;
			end
		end

	end


	-- ３つのpNoを比較して昇順
    if propNo1 > propNo2 then propNo1 , propNo2 , propTmp1 , propTmp2 = propNo2 , propNo1 , propTmp2 , propTmp1 end;
    if propNo2 > propNo3 then propNo2 , propNo3 , propTmp2 , propTmp3 = propNo3 , propNo2 , propTmp3 , propTmp2 end;
    if propNo1 > propNo2 then propNo1 , propNo2 , propTmp1 , propTmp2 = propNo2 , propNo1 , propTmp2 , propTmp1 end;
	prop = "{ol}" .. propTmp1 ..propTmp2 .. propTmp3 .. "{/}";


	-- 属性攻撃の合計
	elAtks = elAtk1 + elAtk2 + elAtk3;

	--属性攻撃の数に応じて最大値を設定し、記号計算に引渡し
	if elFlgs == 3 or elFlgs == 5 or elFlgs == 6 then
		elMax = 198
--		propValueSymboled = GetItemValueSymbol("", elAtks, propList["ADD_EL2"].max);
	elseif elFlgs == 7 then
		elMax = 297
--		propValueSymboled = GetItemValueSymbol("", elAtks, propList["ADD_EL3"].max);
	end
	propValueSymboled = GetItemValueSymbol("", elAtks, elMax);

	--フラグに応じて表示の有無
	if elFlgs == 0 or elFlgs == 1 or elFlgs == 2 or elFlgs == 4 then
		elAtks = ""	
	else
		elAtks = "{#FED0E0}{ol}" .. "(属攻" .. elAtks .. "/" .. elMax .. propValueSymboled .. "){/}{/}";
	end


	if #prop > 0 then prop = "{nl}" .. prop .. elAtks end;

	return prop;

end

function GetItemValueSymbol(propname,value, max)
	local index = 0;

	if propname == "MSPD" or propname == "SR" or propname == "SDR" then
		index = 0
	else
		if value == max then
			index = 5
		elseif value > (max * 0.90) then
			index = 4
		elseif value > (max * 0.80) then
			index = 3
		elseif value > (max * 0.60) then
			index = 2
		elseif value > (max * 0.40) then
			index = 1
		elseif value > (max * 0.00) then
			index = 0
		end
	end

	return itemSymbol[index]
end


function ON_MARKET_ITEM_LIST_HOOKED(frame, msg, argStr, argNum)
	if frame:IsVisible() == 0 then
		return;
	end

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	local count = session.market.GetItemCount();
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());


		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_item_detail");
		ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
		ctrlSet:EnableHitTestSet(1);
		ctrlSet:SetUserValue("DETAIL_ROW", i);

		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());

		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		pic:SetImage(itemObj.Icon);

		local name = ctrlSet:GetChild("name");

		local itemLevel = GET_ITEM_LEVEL(itemObj);
		local itemGroup = itemObj.GroupName;
		

		if itemGroup == "Weapon" or itemGroup == "SubWeapon" then
			local gemInfo = GetGemInfo(itemObj);
			local socketInfo = "[" .. itemObj["MaxSocket"] .. "]";
			if socketInfo == "[0]" then socketInfo = "" end;
			name:SetTextByKey("value", GET_FULL_NAME(itemObj) .. socketInfo .. gemInfo);


		elseif itemGroup == "Armor" then
			local gemInfo = GetGemInfo(itemObj);
			local prop = GetHatProp(itemObj);
			local socketInfo = "[" .. itemObj["MaxSocket"] .. "]";
			if socketInfo == "[0]" then socketInfo = "" end;
			name:SetTextByKey("value", GET_FULL_NAME(itemObj) .. socketInfo .. prop .. gemInfo);



		elseif itemGroup == "Gem" then
			local gemSkill = itemObj["ClassName"] .. " - " .. itemObj["EnableEquipParts"];
			gemSkill = string.sub(itemObj["ClassName"],5) .. " - " .. itemObj["EnableEquipParts"];
			gemSkill = string.gsub(gemSkill,"_"," ");
		
			name:SetTextByKey("value", "Lv".. itemLevel .. ":" .. GET_FULL_NAME(itemObj) .. "{nl}" .. gemSkill);



--CHAT_SYSTEM(GET_FULL_NAME(GetClassByType("Item", 643506)));
		elseif itemGroup == "Card" then
			name:SetTextByKey("value", "Lv".. itemLevel .. ":" .. GET_FULL_NAME(itemObj));


		elseif (itemObj.ClassName == "Scroll_SkillItem") then
			local skillClass = GetClassByType("Skill", itemObj.SkillType);
			name:SetTextByKey("value", "Lv".. itemObj.SkillLevel .. " " .. skillClass.Name .. ":" .. GET_FULL_NAME(itemObj));
		else
			name:SetTextByKey("value", GET_FULL_NAME(itemObj));
		end
		name = tolua.cast(name, 'ui::CRichText');
		name:SetTextAlign("left", "center");

-- add code end

		local count = ctrlSet:GetChild("count");
		count:SetTextByKey("value", marketItem.count);
		
		local level = ctrlSet:GetChild("level");
		level:SetTextByKey("value", itemObj.UseLv);

		local price = ctrlSet:GetChild("price");
		price:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
		price:SetUserValue("Price", marketItem.sellPrice);
		if cid == marketItem:GetSellerCID() then
			local button_1 = ctrlSet:GetChild("button_1");
			button_1:SetEnable(0);

			local btnmargin = 639
			if USE_MARKET_REPORT == 1 then
				local button_report = ctrlSet:GetChild("button_report");
				button_report:SetEnable(0);
				btnmargin = 720
			end

			local btn = ctrlSet:CreateControl("button", "DETAIL_ITEM_" .. i, btnmargin, 8, 100, 50);
			btn = tolua.cast(btn, "ui::CButton");
			btn:ShowWindow(1);
			btn:SetText("{@st41b}" .. ClMsg("Cancel"));
			btn:SetTextAlign("center", "center");

			if notUseAnim ~= true then
				btn:SetAnimation("MouseOnAnim", "btn_mouseover");
				btn:SetAnimation("MouseOffAnim", "btn_mouseoff");
			end
			btn:UseOrifaceRectTextpack(true)
			btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
			btn:SetEventScriptArgString(ui.LBUTTONUP,marketItem:GetMarketGuid());
			btn:SetSkinName("test_pvp_btn");
			local totalPrice = ctrlSet:GetChild("totalPrice");
			totalPrice:SetTextByKey("value", 0);
		else
			local btnmargin = 639
			if USE_MARKET_REPORT == 1 then
				btnmargin = 560
			end
			local numUpDown = ctrlSet:CreateControl("numupdown", "DETAIL_ITEM_" .. i, btnmargin, 20, 100, 30);
			numUpDown = tolua.cast(numUpDown, "ui::CNumUpDown");
			numUpDown:SetFontName("white_18_ol");
			numUpDown:MakeButtons("btn_numdown", "btn_numup", "editbox");
			numUpDown:ShowWindow(1);
			numUpDown:SetMaxValue(marketItem.count);
			numUpDown:SetMinValue(1);
			numUpDown:SetNumChangeScp("MARKET_CHANGE_COUNT");
			numUpDown:SetClickSound('button_click_chat');
			numUpDown:SetNumberValue(1)

			local totalPrice = ctrlSet:GetChild("totalPrice");
				totalPrice:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
				totalPrice:SetUserValue("Price", marketItem.sellPrice);
		end		
	end

	itemlist:RealignItems();
	GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, false, true);

	local maxPage = math.ceil(session.market.GetTotalCount() / MARKET_ITEM_PER_PAGE);
	local curPage = session.market.GetCurPage();
	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage);

	if nil ~= argNum and  argNum == 1 then
		MARGET_FIND_PAGE(frame, session.market.GetCurPage());
	end
end
