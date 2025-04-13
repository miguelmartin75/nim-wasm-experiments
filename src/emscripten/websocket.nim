import std/posix

proc emscripten_websocket_get_ready_state*(socket: cint, readyState: ptr[cushort]): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_get_buffered_amount*(socket: cint, bufferedAmount: ptr[csize_t]): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_get_url*(socket: cint, url: cstring, urlLength: cint): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_get_url_length*(socket: cint, urlLength: ptr[cint]): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_get_extensions*(socket: cint, extensions: cstring, extensionsLength: cint): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_get_extensions_length*(socket: cint, extensionsLength: ptr[cint]): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_get_protocol*(socket: cint, protocol: cstring, protocolLength: cint): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_get_protocol_length*(socket: cint, protocolLength: ptr[cint]): cint {.importc, header: "emscripten/websocket.h".}

type EmscriptenWebSocketOpenEvent* {.importc, bycopy, header: "emscripten/websocket.h".} = object  
  socket* {.importc.}: cint

type em_websocket_open_callback_func* = proc(a0: cint, a1: ptr[EmscriptenWebSocketOpenEvent], a2: pointer): cint {.cdecl.}

proc emscripten_websocket_set_onopen_callback_on_thread*(socket: cint, userData: pointer, callback: em_websocket_open_callback_func, targetThread: Pthread): cint {.importc, header: "emscripten/websocket.h".}

type EmscriptenWebSocketMessageEvent* {.importc, bycopy, header: "emscripten/websocket.h".} = object  
  socket* {.importc.}: cint
  data* {.importc.}: ptr[uint8]
  numBytes* {.importc.}: uint32
  isText* {.importc.}: bool

type em_websocket_message_callback_func* = proc(a0: cint, a1: ptr[EmscriptenWebSocketMessageEvent], a2: pointer): cint {.cdecl.}

proc emscripten_websocket_set_onmessage_callback_on_thread*(socket: cint, userData: pointer, callback: em_websocket_message_callback_func, targetThread: Pthread): cint {.importc, header: "emscripten/websocket.h".}

type EmscriptenWebSocketErrorEvent* {.importc, bycopy, header: "emscripten/websocket.h".} = object  
  socket* {.importc.}: cint

type em_websocket_error_callback_func* = proc(a0: cint, a1: ptr[EmscriptenWebSocketErrorEvent], a2: pointer): cint {.cdecl.}

proc emscripten_websocket_set_onerror_callback_on_thread*(socket: cint, userData: pointer, callback: em_websocket_error_callback_func, targetThread: Pthread): cint {.importc, header: "emscripten/websocket.h".}

type EmscriptenWebSocketCloseEvent* {.importc, bycopy, header: "emscripten/websocket.h".} = object  
  socket* {.importc.}: cint
  wasClean* {.importc.}: bool
  code* {.importc.}: cushort
  reason* {.importc.}: array[512, cchar]

type em_websocket_close_callback_func* = proc(a0: cint, a1: ptr[EmscriptenWebSocketCloseEvent], a2: pointer): cint {.cdecl.}

proc emscripten_websocket_set_onclose_callback_on_thread*(socket: cint, userData: pointer, callback: em_websocket_close_callback_func, targetThread: Pthread): cint {.importc, header: "emscripten/websocket.h".}

type EmscriptenWebSocketCreateAttributes* {.importc, bycopy, header: "emscripten/websocket.h".} = object  
  url* {.importc.}: cstring
  protocols* {.importc.}: cstring
  createOnMainThread* {.importc.}: bool

proc emscripten_websocket_is_supported*(): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_new*(createAttributes: ptr[EmscriptenWebSocketCreateAttributes]): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_send_utf8_text*(socket: cint, textData: cstring): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_send_binary*(socket: cint, binaryData: pointer, dataLength: uint32): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_close*(socket: cint, code: cushort, reason: cstring): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_delete*(socket: cint): cint {.importc, header: "emscripten/websocket.h".}

proc emscripten_websocket_deinitialize*() {.importc, header: "emscripten/websocket.h".}
