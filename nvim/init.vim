call plug#begin('~/.config/nvim/plugged')

Plug 'preservim/nerdtree'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

colorscheme tokyonight

set number
set relativenumber

ino <expr>      <tab>       exists('*coc#pum#visible') && coc#pum#visible()
                            \ ? coc#pum#next(0) : '<tab>'
ino <expr>      <s-tab>     exists('*coc#pum#visible') && coc#pum#visible()
                            \ ? coc#pum#prev(0) : '<s-tab>'
ino <expr>      <cr>        exists('*coc#pum#visible') && coc#pum#visible()
                            \ ? coc#pum#confirm() : '<cr>'
