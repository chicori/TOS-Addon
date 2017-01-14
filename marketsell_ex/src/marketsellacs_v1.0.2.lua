local addonName = "MARKETSELLEX";
local addonNameLower = string.lower(addonName);
local author = "CHICORI";

_G["ADDONS"] = _G["ADDONS"] or {};
_G["ADDONS"][author] = _G["ADDONS"][author] or {};
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {};
local g = _G["ADDONS"][author][addonName];

local acutil = require('acutil');

CHAT_SYSTEM(string.format("%s.lua is loaded", addonName));

function MARKETSELLEX_ON_INIT(addon, frame)

	g.addon = addon;
	g.frame = frame;

	acutil.setupHook(ON_MARKET_SELL_LIST_HOOKED, "ON_MARKET_SELL_LIST");
	acutil.setupHook(MARKET_SELL_REGISTER_HOOKED, "MARKET_SELL_REGISTER");

end

function GET_TRANS_PRICE(splitprice, flg)
--flg 1 = comma : 1000 -> 1,000
--    2 = K/M/G : 1000 -> 1k

local trPrice = {
[1] = {price = 1000;       sign = "K";};
[2] = {price = 1000000;    sign = "M";};
[3] = {price = 1000000000; sign = "G";};
};
local tblMax = table.maxn(trPrice);
local scp = "0";

	if flg == 1 then
		scp = GetCommaedText(splitprice);

	elseif flg == 2 then	
		for i = 1, tblMax do
			local float = 0;
			local trPrices = trPrice[i].price;
		
			if splitprice >= trPrices then
				float = splitprice%trPrices/(trPrices/10);
				if float >= 1 then
					scp = string.format("%d.%d",splitprice/trPrices,float)..trPrice[i].sign;
				else
					scp = string.format("%d",splitprice/trPrices)..trPrice[i].sign;
				end
			end
		end
	end

	return scp;
end


function ON_MARKET_SELL_LIST_HOOKED(frame, msg, argStr, argNum)
	if msg == MARKET_ITEM_LIST then
		local str = GET_TIME_TXT(argNum);
		ui.SysMsg(ScpArgMsg("MarketCabinetAfter{TIME}","Time", str));
		if frame:IsVisible() == 0 then
	        return;
	    end
    end

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();
	local sysTime = geTime.GetServerSystemTime();       
	local count = session.market.GetItemCount();

	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());
		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_sell_item_detail");
		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		pic:SetImage(itemObj.Icon);

		collTxt = GET_FULL_NAME(itemObj);
		if COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT ~= nil then
			if string.match(COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(itemObj),"%d%p%d") == "0/1" then
				collTxt = GET_FULL_NAME(itemObj) .. "{nl}{img icon_item_box 18 18}" .. "{s14}未登録{/}";
			end
		end

		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", collTxt);
		name = tolua.cast(name, 'ui::CRichText'); 
		name:SetTextAlign("left", "center");

		local itemCount = ctrlSet:GetChild("count");
		itemCount:SetTextByKey("value", marketItem.count);

		local priceStr = marketItem.sellPrice * marketItem.count;
		local totalPrice = ctrlSet:GetChild("totalPrice");

		local x1Price = "＠" .. GET_TRANS_PRICE(marketItem.sellPrice, 1);
			if marketItem.sellPrice >=1000 then
				x1Price = x1Price .. "(" .. GET_TRANS_PRICE(marketItem.sellPrice, 2) .. ")";
			end

		local xnPrice = "";
		if marketItem.count >= 2 then
			xnPrice = "計" .. GET_TRANS_PRICE(priceStr, 1);

			if priceStr >=10000000 then
				xnPrice = "{nl}" .. xnPrice .. "(" .. GET_TRANS_PRICE(priceStr, 2) .. ")";
			elseif priceStr >=1000 then
				xnPrice = " / " .. xnPrice .. "(" .. GET_TRANS_PRICE(priceStr, 2) .. ")";
			else
				xnPrice = " / " .. xnPrice ;
			end
		end

		totalPrice:SetTextByKey("value", x1Price .. xnPrice);
		totalPrice = tolua.cast(totalPrice, 'ui::CRichText'); 
		totalPrice:SetTextAlign("left", "center");

		local cashValue = GetCashValue(marketItem.premuimState, "marketSellCom") * 0.01;
		local stralue = GetCashValue(marketItem.premuimState, "marketSellCom");

		local priceFloor = 0;
		priceFloor = math.floor((marketItem.sellPrice*marketItem.count)*cashValue);
		
		priceStr = marketItem.sellPrice * marketItem.count * cashValue;
		local silverFee = ctrlSet:GetChild("silverFee");

		silverFee:SetTextByKey("value", stralue .. "% (" .. GET_TRANS_PRICE(priceStr, 1) ..")");
		silverFee = tolua.cast(silverFee, 'ui::CRichText'); 
		silverFee:SetTextAlign("left", "center");


        SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, marketItem, itemObj.ClassName, "market", marketItem.itemType, marketItem:GetMarketGuid());

		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Cancel"));
		btn:SetEventScript(ui.LBUTTONUP, "CANCEL_MARKET_ITEM");
		btn:SetEventScriptArgString(ui.LBUTTONUP,marketItem:GetMarketGuid());
        
	end

    itemlist:RealignItems();
    GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, false, true);
end

function MARKET_SELL_REGISTER_HOOKED(parent, ctrl)

    local count = session.market.GetItemCount();
    local userType = session.loginInfo.GetPremiumState();
    local maxCount = GetCashValue(userType, "marketUpMax");
    if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
        local tokenCnt = GetCashValue(ITEM_TOKEN, "marketUpMax");
        if tokenCnt > maxCount then
            maxCount = tokenCnt;
        end
    end

    if count+1 > maxCount then
        ui.SysMsg(ClMsg("MarketRegitCntOver"));     
        return;
    end
    local frame = parent:GetTopParentFrame();
    local groupbox = frame:GetChild("groupbox");
    local slot_item = GET_CHILD(groupbox, "slot_item", "ui::CSlot");
    local edit_count = groupbox:GetChild("edit_count");
    local edit_price = groupbox:GetChild("edit_price");

    local invitem = GET_SLOT_ITEM(slot_item);
    if invitem == nil then
        return;
    end

    local count = tonumber(edit_count:GetText());
    local price = tonumber(edit_price:GetText());
    if price < 100 then
        ui.SysMsg(ClMsg("SellPriceMustOverThen100Silver"));     
        return;
    end

    local strprice = edit_price:GetText()

    if string.len(strprice) < 3 then
        return
    end

    local floorprice = strprice.sub(strprice,0,2)
    for i = 0 , string.len(strprice) - 3 do
        floorprice = floorprice .. "0"
    end
    
    if strprice ~= floorprice then
        edit_price:SetText(floorprice)
        ui.SysMsg(ScpArgMsg("AutoAdjustToMinPrice"));       
        price = tonumber(floorprice);
    end

    if count <= 0 then
        ui.SysMsg(ClMsg("SellCountMustOverThenZeo"));       
        return;
    end

    local isPrivate = GET_CHILD(groupbox, "isPrivate", "ui::CCheckBox");
    local itemGuid = invitem:GetIESID();
    local obj = GetIES(invitem:GetObject());

    local droplist = GET_CHILD(groupbox, "sellTimeList", "ui::CDropList");  
    local selecIndex = droplist:GetSelItemIndex();

    local needTime, free = GetMarketTimeAndTP(selecIndex);
    local commission = (price * count * free * 0.01);
    local vis = session.GetInvItemByName("Vis");
    if vis == nil or 0 > vis.count - commission then
        ui.SysMsg(ClMsg("Auto_SilBeoKa_BuJogHapNiDa."));
        return;
    end

    local silverRate = groupbox:GetChild("silverRate");
    local down = silverRate:GetChild("downValue");
    local downValue = down:GetTextByKey("value");
    local idownValue = tonumber(downValue);
    local iPrice = tonumber(price);	

	if 0 ~= idownValue and iPrice < idownValue then
		if userType >= 1 then
		else
			ui.SysMsg(ScpArgMsg("PremiumRegMinPrice{Price}","Price", downValue));
	        return;
	    end
	end

    if obj.GroupName == "Premium" and iPrice < tonumber(TOKEN_MARKET_REG_LIMIT_PRICE) then
		ui.SysMsg(ScpArgMsg("PremiumRegMinPrice{Price}","Price", TOKEN_MARKET_REG_LIMIT_PRICE));
        return;
    end

    if true == invitem.isLockState then
        ui.SysMsg(ClMsg("MaterialItemIsLock"));
        return false;
    end

    local invframe = ui.GetFrame("inventory");
    if true == IS_TEMP_LOCK(invframe, invitem) then
        ui.SysMsg(ClMsg("MaterialItemIsLock"));
        return false;
    end
    local itemProp = geItemTable.GetProp(obj.ClassID);
    local pr = TryGetProp(obj, "PR");

    local noTradeCnt = TryGetProp(obj, "BelongingCount");
    local tradeCount = invitem.count
    if nil ~= noTradeCnt and 0 < tonumber(noTradeCnt) then
        local wareItem = nil;
        if obj.MaxStack > 1 then
            wareItem =session.GetWarehouseItemByType(obj.ClassID);
        end
        local wareCnt = 0;
        if nil ~= wareItem then
            wareCnt = wareItem.count;
        end
        tradeCount = (invitem.count + wareCnt) - tonumber(noTradeCnt);
        if tradeCount <= 0 then
            ui.AlarmMsg("ItemIsNotTradable");
            return false;
        end
    end

    if itemProp:IsExchangeable() == false or itemProp:IsMoney() == true or (pr ~= nil and pr < 1) then
        ui.AlarmMsg("ItemIsNotTradable");
        return false;
    end


    local yesScp = string.format("market.ReqRegisterItem(\'%s\', %d, %d, 1, %d)", itemGuid, price, count, needTime);
    
    commission = math.floor(commission);
    if commission <= 0 then
        commission = 1;
    end

	local silverIcon = "{img icon_item_silver 20 20}";
	local sellMsg    = "次の金額で販売登録します。";
	local sellItem   = "{nl} {nl}{img " .. obj["Icon"] .. " 40 40} " .. GET_FULL_NAME(obj)
	local sellPrice  = "{nl} {nl}販売単価：" .. silverIcon .. GET_TRANS_PRICE(price, 1) .. "シルバー(" .. GET_TRANS_PRICE(price, 2) ..")";
	local sellTax    = "{nl} {nl}販売手数料：" .. silverIcon .. GET_TRANS_PRICE(tostring(commission), 1) .. "シルバー";
	local underRate  = "{nl} {nl}下限レート：" .. string.sub(math.floor(price/downValue*10)*0.1,1,4);
	local collTxt    = "";


		if price <= 999 then
			sellPrice = "{nl} {nl}販売単価：" .. silverIcon .. GET_TRANS_PRICE(price, 1) .. "シルバー";
		end
		if idownValue == 0 then
			underRate = "{nl} {nl}[相場情報なし]";
		end

		if COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT ~= nil then
			collTxt = "{nl} {nl} {nl}" .. COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(obj);
		end

    if nil~= obj and obj.ItemType =='Equip' then
        if 0 < obj.BuffValue then
            -- ????? buffValue?? ???.
            ui.MsgBox(ScpArgMsg("BuffDestroy{Price}","Price", tostring(commission)), yesScp, "None");
        else
--original   ui.MsgBox(ScpArgMsg("CommissionRegMarketItem{Price}","Price", tostring(commission)), yesScp, "None");
             ui.MsgBox(sellMsg .. sellItem .. sellPrice .. sellTax .. underRate .. collTxt, yesScp, "None");
        end
    else
--original   ui.MsgBox(ScpArgMsg("CommissionRegMarketItem{Price}","Price", tostring(commission)), yesScp, "None");
             ui.MsgBox(sellMsg .. sellItem .. " × " .. count .. sellPrice .. sellTax .. underRate .. collTxt, yesScp, "None");
    end
end

--dofile("../data/addon_d/marketsellex/marketsellex.lua");
