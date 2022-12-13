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

## タグ補完を有効にするFileType、拡張子を追加する方法
閉じタグ補完はデフォルトでは以下のファイルに対応しています。
```
FileTypes: html, javascript, blade, vue
Extensions(拡張子): *.html, *.js, *.blade.php, *.erb, *.vue
```

上記以外のファイルで閉じタグ補完を有効化するには、vimrcに以下を追記すます
```vim
" ex)
let g:enabledAutoCloseTagFileTypes = ["vim", "php"] " FileType
let g:enabledAutoCloseTagExtensions = ["vim", "php"] " extension
```

## 特定のFileType、拡張子の閉じタグ補完を無効化する方法
vimrcに以下を追記します

```vim
" ex)
let g:disabledAutoCloseTagFileTypes = ["javascript", "php"] " FileType
let g:disabledAutoCloseTagExtensions = ["js", "php"] " extension
```


## FIXME
まだ色々直すところがあるので、↓の項目が一通り無くなるまで使わない方が良いかも...
- [ ] 括弧内でEnterを打つといい感じに改行されるようにする(VSCodeみたいな)
- [ ] gvimだとプラグインマネージャ経由でインストールできない(手動なら入る)
- [ ] 改行ありのタグだと、閉じタグ補完はできるがインデントがなんかおかしくなる

## 要望等
対応可能なものであれば対応します。(twitter->@YUKI75191105)  
例えば、vim9未満にも対応して欲しいなど。
