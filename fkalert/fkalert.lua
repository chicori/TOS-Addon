--アドオン名（大文字）
local addonName = "FKALERT";
local addonNameLower = string.lower(addonName);
--作者名
local author = "CHICORI";

--アドオン内で使用する領域を作成。以下、ファイル内のスコープではグローバル変数gでアクセス可
_G["ADDONS"] = _G["ADDONS"] or {};
_G["ADDONS"][author] = _G["ADDONS"][author] or {};
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {};
local g = _G["ADDONS"][author][addonName];

--ライブラリ読み込み
local acutil = require('acutil');

--lua読み込み時のメッセージ
CHAT_SYSTEM(string.format("%s.lua is loaded", addonName));

function FKALERT_ON_INIT(addon, frame)
	addon:RegisterMsg("GAME_START_3SEC", "REMOVEALERT_3SEC");
end


function REMOVEALERT_3SEC()
	ui.CloseFrame("ingamealert");
end
--dofile("../data/addon_d/fkalert/fkalert.lua");