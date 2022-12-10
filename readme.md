## 概要
括弧、クォーテーション、タグを閉じる補完を良い感じに行うプラグイン。

## 背景
括弧やクォーテーションを閉じる設定として、以下がよく知られている。
```
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
```

上記設定では、色々不便な点がある。
```())```となってしまったり、括弧を閉じたくない時に閉じてしまったり...
上記補完をもっといい感じに発火するようにしたのがこのプラグインです。
大体VSCodeの補完機能をイメージして実装しました。

## 機能
- 閉じ括弧の補完
- 括弧を改行したときにいい感じにしてくれる(実装予定)
- 閉じクォーテーションの補完
- 閉じタグの補完(実装予定)

## インストール方法
※vim9scriptで実装しているため、vim9以上のみ対応しています。
#### プラグインマネージャ経由
以下を.vimrcに記述する
```
Plug 'hagemanto-saitama/vim9-autoload' # vim-plugの場合
NeoBundle 'hagemanto-saimata/vim9-autoload' # NeoBundleの場合
```
#### 手動
```.vim/pack/plugins/start```というディレクトリを作成し、そこにこのプラグインを配置する
```
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/hagemanto-saitama/vim9-autoload
```
