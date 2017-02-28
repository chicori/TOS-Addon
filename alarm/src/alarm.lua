--とらハムさんフレーム作成ありがとう！

--アドオン名（大文字）
local addonName = "ALARM";
local addonNameLower = string.lower(addonName);
--作者名
local author = "torahamuchicorin";

--アドオン内で使用する領域を作成。以下、ファイル内のスコープではグローバル変数gでアクセス可
_G["ADDONS"] = _G["ADDONS"] or {};
_G["ADDONS"][author] = _G["ADDONS"][author] or {};
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {};
local g = _G["ADDONS"][author][addonName];

--設定ファイル保存先
g.settingsDirLoc  = string.format("../addons/%s", addonNameLower);
g.settingsFileLoc = string.format("%s/settings.json", g.settingsDirLoc);


--デフォルト設定
if not g.loaded then
	g.settings = {
		set0  = {enable=false; hour=""; minute=""; body="アラーム１"  ; repeatcount=0; sound=""; startdate=""};
		set1  = {enable=false; hour=""; minute=""; body="アラーム２"  ; repeatcount=0; sound=""; startdate=""};
		set2  = {enable=false; hour=""; minute=""; body="アラーム３"  ; repeatcount=0; sound=""; startdate=""};
		set3  = {enable=false; hour=""; minute=""; body="アラーム４"  ; repeatcount=0; sound=""; startdate=""};
		set4  = {enable=false; hour=""; minute=""; body="アラーム５"  ; repeatcount=0; sound=""; startdate=""};
		set5  = {enable=false; hour=""; minute=""; body="アラーム６"  ; repeatcount=0; sound=""; startdate=""};
		set6  = {enable=false; hour=""; minute=""; body="アラーム７"  ; repeatcount=0; sound=""; startdate=""};
		set7  = {enable=false; hour=""; minute=""; body="アラーム８"  ; repeatcount=0; sound=""; startdate=""};
		set8  = {enable=false; hour=""; minute=""; body="アラーム９"  ; repeatcount=0; sound=""; startdate=""};
		set9  = {enable=false; hour=""; minute=""; body="アラーム１０"; repeatcount=0; sound=""; startdate=""};
	};
end

--ライブラリ読み込み
local acutil = require('acutil');

-- 読み込みフラグ
g.loaded=false

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName));

--dofile("../data/addon_d/alarm/alarm.lua");

--************************************************
-- 設定保存
--************************************************
function ALARM_SAVE_SETTINGS()
	local errFlg = false;
	local frame = ui.GetFrame("alarm");

	--指定時間後に通知
	for i = 0, 9 do
	-- 時間確認
		if g.settings["set"..i].enable and ((frame:GetChild("HOUR"..i):GetText() == nil) or (frame:GetChild("HOUR"..i):GetText() == "")) then
			errFlg = true;
		else
			g.settings["set"..i].hour = frame:GetChild("HOUR"..i):GetText();
		end
	-- 分確認
		if g.settings["set"..i].enable and ((frame:GetChild("MINUTE"..i):GetText() == nil) or (frame:GetChild("MINUTE"..i):GetText() == "")) then
			errFlg = true;
		else
			g.settings["set"..i].minute = frame:GetChild("MINUTE"..i):GetText();
		end
	-- リピート確認
		if i >= 3 then
		else
			if g.settings["set"..i].enable and ((frame:GetChild("REPEAT"..i):GetText() == nil) or (frame:GetChild("REPEAT"..i):GetText() == "")) then
				errFlg = true;
			else
				g.settings["set"..i].repeatcount = frame:GetChild("REPEAT"..i):GetText();
			end
		end
	-- アラーム内容確認
		if g.settings["set"..i].enable and ((frame:GetChild("BODY"..i):GetText() == nil) or (frame:GetChild("BODY"..i):GetText() == "")) then
			errFlg = true;
		else
			g.settings["set"..i].body = frame:GetChild("BODY"..i):GetText();
		end

		g.settings["set"..i].startdate = math.floor(GetServerAppTime()/60)
--		CHAT_SYSTEM("set:" .. g.settings["set"..i].startdate .. "/os:" .. math.floor(ST()/60))
	end

	if errFlg then
		ui.SysMsg("設定に不正な部分があります。{nl}有効フラグにチェックを入れている時に{nl}時間やアラーム本文を空欄にしないようにしてください");
	else
		acutil.saveJSON(g.settingsFileLoc, g.settings);
		ui.SysMsg("アラーム設定を保存しました");
	end
end

--************************************************
-- プレビュー
--************************************************
function ALARM_PREVIEW_NICO()
	for i=1,5 do
		NICO_CHAT("テスト：" .. os.date("%H:%M").."になりました")
	end
end

function ALARM_PREVIEW_GUIDEMSG()
	GUIDE_MSG("テスト：" .. os.date("%H:%M").."になりました")
end
function ALARM_PREVIEW_MSGBOX()

	ui.MsgBox("テスト：" .. os.date("%H:%M").."になりました")

end
function ALARM_PREVIEW_CHATSYSTEM()

	CHAT_SYSTEM("テスト：" .. os.date("%H:%M").."になりました")

end

--************************************************
--マップ読み込み時処理（1度だけ）
--************************************************
function ALARM_ON_INIT(addon, frame)
	-- 初期設定項目は1度だけ行う
	if g.loaded==false then
		g.addon = addon;
		g.frame = frame;
		frame:ShowWindow(0);
		--コマンド登録
		acutil.slashCommand("/alarm", ALARM_OPEN);
		acutil.slashCommand("/al", ALARM_OPEN);

		-- 設定読み込み
		if not g.loaded then
			local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings);
			-- 読み込めない = ファイルがない
			if err then
				-- フォルダ作ってファイル作る
--				ALARM_CREATE_DIR(g.settingsDirLoc);
				acutil.saveJSON(g.settingsFileLoc, g.settings);
			else
				-- 読み込めたら読み込んだ値使う
				g.settings = t;
			end
			g.loaded = true;
		end
		ALARM_CREATE_FRAME();
	end

	addon:RegisterMsg('REAL_TIME_UPDATE', 'ALARM_ACTION');
end

--************************************************
-- オープンクローズ処理
--************************************************
function ALARM_OPEN()
	ui.OpenFrame("alarm");
	ALARM_CREATE_FRAME()
end

function ALARM_CLOSE()
	ui.CloseFrame("alarm");
end

--************************************************
-- フレーム作成
--************************************************
function ALARM_CREATE_FRAME()

--//フレームサイズ
	local frame = ui.GetFrame("alarm");
	frame:Resize(660,700);	--横,縦

--//ラベル
	local fontType = "{@st43}"
	local fontName = "white_16_ol"
	local rtLabel = {
		[1]  = {name="■ 指定時間後に通知"; left=40 ; top= 0 ;  h=0; w=0;};
		[2]  = {name="使用"               ; left=75 ; top= 40;  h=0; w=0;};
		[3]  = {name="回数"               ; left=140; top= 40;  h=0; w=0;};
		[4]  = {name="時間"               ; left=215; top= 40;  h=0; w=0;};
		[5]  = {name="通知メッセージ"     ; left=360; top= 40;  h=0; w=0;};
		[6]  = {name="音"                 ; left=660; top= 40;  h=0; w=0;};

		[7]  = {name="■ 定時アラーム"    ; left=40 ; top= 220; h=0; w=0;};
		[8]  = {name="使用"               ; left=75 ; top= 260; h=0; w=0;};
		[9]  = {name="毎日"               ; left=140; top= 260; h=0; w=0;};
		[10] = {name="時間"               ; left=210; top= 260; h=0; w=0;};
		[11] = {name="通知メッセージ"     ; left=360; top= 260; h=0; w=0;};
		[12] = {name="音"                 ; left=660; top= 260; h=0; w=0;};
	};

	for i, ver in ipairs(rtLabel) do
		local header = frame:CreateOrGetControl("richtext", "ctrl_rtLabel"..i, rtLabel[i].left, rtLabel[i].top, rtLabel[i].h, rtLabel[i].w);
		tolua.cast(header, "ui::CRichText");
		header:SetFontName(fontName);
		header:SetText(fontType .. rtLabel[i].name .. "{/}");
	end

--//コントロール１
	for i = 0, 2 do		--繰り返し行数
		local marginTop = 75+(40*i)

		local rtCtrl = {
			[1]  = {name="ENABLE"  ; type= "checkbox"; left=90 ; top=0; h=35 ; w=35;        };
			[2]  = {name="REPEAT"  ; type= "edit"    ; left=150; top=0; h=30 ; w=35; max=99 };
			[3]  = {name="HOUR"    ; type= "edit"    ; left=200; top=0; h=35 ; w=35; max=23 };
			[4]  = {name="SPLIT"   ; type= "richtext"; left=229; top=0; h=35 ; w=35;        };
			[5]  = {name="MINUTE"  ; type= "edit"    ; left=250; top=0; h=35 ; w=35; max=59 };
			[6]  = {name="BODY"    ; type= "edit"    ; left=300; top=0; h=300; w=35; max=100};
		};
	
		for j, ver in ipairs(rtCtrl) do
			
			local create_CTRL = frame:CreateOrGetControl(rtCtrl[j].type, rtCtrl[j].name..i, rtCtrl[j].left, marginTop, rtCtrl[j].h, rtCtrl[j].w);
	
			if rtCtrl[j].type == "checkbox" then
				tolua.cast(create_CTRL, "ui::CCheckBox");
				create_CTRL:SetClickSound("button_click_big");
				create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
				create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
				create_CTRL:SetOverSound("button_over");
				create_CTRL:SetEventScript(ui.LBUTTONUP, "ALARM_TOGGLE_CHECK_enable");
				create_CTRL:SetUserValue("NUMBER", i);

			elseif rtCtrl[j].type == "edit" then
				tolua.cast(create_CTRL, "ui::CEditControl");
				create_CTRL:MakeTextPack();
				create_CTRL:SetTextAlign("center", "center");
				create_CTRL:SetFontName("white_16_ol");
				create_CTRL:SetSkinName("systemmenu_vertical");
				if rtCtrl[j].name == "BODY" then
					create_CTRL:SetMaxLen(rtCtrl[j].max);
					create_CTRL:SetTextAlign("left", "center");
				else
					create_CTRL:SetNumberMode(1);
					create_CTRL:SetMaxNumber(rtCtrl[j].max);

				end

			elseif rtCtrl[j].type == "richtext" then
				create_CTRL = frame:CreateOrGetControl(rtCtrl[j].type, rtCtrl[j].name..i, rtCtrl[j].left, marginTop+5, rtCtrl[j].h, rtCtrl[j].w);
				tolua.cast(create_CTRL, "ui::CRichText");
				create_CTRL:SetFontName("white_24_ol");
				create_CTRL:SetText("：");
			end

			--ロード値のセット
			if rtCtrl[j].name == "ENABLE" then
				if g.settings["set"..i].enable then
					create_CTRL:SetCheck(1);
				else
					create_CTRL:SetCheck(0);
				end
			elseif rtCtrl[j].name == "REPEAT" then
				if g.settings["set"..i].hour ~= "" then
					create_CTRL:SetText(g.settings["set"..i].repeatcount);
				end
			elseif rtCtrl[j].name == "HOUR" then
				if g.settings["set"..i].hour ~= "" then
					create_CTRL:SetText(g.settings["set"..i].hour);
				end
			elseif rtCtrl[j].name == "MINUTE" then
				if g.settings["set"..i].minute ~= "" then
					create_CTRL:SetText(g.settings["set"..i].minute);
				end
			elseif rtCtrl[j].name == "BODY" then
				if g.settings["set"..i].body ~= "" then
					create_CTRL:SetText(g.settings["set"..i].body);
					create_CTRL:SetTextAlign("left", "center");
				end
			elseif rtCtrl[j].name == "SOUND" then
				if g.settings["set"..i].sound ~= "" then
					create_CTRL:SetText(g.settings["set"..i].sound);
				end
			end
		end

	--dofile("../data/addon_d/alarm/alarm.lua");
	end

--//コントロール２
--↑のコントロール１に統合すべきか別にすべきか迷いが生じたのでどっちでもいけるように中途半端になってます・・・。
	for i = 3, 9 do	--繰り返し行数
		local marginTop = 180+(40*i)

		local rtCtrl2 = {
			[1]  = {name="ENABLE"  ; type= "checkbox"; left=90 ; top=0; h=35 ; w=35;        };
			[2]  = {name="REPEAT"  ; type= "checkbox"; left=150; top=0; h=30 ; w=35;        };
			[3]  = {name="HOUR"    ; type= "edit"    ; left=200; top=0; h=35 ; w=35; max=23 };
			[4]  = {name="SPLIT"   ; type= "richtext"; left=229; top=0; h=35 ; w=35;        };
			[5]  = {name="MINUTE"  ; type= "edit"    ; left=250; top=0; h=35 ; w=35; max=59 };
			[6]  = {name="BODY"    ; type= "edit"    ; left=300; top=0; h=300; w=35; max=100};
		};
	
		for j, ver in ipairs(rtCtrl2) do

			local create_CTRL = frame:CreateOrGetControl(rtCtrl2[j].type, rtCtrl2[j].name..i, rtCtrl2[j].left, marginTop, rtCtrl2[j].h, rtCtrl2[j].w);
	
			if rtCtrl2[j].type == "checkbox" then	
				tolua.cast(create_CTRL, "ui::CCheckBox");
				create_CTRL:SetClickSound("button_click_big");
				create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
				create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
				create_CTRL:SetOverSound("button_over");
				create_CTRL:SetUserValue("NUMBER", i);
			elseif rtCtrl2[j].type == "edit" then
				tolua.cast(create_CTRL, "ui::CEditControl");
				create_CTRL:MakeTextPack();
				create_CTRL:SetTextAlign("center", "center");
				create_CTRL:SetFontName("white_16_ol");
				create_CTRL:SetSkinName("systemmenu_vertical");
				if rtCtrl2[j].name == "BODY" then
					create_CTRL:SetMaxLen(rtCtrl2[j].max);
					create_CTRL:SetTextAlign("left", "center");
				else
					create_CTRL:SetNumberMode(1);
					create_CTRL:SetMaxNumber(rtCtrl2[j].max);
				end
			elseif rtCtrl2[j].type == "richtext" then
				create_CTRL = frame:CreateOrGetControl(rtCtrl2[j].type, rtCtrl2[j].name..i, rtCtrl2[j].left, marginTop+5, rtCtrl2[j].h, rtCtrl2[j].w);
				tolua.cast(create_CTRL, "ui::CRichText");
				create_CTRL:SetFontName("white_24_ol");
				create_CTRL:SetText("：");
			end
			--ロード値のセット
			if rtCtrl2[j].name == "ENABLE" then
				create_CTRL:SetEventScript(ui.LBUTTONUP, "ALARM_TOGGLE_CHECK_enable");
				if g.settings["set"..i].enable then
					create_CTRL:SetCheck(1);
				else
					create_CTRL:SetCheck(0);
				end
			elseif rtCtrl2[j].name == "REPEAT" then
				create_CTRL:SetEventScript(ui.LBUTTONUP, "ALARM_TOGGLE_CHECK_EVERY_FLG");
				if g.settings["set"..i].repeatcount >= 2 then
					create_CTRL:SetCheck(1);
				else
					create_CTRL:SetCheck(0);
				end
			elseif rtCtrl2[j].name == "HOUR" then
				if g.settings["set"..i].hour ~= "" then
					create_CTRL:SetText(g.settings["set"..i].hour);
				end
			elseif rtCtrl2[j].name == "MINUTE" then
				if g.settings["set"..i].minute ~= "" then
					create_CTRL:SetText(g.settings["set"..i].minute);
				end
			elseif rtCtrl2[j].name == "BODY" then
				if g.settings["set"..i].body ~= "" then
					create_CTRL:SetText(g.settings["set"..i].body);
				end
			elseif rtCtrl2[j].name == "SOUND" then
				if g.settings["set"..i].sound ~= "" then
					create_CTRL:SetText(g.settings["set"..i].sound);
				end
			end
		end
	--dofile("../data/addon_d/alarm/alarm.lua");
	end


--//ボタン：保存
	local save_button = frame:CreateOrGetControl("button", "ALARM_SAVE_BUTTON", 450, 595, 150, 55);
	tolua.cast(save_button, "ui::CButton");
	save_button:SetFontName("white_16_ol");
	save_button:SetEventScript(ui.LBUTTONDOWN, "ALARM_SAVE_SETTINGS");
	save_button:SetText("保存");


--ラベル：プレビュー
--	local header_preview = frame:CreateOrGetControl("richtext", "ALARM_HEADER_PREVIEW", 52, 715, 0, 0);
--	tolua.cast(header_preview, "ui::CRichText");
--	header_preview:SetFontName("white_16_ol");
--	header_preview:SetText("{@st16}通知イメージ{/}");
--//ボタン：プレビュー
--	local btnPV = {
--		[1] = {name="NICO CHAT"; left=50 ; up=740; h=100; w=30; Fn="ALARM_PREVIEW_NICO"      };
--		[2] = {name="Guide MSG"; left=160; up=740; h=100; w=30; Fn="ALARM_PREVIEW_GUIDEMSG"  };
--		[3] = {name="Msg Box"  ; left=270; up=740; h=100; w=30; Fn="ALARM_PREVIEW_MSGBOX"    };
--		[4] = {name="CHAT MSG" ; left=380; up=740; h=100; w=30; Fn="ALARM_PREVIEW_CHATSYSTEM"};
--	};
---	for j, ver in ipairs(btnPV) do
--		local prev_button = frame:CreateOrGetControl("button", "ctrl_prevbtn"..j, btnPV[j].left, btnPV[j].up, btnPV[j].h, btnPV[j].w);
--		tolua.cast(prev_button, "ui::CButton");
--		prev_button:SetFontName(fontName);
--		prev_button:SetEventScript(ui.LBUTTONDOWN, btnPV[j].Fn);
--		prev_button:SetText(btnPV[j].name);
--	end
--dofile("../data/addon_d/alarm/alarm.lua");


end

--************************************************
-- チェックボックスのイベント
--************************************************
function ALARM_TOGGLE_CHECK_enable(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings["set"..ctrl:GetUserValue("NUMBER")].enable = true;
	else
		g.settings["set"..ctrl:GetUserValue("NUMBER")].enable = false;
	end
end
--************************************************
-- チェックボックスのイベント
--************************************************
function ALARM_TOGGLE_CHECK_EVERY_FLG(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings["set"..ctrl:GetUserValue("NUMBER")].repeatcount = 100;
	else
		g.settings["set"..ctrl:GetUserValue("NUMBER")].repeatcount = 1;
	end
end


--アドオンマネージャ経由だといらない処理。
--os.excuteだと一瞬DOS画面が出るので知らない人はびびってしまうかも？
--************************************************
-- ディレクトリ作成
--************************************************
--function ALARM_CREATE_DIR(dirname)
--	if option.GetCurrentCountry()=="Japanese" then
--		local tempDirStr = string.gsub(dirname, "/", "\\");
--		os.execute("mkdir "..tempDirStr)
--	else
--		os.execute("mkdir "..dirname);
--	end
--end

function ALARM_ACTION(frame, msg, argStr, argNum)

	local nowTime = string.format("%02d:%02d", math.floor(argNum/100), argNum%100)
	local nowDate = math.floor(GetServerAppTime()/60)

--		NICO_CHAT(nowTime .. "これは毎分テスト")
--		NICO_CHAT(nowDate)
--		CHAT_SYSTEM("now" .. nowDate)


--set0～2、set3～10で分けているのは今後の処理で迷いが生じたため。
	--指定時間アラーム set0～2
	for i=0, 2 do
		if g.settings["set"..i].enable == true then
			if tonumber(g.settings["set"..i].repeatcount) >= 1 then
				local setDate = g.settings["set"..i].startdate + (g.settings["set"..i].minute) + (g.settings["set"..i].hour*60)
				if nowDate == setDate then
					for v=0,8 do
						NICO_CHAT(g.settings["set"..i].body)
					end

					CHAT_SYSTEM(string.format("【指定時間後通知】%02d:%02d経過%s",g.settings["set"..i].hour,g.settings["set"..i].minute,g.settings["set"..i].body));
					g.settings["set"..i].repeatcount = tonumber(g.settings["set"..i].repeatcount)-1
					g.settings["set"..i].startdate = math.floor(GetServerAppTime()/60)
					acutil.saveJSON(g.settingsFileLoc, g.settings);
				end
			end

		end
	end

	--定時アラーム　set3～10
	for i=3, 10 do
		if g.settings["set"..i].enable == true then
			local setTime = string.format("%02d:%02d", g.settings["set"..i].hour, g.settings["set"..i].minute )

			if nowTime == setTime then
				for v=1,8 do
					NICO_CHAT(g.settings["set"..i].body)
				end
				CHAT_SYSTEM("【定時アラーム通知】" .. setTime .. " " .. g.settings["set"..i].body);

				if g.settings["set"..i].repeatcount ~= 100 then
					g.settings["set"..i].enable = false
					acutil.saveJSON(g.settingsFileLoc, g.settings);
				end
				
			end
		end
	end

end
