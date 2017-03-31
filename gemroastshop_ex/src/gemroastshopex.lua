--アドオン名（大文字）
local addonName = "GEMROASTSHOPEX"
local addonNameLower = string.lower(addonName)
--作者名
local author = "CHICORI"

--アドオン内で使用する領域を作成。以下、ファイル内のスコープではグローバル変数gでアクセス可
_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

--設定ファイル保存先
g.settingsFileLoc = string.format("../addons/%s/settings.json", addonNameLower)

--ライブラリ読み込み
local acutil = require('acutil')

--デフォルト設定
if not g.loaded then
  g.settings = {
    enable = true,
	shop   = "",
	price  = 4286,
  }
end

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName))

function GEMROASTSHOPEX_SAVE_SETTINGS()
	acutil.saveJSON(g.settingsFileLoc, g.settings)
end

--マップ読み込み時処理（1度だけ）
function GEMROASTSHOPEX_ON_INIT(addon, frame)
	g.addon = addon
	g.frame = frame

	if not g.loaded then
		local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings)

		if err then
			--設定ファイル読み込み失敗時処理
			CHAT_SYSTEM(string.format("[%s] cannot load setting files", addonName))
		else
			--設定ファイル読み込み成功時処理
			g.settings = t
		end

		g.loaded = true
	end

	--設定ファイル保存処理
	GEMROASTSHOPEX_SAVE_SETTINGS()

	--メッセージ受信登録処理
	acutil.setupHook(ITEMBUFF_SET_SKILLTYPE_HOOKED, "ITEMBUFF_SET_SKILLTYPE")

end

--dofile("../data/addon_d/gemroastshopex/gemroastshopex.lua");


function ITEMBUFF_SET_SKILLTYPE_HOOKED(frame, skillName, skillLevel, titleName)
    frame:SetUserValue("SKILLNAME", skillName)
    frame:SetUserValue("SKILLLEVEL", skillLevel)

    local title = frame:GetChild("title");
    title:SetTextByKey("txt", titleName);

	local frame    = ui.GetFrame("itembuff");
	local gBox     = GET_CHILD(frame, "OptionBox")
	local shopName = GET_CHILD(gBox, "TitleInput", "ui::CEditControl")
	shopName:SetText(g.settings.shop)

	local shopPrice = GET_CHILD(gBox, "MoneyInput", "ui::CEditControl")
	shopPrice:SetText(g.settings.price)



--//ボタン：保存
	local save_button = frame:CreateOrGetControl("button", "GEMROASTSHOPEX_SAVE_BTN", 317, 135, 120, 22);
	tolua.cast(save_button, "ui::CButton");
	save_button:SetFontName("white_16_ol");
	save_button:SetEventScript(ui.LBUTTONDOWN, "GEMROASTSHOPEX_SAVEBTN");
	save_button:SetText("設定保存");

--//ラベル：原価
	local setLbl   = frame:CreateOrGetControl("richtext", "GEMROASTSHOPEX_LBL", 177, 240, 50, 50);
	tolua.cast(setLbl, "ui::CRichText");
	setLbl:SetFontName("white_16_ol");
	setLbl:SetText("原価 : 4,286");

end


function GEMROASTSHOPEX_SAVEBTN(frame)
	local frame     = ui.GetFrame("itembuff");
	local gBox      = GET_CHILD(frame, "OptionBox")
	local shopName  = GET_CHILD(gBox, "TitleInput"):GetText()
	local shopPrice = GET_CHILD(gBox, "MoneyInput"):GetText()
	
	local SaveMsg = "商店名：".. shopName .. "{nl} {nl}価格：" .. shopPrice .. "{nl} {nl}以上の内容で登録しますか？"
	ui.MsgBox(SaveMsg,"GEMROASTSHOPEX_SAVEACT(\"" .. shopName .. "\"," .. shopPrice .. ")","None")
end
function GEMROASTSHOPEX_SAVEACT(shopName,shopPrice)
	g.settings.shop = shopName
	g.settings.price = shopPrice
	GEMROASTSHOPEX_SAVE_SETTINGS()
	
	CHAT_SYSTEM(shopName .."/価格:".. GetCommaedText(shopPrice) .. "で登録しました。")
end
