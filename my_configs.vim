function! IsOnSomeParticularMachine(hostname)
    return match($HOST, a:hostname) >= 0
endfunction

if !IsOnSomeParticularMachine('batty')
  set columns=163
  set lines=70
  winpos 1520 80
endif

set number
set guifont=IBM_Plex_Mono:h10:cANSI:qDRAFT
set nowrap
set visualbell
colorscheme peaksea
set switchbuf=useopen
set splitbelow
set splitright

" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

command! -nargs=+ MyGrep execute 'silent ack! <args>' | copen 33
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python' shellescape(@%, 1)<CR>

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif


"
" Bind F5 to save file if modified and execute python script in a buffer.
" nnoremap <silent> <F5> :call SaveAndExecutePython()<CR>
" vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction
" Misc commands snippets etc
" :setlocal foldexpr=getline(v:lnum)=~@/?0:1 foldmethod=expr
