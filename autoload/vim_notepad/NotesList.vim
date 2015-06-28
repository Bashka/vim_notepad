" Date Create: 2015-06-28 16:30:54
" Last Change: 2015-06-28 17:34:12
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:Buffer = vim_lib#sys#Buffer#
let s:Content = vim_lib#sys#Content#.new()
let s:BufferStack = vim_lib#view#BufferStack#
let s:System = vim_lib#sys#System#.new()

let s:screen = s:Buffer.new('#Notes-list#')
call s:screen.temp()
call s:screen.option('filetype', 'notes-list')

function! s:screen.render() " {{{
  let l:result = '" Notes list (Press ? for help) "' . "\n\n"

  let l:notesList = g:vim_notepad#.notesDir.getChildren()
  let l:result .= '" Notes' . "\n" . join(l:notesList, "\n")

  let l:result .= "\n\n"

  let l:diaList = g:vim_notepad#.diaDir.getChildren()
  let l:result .= '" Dia' . "\n" . join(l:diaList, "\n")

  let self.diaLine = 3 + len(l:notesList) + 2

  return l:result
endfunction " }}}

call s:screen.map('n', '<Enter>', 'select')
call s:screen.map('n', 'a', 'new')
call s:screen.map('n', 'r', 'rename')
call s:screen.map('n', 'dd', 'delete')

"" {{{
" @return string Тип элемента под курсором. Допустимо: note - заметка; dia - диаграмма.
"" }}}
function! s:screen.getType(lineNum) " {{{
  if a:lineNum < self.diaLine
    return 'note'
  else
    return 'dia'
  endif
endfunction " }}}

"" {{{
" Метод выбирает текущую заметку.
"" }}}
function! s:screen.select() " {{{
  let l:type = self.getType(line('.'))

  if l:type == 'note'
    call vim_notepad#openNote(expand('<cfile>'))
  endif
  if l:type == 'dia'
    call vim_notepad#openDia(expand('<cfile>'))
  endif
endfunction " }}}
"" {{{
" Метод создает новую заметку.
"" }}}
function! s:screen.new() " {{{
  let l:type = self.getType(line('.'))

  if l:type == 'note'
    let l:name = s:System.read('Enter note name: ')
    if l:name != ''
      call vim_notepad#openNote(l:name)
    endif
  endif
  if l:type == 'dia'
    let l:name = s:System.read('Enter dia name: ')
    if l:name != ''
      call vim_notepad#openDia(l:name)
    endif
  endif

  call self.unload()
endfunction " }}}
"" {{{
" Метод переименовывает текущую заметку.
"" }}}
function! s:screen.rename() " {{{
  let l:type = self.getType(line('.'))

  let l:file = expand('<cfile>')
  if l:type == 'note'
    let l:name = s:System.read('Enter note new name: ', 'None', l:file)
    if l:name != ''
      call vim_notepad#renameNote(l:file, l:name)
    endif
  endif
  if l:type == 'dia'
    let l:name = s:System.read('Enter dia new name: ', 'None', l:file)
    if l:name != ''
      call vim_notepad#renameDia(l:file, l:name)
    endif
  endif

  call self.redraw()
endfunction " }}}
"" {{{
" Метод удаляет текущую заметку.
"" }}}
function! s:screen.delete() " {{{
  let l:type = self.getType(line('.'))
  
  if l:type == 'note'
    call vim_notepad#deleteNote(expand('<cfile>'))
  endif
  if l:type == 'dia'
    call vim_notepad#deleteDia(expand('<cfile>'))
  endif

  call self.redraw()
endfunction " }}}

call s:screen.map('n', '?', 'showHelp')
" Подсказки. {{{
let s:screen.help = ['" Manual "',
                   \ '',
                   \ '" a - create new note/dia',
                   \ '" r - rename note/dia',
                   \ '" dd - delete note/dia',
                   \ ''
                   \]
" }}}
function! s:screen.showHelp() " {{{
  if s:Content.line(1) != self.help[0]
    let self.pos = s:Content.pos()
    call s:Content.add(1, self.help)
    let self.diaLine += len(self.help)
  else
    call self.active()
    call s:Content.pos(self.pos)
  endif
endfunction " }}}

let vim_notepad#NotesList# = s:screen
