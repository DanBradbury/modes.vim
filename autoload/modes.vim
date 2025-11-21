vim9script
import autoload 'modes/color.vim' as color

g:modes_pending_operator = ''
g:modes_colors = {
  'insert': { 'gui': '#78ccc5', 'term': 73 },
  'yank': { 'gui': '#f5c359', 'term': 221 },
  'delete': { 'gui': '#c75c6a', 'term': 174 },
  'replace': { 'gui': '#d75f00', 'term': 166 },
  'visual': { 'gui': '#9745be', 'term': 135 }
}

export def TrackOperator(op: string): string
  if op ==# 'yank'
    g:modes_pending_operator = 'yank'
    var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.yank.term, 35)
    var gbg = color.ComputeBlendedColor(g:modes_colors.yank.gui, 35)
    execute $'highlight CursorLine guibg={gbg} ctermbg={ctbg}'
    return 'y'
  elseif op ==# 'delete'
    g:modes_pending_operator = 'delete'
    var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.delete.term, 35)
    execute $'highlight CursorLine guibg={color.ComputeBlendedColor(g:modes_colors.delete.gui, 25)} ctermbg={ctbg}'
    return 'd'
  elseif op ==# 'replace'
    g:modes_pending_operator = 'replace'
    var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.replace.term, 35)
    execute $'highlight CursorLine guibg={color.ComputeBlendedColor(g:modes_colors.replace.gui, 25)} ctermbg={ctbg}'
    return 'r'
  endif
  return ''
enddef

export def OnOperatorComplete()
  g:modes_pending_operator = ''
  highlight clear CursorLine
enddef

export def SetVisualHighlight()
  var normal_bg = color.GetNormalBgColor()
  var blended = color.ComputeBlendedColor(g:modes_colors.visual.gui, 50)
  var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.visual.term, 35)
  execute $'highlight Visual guibg={blended} ctermfg={ctbg}'
enddef

export def SetNormalHighlight()
  highlight CursorLine guibg=NONE
  highlight LineNr guibg=NONE
enddef

export def SetInsertModeCursorline()
  var blended = color.ComputeBlendedColor(g:modes_colors.insert.gui, 25)
  var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.insert.term, 80)
  execute $'highlight CursorLine guibg={blended} ctermbg={ctbg}'
enddef

export def SetReplaceHighlight()
  var blended = color.ComputeBlendedColor(g:modes_colors.replace.gui, 35)
  var ctbg = color.ComputeBlendedColorCterm(g:modes_colors.replace.term, 80)

  execute $'highlight CursorLine guibg={blended} ctermbg={ctbg}'
enddef

export def SetNormalModeCursorline()
  highlight CursorLine guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
enddef
