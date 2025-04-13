--outdir:"build"
--nimcache:"build/cache"

import std/compilesettings
const projectName = querySetting(SingleValueSetting.projectName)

if defined(emscripten):
  switch("out", "public/" & projectName & ".wasm")
  --os:linux # Emscripten pretends to be linux.
  --cpu:wasm32 # Emscripten is 32bits.
  --cc:clang # Emscripten is very close to clang, so we will replace it.
  when defined(windows):
    --clang.exe:emcc.bat  # Replace C
    --clang.linkerexe:emcc.bat # Replace C linker
    --clang.cpp.exe:emcc.bat # Replace C++
    --clang.cpp.linkerexe:emcc.bat # Replace C++ linker.
  else:
    --clang.exe:emcc  # Replace C
    --clang.linkerexe:emcc # Replace C linker
    --clang.cpp.exe:emcc # Replace C++
    --clang.cpp.linkerexe:emcc # Replace C++ linker.
  --gc:arc # GC:arc is friendlier with crazy platforms.
  --exceptions:goto # Goto exceptions are friendlier with crazy platforms.
  --define:noSignalHandler # Emscripten doesn't support signal handlers.

  # Pass this to Emscripten linker to generate html file scaffold for us.
  switch("passL", "-o public/index.html --shell-file src/shell.html")
  switch("passL", "-lwebsocket.js")
elif defined(wasm):
  switch("out", "public/" & projectName & ".wasm")
  --os:linux
  --cpu:wasm32
  --threads:off
  --cc:clang
  --gc:orc
  --noMain
  --d:wasm
  --d:noSignalHandler
  --exceptions:goto
  --d:nimPreviewFloatRoundtrip # Avoid using sprintf as it's not available in wasm
  --d:release
  --opt:size

  --stackTrace:off  # TODO is this needed to be off?

  let 
    llTarget = "wasm32"
    linkerOptions = "-nostdlib -Wl,--no-entry,--allow-undefined,--gc-sections,--strip-all,--export-all"

  switch("passC", "--target=" & llTarget)
  switch("passL", "--target=" & llTarget)

  switch("passC", "-I/usr/include") # Wouldn't compile without this :(
  switch("passC", "-flto") # Important for code size!

  switch("clang.options.linker", linkerOptions)
  switch("clang.cpp.options.linker", linkerOptions)


# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config
