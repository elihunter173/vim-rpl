" Vim syntax file
" Language: Rosie Pattern Language
" Maintainers: Kevin Zander <veratil@gmail.com>, Eli W. Hunter <hunter.eli.w@gmail.com>
" URL: https://rosie-lang.org/
" Licence: MIT

if version < 600
 syntax clear
elseif exists("b:current_syntax")
 finish
endif

" Expressions {{{
" These should be defined very early because they are so broad (prevents
" eating other definitions)
syn region rplUntokenizedSequence transparent matchgroup=rplSequence start='{' end='}' contains=@rplExpression
syn region rplTokenizedSequence transparent matchgroup=rplSequence start='(' end=')' contains=@rplExpression
syn cluster rplSequence contains=rplUntokenizedSequence,rplTokenizedSequence
hi link rplSequence Structure

syn region rplUnion transparent matchgroup=rplUnionEdge start='\[\^' start='\[' end='\]' contains=@rplExpression
hi link rplUnionEdge StorageClass

" Most vague char collection must be defined first
" We don't want '\', '[', ']', '^', or '-' unless they are escaped. To do
" this, we allow any character that isn't one of those, or an escaped version
" one of those.
syn match rplCharList '\[\^\?\([^\\[\]\^-]\|\\[\\[\]\^-]\)\+\]'
hi link rplCharList Character
" TODO: Does this only accept single characters as the edges or can it be
" unicode escapes?
syn match rplCharRange '\[\^\?.-.\]'
hi link rplCharRange Character
" Named char sets can only have word characters
syn match rplNamedCharSet '\[:\^\?\w\+:\]'
hi link rplNamedCharSet Character
syn cluster rplCharCollection contains=rplCharList,rplCharRange,rplNamedCharSet

syn region rplLiteral start='"' end='"' skip='\\\\\|\\"' oneline keepend contains=rplUnicodeEscape
hi link rplLiteral String

syn cluster rplExpression contains=@rplOperator,@rplCharCollection,@rplSequence,rplUnion,rplLiteral,rplString,rplApplication
" }}}


" General {{{
" This is just done to prevent improper highlighting
syn match rplToken contained '\S\+'
hi link rplToken Normal

syn keyword rplModuleDescription rpl package import as nextgroup=rplToken skipwhite
hi link rplModuleDescription Statement

syn keyword rplReservedKeywords let
hi link rplReservedKeywords Error

syn region rplComment start='--' end='$' oneline contains=rplCommentTodo
hi link rplComment Comment
syn keyword rplCommentTodo contained TODO FIXME XXX NOTE
hi link rplCommentTodo Todo

syn region rplString start='#\a' end='\W'he=e-1 end='$' oneline keepend
syn region rplString start='#"' end='"' oneline skip='\\\\\|\\"' keepend contains=rplUnicodeEscape
hi link rplString String

syn match rplUnicodeEscape '\\x\x\{2\}' contained
syn match rplUnicodeEscape '\\u\x\{4\}' contained
syn match rplUnicodeEscape '\\U\x\{8\}' contained
hi link rplUnicodeEscape Special

syn match rplInteger '\<\d\+\>' display
hi link rplInteger Number
" }}}

" Identifiers {{{
syn keyword rplHiddenModifier alias
hi link rplHiddenModifier Type

syn keyword rplLocalModifier local
hi link rplLocalModifier Type
" }}}

" Macros & Functions {{{
syn match rplApplication '\a\w*:' nextgroup=rplArgument
hi link rplApplication Function

syn region rplArgument contained matchgroup=rplArgumentDelimiter start='{' end='}' contains=@rplExpression
syn region rplArgument contained matchgroup=rplArgumentDelimiter start='(' end=')' contains=@rplExpression
syn match rplArgumentDelimiter ',' contained containedin=rplArgument
hi link rplArgumentDelimiter Delimiter
" }}}

" Operators {{{
syn match rplPreOperator '[<>!]'
hi link rplPreOperator SpecialChar

syn match rplPostOperator '[*+?]'
" These must be defined after the sequences so they override them
" {n}
syn match rplPostOperator '{\s*\d\+\s*}'
" {n,m}
syn match rplPostOperator '{\s*\d\+\s*,\s*\d\+\s*}'
" {n,}
syn match rplPostOperator '{\s*\d\+\s*,\s*}'
" {,m}
syn match rplPostOperator '{\s*,\s*\d\+\s*}'
hi link rplPostOperator SpecialChar

syn match rplBinaryOperator '[&/]'
hi link rplBinaryOperator SpecialChar

syn cluster rplOperator contains=rplPreOperator,rplPostOperator,rplBinaryOperator
" }}}

" Grammar Blocks {{{
syn region rplGrammarBlock transparent matchgroup=rplGrammarKeyword start='^\s*grammar\s*$' end='^\s*end\s*$'
syn keyword rplGrammarKeyword in
hi link rplGrammarKeyword Keyword
" }}}

" Testing {{{
syn region rplTest start=+-- \?test+ end=+$+ oneline contains=rplTestKeyword,rplTestDirective,rplLiteral
hi link rplTest Special

syn keyword rplTestDirective contained test
hi link rplTestDirective Debug

syn keyword rplTestKeyword contained accepts rejects includes excludes nextgroup=rplString
hi link rplTestKeyword Debug
" }}}

let b:current_syntax = 'rpl'
