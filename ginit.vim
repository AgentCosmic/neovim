if exists('g:GuiLoaded')
	" https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack
	GuiFont! Hack\ NF:h9
	GuiPopupmenu 0
	GuiTabline 0

	" Start with maximized window
	call GuiWindowMaximized(1)

	augroup vimrcGui
		autocmd!
		" Give alt key control to Windows
		autocmd GUIEnter * simalt ~x
	augroup END
endif
