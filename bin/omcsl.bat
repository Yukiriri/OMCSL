@echo off & chcp 65001 >nul & setlocal enabledelayedexpansion
::cmd arg: <jar> <Xmx> [<GC> [yggdrasil]]
::env arg: [JAVA_BIN]


if "%JAVA_BIN%" == "" (
  set JAVA_BIN=java
)

if "%JAVA_VER%" == "" (
  for /f "delims=" %%b in ('%JAVA_BIN% -version 2^>^&1 ^| findstr /C:"build"') do (
    for /f "delims=" %%v in ('echo %%b ^| findstr /C:"build 21"') do set JAVA_VER=21
    for /f "delims=" %%v in ('echo %%b ^| findstr /C:"build 17"') do set JAVA_VER=17
    for /f "delims=" %%v in ('echo %%b ^| findstr /C:"build 11"') do set JAVA_VER=11
    for /f "delims=" %%v in ('echo %%b ^| findstr /C:"build 1.8"') do set JAVA_VER=8
  )
)
if "%JAVA_VER%" == "" (
  echo [OMCSL][ERROR]: JAVA_BIN error
  goto :EOF
)


set mem_amount=%2
set mem_unit=%mem_amount:~-1%
set mem_amount=%mem_amount:~0,-1%
set mem_size_mb=%mem_amount%
if /i "%mem_unit%" == "G" set /a mem_size_mb=%mem_amount%*1024 >nul
set JAVA_OPTS=-XX:ConcGCThreads=%NUMBER_OF_PROCESSORS% -XX:ParallelGCThreads=%NUMBER_OF_PROCESSORS% -XX:-UseDynamicNumberOfGCThreads
if %JAVA_VER% GEQ 13 (
  set /a SoftMaxHeapSize=%mem_size_mb%/10*9 >nul
  set JAVA_OPTS=%JAVA_OPTS% -XX:SoftMaxHeapSize=!SoftMaxHeapSize!M
)
if %JAVA_VER% GEQ 17 (
  set JAVA_OPTS=%JAVA_OPTS% --add-modules=jdk.incubator.vector
)

set gc_policy=%3
if "%gc_policy%" == "" set gc_policy=auto
if "%gc_policy%" == "auto" (
  set gc_policy=gc8
  if %JAVA_VER% GEQ 21 if %NUMBER_OF_PROCESSORS% GEQ 4  if %mem_size_mb% GEQ 8192 (
    set gc_policy=gc21
  )
)
if "%gc_policy:~0,3%" == "gc8" (
  set gc_flags=%~dp0\..\flags\GC8.txt
  set /a survivor_size_mb=64+%NUMBER_OF_PROCESSORS%*16
  set /a SurvivorRatio=%mem_size_mb%/3/!survivor_size_mb! >nul
  if !SurvivorRatio! LSS 1 set SurvivorRatio=1
  set JAVA_OPTS=!JAVA_OPTS! -XX:SurvivorRatio=!SurvivorRatio! -XX:G1ConcRefinementThreads=%NUMBER_OF_PROCESSORS%
)
if "%gc_policy:~0,4%" == "gc11" (
  set gc_flags=%~dp0\..\flags\GC11.txt
)
if "%gc_policy:~0,4%" == "gc21" (
  set gc_flags=%~dp0\..\flags\GC21.txt
)
if "%gc_policy:~0,5%" == "gc21c" (
  set JAVA_OPTS=!JAVA_OPTS! -XX:ZCollectionIntervalMinor=1.5
)

if "%4" == "ls" set yggdrasil_flags=%~dp0\..\flags\yggdrasil-littleskin.txt

if %JAVA_VER% GEQ 9 (
  if not "%yggdrasil_flags%" == "" set yggdrasil_flags=@%yggdrasil_flags%
  set JAVA_OPTS=@%gc_flags% %JAVA_OPTS% !yggdrasil_flags!
) else (
  for /f "delims=" %%i in (%gc_flags% %yggdrasil_flags%) do set JAVA_OPTS=!JAVA_OPTS! %%i
  set JAVA_OPTS=!JAVA_OPTS! -XX:MaxTenuringThreshold=15
)


if "%OMCSL_DEBUG%" == "" (
  set OMCSL_DEBUG=0
)
if %OMCSL_DEBUG% GEQ 3 (
  set debug_opts=%debug_opts% -XX:-PerfDisableSharedMem
)
if %OMCSL_DEBUG% GEQ 2 if %JAVA_VER% GEQ 11 (
  if not exist logs\gc mkdir logs\gc
  if "%gc_policy:~0,3%" == "gc8"  set gc_log_type=gc,gc+phases,gc+marking
  if "%gc_policy:~0,4%" == "gc11" set gc_log_type=gc,gc+ergo
  if "%gc_policy:~0,4%" == "gc21" set gc_log_type=gc+phases,gc+stats
  set debug_opts=%debug_opts% -Xlog:!gc_log_type!:file="logs/gc/phases.log"::filecount=10
)
if %OMCSL_DEBUG% GEQ 1 (
  echo --------------------------------------------------
  echo [OMCSL][DEBUG]: JAVA_BIN   = %JAVA_BIN%
  echo [OMCSL][DEBUG]: JAVA_VER   = %JAVA_VER%
  echo [OMCSL][DEBUG]: jar        = %1
  echo [OMCSL][DEBUG]: Xmx        = %2
  echo [OMCSL][DEBUG]: JAVA_OPTS  = %JAVA_OPTS%
  echo [OMCSL][DEBUG]: debug_opts = %debug_opts%
  echo --------------------------------------------------
  %JAVA_BIN% -Xmx%2 %JAVA_OPTS% -XX:+UnlockExperimentalVMOptions -XX:+PrintFlagsFinal 2>nul | findstr /C:"command line"
  echo --------------------------------------------------
)

set boot_core=%1
if "%boot_core:~-3%" == "jar" set boot_core=-jar %boot_core%
%JAVA_BIN% -Xms%2 -Xmx%2 %JAVA_OPTS% %debug_opts% %boot_core% nogui
