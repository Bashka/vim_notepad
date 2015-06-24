" Date Create: 2015-06-09 04:55:31
" Last Change: 2015-06-24 21:16:08
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Buffer = vim_lib#sys#Buffer#
let s:System = vim_lib#sys#System#.new()

"" {{{
" Метод создает новую заметку.
"" }}}
function! vim_notepad#createNote() " {{{
  let l:dir = g:vim_notepad#.notesDir
  let l:noteBuffer = s:Buffer.new(l:dir.getChild(len(l:dir.getChildren()) + 1 . '.txt').getAddress())
  call l:noteBuffer.gactive('t')
endfunction " }}}

"" {{{
" Метод открывает последнюю заметку.
"" }}}
function! vim_notepad#lastNote() " {{{
  let l:dir = g:vim_notepad#.notesDir
  let l:name = len(l:dir.getChildren())
  let l:noteBuffer = s:Buffer.new(l:dir.getChild((l:name == 0? 1 : l:name) . '.txt').getAddress())
  call l:noteBuffer.gactive('t')
endfunction " }}}

function! vim_notepad#createDia() " {{{
  let l:dir = g:vim_notepad#.diaDir
  let l:newDiaFile = l:dir.getChild(len(l:dir.getChildren()) + 1 . '.dia')
  call s:System.run('cp ' . g:vim_notepad#.templateDia . ' ' . l:newDiaFile.getAddress())
  call s:System.silentExe('dia ' . l:newDiaFile.getAddress())
endfunction " }}}

function! vim_notepad#lastDia() " {{{
  let l:dir = g:vim_notepad#.diaDir
  let l:currentNum = len(l:dir.getChildren())
  if l:currentNum == 0
    call vim_notepad#createDia()
  else
    let l:diaFile = l:dir.getChild(l:currentNum . '.dia')
    call s:System.silentExe('dia ' . l:diaFile.getAddress())
  endif
endfunction " }}}
