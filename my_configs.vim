set number
set guifont=IBM_Plex_Mono:h10:cANSI:qDRAFT
set nowrap
set visualbell
colorscheme peaksea
set switchbuf=useopen

map <leader>ct :cd ~/Desktop/Todoist/todoist<cr>


function! IsOnSomeParticularMachine(hostname)
    return match($HOST, a:hostname) >= 0
endfunction

if !IsOnSomeParticularMachine('BATTY')
  set columns=163
  set lines=64
  winpos 1520 120
endif
