import wasmrt
proc consoleLog(a: cstring) {.importwasmf: "console.log".}
consoleLog("Hello World!")

# NOTE: doesn't import type correctly
proc foo*(x: cstring): int {.exportwasm.} =
  consoleLog("foo: " & x.len)

proc add*(x, y: int): int {.exportwasm.} =
  consoleLog($(x + y))
