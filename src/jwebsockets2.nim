when true:
  import jsbind
  type WebSocket* = ref object of JSObj
  proc newWebSocket*(url: string): WebSocket {.jsimportgWithName: "(function(a) { return new WebSocket(a); })".}
  proc send*(w: WebSocket, data: cstring) {.jsimport.}
else:
  import wasmrt

  type WebSocket* = distinct JSObj

  proc newWebSocket*(url: string): WebSocket {.importwasmraw: "new WebSocket(_nimsj($0))".}
  # importwasmm appears to be broken, https://github.com/yglukhov/wasmrt/blob/145b4a0b903b8f38ee5050f74efe1222085ed613/wasmrt.nim#L221C7-L221C18
  # proc send*(w: WebSocket, data: cstring) {.importwasmexpr: "$0.send(_nimsj($1))".}
  proc send*(w: WebSocket, data: cstring) {.importwasmraw: "console.log(_nimok[$0]); console.log($0)".}
