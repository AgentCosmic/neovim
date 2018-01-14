if exists('g:GuiLoaded')
	" Guifont! Hack:h10
	set background=dark
	colorscheme	comfort

	" Start with maximized window
	call GuiWindowMaximized(1)

	augroup vimrcGui
		autocmd!
		" Give alt key control to Windows
		autocmd GUIEnter * simalt ~x
	augroup END
endif
