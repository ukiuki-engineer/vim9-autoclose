vim9script
# vim-autoclose
# カッコ、クォーテーション、タグの補完

# 閉じ括弧を補完する関数
def WriteCloseBracket(bracket: string): string
  var brackets = { # 括弧のオブジェクト
    "(": ")",
    "{": "}",
    "[": "]"
  }
  var nextChar = getline('.')[col('.') - 1] # カーソルの次の文字

  if nextChar == "" || # カーソルの後ろの文字が、なにもないとき（行末のとき）
    nextChar == brackets[bracket] || # カーソルの後ろの文字が、閉じ括弧のとき
    nextChar == "" # カーソルの後ろの文字が、空白のとき（半角スペースのとき）
    return bracket .. brackets[bracket] .. "\<LEFT>"
  else
    return bracket
  endif
enddef

# 閉じ括弧入力を止める関数
# FIXME: 日本語の後だと効かない
def StopWriteCloseBracket(closeBracket: string): string
  var nextChar = getline('.')[col('.') - 1] # カーソルの次の文字

  if nextChar == closeBracket
        return "\<RIGHT>"
  else
    return closeBracket
  endif
enddef

# クォーテーション補完
def AutoCloseQuot(quot: string): string
  var prevChar = getline('.')[col('.') - 2] # カーソルの前の文字
  var nextChar = getline('.')[col('.') - 1] # カーソルの次の文字

  if (prevChar == quot && nextChar == quot) # カーソルの左右にクォーテンションがある場合
    return "\<RIGHT>"
  elseif prevChar =~ "\a" || # カーソルの前の文字がアルファベット
    prevChar =~ "\d" || # カーソルの前の文字が数字
    prevChar =~ "[^\x01-\x7E]" || # カーソルの前の文字が全角
    prevChar == quot # カーソルの前の文字がクォーテーション
    return quot
  elseif nextChar == "" || # カーソルの後ろの文字が空(行末)
    nextChar == ")" || nextChar == "}" || nextChar == "]" || # カーソルの後ろの文字が閉じ括弧
    nextChar == " " # カーソルの後ろの文字が空白(半角スペース)
    return quot .. quot .. "\<LEFT>"
  else
    return quot
  endif
enddef

# FIXME:Enter対応

# FIXME: カーソルより前の一番近い要素名を取得する関数
def FindElementName(): string
  # 一文字ずつ左の文字を読み取る
  # <の一の列番を取得
  # <と>の間の文字列を取得
  # スペース以降を削除
  return "div" # モック
enddef

# FIXME: 閉じタグを補完する関数(未実装)
# <文字列>が入力されると</文字列>が入力される
# TODO: 指定された拡張子の時のみ有効
def WriteCloseTag(ket: string): string
  var prevChar = getline('.')[col('.') - 2] # カーソルの前の文字
  # 以下の場合は閉じタグ補完を行わない
  # ・/>で閉じる場合
  # ・->と入力した場合
  # ・=>と入力した場合
  if prevChar == "/" || prevChar == "-" || prevChar == "="
    return ket
  endif

  var elementName = FindElementName()
  var cursorTransition = ""
  for i in range(1, strlen(elementName) + 3)
    cursorTransition = cursorTransition .. "\<LEFT>" # カーソルをタグと閉じタグの中央に移動
  endfor
  return ket .. "</" .. elementName .. ket .. cursorTransition
enddef


# memo:
# <expr>を付けないと、WriteCloseBracket("(")
# という文字列がそのまま出力されてしまう
# 括弧入力
inoremap <expr> ( WriteCloseBracket("(")
inoremap <expr> { WriteCloseBracket("{")
inoremap <expr> [ WriteCloseBracket("[")
# 閉じ括弧入力
inoremap <expr> ) StopWriteCloseBracket(")")
inoremap <expr> } StopWriteCloseBracket("}")
inoremap <expr> ] StopWriteCloseBracket("]")
# クォーテーション入力
inoremap <expr> ' AutoCloseQuot("\'")
inoremap <expr> " AutoCloseQuot("\"")
inoremap <expr> ` AutoCloseQuot("\`")
# タグ入力
if 1 == 1 # FIXME: filetypeによる分岐
  inoremap <expr> > WriteCloseTag(">")
endif
