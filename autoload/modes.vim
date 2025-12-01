vim9script
import autoload 'modes/color.vim' as color

g:modes_pending_operator = ''

g:modes_colors = {
  'insert': { 'gui': '#78ccc5', 'term': 74 },
  'yank': { 'gui': '#f5c359', 'term': 221 },
  'delete': { 'gui': '#c75c6a', 'term': 174 },
  'replace': { 'gui': '#d75f00', 'term': 166 },
  'visual': { 'gui': '#9745be', 'term': 135 }
}
var cterm_blend = 35
var gui_blend = 35

if exists('g:modes_custom_colors')
  for [mode, settings] in items(g:modes_custom_colors)
    for [col, val] in items(settings)
      echom col
      g:modes_colors[mode][col] = val
    endfor
  endfor
endif

export def TrackOperator(op: string): string
  if op ==# 'yank'
    g:modes_pending_operator = 'yank'
    var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.yank.term, cterm_blend)
    var gbg = color.ComputeBlendedColor(g:modes_colors.yank.gui, gui_blend)
    execute $'highlight CursorLine guibg={gbg} ctermbg={ctbg}'
    return 'y'
  elseif op ==# 'delete'
    g:modes_pending_operator = 'delete'
    var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.delete.term, cterm_blend)
    execute $'highlight CursorLine guibg={color.ComputeBlendedColor(g:modes_colors.delete.gui, gui_blend)} ctermbg={ctbg}'
    return 'd'
  elseif op ==# 'replace'
    g:modes_pending_operator = 'replace'
    execute $'highlight CursorLine guibg={color.ComputeBlendedColor(g:modes_colors.replace.gui, gui_blend)} cterm=underline ctermul={g:modes_colors.replace.term}'
    return 'r'
  endif
  return ''
enddef

export def OnOperatorComplete()
  g:modes_pending_operator = ''
  highlight clear CursorLine
enddef

export def SetVisualHighlight()
  var blended = color.ComputeBlendedColor(g:modes_colors.visual.gui, gui_blend)
  var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.visual.term, cterm_blend)
  execute $'highlight Visual guibg={blended} ctermfg={ctbg}'
enddef

export def SetNormalHighlight()
  highlight CursorLine guibg=NONE
  highlight LineNr guibg=NONE
enddef

export def SetInsertModeCursorline()
  var blended = color.ComputeBlendedColor(g:modes_colors.insert.gui, gui_blend)
  execute $'highlight CursorLine guibg={blended} cterm=underline ctermul={g:modes_colors.insert.term}'
enddef

export def SetReplaceHighlight()
  var blended = color.ComputeBlendedColor(g:modes_colors.replace.gui, gui_blend)
  execute $'highlight CursorLine guibg={blended} cterm=underline ctermul={g:modes_colors.replace.term}'
enddef

export def SetNormalModeCursorline()
  highlight CursorLine guibg=NONE ctermbg=NONE cterm=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
enddef
