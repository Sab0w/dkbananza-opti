@echo off
rem Usage: build-selevet.bat <build-dir-name> <cmake cache file>
rem Configures (first time) and builds Selevet Eglantine (src\selevet) with clang-cl from D:\BuildTools\LLVM.
rem Environment: JOBS (parallel jobs, default 16).
setlocal
set "SRC_ROOT=%~dp0"
set "BUILD_NAME=%~1"
set "CACHE_FILE=%~2"
if "%JOBS%"=="" set "JOBS=16"
if "%BUILD_NAME%"=="" exit /b 2

call "D:\BuildTools\VS2026\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1
set "CMAKE_DIR=D:\BuildTools\VS2026\Common7\IDE\CommonExtensions\Microsoft\CMake"
set "PATH=D:\BuildTools\LLVM\bin;D:\BuildTools\Python312;%CMAKE_DIR%\CMake\bin;%CMAKE_DIR%\Ninja;D:\BuildTools\VulkanSDK\Bin;C:\Program Files\Git\usr\bin;%PATH%"
set "VULKAN_SDK=D:\BuildTools\VulkanSDK"
cd /d "%SRC_ROOT%selevet" || exit /b 1

if not exist "%BUILD_NAME%\CMakeCache.txt" (
  if "%CACHE_FILE%"=="" exit /b 2
  cmake -C "%CACHE_FILE%" -S . -B "%BUILD_NAME%" -G Ninja || exit /b 1
)
cmake --build "%BUILD_NAME%" --target yuzu --parallel %JOBS% || exit /b 1
echo BUILD_OK %BUILD_NAME%
