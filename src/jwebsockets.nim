# TODO: 
# when defined(emscripten) ...
import emscripten/websocket

type WebSocket* = distinct cint

template check(body: untyped) =
  # TODO: raise exception
  doAssert body == 0

proc newWebSocket*(url: string, protocol: string = ""): Websocket = 
  var createParams = EmscriptenWebSocketCreateAttributes(
    url: url,
    protocols: if protocol == "":
      nil
    else:
      protocol,
    createOnMainThread: true,
  )
  WebSocket(emscripten_websocket_new(createParams.addr))

proc send*(w: WebSocket, data: openArray[char]) =
  check emscripten_websocket_send_binary(w.cint, data[0].addr, data.len.uint32)

# assume UTF-8 encoded
proc send*(w: WebSocket, data: cstring) =
  check emscripten_websocket_send_utf8_text(w.cint, data)

proc close*(w: WebSocket) =
  check emscripten_close(w, )

proc delete*(w: WebSocket) =
  check emscripten_delete(w)

proc `=destroy`(w: WebSocket) =
  close(w)
  delete(w)
