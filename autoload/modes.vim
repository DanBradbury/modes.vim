vim9script
import autoload 'modes/color.vim' as color

g:modes_pending_operator = ''
var color_list: dict<dict<any>> = {
  'insert': { 'gui': '#78ccc5', 'term': 73 }
}

export def TrackOperator(op: string): string
  if op ==# 'yank'
    g:modes_pending_operator = 'yank'
    var ctbg = color.ComputeBlendedColorCterm(221, 35)
    var gbg = color.ComputeBlendedColor("#f5c359", 35)
    execute $'highlight CursorLine guibg={gbg} ctermbg={ctbg}'
    return 'y'
  elseif op ==# 'delete'
    g:modes_pending_operator = 'delete'
    var ctbg = color.ComputeBlendedColorCterm(174, 35)
    execute $'highlight CursorLine guibg={color.ComputeBlendedColor("#c75c6a", 25)} ctermbg={ctbg}'
    return 'd'
  elseif op ==# 'replace'
    g:modes_pending_operator = 'replace'
    var ctbg = color.ComputeBlendedColorCterm(166, 35)
    execute $'highlight CursorLine guibg={color.ComputeBlendedColor("#d75f00", 25)} ctermbg={ctbg}'
    return 'r'
  endif
  return ''
enddef

export def OnDeleteOperator(): string
  var ctbg = color.ComputeBlendedColorCterm(174, 35)
  g:modes_pending_operator = 'delete'
  execute $'highlight CursorLine guibg={color.ComputeBlendedColor("#c75c6a", 25)} ctermbg={ctbg}'
  return 'd'
enddef

export def OnYankOperator(): string
  var ctbg = color.ComputeBlendedColorCterm(221, 35)
  var gbg = color.ComputeBlendedColor("#f5c359", 35)
  g:modes_pending_operator = 'yank'
  execute $'highlight CursorLine guibg={gbg} ctermbg={ctbg}'
  return 'y'
enddef

export def OnOperatorComplete()
  g:modes_pending_operator = ''
  highlight clear CursorLine
enddef

export def SetVisualHighlight()
  var normal_bg = color.GetNormalBgColor()
  var target_color = '#9745be'
  var blended = color.ComputeBlendedColor(target_color, 35)
  var ctbg = color.ComputeBlendedColorCterm(135, 35)
  execute $'highlight Visual guibg={blended} ctermfg={ctbg}'
enddef

export def SetNormalHighlight()
  highlight CursorLine guibg=NONE
  highlight LineNr guibg=NONE
enddef

export def SetInsertModeCursorline()
  var target_color = '#78ccc5'
  var blended = color.ComputeBlendedColor(color_list.insert.gui, 25)
  var ctbg = color.ComputeBlendedColorCterm(color_list.insert.term, 80)

  execute $'highlight CursorLine guibg={blended} ctermbg={ctbg}'
enddef

export def SetReplaceHighlight()
  var target_color = '#c75c6a'
  var blended = color.ComputeBlendedColor(target_color, 35)
  var ctbg = color.ComputeBlendedColorCterm(168, 80)

  execute $'highlight CursorLine guibg={blended} ctermbg={ctbg}'
enddef

export def SetNormalModeCursorline()
  highlight CursorLine guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
enddef
