" Vim indent file
" Language: Rosie Pattern Language
" Maintainers: Eli W. Hunter <hunter.eli.w@gmail.com>
" URL: https://rosie-lang.org/
" Licence: MIT

" " Only load this indent file when no other was loaded.
" if exists("b:did_indent")
"   finish
" endif
" let b:did_indent = 1

setlocal indentexpr=RplIndent(v:lnum)

let s:grammar_delimiters = ['^\s*grammar\s*$', '^\s*in\s*$', '^\s*end\s*$']

func! RplIndent(lnum)
  " Grammar lines should not be indented
  if s:IsGrammarLine(a:lnum)
    return 0
  endif

  " We see if we are in between two grammar delimiters
  let prev_lnum = a:lnum
  while prev_lnum > 0
    let prev_lnum = prevnonblank(prev_lnum - 1)
    let prev_grammar_index = s:IsGrammarLine(prev_lnum)
    if prev_grammar_index > 0
      break
    endif
  endwhile

  let next_lnum = a:lnum
  let max_line = line('$')
  while next_lnum <= max_line
    let next_lnum = nextnonblank(next_lnum + 1)
    let next_grammar_index = s:IsGrammarLine(next_lnum)
    if next_grammar_index > 0
      break
    endif
  endwhile

  echo next_grammar_index prev_grammar_index

  if !next_grammar_index || !prev_grammar_index
    " We hit the end of the file on one end
    return 0
  elseif next_grammar_index > prev_grammar_index
    " The next grammar line is supposed to go after the previous (correct!)
    return &sw
  else
    " The next grammar line is supposed to go before the previous (wrong!)
    return 0
  endif
endfunc

func! s:IsGrammarLine(lnum)
  let line = getline(a:lnum)
  for regex in s:grammar_delimiters
    if l:line =~ regex
      return index(s:grammar_delimiters, regex) + 1
    endif
  endfor
  return 0
endfunc
