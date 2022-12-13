## <font color="Red">まだβ版です!!</font>

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

![image](https://user-images.githubusercontent.com/101523180/207132447-974aabd8-e67f-4e55-b0e2-0b4ed5e05a1c.gif)

## 機能
- 閉じ括弧の補完
- 括弧を改行したときにいい感じにしてくれる(実装予定)
- 閉じクォーテーションの補完
- 閉じタグの補完

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

## FIXME
まだ色々直すところがあるので、↓の項目が一通り無くなるまで使わない方が良いかも...
- [ ] 日本語の後だと、```()```と打つと```())```となってしまう
- [ ] 括弧内でEnterを打つといい感じに改行されるようにする(VSCodeみたいな)
- [ ] タグ補完を適用するFileTypeや拡張子をvimrcから設定できるようにする
- [ ] gvimだとプラグインマネージャ経由でインストールできない