<div align="center">

# modes.vim
> Prismatic line decorations for the adventurous **vim** users

![](https://github.com/user-attachments/assets/b87ff98d-639b-459f-9a35-7c3df36fd5fb)

</div>

## Requirements
- **vim 9.0**

## Usage
Install with your package manager of choice `DanBradbury/modes.vim`

### Defaults
| Highlight | guibg | ctermbg |
| --------- | ----- | ------- |
| insert | #78ccc5 | 73 |
| yank | #f5c359 | 221 |
| delete | #c75c6a | 174 |
| replace | #d75f00 | 166 |
| visual | #9745be | 135 |

### Configuration
If you'd like to change the colors add to your `.vimrc`
```vim
let g:modes_colors = {
    \ 'insert': { 'gui': '#00ff00', 'term': 10 },
    \ 'yank': { 'gui': '#ffff00', 'term': 226 },
    \ 'delete': { 'gui': '#ff0000', 'term': 196 },
    \ 'replace': { 'gui': '#ff8800', 'term': 208 },
    \ 'visual': { 'gui': '#ff00ff', 'term': 201 },
    \ }
```
