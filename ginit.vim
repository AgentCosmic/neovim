if exists('g:GuiLoaded')
	" GuiFont! Hack:h10
	GuiFont! Consolas:h10
	GuiPopupmenu 0
	GuiTabline 0
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
