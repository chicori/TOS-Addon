# marketshowlevel ex

ver.1.03対応 ※但しレイアウトが少し崩れてます。<br>
<br>
とらハム様の<b>『marketshowlevel_jp_v.1.03.ipf』</b>をベースに、<br>
オプション別に色分け＆値の評価といった違うアプローチでの表示を行いました。<br>
大きな改修を加えてる途中ですが、少し時間がかかりそうなので、ひとまず使えそうな段階になったので公開いたします。<br>
<br>
<br>
■ベースになったもの：とらハム様 GitHub<br>
https://github.com/torahamu/TOSAddon/tree/master/marketshowlevel
<br>
<br>
<br>
■本家からの変更点<br>
１．ヘアアクセオプションの表記においてオプション別の色分け<br>
黄 = HP、HPR<br>
青 = SP、SPR<br>
赤 = 物理攻撃<br>
紫 = 魔法攻撃、魔法増幅<br>
緑 = クリティカル<br>
など・・・<br>
<br>
２．最大値と比較した現在のパーセンテージによって記号付与<br>
９０％以上 = ★<br>
８０％以上 = ●<br>
６０％以上 = ▲<br>
５０％以上 = ×<br>
<br>
３．非表示オプション<br>
広域防御、クリティカル抵抗、命中、回避を非表示にいています。<br>
フラグ制御なので、luaいじれる人はオンにできます。<br>
<br>
<br>
■サンプルイメージ<br>
たまたまですが、魔法系ばっかりになってしまいました。<br>
魔攻、魔幅、属性抵抗あたりの数値と付与記号を見比べてみてください。<br>
<img src="https://github.com/chicori/chicorin/blob/master/sample_image.jpg">
<br>
■使い方<br>
<b>他の marketshowlevel.ipf（類似含む）が既にある場合削除してください。</b><br>
<b>『_marketshowlevel_jp_v1.0.2♬ex1.ipf』</b>を Tree of Saviorインストールフォルダの「data」フォルダ内にコピーしてください。<br>
<br>
とすけん様、とらハム様、本当にありがとうございます！<br>
Special Thanks to tosken and torahamu<br>
