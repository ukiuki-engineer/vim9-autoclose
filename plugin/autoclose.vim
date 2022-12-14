vim9script
# vim-autoclose
# カッコ、クォーテーション、タグの補完

# 閉じ括弧を補完する
def WriteCloseBracket(bracket: string): string
  var brackets = { # 括弧のオブジェクト
    "(": ")",
    "{": "}",
    "[": "]"
  }
  var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字

  # 以下の場合に括弧補完する
  # ・カーソルの次の文字が、なにもないとき（行末のとき）
  # ・カーソルの次の文字が、閉じ括弧のとき
  # ・カーソルの次の次の文字が他の閉じ括弧
  # ・カーソルの次の文字が、空白のとき（半角スペースのとき）
  # ・カーソルの次の文字が<のとき
  # ・カーソルの前の文字が>のとき
  if nextChar == "" || nextChar == ")" || nextChar == "}" || nextChar == "]" || nextChar == " " || prevChar == ">" || nextChar == "<"
    return bracket .. brackets[bracket] .. "\<LEFT>" # 括弧補完
  else
    return bracket # 括弧補完しない
  endif
enddef

# 閉じ括弧入力を止める
def StopWriteCloseBracket(closeBracket: string): string
  var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字
  if nextChar == closeBracket
        return "\<RIGHT>"
  else
    return closeBracket
  endif
enddef

# 括弧を改行するといい感じに
def EnterBrackets(): string
  var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字
  if (prevChar == "(" && nextChar == ")") || (prevChar == "{" && nextChar == "}") || (prevChar == "[" && nextChar == "]")
    return "\<CR>\<ESC>\<S-o>"
  else
    return "\<CR>"
  endif
enddef

# クォーテーション補完
def AutoCloseQuot(quot: string): string
  var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字

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

# 要素内文字列から要素名を抜き出す
def TrimElementName(strLineNum: number, strInTag: string): string
  var elementName = ""
  var startRange = 1
  # カーソル行とタグがある行が違う場合、
  # インデントが含まれているので要素名抜き出しのスタート位置をずらす
  if strLineNum != line('.')
    startRange = indent(strLineNum) + 1
  endif
  for i in range(startRange, strlen(strInTag))
    if strInTag[i] == " "
      break
    endif
    if strInTag[i] != "<"
      elementName = elementName .. strInTag[i]
    endif
  endfor
  return elementName
enddef

# カーソルより前の一番近い要素名を取得する
def FindElementName(ket: string): string
  # カーソル行を検索
  var strInTag = ""
  for i in range(1, charcol('.'))
    var targetChar = getline('.')[charcol('.') - 1 - i]
    strInTag = targetChar .. strInTag
    if targetChar == "<"
      break
    endif
  endfor
  if "<" == matchstr(strInTag, "<")
    return TrimElementName(line('.'), strInTag)
  endif
  # カーソルより上の行を検索
  var strOnLine = ""
  for i in range(1, line('.') - 1)
    strOnLine = getline(line('.') - i)
    if "<" == matchstr(strOnLine, "<")
      return TrimElementName(line('.') - i, strOnLine)
    endif
  endfor
  return ket
enddef

# 閉じタグを補完する
def WriteCloseTag(ket: string): string
  var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  # 以下の場合は閉じタグ補完を行わない
  # ・/>で閉じる場合
  # ・->と入力した場合
  # ・=>と入力した場合
  if prevChar == "/" || prevChar == "-" || prevChar == "="
    return ket
  endif

  var elementName = FindElementName(ket)
  var cursorTransition = ""
  for i in range(1, strlen(elementName) + 3)
    cursorTransition = cursorTransition .. "\<LEFT>" # カーソルをタグと閉じタグの中央に移動
  endfor
  if elementName == ""
    return ket
  else
    return ket .. "</" .. elementName .. ket .. cursorTransition
  endif
enddef

# 閉じタグ補完を有効化するか判定して、有効化する
def EnableAutoCloseTag()
  if enabledAutoCloseTagFileTypes->count(&filetype) >= 1 || enabledAutoCloseTagExtensions->count(expand("%:e")) >= 1
    inoremap <expr> > WriteCloseTag(">")
  endif
enddef

# 括弧入力
inoremap <expr> ( WriteCloseBracket("(")
inoremap <expr> { WriteCloseBracket("{")
inoremap <expr> [ WriteCloseBracket("[")
# 閉じ括弧入力
inoremap <expr> ) StopWriteCloseBracket(")")
inoremap <expr> } StopWriteCloseBracket("}")
inoremap <expr> ] StopWriteCloseBracket("]")
# Enter入力
inoremap <expr> <CR> EnterBrackets()
# クォーテーション入力
inoremap <expr> ' AutoCloseQuot("\'")
inoremap <expr> " AutoCloseQuot("\"")
inoremap <expr> ` AutoCloseQuot("\`")

# タグ入力
var enabledAutoCloseTagFileTypes = ["html", "javascript", "blade", "vue"]
var enabledAutoCloseTagExtensions = ["html", "js", "blade.php", "erb", "vue"]
if exists('g:enabledAutoCloseTagFileTypes')
  enabledAutoCloseTagFileTypes = enabledAutoCloseTagFileTypes + g:enabledAutoCloseTagFileTypes
endif
if exists('g:enabledAutoCloseTagExtensions')
  enabledAutoCloseTagExtensions = enabledAutoCloseTagExtensions + g:enabledAutoCloseTagExtensions
endif

au FileType * EnableAutoCloseTag()
au BufEnter * EnableAutoCloseTag()

# 閉じタグ補完の解除
if exists('g:disabledAutoCloseTagFileTypes') || exists('g:disabledAutoCloseTagFileTypes')
  iunmap >
endif
