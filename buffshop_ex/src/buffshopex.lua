--アドオン名（大文字）
local addonName = "BUFFSHOPEX"
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
	shop   = "おみせ",
	aspar  = 1000,
	bless  = 400,
	sacra  = 700
  }
end

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName))

function BUFFSHOPEX_SAVE_SETTINGS()
	acutil.saveJSON(g.settingsFileLoc, g.settings)
end


--マップ読み込み時処理（1度だけ）
function BUFFSHOPEX_ON_INIT(addon, frame)
	g.addon = addon
	g.frame = frame

	acutil.slashCommand("/"..addonNameLower, BUFFSHOPEX_PROCESS_COMMAND)
	acutil.slashCommand("/buffshop", BUFFSHOPEX_PROCESS_COMMAND)

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
	BUFFSHOPEX_SAVE_SETTINGS()

	--メッセージ受信登録処理
	acutil.setupHook(BUFFSELLER_REG_OPEN_HOOKED, "BUFFSELLER_REG_OPEN")
end


--チャットコマンド処理（acutil使用時）
function BUFFSHOPEX_PROCESS_COMMAND(command)
	local cmd = ""

	if #command > 0 then
		cmd = table.remove(command, 1)
	else
		local msg = "/buffshop *{nl}name = 店名{nl}アスパーション = a金額{nl}ブレス = b金額{nl}サクラメント = s金額{nl}例：/buffshop b777"
		return ui.MsgBox(msg,"","Nope")
	end

	if cmd == "on" then
		g.settings.enable = true
		CHAT_SYSTEM(string.format("[%s] is enable", addonName))
		BUFFSHOPEX_SAVE_SETTINGS()
		return
	elseif cmd == "off" then
		--無効
		g.settings.enable = false
		CHAT_SYSTEM(string.format("[%s] is disable", addonName))
		BUFFSHOPEX_SAVE_SETTINGS()
		return
	elseif string.sub(cmd,1,4) == "name" then
		g.settings.shop = string.sub(cmd,5)
		ui.MsgBox("ショップ名を登録しました。{nl} {nl}" .. string.sub(cmd,5))
		BUFFSHOPEX_SAVE_SETTINGS()
		return

	--この辺適当です。廃止予定
	elseif string.sub(cmd,1,1) == "a" then
		local cmdPrice = tonumber(string.sub(cmd,2))
		local altMsg = "アスパーションを次の価格で保存します。"

		if 1000 >= tonumber(cmdPrice) then
			altMsg = "アスパーションの原価は1000sです。{nl}原価以下になりますが保存しますか？"
		end

		local calcPrice = cmdPrice - 1000
		local yesscp    = string.format("SKILLPRICE_SAVE(%q)",cmd)
		ui.MsgBox(altMsg .. "{nl} {nl}（設定額:" .. cmdPrice .. "s / 差益:".. calcPrice .."s)",yesscp,"None")
		return

	elseif string.sub(cmd,1,1) == "b" then
		local cmdPrice = tonumber(string.sub(cmd,2))
		local altMsg   = "ブレッシングを次の価格で保存します。"

		if 400 >= cmdPrice then
			altMsg = "ブレッシングの原価は400sです。{nl}原価以下になりますが保存しますか？"
		end

		local calcPrice = cmdPrice - 400
		local yesscp = string.format("SKILLPRICE_SAVE(%q)",cmd)
		ui.MsgBox(altMsg .. "{nl} {nl}（設定額:" .. cmdPrice .. "s / 差益:".. calcPrice .."s)",yesscp,"None")
		return

	elseif string.sub(cmd,1,1) == "s" then
		local cmdPrice = tonumber(string.sub(cmd,2))
		local altMsg   = "サクラメントを次の価格で保存します。"

		if 700 >= tonumber(cmdPrice) then
			altMsg = "サクラメントの原価は700sです。{nl}原価以下になりますが保存しますか？"
		end

		local calcPrice = cmdPrice - 700
		local yesscp = string.format("SKILLPRICE_SAVE(%q)",cmd)
		ui.MsgBox(altMsg .. "{nl} {nl}（設定額:" .. cmdPrice .. "s / 差益:".. calcPrice .."s)",yesscp,"None")
		return
	end

	CHAT_SYSTEM(string.format("[%s] Invalid Command", addonName))
end

function SKILLPRICE_SAVE(cmd)
	local cmdFlg   = string.sub(cmd,1,1)
	local cmdPrice = tonumber(string.sub(cmd,2))

		if cmdFlg == "a" then				--アスパ
			g.settings.aspar = cmdPrice

		elseif cmdFlg == "b" then			--ブレス
			g.settings.bless = cmdPrice

		elseif cmdFlg == "s" then			--サクラ
			g.settings.sacra = cmdPrice

		end

		BUFFSHOPEX_SAVE_SETTINGS()
end


function BUFFSELLER_REG_OPEN_HOOKED(frame)
	ui.OpenFrame("skilltree")

	local customSkill = frame:GetUserValue("CUSTOM_SKILL")
	if customSkill == "None" then
		frame:SetUserValue("GroupName", "BuffRegister")
		frame:SetUserValue("ServerGroupName", "Buff")
	else
		frame:SetUserValue("GroupName", customSkill)
		frame:SetUserValue("ServerGroupName", customSkill)
	end
	BUFFSELLER_UPDATE_LIST(frame)

-- ここから追加処理(ここまではオリジナル処理) ------------------------------


--使用可否
	if g.settings.enable == false then return end


--露店名
	local gBox     = GET_CHILD(frame, "gbox")
	local sellList = GET_CHILD(gBox, "selllist")
	local shopName = GET_CHILD(gBox, "inputname", "ui::CEditControl")
	shopName:SetText(g.settings.shop)


--スキルセット
	local relationSkill = {
		[1] = {name = "アスパーション"; sklID = 40201; price=g.settings.aspar};
		[2] = {name = "ブレッシング";   sklID = 40203; price=g.settings.bless};
		[3] = {name = "サクラメント";   sklID = 40205; price=g.settings.sacra};
	}
	for i, ver in ipairs(relationSkill) do
		local skillID = relationSkill[i].sklID
		local toFrame = frame:GetTopParentFrame()
		BUFFSELLER_REGISTER(toFrame, skillID)
	end


--価格セット（スキルセットと同じループに入れると処理タイミングの関係で不発します。）
	for i, ver in ipairs(relationSkill) do
		local setPrice = relationSkill[i].price
		local ctrlSet  = GET_CHILD(sellList, "CTRLSET_" .. i - 1)
		local priceIn  = GET_CHILD(ctrlSet, "priceinput")
		tolua.cast(priceIn, 'ui::CEditControl');
		priceIn:SetText(setPrice)

		BUFFSELLER_TYPING_PRICE(ctrlSet, priceIn)
	end

end
