## 概要
括弧、クォーテーション、タグを閉じる補完を良い感じに行うプラグイン。  
※最近は[vimscript版](https://github.com/ukiuki-engineer/vim-autoclose)がメインで、このvim9script版はあまり更新していないです。  
　需要があればこのvim9script版もいつか更新します。

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
このプラグインでは、上記補完をもっといい感じに発火するように色々と制御しています。
加えて、htmlの閉じタグ補完機能も実装しています。
全体的に大体VSCodeのような動きをイメージして実装しました。

https://user-images.githubusercontent.com/101523180/207311455-5a2b63f4-6102-4607-b9f7-26e07552c7b8.mov

https://user-images.githubusercontent.com/101523180/207350557-5c52c90d-a058-45f1-b226-2dded5c428a4.mov


## 機能
- 閉じ括弧の補完
<!-- memo: この機能はコメントアウト中
- 括弧を改行したときにいい感じにしてくれる(この機能は削除するかも...)
-->
- 閉じクォーテーションの補完
- 閉じタグの補完  
→以下を入力した場合に閉じタグが補完される  
```>```or```</```
- 補完をいい感じに制御
→補完してほしくない時は無効になるようにいい感じに制御してある。
例えば以下ように制御してある。(全部を書くと多いので一部だけです)
  - ```()```と入力しても```())```とならないように
  - いわゆる**void要素**(以下)は閉じタグを補完しない  
  →```<br>```, ```<hr>```, ```<img>```, ```<input>```, ```<link>```, ```<meta>```
  - タグじゃない場合の>は補完をしない  
  →```=>```とか、```->```とか

## 動作環境
vim9以上

## インストール方法
※vim9scriptで実装しているため、vim9以上のみ対応しています。
#### プラグインマネージャ経由
以下を.vimrcに記述する
```
Plug 'ukiuki-engineer/vim9-autoclose' # vim-plugの場合
```
#### 手動
```.vim/pack/plugins/start```というディレクトリを作成し、そこにこのプラグインを配置する
```
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/ukiuki-engineer/vim9-autoclose
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
