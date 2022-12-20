vim9script

# 対の括弧を返す
def ReverseBracket(bracket: string): string
  var startBracket = { # 括弧
    ")": "(",
    "}": "{",
    "]": "["
  }
  var closeBracket = { # 閉じ括弧
    "(": ")",
    "{": "}",
    "[": "]"
  }
  if startBracket->count(bracket) == 1     # 括弧が渡されたら閉じ括弧を返す
    return closeBracket[bracket]
  elseif closeBracket->count(bracket) == 1 # 閉じ括弧が渡されたら括弧を返す
    return startBracket[bracket]
  else
    return ""
  endif
enddef

# 閉じ括弧を補完する
# FIXME: 補完した操作を、.で繰り返すことができない
export def WriteCloseBracket(bracket: string): string
  var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字

  # 以下の場合は閉じ括弧を補完しない
  # ・カーソルの次の文字がアルファベット
  # ・カーソルの次の文字が数字
  # ・カーソルの次の文字が全角
  if nextChar =~ '\a' || nextChar =~ '\d' || nextChar =~ '[^\x01-\x7E]'
    return bracket # 括弧補完しない
  else
    return bracket .. ReverseBracket(bracket) .. "\<LEFT>" # 括弧補完
  endif
enddef

# 閉じ括弧入力時の挙動
export def NotDoubleCloseBracket(closeBracket: string): string
  var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字
  # ()と入力した場合())とせずに()で止める
  if nextChar == closeBracket && prevChar == ReverseBracket(closeBracket)
    return "\<RIGHT>"
  else
    return closeBracket
  endif
enddef

# 括弧を改行するといい感じに
# memo: いらない気がするので一旦コメントアウト
# export def EntercloseBracket(): string
  # var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  # var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字
  # if (prevChar == "(" && nextChar == ")") || (prevChar == "{" && nextChar == "}") || (prevChar == "[" && nextChar == "]")
    # return "\<CR>\<ESC>\<S-o>"
  # else
    # return "\<CR>"
  # endif
# enddef

# クォーテーション補完
export def AutoCloseQuot(quot: string): string
  var prevChar = getline('.')[charcol('.') - 2] # カーソルの前の文字
  var nextChar = getline('.')[charcol('.') - 1] # カーソルの次の文字
  # カーソルの次の文字が以下に含まれている場合にクォーテーション補完を有効にする
  var availableNextChars = ["", " ", ",", "$", ")", "}", "]", ">"]

  if (prevChar == quot && nextChar == quot) # カーソルの左右にクォーテンションがある場合は何も入力せずにカーソルを移動
    return "\<RIGHT>"
  # 以下の場合はクォーテーション補完を行わない
  # ・カーソルの前の文字がアルファベット
  # ・カーソルの前の文字が数字
  # ・カーソルの前の文字が全角
  # ・カーソルの前の文字がクォーテーション
  elseif prevChar =~ "\a" || prevChar =~ "\d" || prevChar =~ "[^\x01-\x7E]" || prevChar == quot
    return quot
  # カーソルの次の文字が上記のavailableNextCharsに含まれている場合、クォーテー
  # ション補完する
  elseif availableNextChars->count(nextChar) == 1
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
  var voidElements = ["br", "hr", "img", "input", "link", "meta"]
  # 以下の場合は閉じタグ補完を行わない
  # ・/>で閉じる場合
  # ・->と入力した場合
  # ・=>と入力した場合
  # ・上記のvoidElementsに含まれる要素
  # ・elementNameに/が含まれる場合
  # ・elementNameが空白の場合
  var elementName = FindElementName(ket)
  if prevChar == "/" || prevChar == "-" || prevChar == "=" || voidElements->count(elementName) == 1 || elementName =~ "/" || elementName == ""
    return ket
  else
    return ket .. "</" .. elementName .. ket .. "\<ESC>F<i"
  endif
enddef

# 適用するFileType
var enabledAutoCloseTagFileTypes = ["html", "xml", "javascript", "blade", "eruby", "vue"]
# 適用する拡張子
var enabledAutoCloseTagExtensions = ["html", "xml", "js", "blade.php", "erb", "vue"]

# 閉じタグ補完を有効化するか判定して、有効化する
export def EnableAutoCloseTag()
  if enabledAutoCloseTagFileTypes->count(&filetype) == 1 || enabledAutoCloseTagExtensions->count(expand("%:e")) == 1
    inoremap <expr> > WriteCloseTag(">")
    inoremap </ </<C-x><C-o><ESC>F<i
  endif
enddef

# vimrcの設定を反映
export def ReflectVimrc()
  if exists('g:enabledAutoCloseTagFileTypes')
    enabledAutoCloseTagFileTypes = enabledAutoCloseTagFileTypes + g:enabledAutoCloseTagFileTypes
  endif
  if exists('g:enabledAutoCloseTagExtensions')
    enabledAutoCloseTagExtensions = enabledAutoCloseTagExtensions + g:enabledAutoCloseTagExtensions
  endif
enddef
