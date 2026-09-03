@echo off
setlocal
rem --- TRACE (diagnostic; remove when done) ---
set "LOG=%APPDATA%\yazi\config\mux-open.log"
rem mux-open.cmd [--here] [command args...]   (cwd inherited from caller)
rem   default : NEW psmux window in the CURRENT live server
rem   --here  : SPLIT the current psmux window
rem
rem FIX B: never fork a second psmux server.
rem   Old script trusted %TMUX% being *set*. A set-but-dead socket made psmux
rem   spawn/confuse another server -> server proliferation -> bad ConPTY handles
rem   -> pwsh FailFast. Now we PROBE the server for real liveness first, and only
rem   issue client commands (new-window/split-window) to a server that answered.
rem   If no live server: open a plain OS window. We never run a command that can
rem   auto-start a server.

set "MODE=new"
if /i "%~1"=="--here" (
  set "MODE=here"
  shift /1
)

rem --- collect the rest as the command to run (may be empty = bare shell) ---
set "CMD=%1"
:collect
shift /1
if not "%~1"=="" set "CMD=%CMD% %1"& goto collect

rem --- Is %TMUX% pointing at a server that is actually ALIVE and answering? ---
rem   list-sessions is a pure client query. Dead/unreachable server -> nonzero
rem   errorlevel -> we do NOT touch psmux at all.
rem   NOTE: a *hung* (not dead) server will make this probe block; that is a
rem   sicker state than this guard can cover from batch (no per-command timeout
rem   in cmd). Kill the hung server if the probe ever hangs.
set "INMUX="
if defined TMUX (
  psmux list-sessions >nul 2>&1 && set "INMUX=1"
)

>>"%LOG%" echo [%DATE% %TIME%] MODE=%MODE% INMUX=%INMUX% TMUX=%TMUX% CWD=%CD% CMD=[%CMD%]

if not defined INMUX goto osfallback

rem --- RENDER FIX -------------------------------------------------------
rem   Passing the command straight to new-window/split-window makes psmux run
rem   it as `pwsh -Command "<cmd>"` (default-shell=pwsh). That is a NON-interactive
rem   pwsh, which spawns the real program (e.g. nvim.exe) inside a *nested*
rem   ConPTY. A TUI like nvim then draws into the inner pseudo-console that psmux
rem   never surfaces -> pitch-black pane, input ignored (proven empirically).
rem   Fix: create a BARE *interactive* pwsh pane (single ConPTY, renders fine),
rem   then type the command into it with send-keys. Bonus: the shell stays after
rem   the program exits instead of the pane vanishing.
set "PANE="
if "%MODE%"=="here" (
  for /f "usebackq delims=" %%p in (`psmux split-window -c "%CD%" -P -F "#{pane_id}"`) do set "PANE=%%p"
) else (
  for /f "usebackq delims=" %%p in (`psmux new-window -c "%CD%" -P -F "#{pane_id}"`) do set "PANE=%%p"
)
if not "%CMD%"=="" psmux send-keys -t "%PANE%" "%CMD%" Enter
>>"%LOG%" echo   pane=%PANE% sent=[%CMD%] send-exit=%ERRORLEVEL%
goto :eof

:osfallback
rem No live server reachable. Do NOT start psmux (that is the fork we are killing).
rem Fall back to a plain OS terminal window so the action still does something.
>>"%LOG%" echo   OS-FALLBACK (no live server)
if "%CMD%"=="" ( start "" cmd /k ) else ( start "" %CMD% )
goto :eof
