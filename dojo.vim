"last-edit(14/08/10 16:48:59)
"
"TODO
"to write movements for all the vim cart
"asp and php are not coloring... see why
"
"finish and polish
"to create a folder structure
"to create a doc
"to create a git and upload the code to github
"to prepare a text to vim site
"to publish the plugin and start another

 " DechoOn
"CONFIGURATION
let g:kmode = "practice" "kmode: practice, samurai, ninja
let g:kmodule = "all_katas" "kmodule: what module you want to try (basic.kata)

"MAIN FUNCTION
function! Dojo(...)
  let g:kmode = a:0 >= 1 ? a:1 : g:kmode 
  let g:kmodule = a:0 >= 2 ? a:2 : g:kmodule
  call GuiStart()
endfunction

"WORKING WITH THE FILES
fun! ExtractFiles(module)
  let g:kata = []
  let g:samples = []
  for path in split(globpath(getcwd(), '*'), "\n")
    if isdirectory(path)
      for sampleFile in split(globpath(path, '*.codes'), "\n")
        if !filereadable(sampleFile) | return | endif
        let g:samples += ParseFile(readfile(sampleFile),"s")
      endfor
      if a:module == "all_katas"
        for kataFile in split(globpath(path, '*.kata'), "\n")
          if !filereadable(kataFile) | return | endif
          let g:kata += ParseFile(readfile(kataFile),"k")
        endfor
      else
        let g:kata = ParseFile(readfile("katas/".a:module.".kata"),"k")
      endif
    endif
  endfor
  if g:kmode == "ninja"
    if s:NinjaCheck()|return|endif
    call RndmInit()
    let b = sort(g:kata) 

    function! Shuffle(a) 
      let b = copy(a:a) 
      let n = 0 
      let length = len(b) 
      while n < length 
        let tmp = b[n] 
        let dst = Rndm() % length 
        let b[n] = b[dst] 
        let b[dst] = tmp 
        let n += 1 
      endwhile 
      return b 
    endfunction 
    let g:kata = Shuffle(b)
  endif
endf

function! ParseFile(text,type)
  let l:full = []
  let l:partial = []
  let l:partial_str = []
  let l:count = 0

  for line in a:text
    if strpart(line,0,13) == "plugin_test: "
      if !exists(strpart(line,13))
        return [] "Flagged
      endif
    elseif line == '-------'
      let l:count = 0
      if a:type == "s"
        call add(l:partial, join(l:partial_str))
      endif
      call add(l:full, l:partial)
      let l:partial = []
      let l:partial_str = []
    else
      if a:type == "k"
        if l:count == 0 || l:count == 4 || l:count == 5
          call add(l:partial, substitute(strpart(line,8), '\\n', "\n", 'g'))
        else
          call add(l:partial, str2nr(strpart(line,8)))
        endif
      else
        if l:count == 0
          call add(l:partial, strpart(line,13))
        else
          call add(l:partial_str, line."\n")
        endif
      endif
      let l:count += 1
    endif
  endfor
  return l:full
endfunction

"STARTING THE DOJO
function! GuiStart()
  call ExtractFiles(g:kmodule)
  execute ":silent wincmd n"
  call KataRestart()

  augroup session
    autocmd!
    autocmd WinEnter <buffer> call StartRecording()
    autocmd WinLeave <buffer> call StopRecording()
    autocmd InsertLeave <buffer> call MovementStop()
  augroup END
  cmap <buffer> stop call StopDojo()
  cmap <buffer> again call KataRestart()
  cmap <buffer> help call HelpScreen()
  exe ":only"
  setlocal bt=nofile
  setlocal bufhidden=hide
	setlocal noswapfile
  setlocal report=3
endfunction

"CHECK IF THE ENVY HAS THE REQUIREMENTS
fun! s:NinjaCheck()
  if !exists("*RndmInit")
    rightb split
    enew
    setlocal bt=nofile
    setlocal bufhidden=hide
	  setlocal noswapfile
    put =' '
    put ='Rndm.vim is available at'
    put ='http://mysite.verizon.net/astronaut/vim/index.html#VimFuncs'
    let msg='as "Rndm"  (Rndm is what generates pseudo-random variates)'
    put =msg
    return 1
  endif
  return 0
endfun

"RESTART THE VARIABLES OF PLUGIN AND START OVER. FIRED IN :AGAIN
function! KataRestart()
  let g:kesc = ""
  let g:first_move = 0
  let g:sec = 0
  let g:time_total = 0
  let g:count_errors = 0
  let g:count_sequence = 0
  let g:count_movements = len(g:kata)
  call FirstScreen()
endfunction

"OK I KNOW... BUT NUBES COULD USE THE PLUGIN TO LEARN, SO LETS BE LESS SERIOUS
function! FirstScreen()
  normal ggdG

  put = '\"     8888888b.            d8b              \"'
  put = '\"     888  `Y88b           Y8P              \"'
  put = '\"     888    888                            \"'
  put = '\"     888    888  .d88b.  8888  .d88b.      \"'
  put = '\"     888    888 d88``88b `888 d88``88b     \"'
  put = '\"     888    888 888  888  888 888  888     \"'
  put = '\"     888  .d88P Y88..88P  888 Y88..88P     \"'
  put = '\"     8888888P`   `Y88P`   888  `Y88P`      \"'
  put = '\"                          888              \"'
  put = '\"     FOR VIM!            d88P              \"'
  put = '\"                       888P`               \"'
  put = ''
  put = ''
  put = '//Dojo is a training system based in the real martial arts katas.'
  put = '//Follow the movements exactly as showed and be a ninja!'
  put = ''
  put = '\"TO START: GO TO NORMAL MODE    :)\"'
  put = '//we gonna set your key to normal mode'
  put = ''
  put = '//\":help\" for \"hell\"p'
  exe ":setlocal filetype=javascript"
  exe ":startinsert"
  call StartRecording()
endfunction

"THIS HELP SCREEN MUST BE IMPROVED. FIRED IN :HELP
function! HelpScreen()
  normal ggdG
  put = 'HELP??'
  put = '\"to back just back to normal mode\"'
  put = 'to stop: dojo \":stop\"'
  put = 'to restart" \":again\"'
  put = 'to configure: :call Dojo(\"[practice],samurai,ninja\",\"[all_katas],your_desired_kata\")'
  put = '...or change it direcly in the plugin'
  put = ''
  put = 'to choose what katas to use: rename the extension, and the plugin will not read it (example.kata => example.xxx)'
  put = ''
  put = 'if you want to write your own katas, take a look in the files, is pretty simple'
  put = 'if you write a good kata, pls, send me and i will include in the package'
  put = 'the katas official repository http://www.github.com/tcha-tcho/katas'
  exe ":setlocal filetype=javascript"
  exe ":startinsert"
endfunction

"HERE START THE CICLES
function! MovementStart(ok)
  let g:start_writing_time = reltime()[0]
  let g:time_partial = 1
  call WriteDojoWindow(a:ok, 0)
  call StartRecording()
endfunction

"FIRED WHEN THE USER GOES TO NORMAL MODE
function! MovementStop()
  call StopRecording()
  if g:first_move == 0
    let g:kesc = escape(@a,'\')
    call MovementStart(1)
    let g:first_move = 1
  else
    let g:sec = reltime()[0] - g:start_writing_time
    let g:time_partial = 0
    "FIXME: the <esc> is in the chainning commands...
    let l:movement = substitute(escape(@a,'\'),g:kesc,"","g")
    if l:movement == g:kata[g:count_sequence][5]
      if g:count_sequence == g:count_movements-1
        call WriteDojoWindow(0,1)
      else
        let g:count_sequence += 1
        call MovementStart(1)
      endif
    else
      let g:count_errors += 1
      call MovementStart(0)
    endif
  endif
endfunction

"WRITE THE MAIN WINDOW
function! WriteDojoWindow(from_error, finish)
  let g:time_total += g:sec
  normal ggdG
  put = 'DOJO! FOR VIM: '.g:kmode.' mode'
  put = a:finish == 1 ? '  ' : DrawProgress()
  put = '  '
  if a:finish == 1
    let l:desired_time = g:count_movements * 3
    put = '\"Arigatoh gozaimashita!  :)\"'
    put = '  '
    put = '//Stats:'
    put = 'Errors: '.g:count_errors.' from '.g:count_movements.' movements'
    put = 'Time: '.ParseSeconds(g:time_total).' seconds'
    put = 'Reference: '.ParseSeconds(l:desired_time).' seconds'
    put = ''
    put = ''
    if g:time_total > l:desired_time * 2
      put = '\"   [Luke:] I can’t believe it. [Yoda:] That is why you fail.    \"'
    elseif g:time_total >= l:desired_time && g:time_total <= l:desired_time * 2
      put = '\"   Yoda: Try not.Do or do not.There is no try.    \"'
    elseif g:time_total < l:desired_time
      put = '\"   Yoda: Ohhh. Great warrior.Wars not make one great.     \"'
      put = '\"         Try change the mode (practice, samurai, ninja)!  \"'
    endif
    put = '//             .--.             '
    put = '//   ::\`--._,`.::.`._.--`/::   '
    put = '//   ::::.  ` __::__ `  .::::   '
    put = '//   ::::::-:.``..``.:-::::::   '
    put = '//   :::::::::.`--`.:::::::::   '
    put = ''
    put = ''
    put = '\":again  ?\"'
    put = '  '
    put = '  '
    put = '  '
    put = '//to help improve this work http://github.com/tcha-tcho/dojo  thanks!' 
    exe ":setlocal filetype=javascript"
    call StopRecording()
    return
  else
    if a:from_error == 0
      put = 'try again!! ('.g:sec.'sec) -- remember: you did set-'.g:kesc.'-to normal-mode'
    elseif g:count_sequence == 0
      put = 'Follow the Movement! and go to normal mode... Seiza! Mokusoh! YAME! Hajime!'
    else
      put = 'Kyyyaii! ('.g:sec.'sec)'
    endif
    put = 'Name       : '.g:kata[g:count_sequence][0]
    if g:kmode == "practice"
      put = 'Description: '.g:kata[g:count_sequence][4]
      put = 'Movement!  : '.g:kata[g:count_sequence][5]
    endif
    put = '  '
    let msg=g:samples[g:kata[g:count_sequence][1]][1]
    put =msg
    put = '  '
    put = '  '
    put = '  '
    put = '  '
    put = '...........................................................'
    put = 'HELP? \":help\"'
    exe "setlocal filetype=".g:samples[g:kata[g:count_sequence][1]][0]
    let l:line_number = g:kata[g:count_sequence][2]+10
    exe "normal ".l:line_number."G"
    exe "normal ".g:kata[g:count_sequence][3]."|"
  endif
endfunction

"CLEAN UP THE SYSTEM WHEN DOJO STOPS. FIRED IN :STOP
function! StopDojo()
  cunmap <buffer> stop
  cunmap <buffer> again
  execute ":close!"
endfunction

"SOME HELP FUNCTIONS
function! StopRecording()
  normal q
  " normal qˆ]
endfunction

function! StartRecording()
  call StopRecording()
  normal qa
endfunction

function! CurMovementTime()
  if !exists("g:time_partial")
    let g:time_partial = 0
  endif
  let a:rs = 0
  if g:time_partial == 1
    let a:rs = reltime()[0] - g:start_writing_time
  endif
endfunction

function! ParseSeconds(sec)
  let l:mins = a:sec / 60
  let l:secs = a:sec - (l:mins * 60)
  if l:secs < 10
    let l:secs = "0".l:secs
  endif
  return l:mins.':'.l:secs
endfunction

function! DrawProgress()
  let l:position = repeat(["-"],g:count_movements)
  let l:position[g:count_sequence] = "o"
  return substitute(join(l:position),' ','',"g")
endfunction

cmap dojo call Dojo()
call Dojo()
