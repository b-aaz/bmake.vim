vim9script
# Better file type detection for BSD Makefiles.
export def FTbmake()
	if exists('b:make_flavor') 
		if b:make_flavor == 'bsd'
			set filetype=bmake
			return
		endif
	endif
	if &filetype == 'make' 
		var n = 1
		while n < 1000 && n <= line('$')
			var line = getline(n)
			if line =~ '^\.\%(export\|error\|for\|if\%(n\=\%(def\|make\)\)\=\|info\|warning\|include\|undef\)\>'
				set filetype=bmake
				return
			endif
			++n
		endwhile
	endif
enddef
