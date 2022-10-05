" 기본 set
set number	 		" 라인 넘버 보이기
set ruler			" 현재 커서 위치 좌표 출력
set cursorline		" 커서 라인 하이라이트 표시
set ignorecase 		" 검색 시 대소문자 무시
set hlsearch		" 검색 시 하이라이트
set laststatus=2	" 상태바 항상 표시
set showcmd			" 입력한 명령어 표시
set tabstop=4		" tab을 4칸으로
set history=200		" 편집 기록 기억 수 .viminfo에 기록
set nocompatible	" vi의 기능을 사용하지 않고, vim 만의 기능을 사용
set mouse=a			" 마우스 더블클릭 사용 가능
set list listchars=tab:·\ ,trail:·,extends:>,precedes:<

set rtp+=/opt/homebrew/opt/fzf

" vim-plug installation

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" vim-plug 플러그인 begin
call plug#begin()

" Vimwiki
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
" Startify
Plug 'mhinz/vim-startify'
" fzf
Plug 'junegunn/fzf'
" nerdtree
Plug 'preservim/nerdtree'
" tags
Plug 'preservim/tagbar'
Plug 'ludovicchabant/vim-gutentags'

" vim-plug 플러그인 end
call plug#end()

" 종립님의 .vimrc 설정 중 일부 (Vimwiki)
" 로컬 리더 키 설정은 취향이니 각자 마음에 드는 키로 설정한다
let maplocalleader = "\\"

"1번 위키(공개용)
let g:vimwiki_list = [
    \{
    \   'path': '~/Blog/pennynd1me.github.io/_wiki',
    \   'ext' : '.md',
    \   'diary_rel_path': '.',
    \}
\]

" vimwiki의 conceallevel 을 끄는 쪽이 좋다
let g:vimwiki_conceallevel = 0
" vimwiki 모든 마크다운 파일을 wiki로 인식하는 문제 해결하는 설정
let g:vimwiki_global_ext = 0

" 오늘 날짜와 요일 입력
nmap <LocalLeader>xz :r! date "+\%Y-\%m-\%d"<CR>

" NerdTree 단축키
nnoremap <LocalLeader>nn :NERDTreeToggle<CR>

" tagbar 단축키
nnoremap <LocalLeader>tt :TagbarToggle<CR>

" 자주 사용하는 vimwiki 명령어에 단축키를 취향대로 매핑해둔다
command! WikiIndex :VimwikiIndex
nmap <LocalLeader>ww <Plug>VimwikiIndex
nmap <LocalLeader>wt :VimwikiTable<CR>


" F4 키를 누르면 커서가 놓인 단어를 위키에서 검색한다.
nnoremap <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>

" Shift F4 키를 누르면 현재 문서를 링크한 모든 문서를 검색한다
nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>

" startify 설정
if !exists('g:include_set_startify_loaded')
    let g:include_set_startify_loaded = 1

    nmap <LocalLeader>s :Startify<CR>
    nmap <LocalLeader><LocalLeader>s :SSave<CR>

    let g:startify_custom_header = ['']
    let g:startify_update_oldfiles = 1
    let g:startify_change_to_vcs_root = 1
    let g:startify_session_sort = 1
    let g:startify_session_persistence = 1

    let g:startify_commands = [
                \ ':help startify',
                \ ]
    let g:startify_list_order = [
                \ ['    Sessions'],
                \'sessions',
                \ ['    Most Recently Used files'],
                \'files',
                \'bookmarks',
                \ ['    Commands'],
                \'commands'
                \]
    let g:startify_session_dir = '~/.vim/sessions'
endif

" tagbar toc 설정
let g:tagbar_type_vimwiki = {
    \ 'ctagstype' : 'vimwiki',
    \ 'sort': 0,
    \ 'kinds' : [
        \ 't:목차'
    \ ]
\ }

" 메타 데이터 기본 값 입력 함수
function! LastModified()
    if g:md_modify_disabled
        return
    endif

    if (&filetype != "vimwiki")
        return
    endif

    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])

        exe 'keepjumps 1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
                    \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfunction

function! NewTemplate()

    let l:wiki_directory = v:false

    for wiki in g:vimwiki_list
        if expand('%:p:h') =~ expand(wiki.path)
            let l:wiki_directory = v:true
            break
        endif
    endfor

    if !l:wiki_directory
        return
    endif

    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'layout  : wiki')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'tag     : ')
    call add(l:template, 'toc     : true')
    call add(l:template, 'public  : true')
    call add(l:template, 'parent  : ')
    call add(l:template, 'latex   : false')
    call add(l:template, '---')
    call add(l:template, '* TOC')
    call add(l:template, '{:toc}')
    call add(l:template, '')
    call add(l:template, '# ')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction

augroup vimwikiauto
	autocmd BufWritePre *.md keepjumps call LastModified()
	autocmd BufRead,BufNewFile *.md call NewTemplate()
augroup END

augroup tagbar_custom_color
    autocmd FileType tagbar syntax match tagbar_ignore_char /·/
    autocmd FileType tagbar hi def link tagbar_ignore_char Comment
augroup END
