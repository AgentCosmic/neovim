if exists('g:GuiLoaded')
	GuiFont! Hack\ NF:h9
	GuiPopupmenu 0
	GuiTabline 0
	set background=dark
	colorscheme	soft

	" Start with maximized window
	call GuiWindowMaximized(1)

	augroup vimrcGui
		autocmd!
		" Give alt key control to Windows
		autocmd GUIEnter * simalt ~x
	augroup END
endif
