if exists('loaded_trailing_whitespace_plugin') | finish | endif
let loaded_trailing_whitespace_plugin = 1

" Highlight EOL whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight link ExtraWhitespce Error
autocmd ColorScheme * highlight link ExtraWhitespace Error

function! s:ExtraWhiteSpace(...)
    " Ignore EOL whitespace in readonly buffers
    if !&readonly
        match ExtraWhiteSpace /\s\+$/
        if a:0 > 0
            match ExtraWhitespace /\s\+\%#\@<!$/
        endif
    endif
endfunction
autocmd BufWinEnter * call <SID>ExtraWhiteSpace()

" The above flashes annoyingly while typing, be calmer in insert mode
autocmd InsertLeave * call <SID>ExtraWhiteSpace(1)
autocmd InsertEnter * call <SID>ExtraWhiteSpace(1)

function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//'
    call setpos('.', l:save_cursor)
endfunction

" Run :FixWhitespace to remove end of line white space
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)
