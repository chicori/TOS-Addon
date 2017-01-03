CHAT_SYSTEM("MARKET SHOW LEVEL JP v1.0.6 Ex2 loaded!");

--<addon:tooltiphelperの確認　コレクション表示に使用>
local addTooltiphelper = pcall(COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT,"640001");

-- Equip Jem And Hat prop align
local propAlign = "left";

local equipRedgem = 0;

-- Prop Text
local AwakenText    = "覚醒"
local SocketText    = "スロット"
local PotentialText = "ポテンシャル"
local UnknownText   = "未鑑定アイテム"

-- ヘアコスチュームのオプション、ポテンシャルの評価 (fn:GetItemValueSign)
-- vcalc = 割合, sign = 表示記号, scolor = 色指定
local itemSign = {
[1] = {vcalc = 1.00; sign = "☆"; scolor ="A0522D";};
[2] = {vcalc = 0.90; sign = "★"; scolor ="FFD700";};
[3] = {vcalc = 0.75; sign = "●"; scolor ="FFD700";};
[4] = {vcalc = 0.60; sign = "▲"; scolor ="FFD700";};
[5] = {vcalc = 0.40; sign = "×"; scolor ="FF6347";};
[6] = {vcalc = 0.30; sign = "×"; scolor ="FF6347";};
[7] = {vcalc = 0.00; sign = "";   scolor ="FF6347";};
};

-- Hat setting(item_opt.ies)
-- visible = 表示設定 1表示/2非表示　pNo = 並び替え（昇順）
local propList = {};
propList.MHP           = {name = "HP";  max = 2283; vcolor="FFD700"; visible=1; pNo =  5;};
propList.RHP           = {name = "HPR"; max =   56; vcolor="FFD700"; visible=1; pNo = 15;};
propList.MSP           = {name = "SP";  max =  447; vcolor="6495ED"; visible=1; pNo = 16;};
propList.RSP           = {name = "SPR ";max =   42; vcolor="6495ED"; visible=1; pNo =  6;};
propList.PATK          = {name = "物攻";max =  126; vcolor="FF6347"; visible=1; pNo =  7;};
propList.ADD_MATK      = {name = "魔攻";max =  126; vcolor="DA70D6"; visible=1; pNo =  8;};
propList.ADD_DEF       = {name = "物防";max =  110; vcolor="CD853F"; visible=1; pNo =  1;};
propList.ADD_MDEF      = {name = "魔防";max =  110; vcolor="DDA0DD"; visible=1; pNo =  2;};
propList.ADD_MHR       = {name = "魔増";max =  126; vcolor="DA70D6"; visible=1; pNo =  9;};
propList.CRTATK        = {name = "ｸﾘ攻";max =  189; vcolor="98FB98"; visible=1; pNo = 10;};
propList.CRTHR         = {name = "ｸﾘ発";max =   14; vcolor="98FB98"; visible=1; pNo = 11;};
propList.CRTDR         = {name = "ｸﾘ抵";max =   14; vcolor="98FB98"; visible=1; pNo = 96;};
propList.BLK           = {name = "ブロ";max =   14; vcolor="B0C4DE"; visible=1; pNo = 13;};
propList.ADD_HR        = {name = "命中";max =   14; vcolor="B0C4DE"; visible=1; pNo = 97;};
propList.ADD_DR        = {name = "回避";max =   14; vcolor="B0C4DE"; visible=1; pNo = 98;};
propList.ADD_FIRE      = {name = "炎攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 26;};
propList.ADD_ICE       = {name = "氷攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 27;};
propList.ADD_POISON    = {name = "毒攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 28;};
propList.ADD_LIGHTNING = {name = "雷攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 29;};
propList.ADD_EARTH     = {name = "土攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 30;};
propList.ADD_SOUL      = {name = "念攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 31;};
propList.ADD_HOLY      = {name = "聖攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 32;};
propList.ADD_DARK      = {name = "闇攻";max =   99; vcolor="FED0E0"; visible=1; pNo = 33;};
propList.RES_FIRE      = {name = "炎防";max =   84; vcolor="BDB76B"; visible=1; pNo = 18;};
propList.RES_ICE       = {name = "氷防";max =   84; vcolor="BDB76B"; visible=1; pNo = 19;};
propList.RES_POISON    = {name = "毒防";max =   84; vcolor="BDB76B"; visible=1; pNo = 20;};
propList.RES_LIGHTNING = {name = "雷防";max =   84; vcolor="BDB76B"; visible=1; pNo = 21;};
propList.RES_EARTH     = {name = "土防";max =   84; vcolor="BDB76B"; visible=1; pNo = 22;};
propList.RES_SOUL      = {name = "念防";max =   84; vcolor="BDB76B"; visible=1; pNo = 23;};
propList.RES_HOLY      = {name = "聖防";max =   84; vcolor="BDB76B"; visible=1; pNo = 24;};
propList.RES_DARK      = {name = "闇防";max =   84; vcolor="BDB76B"; visible=1; pNo = 25;};
propList.MSPD          = {name = "移動";max =    1; vcolor="FFFFFF"; visible=1; pNo =  4;};
propList.SR            = {name = "広攻";max =    1; vcolor="FFFFFF"; visible=1; pNo =  3;};
propList.SDR           = {name = "広防";max =    4; vcolor="FFFFFF"; visible=1; pNo = 99;};

--Equip setting(item.equip.ies)
local transStr = {
[1] = {basestr = "ATK-";         transw = "物攻";};
[2] = {basestr = "MATK";        transw = "魔攻";};
[3] = {basestr = "MHR";         transw = "魔増";};
[4] = {basestr = "DEF";         transw = "物防";};
[5] = {basestr = "MDEF";        transw = "魔防";};
[6] = {basestr = "DR";          transw = "回避";};
[7] = {basestr = "HR";          transw = "命中";};
[8] = {basestr = "ADD_FIRE";    transw = "火攻";};
};

--<ジェムテーブル見つけたら廃止>
local gemRed = {
[0] = {wep = ""; gvalue = 0;};
[1] = {wep = "最攻 40 / 物攻 25 / HP 30 / HPR 10 / ｸﾘ攻 5"; gvalue = 40;};
[2] = {wep = "最攻 60 / 物攻 35 / HP 48 / HPR 20 / ｸﾘ攻 8"; gvalue = 60;};
[3] = {wep = "最攻 90 / 物攻 55 / HP 72 / HPR 30 / ｸﾘ攻11"; gvalue = 90;};
[4] = {wep = "最攻130 / 物攻 80 / HP102 / HPR 40 / ｸﾘ攻16"; gvalue = 130;};
[5] = {wep = "最攻180 / 物攻110 / HP138 / HPR 50 / ｸﾘ攻23"; gvalue = 180;};
[6] = {wep = "最攻240 / 物攻145 / HP180 / HPR 60 / ｸﾘ攻30"; gvalue = 240;};
[7] = {wep = "最攻310 / 物攻185 / HP228 / HPR 70 / ｸﾘ攻39"; gvalue = 320;};
[8] = {wep = "最攻390 / 物攻235 / HP282 / HPR 80 / ｸﾘ攻49"; gvalue = 390;};
[9] = {wep = "最攻480 / 物攻290 / HP342 / HPR 90 / ｸﾘ攻60"; gvalue = 480;};
[10] ={wep = "最攻580 / 物攻350 / HP408 / HPR100 / ｸﾘ攻73"; gvalue = 580;};
[11] ={wep = "None";};
};
local gemBlue = {
[1] = {wep = "魔攻 23 / ﾌﾞﾛｯｸ  1 / SP 30 / 魔防 10 / SPR 2";};
[2] = {wep = "魔攻 32 / ﾌﾞﾛｯｸ  4 / SP 48 / 魔防 20 / SPR 4";};
[3] = {wep = "魔攻 45 / ﾌﾞﾛｯｸ 10 / SP 72 / 魔防 30 / SPR 8";};
[4] = {wep = "魔攻 63 / ﾌﾞﾛｯｸ 19 / SP102 / 魔防 40 / SPR14";};
[5] = {wep = "魔攻 86 / ﾌﾞﾛｯｸ 30 / SP138 / 魔防 50 / SPR22";};
[6] = {wep = "魔攻113 / ﾌﾞﾛｯｸ 44 / SP180 / 魔防 60 / SPR32";};
[7] = {wep = "魔攻144 / ﾌﾞﾛｯｸ 60 / SP228 / 魔防 70 / SPR44";};
[8] = {wep = "魔攻180 / ﾌﾞﾛｯｸ 79 / SP282 / 魔防 80 / SPR58";};
[9] = {wep = "魔攻221 / ﾌﾞﾛｯｸ100 / SP342 / 魔防 90 / SPR74";};
[10] ={wep = "魔攻266 / ﾌﾞﾛｯｸ124 / SP408 / 魔防100 / SPR92";};
[11] ={wep = "None";};
};
local gemGreen = {
[1] = {wep = "ｸﾘ発  2 / ｸﾘ発  3 / ｸﾘ抵 1 / 回避 2 / 命中2";};
[2] = {wep = "ｸﾘ発  4 / ｸﾘ発  5 / ｸﾘ抵 3 / 回避 4 / 命中4";};
[3] = {wep = "ｸﾘ発  9 / ｸﾘ発 10 / ｸﾘ抵 5 / 回避 6 / 命中8";};
[4] = {wep = "ｸﾘ発 16 / ｸﾘ発 18 / ｸﾘ抵 9 / 回避10 / 命中14";};
[5] = {wep = "ｸﾘ発 26 / ｸﾘ発 29 / ｸﾘ抵15 / 回避17 / 命中22";};
[6] = {wep = "ｸﾘ発 38 / ｸﾘ発 42 / ｸﾘ抵21 / 回避24 / 命中32";};
[7] = {wep = "ｸﾘ発 52 / ｸﾘ発 57 / ｸﾘ抵29 / 回避32 / 命中44";};
[8] = {wep = "ｸﾘ発 69 / ｸﾘ発 75 / ｸﾘ抵38 / 回避42 / 命中58";};
[9] = {wep = "ｸﾘ発 88 / ｸﾘ発 96 / ｸﾘ抵49 / 回避54 / 命中74";};
[10] ={wep = "ｸﾘ発110 / ｸﾘ発120 / ｸﾘ抵61 / 回避68 / 命中92";};
[11] ={wep = "None";};
};
local gemYellow = {
[1] = {wep = "ｸﾘ攻 60 / ｸﾘ攻 35 / 物防 10 / HP  45 / 貫通  1";};
[2] = {wep = "ｸﾘ攻 90 / ｸﾘ攻 45 / 物防 20 / HP 120 / 貫通  4";};
[3] = {wep = "ｸﾘ攻140 / ｸﾘ攻 75 / 物防 30 / HP 225 / 貫通 10";};
[4] = {wep = "ｸﾘ攻200 / ｸﾘ攻105 / 物防 40 / HP 360 / 貫通 19";};
[5] = {wep = "ｸﾘ攻270 / ｸﾘ攻145 / 物防 50 / HP 525 / 貫通 30";};
[6] = {wep = "ｸﾘ攻360 / ｸﾘ攻195 / 物防 60 / HP 720 / 貫通 44";};
[7] = {wep = "ｸﾘ攻470 / ｸﾘ攻245 / 物防 70 / HP 945 / 貫通 60";};
[8] = {wep = "ｸﾘ攻590 / ｸﾘ攻315 / 物防 80 / HP1200 / 貫通 79";};
[9] = {wep = "ｸﾘ攻720 / ｸﾘ攻385 / 物防 90 / HP1485 / 貫通100";};
[10] ={wep = "ｸﾘ攻870 / ｸﾘ攻465 / 物防100 / HP1800 / 貫通124";};
[11] ={wep = "None";};
};
local gemExp = {
[1] = {gexp = 0;};
[2] = {gexp = 300;};
[3] = {gexp = 1200;};
[4] = {gexp = 3900;};
[5] = {gexp = 14700;};
[6] = {gexp = 57900;};
[7] = {gexp = 230700;};
[8] = {gexp = 1094700;};
[9] = {gexp = 5414700;};
[10] ={gexp = 27014700;};
};


function GET_COLLECTION_PROP(itemObj)
local cllTxt = "";
    if addTooltiphelper == true then
        local cllItem = string.match(COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(itemObj),"%x%p%x");

        if cllItem == "0/1" then    
            cllTxt = "{img " .. "icon_item_box" .. " 18 18}" .. "{s14}未登録{/}" .. "{/}"
        end
    end

    return cllTxt;
end



function MARKETSHOWLEVEL_ON_INIT(addon, frame)
    if (acutil ~= nil) then
        acutil.setupEvent(addon, "ON_MARKET_ITEM_LIST", "ON_MARKET_ITEM_LIST_HOOKED")
    else
        _G["ON_MARKET_ITEM_LIST"] = ON_MARKET_ITEM_LIST_HOOKED;
    end
end

function GET_GEM_INFO(itemObj)
    local gemInfo = "";
    local fn = GET_FULL_NAME_OLD or GET_FULL_NAME;

    local socketId;
    local rstLevel;
    local gemName;
    local exp;
    local color="";

    local socketInfo = "";

    equipRedgem = 0;

    if itemObj.NeedAppraisal ~= 0 then
        gemInfo = "{#B0C4DE}{ol}" .. UnknownText .. "{/}{/}";
    else

    --<ジェム>
        for i = 0, 4 do
            socketId = itemObj["Socket_Equip_" .. i];
            rstLevel = itemObj["Socket_JamLv_" .. i];
            exp = itemObj["SocketItemExp_" .. i];
    
            if socketId > 0 then
                local obj = GetClassByType("Item", socketId);
                gemName = fn(obj);
                local gemLevel = 0;


                for i = 10, 1, -1 do
                    if exp >= gemExp[i].gexp then
                        gemLevel = i
                        break;
                    end
                end

                if gemLevel <= rstLevel then
                    gemInfo = gemInfo .. "{#FF6347}{ol}Lv" .. gemLevel .. GET_ITEM_IMG_BY_CLS(obj, 18) .."{/}{/}";
                else
                    gemInfo = gemInfo .. "Lv" .. gemLevel .. GET_ITEM_IMG_BY_CLS(obj, 18);
                end
--<赤ジェムの合計値>
                if socketId == 643501 then
                    equipRedgem = equipRedgem + gemRed[gemLevel].gvalue;
                end
            end

        end
    
--<ソケット>
        local nowusesocketcount = 0
        for i = 0, itemObj.MaxSocket - 1 do
            local nowsockettype = itemObj['Socket_' .. i]
    
            if nowsockettype ~= 0 then
                nowusesocketcount = nowusesocketcount + 1
            end
        end

        socketInfo = SocketText .. nowusesocketcount .. "/" .. itemObj.MaxSocket;

        --ソケット開放していたら色付け
        if nowusesocketcount >= 1 then 
            socketInfo = "{#98FB98}{ol}" .. socketInfo .. "{/}{/}";
        end


        --<ポテンシャル>
        local maxPR = 0;
    
        if itemObj.MaxPR == 0 then
            local itemCls = GetClass("Item",itemObj.ClassName)
            maxPR = itemCls.PR
        else
            maxPR = itemObj.MaxPR
        end

        local prInfo = PotentialText .. itemObj["PR"] .. "/" .. maxPR;

        --ポテンシャルの数値に応じて色変え
        if itemObj["PR"] ~= maxPR then
            local prColor = GetItemValueSign(itemObj["PR"], maxPR, "2") ;
            prInfo = "{#" .. prColor .. "}{ol}" .. prInfo .. "{/}{/}";
        end

        --<結合>
        if #gemInfo >= 1 then
            gemInfo = socketInfo .. "(" .. gemInfo .. ")" .. prInfo;
        else
            gemInfo = socketInfo .. "　" .. prInfo;
        end
    end

    return gemInfo;

end


function GET_HAT_PROP(itemObj)
if itemObj.ClassType ~= "Hat" then
    return ""
end


local prop = "";
local elAtks = ""; 
local elFlgs = 0;
local elMax = 0;

local tblAct = {
[1] = {vAct = ""; tNo = 0; elName = ""; elAct = 0; elFlg = 0};
[2] = {vAct = ""; tNo = 0; elName = ""; elAct = 0; elFlg = 0};
[3] = {vAct = ""; tNo = 0; elName = ""; elAct = 0; elFlg = 0};
};

    for i = 1 , 3 do
        local propName = "";
        local propValue = 0;
        local propNameStr = "HatPropName_"..i;
        local propValueStr = "HatPropValue_"..i;

        if itemObj[propValueStr] ~= 0 and itemObj[propNameStr] ~= "None" then
            if #prop > 0 then 
                prop = prop..",";
            end

            propName = itemObj[propNameStr];
            propValue = itemObj[propValueStr];
            propSign = GetItemValueSign(propValue, propList[propName].max, 0);

        -- テーブルへ代入
            if propList[propName].visible ~= 0 then         -- 表示条件
                if propList[propName].max==99 then
                    tblAct[i].elAct = propValue;
                    tblAct[i].elFlg = i * i;
                    tblAct[i].vAct = "{#" .. propList[propName].vcolor .. "}" .. propList[propName].name .. propValue .. propSign .. " {/}";
                    tblAct[i].tNo = 100 + i
                else
                    tblAct[i].vAct = "{#" .. propList[propName].vcolor .. "}" .. propList[propName].name .. propValue .. propSign .. " {/}";
                    tblAct[i].tNo = propList[propName].pNo
                end
            end

        end
    end

    --<属性攻撃の合計値からパターン出して記号付与に渡し>
    elAtks = tblAct[1].elAct + tblAct[2].elAct + tblAct[3].elAct;           -- 合計値
    if elAtks ~= 0 then
        elFlgs = tblAct[1].elFlg + tblAct[2].elFlg + tblAct[3].elFlg;       -- 組合せパターン
        if elFlgs == 5 or elFlgs == 10 or elFlgs == 13 then                 -- 2種:5,10,13
            elMax = 198;
        elseif elFlgs == 14 then                                            -- 3種:14
            elMax = 297;
        else
            elAtks = "";
        end

        if elMax >= 1 then
            local propSign = GetItemValueSign(elAtks, elMax, 0);
            elAtks = "{#FED0E0}{ol}" .. "" .. "(属攻" .. elAtks .. "/" .. elMax .. propSign .. "){/}{/}";
        end
    else
        elAtks = "";
    end

    --<属性攻撃以外を並び替え>
    table.sort(tblAct,function(a,b) return (b.tNo > a.tNo) end);
    prop = "{ol}" .. tblAct[1].vAct .. tblAct[2].vAct .. tblAct[3].vAct .. "{/}";

    if #prop > 0 then
        prop = "{nl}{s13}" .. itemObj["ReqToolTip"] .. "{/}{nl}" .. prop .. elAtks;
    end;

    return prop;

end

--<計算して記号か色を返す>
function GetItemValueSign(value, max, cflg)
local index     = "";
local tblMax    = table.maxn(itemSign);

    for i = 1 , tblMax do
        if value >= (max * itemSign[i].vcalc) then
            if cflg == "2" then
                index = itemSign[i].scolor;
                break;
            else
                index = itemSign[i].sign;
                break;
            end
        end
    end

    return index
end

--<２段目>
function GET_SOCKET_POTENSIAL_AWAKEN_PROP(ctrlSet, itemObj, row)

    local awakenProp = "";
    if itemObj.IsAwaken == 1 then
        awakenProp = " {#3300FF}{b}"..AwakenText.."["..propList[itemObj.HiddenProp].name.. " "..itemObj.HiddenPropValue.."]{/}{/}";
    end

    --<表示方法わかるまで仮>
    local equipMaterial = itemObj["Material"];
    if #equipMaterial ~= 0 then
        equipMaterial = string.gsub(equipMaterial,"Iron"   ,"プレート：");
        equipMaterial = string.gsub(equipMaterial,"Leather","レザー　：");
        equipMaterial = string.gsub(equipMaterial,"Cloth"  ,"クロース：");
        equipMaterial = string.gsub(equipMaterial,"None"   ,"");        
    end


    --<ベースステータスの表示：配列だとベースの新概念が出たらエラーになるので処理遅いけどこっちで>
    local tblMax   = table.maxn(transStr);
    local basicStr = itemObj["BasicTooltipProp"];
    local equipStr = "";
    local minAtk   = 0;
    local maxAtk   = 0;
    local maxAtkg  = 0;

	for i = 1 , tblMax do
		if basicStr == "ATK" then
			minAtk  = itemObj["MINATK"];
			maxAtk  = itemObj["MAXATK"];
			maxAtkg = itemObj["MAXATK"] + equipRedgem;

			--レイピア
			if minAtk == maxAtk then
				equipStr = transStr[i].transw .. minAtk;
				if equipRedgem >= 1 then
					equipStr = equipStr .. "(Max" .. minAtk+equipRedgem .. "/Ave" .. (minAtk+maxAtkg)/2 .. ")";
				end
				
		--最小～最大がある武器
			else
				equipStr = transStr[i].transw .. minAtk .. "～" .. maxAtk;

				if equipRedgem >=1 then
					equipStr = equipStr .. "(Max" .. maxAtkg .. "/Ave" .. (minAtk+maxAtk+equipRedgem)/2 .. ")";
				else
					equipStr = equipStr .. "(Ave" .. (minAtk+maxAtk)/2 .. ")";
				end
			end
			break;
		elseif basicStr == transStr[i].basestr then
			equipStr = transStr[i].transw .. itemObj[transStr[i].basestr];		

			if basicStr == "MATK" then
				if equipRedgem >= 1 then
					local mMATK = itemObj[transStr[i].basestr] + equipRedgem;
					equipStr = equipStr .. "～" .. mMATK .. "(Ave" .. (mMATK / 2) .. ")";
				end
			end
	        break;
		end
	end

	equipRedgem = 0;

    local socketDetail = ctrlSet:CreateControl("richtext", "SOCKTE_ITEM_" .. row, 100, 30, 0, 0);
    tolua.cast(socketDetail, 'ui::CRichText');
    socketDetail:SetFontName("brown_16_b");
    socketDetail:SetText("{s12}".. equipMaterial .. equipStr .. awakenProp.."{/}");
    socketDetail:Resize(400, 0)
    socketDetail:SetTextAlign(propAlign, "center");
end

--<３段目>
function GET_EQUIP_PROP(ctrlSet, itemObj, row)

    if itemObj.ClassType ~= "Hat" then
        local gemInfo = GET_GEM_INFO(itemObj);
    
        local propDetail = ctrlSet:CreateControl("richtext", "PROP_ITEM_" .. row, 100, 45, 0, 0);
        tolua.cast(propDetail, 'ui::CRichText');
        propDetail:SetFontName("brown_16_b");
        propDetail:SetText("{s12}"..gemInfo.."{/}");
        propDetail:Resize(400, 0)
        propDetail:SetTextAlign(propAlign, "center");
    end
end


--Market names integration
function SHOW_MARKET_NAMES(ctrlSet, marketItem)
    if marketItem == nil then
        return;
    end

    if _G["MARKETNAMES"] == nil then
        return;
    end
    
    local marketName = _G["MARKETNAMES"][marketItem:GetSellerCID()];
    if marketName == nil then
        return;
    end
    
    local buyButton = ctrlSet:GetChild("button_1");

    if buyButton ~= nil then
        buyButton:SetTextTooltip("Buy from " .. marketName.characterName .. " " .. marketName.familyName .. "!");
    end
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
--	count =  math.ceil(session.market.GetTotalCount();
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



-- add code start
        local cllInfo   = GET_COLLECTION_PROP(itemObj)
        local itemLevel = GET_ITEM_LEVEL(itemObj);
        local itemGroup = itemObj.GroupName;

        if itemGroup == "Weapon" or itemGroup == "SubWeapon" or itemGroup == "Armor" then
            local prop = GET_HAT_PROP(itemObj);
            name:SetTextByKey("value", GET_FULL_NAME(itemObj)..cllInfo.."{nl}{s14}"..prop.."{/}");
            if itemObj.NeedAppraisal ~= 0 then
                pic:SetColorTone("CC222222");
            end
            GET_EQUIP_PROP(ctrlSet, itemObj, i);

            if itemObj.ClassType ~= "Hat" then
                GET_SOCKET_POTENSIAL_AWAKEN_PROP(ctrlSet, itemObj, i);
            end


        elseif itemGroup == "Gem" then
            local gemSkill = string.sub(itemObj["ClassName"],5);
            local gemParts = itemObj["EnableEquipParts"];
            
            --<表示方法見つけるまで仮>
            if #gemSkill >= 1 then
                gemSkill = string.gsub(gemSkill,"_"," ");
            end
            if #gemParts >= 1 then
                gemParts = string.gsub(gemParts,"Weapon","武器");
                gemParts = string.gsub(gemParts,"Foot","足");
                gemParts = string.gsub(gemParts,"Hand","手");
                gemParts = string.gsub(gemParts,"TopLeg","体");
            end
            --<ジェムテーブル見つけるまで仮>
            if itemObj["EquipXpGroup"] == "Gem" then
                if itemObj["ClassName"] == "gem_circle_1" then
                    gemParts = gemRed[GET_ITEM_LEVEL(itemObj)].wep;
                    gemSkill = gemRed[GET_ITEM_LEVEL(itemObj)+1].wep;

                elseif itemObj["ClassName"] == "gem_square_1" then
                    gemParts = gemBlue[GET_ITEM_LEVEL(itemObj)].wep;
                    gemSkill = gemBlue[GET_ITEM_LEVEL(itemObj)+1].wep;

                elseif itemObj["ClassName"] == "gem_diamond_1" then
                    gemParts = gemGreen[GET_ITEM_LEVEL(itemObj)].wep;
                    gemSkill = gemGreen[GET_ITEM_LEVEL(itemObj)+1].wep;

                elseif itemObj["ClassName"] == "gem_star_1" then
                    gemParts = gemYellow[GET_ITEM_LEVEL(itemObj)].wep;
                    gemSkill = gemYellow[GET_ITEM_LEVEL(itemObj)+1].wep;
                end

                --<表示方法見つけるまで仮>
                gemSkill = string.gsub(gemSkill,"最","　");
                gemSkill = string.gsub(gemSkill,"物","　");
                gemSkill = string.gsub(gemSkill,"発","　");
                gemSkill = string.gsub(gemSkill,"抵","　");
                gemSkill = string.gsub(gemSkill,"魔","　");
                gemSkill = string.gsub(gemSkill,"攻","　");
                gemSkill = string.gsub(gemSkill,"防","　");
                gemSkill = string.gsub(gemSkill,"ｸﾘ","  ");
                gemSkill = string.gsub(gemSkill,"ﾌﾞﾛｯｸ","　 　");
                gemSkill = string.gsub(gemSkill,"HP","  ");
                gemSkill = string.gsub(gemSkill,"SP","  ");
                gemSkill = string.gsub(gemSkill,"R"," ");
                gemSkill = string.gsub(gemSkill,"回避","　　");
                gemSkill = string.gsub(gemSkill,"命中","　　");
                gemSkill = string.gsub(gemSkill,"貫通","　　");

                --<ジェムロースティングしていれば色変え>
                if itemObj["GemRoastingLv"] >= 1 then
                    gemParts = "{s11}Now : " .. "{#98FB98}{ol}" .. gemParts .. "{/}{/}{/}";
                else
                    gemParts = "{s11}Now : " .. gemParts .. "{/}";
                end

                gemSkill = "{s11}Next: " .. gemSkill .. "{/}";
            end
            

            name:SetTextByKey("value", "Lv".. itemLevel .. ":" .. GET_FULL_NAME(itemObj) .. cllInfo .."{nl}{s14}" .. gemParts .. "{nl}" .. gemSkill .. "{/}");

        elseif itemGroup == "Card" then
        --<Descの値は文字列じゃないっぽい？あとまわし>
            local cardDesc = "{s12}" .. itemObj["Desc"] .."{/}";
            name:SetTextByKey("value", "Lv".. itemLevel .. ":" .. GET_FULL_NAME(itemObj) .. cllInfo .. "{nl}　{nl}" .. cardDesc);


        elseif (itemObj.ClassName == "Scroll_SkillItem") then
            local skillClass = GetClassByType("Skill", itemObj.SkillType);
            name:SetTextByKey("value", "Lv".. itemObj.SkillLevel .. " " .. skillClass.Name .. ":" .. GET_FULL_NAME(itemObj));
        else
            name:SetTextByKey("value", GET_FULL_NAME(itemObj) .. cllInfo);
        end

        name = tolua.cast(name, 'ui::CRichText');
        name:SetTextAlign("left", "center");
        name:SetPos(name:GetX(), 10);


-- add code end

        local count = ctrlSet:GetChild("count");
        count:SetTextByKey("value", marketItem.count);
        
        local level = ctrlSet:GetChild("level");
        level:SetTextByKey("value", itemObj.UseLv);

        local price = ctrlSet:GetChild("price");
        price:SetTextByKey("value", GetCommaedText(marketItem.sellPrice));
        price:SetUserValue("Price", marketItem.sellPrice);

        --Marketnames integration
        if (marketItem ~= nil) then
            SHOW_MARKET_NAMES(ctrlSet, marketItem)
        end

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

