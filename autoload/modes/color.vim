vim9script

export def GetNormalBgColor(): string
  var hlid = hlID('Normal')
  # Resolve any links
  hlid = synIDtrans(hlid)
  # Get the background color in #RRGGBB format
  return synIDattr(hlid, 'bg#')
enddef

export def ComputeBlendedColor(rgb_fg: string, blend: number): string
  var rgb_bg = GetNormalBgColor()
  # blend is 0-100
  var alpha = blend / 100.0
  var r = float2nr(str2nr(strpart(rgb_fg, 1, 2), 16) * alpha + str2nr(strpart(rgb_bg, 1, 2), 16) * (1 - alpha))
  var g = float2nr(str2nr(strpart(rgb_fg, 3, 2), 16) * alpha + str2nr(strpart(rgb_bg, 3, 2), 16) * (1 - alpha))
  var b = float2nr(str2nr(strpart(rgb_fg, 5, 2), 16) * alpha + str2nr(strpart(rgb_bg, 5, 2), 16) * (1 - alpha))

  return printf('#%02x%02x%02x', r, g, b)
enddef

def GetNormalBgColorCterm(): number
    # Get the highlight ID for 'Normal'
    var hlid = hlID('Normal')
    # Resolve any links
    hlid = synIDtrans(hlid)
    # Get the background color in cterm format
    var bg_color = synIDattr(hlid, 'ctermbg')
    return str2nr(bg_color)
enddef

def CtermToRGB(cterm: number): list<number>
    # Standard 256-color palette conversion
    if cterm < 16
        # Standard 16 colors
        var colors = [
            \ [0, 0, 0], [128, 0, 0], [0, 128, 0], [128, 128, 0],
            \ [0, 0, 128], [128, 0, 128], [0, 128, 128], [192, 192, 192],
            \ [128, 128, 128], [255, 0, 0], [0, 255, 0], [255, 255, 0],
            \ [0, 0, 255], [255, 0, 255], [0, 255, 255], [255, 255, 255]
        \ ]
        return colors[cterm]
    elseif cterm < 232
        # 216 color cube (6x6x6)
        var idx = cterm - 16
        var r = (idx / 36) * 51
        var g = ((idx % 36) / 6) * 51
        var b = (idx % 6) * 51
        return [r, g, b]
    else
        # Grayscale (24 shades)
        var gray = 8 + (cterm - 232) * 10
        return [gray, gray, gray]
    endif
enddef

def RGBToCterm(r: number, _g: number, _b: number): number
    # Try to match to the 6x6x6 color cube for best results
    var ri = float2nr(round(r / 51.0))
    var gi = float2nr(round(_g / 51.0))
    var bi = float2nr(round(_b / 51.0))

    # Clamp to valid range
    ri = min([max([ri, 0]), 5])
    gi = min([max([gi, 0]), 5])
    bi = min([max([bi, 0]), 5])

    return 16 + ri * 36 + gi * 6 + bi
enddef

export def ComputeBlendedColorCterm(cterm_bg: number, blend: number): number
  var cterm_fg = GetNormalBgColorCterm()
  # blend is 0-100
  # Convert cterm colors to RGB, blend, then convert back to nearest cterm color
  var alpha = blend / 100.0

  # Get RGB values for cterm colors
  var rgb_fg = CtermToRGB(cterm_fg)
  var rgb_bg = CtermToRGB(cterm_bg)

  # Blend the RGB values
  var r = float2nr(rgb_fg[0] * alpha + rgb_bg[0] * (1 - alpha))
  var g = float2nr(rgb_fg[1] * alpha + rgb_bg[1] * (1 - alpha))
  var b = float2nr(rgb_fg[2] * alpha + rgb_bg[2] * (1 - alpha))

  # Find nearest cterm color
  return RGBToCterm(r, g, b)
enddef
