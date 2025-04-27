import wasmrt

import jwebsockets2

proc consoleLog(a: cstring) {.importwasmf: "console.log".}
consoleLog("Hello World!")

proc add*(x, y: int): int {.exportwasm.} =
  consoleLog($(x + y))

proc testWs*(msg: cstring) {.exportwasm.} =
  var s = newWebSocket("/ws")
  s.send(msg)
  
