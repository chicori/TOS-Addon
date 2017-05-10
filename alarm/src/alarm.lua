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
		set0  = {enable=false; hour=""; minute=""; body="Alarm 1"  ; repeatcount=0; sound=""; startdate=""};
		set1  = {enable=false; hour=""; minute=""; body="Alarm 2"  ; repeatcount=0; sound=""; startdate=""};
		set2  = {enable=false; hour=""; minute=""; body="Alarm 3"  ; repeatcount=0; sound=""; startdate=""};
		set3  = {enable=false; hour=""; minute=""; body="Alarm 4"  ; repeatcount=0; sound=""; startdate=""};
		set4  = {enable=false; hour=""; minute=""; body="Alarm 5"  ; repeatcount=0; sound=""; startdate=""};
		set5  = {enable=false; hour=""; minute=""; body="Alarm 6"  ; repeatcount=0; sound=""; startdate=""};
		set6  = {enable=false; hour=""; minute=""; body="Alarm 7"  ; repeatcount=0; sound=""; startdate=""};
		set7  = {enable=false; hour=""; minute=""; body="Alarm 8"  ; repeatcount=0; sound=""; startdate=""};
		set8  = {enable=false; hour=""; minute=""; body="Alarm 9"  ; repeatcount=0; sound=""; startdate=""};
		set9  = {enable=false; hour=""; minute=""; body="Alarm 10"; repeatcount=0; sound=""; startdate=""};
		set10 = {enable=false; hour=""; minute=""; body="Dilgele"  ; repeatcount=0; sound=""; startdate=""};
	};
end

--ライブラリ読み込み
local acutil = require('acutil');

-- 読み込みフラグ
g.loaded=false

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName));

	local playList = {
	{name=""             ,         title="None"},
	{name="Login_Barrack",         title="BGM1 : Tree of Savior          "},
	{name="f_3cmlake",             title="BGM2 : Signs of Penance        "},
    {name="id_thorn",              title="BGM3 : Kevin Cordis            "},
    {name="id_thorn2",             title="BGM4 : Hunter Green            "},
    {name="m_boss_b",              title="BGM5 : Wings of courage        "},
    {name="m_boss_scenario",       title="BGM6 : O Deive                 "},
    {name="m_boss_scenario2",      title="BGM7 : Deives Veliava          "},
    {name="mission_chaple_01",     title="BGM8 : Kevin Peripeteia        "},
    {name="mission_huevillage_01", title="BGM9 : Symphonix Feel Free     "},
	{name="id_new3",               title="BGM10 : Repetitive              "},
	};



--------------------------------------------------------------------------------------------
-- 設定保存
--------------------------------------------------------------------------------------------
function ALARM_SAVE_SETTINGS()
	local errFlg = false;
	local frame = ui.GetFrame("alarm");

	--指定時間後に通知
	for i = 0, 9 do

	-- 時間
		local txtHour = frame:GetChild("HOUR"..i):GetText();
		if g.settings["set"..i].enable and ((txtHour == nil) or (txtHour == "")) then
			errFlg = true;
		else
			g.settings["set"..i].hour = txtHour
		end

	-- 分
		local txtMinute = frame:GetChild("MINUTE"..i):GetText();
		if g.settings["set"..i].enable and ((txtMinute == nil) or (txtMinute == "")) then
			errFlg = true;
		else
			g.settings["set"..i].minute = txtMinute
		end

	-- リピート
		if i >= 3 then
		else
			local txtRepeat = frame:GetChild("REPEAT"..i):GetText()
			if g.settings["set"..i].enable and ((txtRepeat == nil) or (txtRepeat == "")) then
				errFlg = true;
			else
				g.settings["set"..i].repeatcount = txtRepeat
			end
		end

	-- アラーム内容
		local txtBody = frame:GetChild("BODY"..i):GetText()
		if g.settings["set"..i].enable and ((txtBody == nil) or (txtBody == "")) then
			errFlg = true
		else
			g.settings["set"..i].body = txtBody
		end

	-- 今の時刻
		g.settings["set"..i].startdate = math.floor(GetServerAppTime()/60)

	-- 通知音
		local txtDroplist = string.sub((frame:GetChild("DROPLIST"..i):GetText()),22);
		for j, v in ipairs(playList) do
			if playList[j].title == txtDroplist then
				g.settings["set"..i].sound = playList[j].name
			end
		end

	end

	if errFlg then
		ui.SysMsg("There is an error with the current setup. {nl}Please don't leave any empty fields{nl}on a enabled (checked) alarm.");
	else
		acutil.saveJSON(g.settingsFileLoc, g.settings);
		ui.SysMsg("Alarms Set!");
	end
end

--------------------------------------------------------------------------------------------
-- 個別保存
--------------------------------------------------------------------------------------------
function ALARM_SINGLESAVE_SETTINGS(setno)
	local errFlg = false;
	local frame = ui.GetFrame("alarm");

	-- 時間確認
		local txtHour = frame:GetChild("HOUR"..setno):GetText();
		if g.settings["set"..setno].enable and ((txtHour == nil) or (txtHour == "")) then
			errFlg = true;
		else
			g.settings["set"..setno].hour = txtHour
		end

	-- 分確認
		local txtMinute = frame:GetChild("MINUTE"..setno):GetText();
		if g.settings["set"..setno].enable and ((txtMinute == nil) or (txtMinute == "")) then
			errFlg = true;
		else
			g.settings["set"..setno].minute = txtMinute
		end

	-- リピート確認
		local txtRepeat =  frame:GetChild("REPEAT"..setno):GetText();
		if setno >= 3 then
		else
			if g.settings["set"..setno].enable and ((txtRepeat == nil) or (txtRepeat == "")) then
				errFlg = true;
			else
				g.settings["set"..setno].repeatcount =txtRepeat
			end
		end

	-- アラーム内容確認
		local txtBody = frame:GetChild("BODY"..setno):GetText();
		if g.settings["set"..setno].enable and ((txtBody == nil) or (txtBody == "")) then
			errFlg = true;
		else
			g.settings["set"..setno].body = txtBody
		end

	-- 今の時刻
		g.settings["set"..setno].startdate = math.floor(GetServerAppTime()/60)

	-- 通知音
		local txtDroplist = string.sub((frame:GetChild("DROPLIST"..setno):GetText()),22);
		for i, v in ipairs(playList) do
			if playList[i].title == txtDroplist then
				g.settings["set"..setno].sound = playList[i].name
			end
		end

	if errFlg then
		ui.SysMsg("There is an error with the current setup. {nl}Please don't leave any empty fields{nl}on a enabled (checked) alarm.");
	else
		acutil.saveJSON(g.settingsFileLoc, g.settings);
		ui.SysMsg("Alarm " .. setno+1 .. " Set!");
	end
end


--------------------------------------------------------------------------------------------
-- テスト
--------------------------------------------------------------------------------------------
function ALARM_PREVIEW_NICO()
	for i=1,5 do
		NICO_CHAT("test")
	end
	imcSound.PlayMusic("f_3cmlake", 0)
end

function ALARM_PREVIEW_GUIDEMSG()
	GUIDE_MSG("test: " .. os.date("%H:%M").." became?")
end
function ALARM_PREVIEW_MSGBOX()
	ui.MsgBox("test: " .. os.date("%H:%M").." became?")
end
function ALARM_PREVIEW_CHATSYSTEM()
	CHAT_SYSTEM("test: " .. os.date("%H:%M").." became?")
end


function MINIMAP_RESIZE(width, hight, mywidth, myhight)
	local frame = ui.GetFrame("minimap");
	frame:Resize(width,hight);

	local ctrlMY = GET_CHILD(frame, "my")
	ctrlMY:Resize(mywidth, myhight);

end


--------------------------------------------------------------------------------------------
--マップ読み込み時処理（1度だけ）
--------------------------------------------------------------------------------------------
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

--//ボタン：ミニマップ
	local addbtnFrame = ui.GetFrame("time");
	addbtnFrame:SetLayerLevel(30);

	local addBtn
	local testMAPMATE = pcall(TOUKIBI_MAPMATE_EXEC_PCCUPDATE,"");
	if testMAPMATE == true then
		addBtn = addbtnFrame:CreateOrGetControl("button", "ADDBTN", 10, 0, 80, 30);
	else
		addBtn = addbtnFrame:CreateOrGetControl("button", "ADDBTN", 72, 3, 92, 30);
	end

	tolua.cast(addBtn, "ui::CButton");
	addBtn:SetAlpha(10);
	addBtn:SetEventScript(ui.LBUTTONDOWN, "ALARM_OPEN");
	addBtn:SetEventScript(ui.RBUTTONDOWN, "ALARM_SAVE_DILGER");
	addBtn:SetLayerLevel(35);

end

--------------------------------------------------------------------------------------------
-- オープンクローズ処理
--------------------------------------------------------------------------------------------
--/ オープン
function ALARM_OPEN()
	ui.OpenFrame("alarm");
	ALARM_CREATE_FRAME()





end
--// クローズ
function ALARM_CLOSE()
	ui.CloseFrame("alarm");
end


--------------------------------------------------------------------------------------------
-- フレーム作成
--------------------------------------------------------------------------------------------
function ALARM_CREATE_FRAME()

--//フレームサイズ
	local frame = ui.GetFrame("alarm");
	frame:Resize(840,690);	--横,縦

--//ラベル
	local fontType = "{@st43}{s18}"
	local fontName = "white_16_ol"
	local rtLabel = {
		[1]  = {name="■ Simple Timer: notify after the time set" ; left=48 ; top= 0 ;  h=0; w=0;};
		[2]  = {name="ON"                ; left=82 ; top= 30;  h=0; w=0;};
		[3]  = {name="Repeat"                ; left=128; top= 30;  h=0; w=0;};
		[4]  = {name="HH:MM"                ; left=200; top= 30;  h=0; w=0;};
		[5]  = {name="Message"      ; left=295; top= 30;  h=0; w=0;};
		[6]  = {name="Sound"                  ; left=520; top= 30;  h=0; w=0;};

		[7]  = {name="■ Scheduled Alarm: notify today or daily at HH:MM (24h format)"     ; left=48 ; top= 200; h=0; w=0;};
		[8]  = {name="ON"                ; left=82 ; top= 230; h=0; w=0;};
		[9]  = {name="Daily"                ; left=132; top= 230; h=0; w=0;};
		[10] = {name="HH:MM"                ; left=200; top= 230; h=0; w=0;};
		[11] = {name="Message"      ; left=295; top= 230; h=0; w=0;};
		[12] = {name="Sound"              ; left=520; top= 230; h=0; w=0;};

		[13] = {name="■ Sound Preview" ; left=48 ; top= 555; h=0; w=0;};
	};

	for i, ver in ipairs(rtLabel) do
		local header = frame:CreateOrGetControl("richtext", "ctrl_rtLabel"..i, rtLabel[i].left, rtLabel[i].top, rtLabel[i].h, rtLabel[i].w);
		tolua.cast(header, "ui::CRichText");
		header:SetFontName(fontName);
		header:SetText(fontType .. rtLabel[i].name .. "{/}");
	end


--//コントロールセット１
	for i = 0, 2 do		--繰り返し行数
		local marginTop = 60+(40*i)

		local rtCtrl = {
			[1]  = {name="ENABLE"  ; type= "checkbox"; left=85 ; top=0; h=35 ; w=35;            };
			[2]  = {name="REPEAT"  ; type= "edit"    ; left=140; top=0; h=30 ; w=35; max=99;    };
			[3]  = {name="HOUR"    ; type= "edit"    ; left=195; top=0; h=35 ; w=35; max=23;    };
			[4]  = {name="SPLIT"   ; type= "richtext"; left=234; top=0; h=35 ; w=35;            };
			[5]  = {name="MINUTE"  ; type= "edit"    ; left=245; top=0; h=35 ; w=35; max=59;    };
			[6]  = {name="BODY"    ; type= "edit"    ; left=300; top=0; h=200; w=35; max=100;   };
			[7]  = {name="DROPLIST"; type= "droplist"; left=515; top=0; h=200; w=33;            };
			[8]  = {name="SAVE"    ; type= "button"  ; left=730; top=0; h=70 ; w=32; body="Save"; fnc="ALARM_SINGLESAVE_SETTINGS"};
		};

		for j, ver in ipairs(rtCtrl) do
			local create_CTRL = frame:CreateOrGetControl(rtCtrl[j].type, rtCtrl[j].name..i, rtCtrl[j].left, marginTop, rtCtrl[j].h, rtCtrl[j].w);

			if rtCtrl[j].type == "checkbox" then
				tolua.cast(create_CTRL, "ui::CCheckBox");
				create_CTRL:SetClickSound("button_click_big");
				create_CTRL:SetAnimation("MouseOnAnim",  "btn_mouseover");
				create_CTRL:SetAnimation("MouseOffAnim", "btn_mouseoff");
				create_CTRL:SetOverSound("button_over");
				create_CTRL:SetEventScript(ui.LBUTTONUP, "ALARM_TOGGLE_CHECK_enableinput");
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

			elseif rtCtrl[j].type == "droplist" then
				tolua.cast(create_CTRL, "ui::CDropList");
				create_CTRL:SetSkinName("droplist_normal2");
				create_CTRL:SetTextAlign("left", "center");

				for j, v in ipairs(playList) do
					create_CTRL:AddItem(j, string.format("{#FFFFFF}{ol}{b}{s16}%s",v.title), 0, "None");
				end

			elseif rtCtrl[j].type == "button" then
				tolua.cast(create_CTRL, "ui::CButton");
				create_CTRL:SetFontName("white_16_ol");
				create_CTRL:SetEventScript(ui.LBUTTONDOWN, string.format("%s(%s)",rtCtrl[j].fnc,i));
				create_CTRL:SetText(rtCtrl[j].body);
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
			elseif rtCtrl[j].name == "DROPLIST" then
				if g.settings["set"..i].sound ~= "" then
		--			create_CTRL:SetText(g.settings["set"..i].sound);
				end
			end
		end
	end

--//コントロールセット２
--↑のコントロール１に統合すべきか別にすべきか迷いが生じたのでどっちでもいけるように中途半端になってます・・・。
	for i = 3, 9 do	--繰り返し行数
		local marginTop = 140+(40*i)

		local rtCtrl2 = {
			[1]  = {name="ENABLE"  ; type= "checkbox"; left=90 ; top=0; h=35 ; w=35;        };
			[2]  = {name="REPEAT"  ; type= "checkbox"; left=145; top=0; h=30 ; w=35;        };
			[3]  = {name="HOUR"    ; type= "edit"    ; left=195; top=0; h=35 ; w=35; max=23 };
			[4]  = {name="SPLIT"   ; type= "richtext"; left=234; top=0; h=35 ; w=35;        };
			[5]  = {name="MINUTE"  ; type= "edit"    ; left=245; top=0; h=35 ; w=35; max=59 };
			[6]  = {name="BODY"    ; type= "edit"    ; left=300; top=0; h=200; w=35; max=100};
			[7]  = {name="DROPLIST"; type= "droplist"; left=515; top=0; h=200; w=33;        };
			[8]  = {name="SAVE"    ; type= "button"  ; left=730; top=0; h=70 ; w=32; body="Save"; fnc="ALARM_SINGLESAVE_SETTINGS"};
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

			elseif rtCtrl2[j].type == "droplist" then
				tolua.cast(create_CTRL, "ui::CDropList");
				create_CTRL:SetSkinName("droplist_normal2");
				create_CTRL:SetTextAlign("left", "center");

				for k, v in ipairs(playList) do
					create_CTRL:AddItem(k, string.format("{#FFFFFF}{ol}{b}{s16}%s",v.title), 0, "None");
				end

			elseif rtCtrl2[j].type == "button" then
				tolua.cast(create_CTRL, "ui::CButton");
				create_CTRL:SetFontName("white_16_ol");
				create_CTRL:SetEventScript(ui.LBUTTONDOWN, string.format("%s(%s)",rtCtrl2[j].fnc,i));
				create_CTRL:SetText(rtCtrl2[j].body);
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
			elseif rtCtrl2[j].name == "DROPLIST" then
				if g.settings["set"..i].sound ~= "" then
			--		create_CTRL:SetText(g.settings["set"..i].sound);
				end
			end
		end
	end



--//プレビュー：DropBox
	local prev_sound = frame:CreateOrGetControl("droplist", "PREVSOUND", 80, 585, 260, 40);
	tolua.cast(prev_sound, "ui::CDropList");
	prev_sound:SetSkinName("droplist_normal2");
	prev_sound:ClearItems();
	prev_sound:SetTextAlign("left", "center");

	for j, v in ipairs(playList) do
		local nm = "{#FFFFFF}{ol}{b}{s16}" .. v.title;
		prev_sound:AddItem(j, nm, 1, "SOUND_PREV(\"" .. v.name .. "\"," .. "\"" .. v.title .."\")");
	end


--//ボタン：ディルゲレタイマー
	local save_button2 = frame:CreateOrGetControl("button", "ALARM_SAVE_BUTTON2",470, 570, 150, 55);
	tolua.cast(save_button2, "ui::CButton");
	save_button2:SetFontName("white_16_ol");
	save_button2:SetEventScript(ui.LBUTTONDOWN, "ALARM_SAVE_DILGER");
	save_button2:SetText("Dilgele");


--//ボタン：保存
	local save_button = frame:CreateOrGetControl("button", "ALARM_SAVE_BUTTON", 648, 570, 150, 55);
	tolua.cast(save_button, "ui::CButton");
	save_button:SetFontName("white_16_ol");
	save_button:SetEventScript(ui.LBUTTONDOWN, "ALARM_SAVE_SETTINGS");
	save_button:SetText("Save");


--//画像
	local obj_picture = frame:CreateOrGetControl("picture", "ALARM_OBJ_PICTURE", 425, 573, 45, 50);
	tolua.cast(obj_picture, "ui::CPicture");
	obj_picture:SetImage("emoticon_0023");


end

--------------------------------------------------------------------------------------------
-- チェックボックスのイベント
--------------------------------------------------------------------------------------------
--// 共通：使用
function ALARM_TOGGLE_CHECK_enable(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings["set"..ctrl:GetUserValue("NUMBER")].enable = true;
	else
		g.settings["set"..ctrl:GetUserValue("NUMBER")].enable = false;
	end
end

--// コントロールセット１：自動セット
function ALARM_TOGGLE_CHECK_enableinput(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings["set"..ctrl:GetUserValue("NUMBER")].enable = true;

		local find_name = GET_CHILD(frame, "REPEAT"..ctrl:GetUserValue("NUMBER"), "ui::CEditControl");
		find_name:SetText(1);

	else
		g.settings["set"..ctrl:GetUserValue("NUMBER")].enable = false;
		local find_name = GET_CHILD(frame, "REPEAT"..ctrl:GetUserValue("NUMBER"), "ui::CEditControl");
		find_name:SetText(0);
	end
end

--// コントロールセット２：毎日
function ALARM_TOGGLE_CHECK_EVERY_FLG(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.settings["set"..ctrl:GetUserValue("NUMBER")].repeatcount = 100;
	else
		g.settings["set"..ctrl:GetUserValue("NUMBER")].repeatcount = 1;
	end
end


--------------------------------------------------------------------------------------------
-- アラーム
--------------------------------------------------------------------------------------------
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
					CHAT_SYSTEM(string.format("Notify after: %02d:%02d repeat: %s alarm: %s",g.settings["set"..i].hour,g.settings["set"..i].repeatcount,g.settings["set"..i].minute,g.settings["set"..i].body));
					for v=0,10 do
						NICO_CHAT(g.settings["set"..i].body)
					end

					local alarmSound = g.settings["set"..i].sound
					if #alarmSound >= 1 then
						imcSound.PlayMusic(tostring(alarmSound), 1)
					end

					if tonumber(g.settings["set"..i].repeatcount) >= 2 then
						g.settings["set"..i].repeatcount = tonumber(g.settings["set"..i].repeatcount)-1
					else
						g.settings["set"..i].enable = false
					end

					g.settings["set"..i].startdate = math.floor(GetServerAppTime()/60)

					acutil.saveJSON(g.settingsFileLoc, g.settings);
					break;
				end
			end
		end
	end

	--定時アラーム　set3～9
	for i=3, 9 do
		if g.settings["set"..i].enable == true then
			local setTime = string.format("%02d:%02d", g.settings["set"..i].hour, g.settings["set"..i].minute )

			if nowTime == setTime then
				for v=0,10 do
					NICO_CHAT(g.settings["set"..i].body)
				end
				CHAT_SYSTEM("Scheduled" .. setTime .. " " .. g.settings["set"..i].body);

				local alarmSound = g.settings["set"..i].sound
				if #alarmSound >= 1 then
					imcSound.PlayMusic(tostring(alarmSound), 1)
				end

				if g.settings["set"..i].repeatcount ~= 100 then
					g.settings["set"..i].enable = false
					acutil.saveJSON(g.settingsFileLoc, g.settings);
				end
				break;
			end
		end
	end

	--ディルゲレ
	if g.settings["set10"].enable == true then

			local notice1h = g.settings["set10"].startdate + 60
			if nowDate == notice1h then
				CHAT_SYSTEM("Dilgele Timer: 1 hour and 30 minutes");
			end

			local notice2h = g.settings["set10"].startdate + 120
			if nowDate == notice2h then
				GUIDE_MSG("Dilgele Timer: About 30 minutes");
				CHAT_SYSTEM("Dilgele Timer: About 30 minutes");
			end


			local setDate = g.settings["set10"].startdate + (g.settings["set10"].minute) + (g.settings["set10"].hour*60)
			if nowDate == setDate then
					CHAT_SYSTEM("Dilgele Timer: 2 hours and 30 minutes has passed");
					for v=0,8 do
						NICO_CHAT("{img icon_item_Dilgele 40 40}" .. g.settings["set10"].body .. "{img icon_item_Dilgele 40 40}")
					end

					imcSound.PlayMusic(g.settings["set10"].sound, 1)
					g.settings["set10"].enable = false;
					acutil.saveJSON(g.settingsFileLoc, g.settings);

					local addImgFrame = ui.GetFrame("openingameshopbtn");
					local alarm_picture = addImgFrame:CreateOrGetControl("picture", "ALARM_PICTURE", 10, 0, 60, 60);
					tolua.cast(alarm_picture, "ui::CPicture");
					alarm_picture:SetImage("icon_item_Dilgele");
					alarm_picture:SetEnableStretch(1);
					alarm_picture:SetBlink(0, 0.8, "00FFFFFF");
					alarm_picture:SetEventScript(ui.LBUTTONDOWN, "ALARM_STOP_DILGER");
			end
	end

end

--------------------------------------------------------------------------------------------
-- ディルゲレタイマー
--------------------------------------------------------------------------------------------
function ALARM_SAVE_DILGER()
	ui.MsgBox("[Dilgele Timer]{nl} {nl}Do you want to be notified in 2 and a half hours to check upon your Dilgele sprouts?","ALARM_SET_DILGER","None")
end

function ALARM_SET_DILGER()
		g.settings["set10"].enable      = true;
		g.settings["set10"].hour        = "2";
		g.settings["set10"].minute      = "30";
		g.settings["set10"].body        = "It's time to check on Dilgeles!";
		g.settings["set10"].repeatcount = 1;
		g.settings["set10"].sound       = "m_boss_scenario2";
		g.settings["set10"].startdate   = math.floor(GetServerAppTime()/60)
		acutil.saveJSON(g.settingsFileLoc, g.settings);
		ui.SysMsg("Dilgele timer set");
end

function ALARM_STOP_DILGER()
	local addImgFrame   = ui.GetFrame("openingameshopbtn");
	local alarm_picture = addImgFrame:RemoveChild("ALARM_PICTURE")
	g.settings["set10"].repeatcount = 0;
	acutil.saveJSON(g.settingsFileLoc, g.settings);
end

--------------------------------------------------------------------------------------------
-- 音通知プレビュー
--------------------------------------------------------------------------------------------
function SOUND_PREV(name,bgmnames)

	if string.sub(bgmnames,1,2) == "SE" then
		imcSound.PlaySoundEvent(name);
	else
		imcSound.PlayMusic(name, 1)
	end

	NICO_CHAT(bgmnames)
	CHAT_SYSTEM("Notification sound preview: "..bgmnames)

end


