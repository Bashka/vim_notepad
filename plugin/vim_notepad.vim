" Date Create: 2015-06-09 04:50:57
" Last Change: 2015-06-09 05:39:49
" Author: Artur Sh. Mamedbekov (Artur-Mamedbekov@yandex.ru)
" License: GNU GPL v3 (http://www.gnu.org/copyleft/gpl.html)

let s:File = vim_lib#base#File#

let s:Plugin = vim_lib#sys#Plugin#

let s:p = s:Plugin.new('vim_notepad', '1')

"" {{{
" @var string Абсолютный адрес до файла шаблона dia.
"" }}}
let s:p.templateDia = expand('<sfile>:p:h') . s:File.slash . 'templates' . s:File.slash . 'template.dia'

function! s:p.run() " {{{
  let self.notepadDir = s:File.absolute(g:vim_lib#sys#Autoload#currentLevel . s:File.slash . 'notepad')
  if !self.notepadDir.isExists() || !self.notepadDir.isDir()
    call self.notepadDir.createDir()
  endif

  let self.notesDir = self.notepadDir.getChild('notes')
  if !self.notesDir.isExists() || !self.notesDir.isDir()
    call self.notesDir.createDir()
  endif

  let self.diaDir = self.notepadDir.getChild('dia')
  if !self.diaDir.isExists() || !self.diaDir.isDir()
    call self.diaDir.createDir()
  endif
endfunction " }}}

call s:p.menu('CreateNote', 'createNote', '1')
call s:p.menu('LastNote', 'lastNote', '2')
call s:p.menu('CreateDia', 'createDia', '3')
call s:p.menu('LastDia', 'lastDia', '4')

call s:p.reg()
