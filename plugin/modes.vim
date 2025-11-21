vim9script
import autoload 'modes.vim' as base

if exists('g:loaded_modes')
  finish
endif
g:loaded_modes = 1

g:modes_pending_operator = ''

nnoremap <expr> d base.TrackOperator('delete')
nnoremap <expr> y base.TrackOperator('yank')
nnoremap <expr> r base.TrackOperator('replace')

augroup Modes
  autocmd!
  autocmd CursorMoved * if g:modes_pending_operator !=# '' | call base.OnOperatorComplete() | endif
  autocmd InsertEnter * call base.SetInsertModeCursorline()
  autocmd InsertLeave * call base.SetNormalModeCursorline()
  autocmd CmdlineEnter : call base.SetNormalModeCursorline()

  autocmd ModeChanged *:v call base.SetVisualHighlight()
  autocmd ModeChanged v:* call base.SetNormalHighlight()
  autocmd ModeChanged *:V call base.SetVisualHighlight()
  autocmd ModeChanged V:* call base.SetNormalHighlight()
  autocmd ModeChanged *:R call base.SetReplaceHighlight()
  autocmd ModeChanged *:Rv call base.SetReplaceHighlight()
augroup END
