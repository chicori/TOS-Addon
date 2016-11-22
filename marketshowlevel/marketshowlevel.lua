CHAT_SYSTEM("MARKET SHOW LEVEL v1.0.2 JP - Ex loaded!");
local itemColor = {
    [0] = "FFFFFF",    -- Normal
    [1] = "FFD700",    -- 黄HP
    [2] = "FFD700",    -- 黄HPR
    [3] = "6495ED",    -- 青SP
    [4] = "6495ED",    -- 青SPR
    [5] = "FF6347",    -- 朱Atk
    [6] = "DA70D6",    -- 紫Matk
    [7] = "CD853F",    -- DEF
    [8] = "DDA0DD",    -- 藤Mdef
    [9] = "DA70D6",    -- 紫魔法増幅
    [10] = "98FB98",   -- 緑Cri攻撃
    [11] = "98FB98",   -- 緑Cri発生
    [12] = "B0C4DE",   -- 緑Cri抵抗
    [13] = "B0C4DE",   -- 
    [14] = "B0C4DE",   -- 
    [15] = "B0C4DE",   -- 
    [16] = "FED0E0",   -- 
    [17] = "FED0E0",   -- 
    [18] = "FED0E0",   -- 
    [19] = "FED0E0",   -- 
    [20] = "FED0E0",   --
    [21] = "FED0E0",   -- 
    [22] = "FED0E0",   -- 
    [23] = "FED0E0",   -- 
    [24] = "BDB76B",   -- 属性防御おまとめくん
    [25] = "E4B4A4",   -- 広域防御
};

local propNameList = {
    ["MHP"]            = "HP",
    ["RHP"]            = "HPR ",
    ["MSP"]            = "SP",
    ["RSP"]            = "SPR",
    ["PATK"]           = "物攻",
    ["ADD_MATK"]       = "魔攻",
    ["ADD_DEF"]        = "物防",
    ["ADD_MDEF"]       = "魔防",
    ["ADD_MHR"]        = "魔増",
    ["CRTATK"]         = "ｸﾘ攻",
    ["CRTHR"]          = "ｸﾘ発",
    ["CRTDR"]          = "ｸﾘ抵",
    ["ADD_HR"]         = "命中",
    ["ADD_DR"]         = "回避",
    ["ADD_FIRE"]       = "炎攻",
    ["ADD_ICE"]        = "氷攻",
    ["ADD_POISON"]     = "毒攻",
    ["ADD_LIGHTNING"]  = "雷攻",
    ["ADD_EARTH"]      = "地攻",
    ["ADD_SOUL"]       = "霊攻",
    ["ADD_HOLY"]       = "聖攻",
    ["ADD_DARK"]       = "闇攻",
    ["RES_FIRE"]       = "炎防",
    ["RES_ICE"]        = "氷防",
    ["RES_POISON"]     = "毒防",
    ["RES_LIGHTNING"]  = "雷防",
    ["RES_EARTH"]      = "地防",
    ["RES_SOUL"]       = "霊防",
    ["RES_HOLY"]       = "聖防",
    ["RES_DARK"]       = "闇防",
    ["MSPD"]           = "移動",
    ["SR"]             = "広攻",
    ["SDR"]            = "広防",
    ["BLK"]            = "ブロ",
    
};

local itemSymbol = {
    [0] = "　",    -- Normal
    [1] = "×",    -- 0.50 over
    [2] = "▲",    -- 0.60 over
    [3] = "●",    -- 0.80 over
    [4] = "★",    -- 0.90 over
};

function GetItemValueSymbol(value, max)
    local index = 0;
    if value > (max * 0.90) then
        index = 4
    elseif value > (max * 0.80) then
        index = 3
    elseif value > (max * 0.60) then
        index = 2
    elseif value > (max * 0.50) then
        index = 1
    end
    return itemSymbol[index]
end

function MARKETSHOWLEVEL_ON_INIT(addon, frame)

    _G["ON_MARKET_ITEM_LIST"] = ON_MARKET_ITEM_LIST_HOOKED;

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

-- add code start
        local itemLevel = GET_ITEM_LEVEL(itemObj);
        local itemGroup = itemObj.GroupName;
-- add code end

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

-- add code start
        if itemGroup == "Gem" or itemGroup == "Card" then
            name:SetTextByKey("value", "Lv".. itemLevel .. ":" .. GET_FULL_NAME(itemObj));
        elseif (itemObj.ClassName == "Scroll_SkillItem") then
            local skillClass = GetClassByType("Skill", itemObj.SkillType);
            name:SetTextByKey("value", "Lv".. itemObj.SkillLevel .. " " .. skillClass.Name .. ":" .. GET_FULL_NAME(itemObj));
        elseif itemGroup == "Armor" then
            local prop = "";
            local space= "";
            for i = 1 , 3 do
                local propName = "";
                local propValue = 0;
                local propNameStr = "HatPropName_"..i;
                local propValueStr = "HatPropValue_"..i;
                local propValueColored = "FFFFFF";
                local propValueSymboled = "　"
                if itemObj[propValueStr] ~= 0 and itemObj[propNameStr] ~= "None" then
                    if #prop > 0 then
                        prop = prop..",";
                        space = space .. " ";
                    end

                    propName = itemObj[propNameStr];
                    propValue = itemObj[propValueStr];

                    if propName == "MHP" then
                        propValueColored = itemColor[1];
                        propValueSymboled = GetItemValueSymbol(propValue,2283);
                    elseif propName == "RHP" then
                        propValueColored = itemColor[2];
                        propValueSymboled = GetItemValueSymbol(propValue,56);
                    elseif propName == "MSP" then
                        propValueColored = itemColor[3];
                        propValueSymboled = GetItemValueSymbol(propValue,447);
                    elseif propName == "RSP" then
                        propValueColored = itemColor[4];
                        propValueSymboled = GetItemValueSymbol(propValue,42);
                    elseif propName == "PATK" then
                        propValueColored = itemColor[5];
                        propValueSymboled = GetItemValueSymbol(propValue,126);
                    elseif propName == "ADD_MATK" then
                        propValueColored = itemColor[6];
                        propValueSymboled = GetItemValueSymbol(propValue,126);
                    elseif propName == "ADD_DEF" then
                        propValueColored = itemColor[7];
                        propValueSymboled = GetItemValueSymbol(propValue,110);
                    elseif propName == "ADD_MDEF" then
                        propValueColored = itemColor[8];
                        propValueSymboled = GetItemValueSymbol(propValue,110);
                    elseif propName == "ADD_MHR" then
                        propValueColored = itemColor[9];
                        propValueSymboled = GetItemValueSymbol(propValue,126);
                    elseif propName == "CRTATK" then
                        propValueColored = itemColor[10];
                        propValueSymboled = GetItemValueSymbol(propValue,189);
                    elseif propName == "CRTHR" then
                        propValueColored = itemColor[11];
                        propValueSymboled = GetItemValueSymbol(propValue,14);
                    elseif propName == "CRTDR" then
                        propValueColored = itemColor[12];
                        propValueSymboled = GetItemValueSymbol(propValue,14);
                    elseif propName == "BLK" then
                        propValueColored = itemColor[13];
                        propValueSymboled = GetItemValueSymbol(propValue,14);
                    elseif propName == "ADD_HR" then
                        propValueColored = itemColor[14];
                        propValueSymboled = GetItemValueSymbol(propValue,14);
                    elseif propName == "ADD_DR" then
                        propValueColored = itemColor[15];
                        propValueSymboled = GetItemValueSymbol(propValue,14);
                    elseif propName == "ADD_FIRE" then
                        propValueColored = itemColor[16];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "ADD_ICE" then
                        propValueColored = itemColor[17];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "ADD_POISON" then
                        propValueColored = itemColor[18];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "ADD_LIGHTNING" then
                        propValueColored = itemColor[19];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "ADD_EARTH" then
                        propValueColored = itemColor[20];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "ADD_SOUL" then
                        propValueColored = itemColor[21];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "ADD_HOLY" then
                        propValueColored = itemColor[22];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "ADD_DARK" then
                        propValueColored = itemColor[23];
                        propValueSymboled = GetItemValueSymbol(propValue,99);
                    elseif propName == "SDR" then
                        propValueColored = itemColor[25];
                    end

                   if string.sub(propName,1,3) == "RES" then
                        propValueColored = itemColor[24];		
                        propValueSymboled = GetItemValueSymbol(propValue,84);
                   end

                    propName = propNameList[propName];
                    prop = prop..string.format("{#%s}{ol}%s{/}{/}", propValueColored, propName)..string.format("{#%s}{ol}%4d{/}{/}", propValueColored, propValue)..string.format("{#%s}{ol}%s{/}{/}", propValueColored, propValueSymboled);
                    space = space .. "           ";
                end
            end
            if prop == "" then
                name:SetTextByKey("value", GET_FULL_NAME(itemObj));
            else
                name:SetTextByKey("value", GET_FULL_NAME(itemObj).."\r\n"..space..prop);
            end
        else
            name:SetTextByKey("value", GET_FULL_NAME(itemObj));
        end
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
