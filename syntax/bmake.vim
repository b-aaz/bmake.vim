" Vim syntax file
" Language:	BSD Makefile
" Maintainer:	b-aaz <b-aazbsd@proton.me>
" Last Change:	2026

" quit when a syntax file was already loaded
if exists("b:current_syntax")
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

" some special characters
syn match makeSpecial	"\$\$"

" make targets
"syn match makeImplicit transparent		"^\.[A-Za-z0-9_./\t -]\+\s*:$"me=e-1
"syn match makeImplicit	 transparent	"^\.[A-Za-z0-9_./\t -]\+\s*:[^=]"me=e-2

syn region makeForLines 
			\ start="^\.\s*for\>"
			\ skip="\\$"
			\ end="$"
			\ contains=makeForIn,makeFor,makeIdentRegion
			\ transparent
syn match makeForIn "\<in\>"
			\ contained
syn match makeFor "^\.\s*for\>"hs=s+1
			\ contained
syn region makeForRegion 
			\ transparent
			\ start="^\.\s*for\s\+\S\+"
			\ matchgroup=makeFor
			\ end="^\.\s*\zsendfor"
			\ containedin=makeForRegion
			\ contains=TOP,makeError
			\ fold




syn region makeIfLines 
			\ start="^\.\s*if\(def\|ndef\|make\|nmake\)\?\s\+\S\+"
			\ skip="\\$"
			\ end="$"
			\ contains=makeLogical,makeIf,makeIfFunctionRegion,makeIdentRegion
			\ transparent

syn match makeIf "^\.\s*if\(def\|ndef\|make\|nmake\)\?\ze\s\+\S\+"hs=s+1
			\ contained
syn region makeFullIfRegion 
			\ transparent
			\ start="^\.\s*if\(def\|ndef\|make\|nmake\)\?\s\+\S\+"
			\ matchgroup=makeIf
			\ end="^\.\s*\zsendif"
			\ containedin=makeFullIfRegion,makeIfRegion,makeElseRegion
			\ contains=TOP,makeError,makeElseError
			\ fold
syn region makeIfRegion 
			\ transparent
			\ start="^\.\s*if\(def\|ndef\|make\|nmake\)\?\s\+\S\+"
			\ end="^\ze\.\s*else"re=s-1,me=s-1
			\ end="^\ze\.\s*endif"re=s-1,me=s-1
			\ contains=TOP,makeError,makeElifError
			\ contained
			\ containedin=makeFullIfRegion
			\ fold

syn region makeElifLines 
			\ start="^\.\s*elif\(def\|ndef\|make\|nmake\)\?\s\+\S\+"
			\ skip="\\$"
			\ end="$"
			\ contains=makeLogical,makeIfFunctionRegion,makeIdentRegion
			\ containedin=makeIfRegion
			\ contained
			\ transparent

syn match makeElif "^\.\s*elif\(def\|ndef\|make\|nmake\)\?\ze\s\+\S\+"hs=s+1
			\ contained
			\ containedin=makeElifLines

syn region makeElseRegion 
			\ transparent
			\ matchgroup=makeElse
			\ start="^\.\s*\zselse"
			\ end="^\ze\.\s*endif"re=s-1,me=s-1
			\ contains=TOP,makeError,makeElseRegion
			\ containedin=makeFullIfRegion
			\ contained
			\ fold

syn region makeIfFunctionRegion
			\ matchgroup=makeIfFunctions
			\ start="\(empty\|defined\|make\|exists\|target\|commands\)("
			\ end=")"
			\ contained
			\ contains=makeIdent

syn match makeLogical contained '&&\|||\|!=\|!\|==\|<=\|>=\|<\|>'

syn match makeError display "^\.\s*endif\>.*"
syn match makeElifError display "^\.\s*elif\>.*"
syn match makeElseError display "^\.\s*else\>.*"
syn match makeError display "^\.\s*endfor\>.*"

syn match makeBreak	"^\.\s*\zsbreak\>"
syn region makeMsgInfoLine 
			\ matchgroup=makeMsgInfo
			\ contains=makeComment,makeIdentRegion,@Spell
			\ keepend
			\ start="^\.\s*\zsinfo\>"
			\ skip="\\$"
			\ end="$"

syn region makeMsgErrorLine 
			\ matchgroup=makeMsgError
			\ contains=makeIdentRegion,makeComment,@Spell
			\ keepend
			\ start="^\.\s*\zserror\>"
			\ skip="\\$"
			\ end="$"

syn region makeMsgWarnLine 
			\ matchgroup=makeMsgWarn
			\ contains=makeIdentRegion,makeComment,@Spell
			\ keepend
			\ start="^\.\s*\zswarn\>"
			\ skip="\\$"
			\ end="$"

syn region makeMsgExportLine 
			\ matchgroup=makeExport
			\ contains=makeIdentRegion,makeComment
			\ keepend
			\ start="^\.\s*\zs\(unexport\|\(export\(-literal\|-env\)\=\)\)\>\ze\s\+\S\+"
			\ skip="\\$"
			\ end="\_$"

syn match makeExport    "^\.\s*\zsexport-all\>\ze\s*\(\s#.*\)\=$"
syn match makeExport    "^\.\s*\zsunexport-env\>\ze\s*\(\s#.*\)\=$"

syn match makeInc ;^\.\s*\zsinclude\>\s\+\(".*"\|<.*>\);

syn region makeIncSystemRegion
			\ matchgroup=makeIncSystem
			\ start=;";
			\ skip=;\\";
			\ end=;";
			\ contained
			\ containedin=makeInc
			\ contains=makeIdentRegion

syn region makeIncLocalRegion
			\ matchgroup=makeIncLocal
			\ start="<"
			\ skip="\\[<>]"
			\ end=">"
			\ contained
			\ containedin=makeInc
			\ contains=makeIdentRegion


syn region makeUndefLine 
			\ matchgroup=makeUndef
			\ contains=makeIdentRegion,makeComment
			\ keepend
			\ start="^\.\s*\zsundef\>"
			\ skip="\\$"
			\ end="$"

syn region makeTarget 
			\ transparent
			\ keepend
			\ contains=makeIdentRegion,makeSpecTarget,makeComment
			\ skipnl 
			\ nextgroup=makeCommands
			\ matchgroup=makeTarget
			\ start="^[^.][^[:space:]]*\s*:[^:=]"rs=e-1
			\ skip="\\$"
			\ end="$"

syn match makeTarget           "^[^[:space:]]*&\?::\=\s*$"
			\ contains=makeIdentRegion,makeSpecTarget,makeComment
			\ skipnl nextgroup=makeCommands,makeCommandError



syn region makeSpecTarget
			\ transparent
			\ matchgroup=makeSpecTarget
			\ start="^\.\(BEGIN\|DEFAULT\|DELETE_ON_ERROR\|END\|ERROR\|IGNORE\|INTERRUPT\|MAIN\|MAKEFLAGS\|NOPATH\|NOTPARALLEL\|NO_PARALLEL\|NOREADONLY\|OBJDIR\|ORDER\|PATH\|PATH.suffix\|PHONY\|POSIX\|PRECIOUS\|READONLY\|SHELL\|SILENT\|STALE\|SUFFIXES\|SYSPATH\)\>\s*:\{1,2}[^:=]"rs=e-1
			\ end="[^\\]$" keepend
			\ contains=makeIdentRegion,makeSpecTarget,makeComment 
			\ skipnl
			\ nextgroup=makeCommands



syn match makeSpecTarget	"^\.\(BEGIN\|DEFAULT\|DELETE_ON_ERROR\|END\|ERROR\|IGNORE\|INTERRUPT\|MAIN\|MAKEFLAGS\|NOPATH\|NOTPARALLEL\|NO_PARALLEL\|NOREADONLY\|OBJDIR\|ORDER\|PATH\|PATH.suffix\|PHONY\|POSIX\|PRECIOUS\|READONLY\|SHELL\|SILENT\|STALE\|SUFFIXES\|SYSPATH\)\>\s*::\=\s*$"
			\ contains=makeIdentRegion,makeComment
			\ skipnl nextgroup=makeCommands,makeCommandError

syn match makeSpecialVars "\<\\.ALLSRC\>\|\<\.ARCHIVE\>\|\<\.IMPSRC\>\|\<\.MEMBER\>\|\<\.OODATE\>\|\<\.PREFIX\>\|\<\.TARGET\>\|\<\.ALLTARGETS\>\|\<\.CURDIR\>\|\<\.ERROR_CMD\>\|\<\.ERROR_CWD\>\|\<\.ERROR_META_FILE\>\|\<\.ERROR_TARGET\>\|\<\.INCLUDEDFROMDIR\>\|\<\.INCLUDEDFROMFILE\>\|\<MACHINE\>\|\<MACHINE_ARCH\>\|\<MAKE\>\|\<\.MAKE\>\|\<\.MAKE\.ALWAYS_PASS_JOB_QUEUE\>\|\<\.MAKE\.DEPENDFILE\>\|\<\.MAKE\.DIE_QUIETLY\>\|\<\.MAKE\.EXPAND_VARIABLES\>\|\<\.MAKE\.EXPORTED\>\|\<MAKEFILE\>\|\<\.MAKEFLAGS\>\|\<\.MAKE\.GID\>\|\<\.MAKE\.JOB\.PREFIX\>\|\<\.MAKE\.JOBS\>\|\<\.MAKE\.LEVEL\>\|\<\.MAKE\.LEVEL\.ENV\>\|\<\.MAKE\.MAKEFILE_PREFERENCE\>\|\<\.MAKE\.MAKEFILES\>\|\<\.MAKE\.META\.BAILIWICK\>\|\<\.MAKE\.META\.CMP_FILTER\>\|\<\.MAKE\.META\.CREATED\>\|\<\.MAKE\.META\.FILES\>\|\<\.MAKE\.META\.IGNORE_FILTER\>\|\<\.MAKE\.META\.IGNORE_PATHS\>\|\<\.MAKE\.META\.IGNORE_PATTERNS\>\|\<\.MAKE\.META\.PREFIX\>\|\<\.MAKE\.MODE\>\|\<MAKEOBJDIR\>\|\<MAKE_OBJDIR_CHECK_WRITABLE\>\|\<MAKEOBJDIRPREFIX\>\|\<\.MAKEOVERRIDES\>\|\<\.MAKE\.PATH_FILEMON\>\|\<MAKE_PRINT_VAR_ON_ERROR\>\|\<\.MAKE\.SAVE_DOLLARS\>\|\<\.MAKE\.TARGET_LOCAL_VARIABLES\>\|\<\.OBJDIR\>\|\<\.PARSEDIR\>\|\<\.PARSEFILE\>\|\<\.PATH\>\|\<%POSIX\>\|\<PWD\>\|\<\.TARGETS\>\|\<VPATH\>\|\<\.SYSPATH\>\|\<\.MAKE\.OS\>\|\<\.MAKE\.PID\>\|\<\.MAKE\.PPID\>\|\<\.SUFFIXES\>\|\<\.SHELL\>\|\<\.newline\>\|\<\.MAKE\.UID\>"
syn region makeIdentRegion
			\ matchgroup=makeIdent
			\ start="\$(" 
			\ skip="\\)\|\\\\" 
			\ end=")" 
			\ contains=makeIden,makeSpecialVars
			\ containedin=makeIdentRegion

syn region makeIdentRegion 
			\ matchgroup=makeIdent
			\ start="\${"
			\ skip="\\}\|\\\\" 
			\ end="}" 
			\ extend
			\ containedin=makeIdentRegion
			\ contains=makeIden,makeSpecialVars

syn match makeIdent	"^ *[^:#= \t]\{-}\s\{-}\ze[:+?!]\=="
syn match makeIdent	"%"
syn match makeIdent	"$[@*?%!><]"




syn match makeCommandError "^\s\+\S.*" contained

syn match makeSpecial	"^\s*[@+-]"
syn region makeCommands 
			\ contained 
			\ start="^\zs[\t.]"ms=s-1,rs=s-1
			\ end="^[^\t#.]"me=e-1,re=e-1
			\ end="^$"
			\ end="^\ze\.\s*end"me=s-1
			\ contains=TOP
			\ nextgroup=makeCommandError

" Comment
syn region  makeComment	skip="\\#" start="#"  end="^$" end="[^\\]$"
			\ keepend contains=@Spell,makeTodo
syn match   makeComment	"#$" contains=@Spell
" Special region for highlighting commented code blocks differently.
syn region  makeCodeComment	skip="\\#" start="#\{2,}"  end="^$" end="[^\\]$"
			\ keepend
syn keyword makeTodo TODO FIXME XXX contained

syn match makeEscapedChar	"\\\_." containedin=ALL

" Syncing
if !exists("g:bmake_minlines")
    let s:bmake_minlines = 200
else
    let s:bmake_minlines= g:bmake_minlines
endif
if !exists("g:bmake_maxlines")
    let s:bmake_maxlines = 2*s:bmake_minlines
    if s:bmake_maxlines < 25
        let s:bmake_maxlines= 25
    endif
else
    let s:bmake_maxlines= g:bmake_maxlines
endif
exec "syn sync minlines=" . s:bmake_minlines . " maxlines=" . s:bmake_maxlines

" Sync on Make command block region: When searching backwards hits a line that
" can't be a command or a comment, use makeCommands if it looks like a target,
" NONE otherwise.
syn sync match makeCommandSync groupthere NONE "^[^\t#]"
syn sync match makeCommandSync groupthere makeCommands "^[[:alnum:]_./$()%-][[:alnum:]_./\t $()%-]*:\{1,2}[^:=]"
syn sync match makeCommandSync groupthere makeCommands "^[[:alnum:]_./$()%-][[:alnum:]_./\t $()%-]*:\{1,2}\s*$"
syn sync match makeIfSync groupthere makeIfRegion	"^\.\s*if\>"
syn sync match makeIfSync groupthere makeIfRegion	"^\.\s*endif\>"
syn sync match makeForSync groupthere makeForRegion	"^\.\s*for\>"
syn sync match makeForSync groupthere makeForRegion	"^\.\s*endfor\>"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link makeCmdNextLine	Special
hi link     makeExport          Statement

hi def link makeSpecTarget	Statement
hi def link makeSpecialVars	Special
hi def link makeFor		Repeat
hi def link makeForIn		Operator
hi def link makeIf		Conditional
hi def link makeElif		Conditional
hi def link makeElse		Conditional

hi def link makeLogical		Operator

hi def link makeBreak		Function
hi def link makeUndef		Special

hi def link makeMsgInfo		Function
hi def link makeMsgError	ErrorMsg
hi def link makeMsgWarn		WarningMsg

hi def link makeMsgWarnLine	String
hi def link makeMsgInfoLine	String
hi def link makeMsgErrorLine	String

hi def link makeIfFunctions	Special

hi def link makeIncSystem	Special
hi def link makeIncLocal	Special
hi def link makeIncSystemRegion	String
hi def link makeIncLocalRegion	String

hi def link makeEscapedChar	Special

hi link makeCommands	String
hi def link makeImplicit	Function
hi def link makeTarget		Function
hi def link makeTargetinDefine	Function
hi def link makeInc		Include
hi def link makeMsgeCondit	PreCondit
hi def link makeIdent		Identifier
hi def link makeSpecial		Special
hi def link makeComment		Comment
if hlexists('CodeComment')
	hi def link makeCodeComment	CodeComment
else
	hi def link makeCodeComment	Comment
endif
hi def link makeElifError	Error
hi def link makeElseError	Error
hi def link makeError		Error
hi def link makeTodo		Todo
hi def link makeDefine		Define
hi def link makeCommandError	Error

let b:current_syntax = "bmake"


let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8


