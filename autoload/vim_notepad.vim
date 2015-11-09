" Date Create: 2015-06-09 04:55:31
" Last Change: 2015-11-09 13:03:20
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Buffer = vim_lib#sys#Buffer#
let s:System = vim_lib#sys#System#.new()
let s:File = vim_lib#base#File#

"" {{{
" Метод открывает заметку с данным именем в новом буфере. Если файла заметки не существует, он создается.
" @param string name Имя заметки.
"" }}}
function! vim_notepad#openNote(name) " {{{
  let l:noteFile = g:vim_notepad#.notesDir.getChild(a:name)

  if !l:noteFile.isExists() || !l:noteFile.isFile()
    call l:noteFile.createFile()
  endif

  let l:noteBuffer = s:Buffer.new(l:noteFile.getAddress())
  echom g:vim_notepad#.noteWindowOption
  if index(['t', 'b', 'T', 'B'], g:vim_notepad#.noteWindowOption) != -1
    call l:noteBuffer.gactive(g:vim_notepad#.noteWindowOption)
  else
    call l:noteBuffer.vactive(g:vim_notepad#.noteWindowOption)
  endif

  let g:vim_notepad#.lastNote = a:name
endfunction " }}}

"" {{{
" Метод удаляет указанную заметку.
" @param string name Имя удаляемой заметки.
"" }}}
function! vim_notepad#deleteNote(name) " {{{
  let l:noteFile = g:vim_notepad#.notesDir.getChild(a:name)

  if l:noteFile.isExists() && l:noteFile.isFile()
    call l:noteFile.deleteFile()
  endif
endfunction " }}}

"" {{{
" Метод переименовывает указанную заметку.
" @param string name Имя переименовываемой заметки.
" @param string newName Новое имя.
"" }}}
function! vim_notepad#renameNote(name, newName) " {{{
  let l:noteFile = g:vim_notepad#.notesDir.getChild(a:name)
  
  if l:noteFile.isExists() && l:noteFile.isFile()
    call s:System.silentExe('mv ' . l:noteFile.getAddress() . ' ' . l:noteFile.getDir().getAddress() . s:File.slash . a:newName)
  endif
endfunction " }}}

"" {{{
" Метод открывает последнюю заметку.
"" }}}
function! vim_notepad#lastNote() " {{{
  call vim_notepad#openNote(g:vim_notepad#.lastNote)
endfunction " }}}

"" {{{
" Метод открывает диаграмму с данным именем в новом буфере. Если файла диаграммы не существует, он создается.
" @param string name Имя диаграммы.
"" }}}
function! vim_notepad#openDia(name) " {{{
  let l:diaFile = g:vim_notepad#.diaDir.getChild(a:name)

  if !l:diaFile.isExists() || !l:diaFile.isFile()
    call s:System.run('cp ' . g:vim_notepad#.templateDia . ' ' . l:diaFile.getAddress())
  endif

  call s:System.silentExe('dia ' . l:diaFile.getAddress())

  let g:vim_notepad#.lastDia = a:name
endfunction " }}}

"" {{{
" Метод удаляет указанную диаграмму.
" @param string name Имя удаляемой диаграммы.
"" }}}
function! vim_notepad#deleteDia(name) " {{{
  let l:diaFile = g:vim_notepad#.diaDir.getChild(a:name)

  if l:diaFile.isExists() && l:diaFile.isFile()
    call l:diaFile.deleteFile()
  endif
endfunction " }}}

"" {{{
" Метод переименовывает указанную диаграмму.
" @param string name Имя переименовываемой диаграммы.
" @param string newName Новое имя.
"" }}}
function! vim_notepad#renameDia(name, newName) " {{{
  let l:diaFile = g:vim_notepad#.diaDir.getChild(a:name)
  
  if l:diaFile.isExists() && l:diaFile.isFile()
    call s:System.silentExe('mv ' . l:diaFile.getAddress() . ' ' . l:diaFile.getDir().getAddress() . s:File.slash . a:newName)
  endif
endfunction " }}}

"" {{{
" Метод открывает последнюю диаграмму.
"" }}}
function! vim_notepad#lastDia() " {{{
  call vim_notepad#openDia(g:vim_notepad#.lastDia)
endfunction " }}}

"" {{{
" Метод открывает список созданных заметок.
"" }}}
function! vim_notepad#notesList() " {{{
  let l:screen = g:vim_notepad#NotesList#
  if l:screen.getWinNum() != -1
    " Закрыть окно, если оно уже открыто.
    call l:screen.unload()
  else
    call l:screen.vactive('R', 40)
  endif
endfunction " }}}
