" Same as normal Make.
au BufNewFile,BufRead *[mM]akefile,*.mk,*.mak	call bmake#FTbmake()
