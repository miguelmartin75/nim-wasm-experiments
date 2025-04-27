import sokol/log as slog
import sokol/app as sapp
import sokol/gfx as sg
import sokol/glue as sglue

import jwebsockets
# import ws

var 
  passAction = PassAction(
    colors: [ ColorAttachmentAction( loadAction: loadActionClear, clearValue: (1, 0, 0, 0)) ]
  )
  s: WebSocket

proc init() {.cdecl.} =
  sg.setup(sg.Desc(
    environment: sglue.environment(),
    logger: sg.Logger(fn: slog.fn),
  ))
  case sg.queryBackend():
    of backendGlcore: echo "using GLCORE backend 3"
    of backendD3d11: echo "using D3D11 backend"
    of backendMetalMacos: echo "using Metal backend"
    else: echo "using untested backend"

  s = newWebSocket("/ws")
  s.send("hello")

proc frame() {.cdecl.} =
  var g = passAction.colors[0].clearValue.g + 0.01
  # passAction.colors[0].clearValue.g = if g > 1.0: 0.0 else: g
  beginPass(Pass(action: passAction, swapchain: sglue.swapchain()))
  endPass()
  commit()

proc cleanup() {.cdecl.} =
  sg.shutdown()

sapp.run(sapp.Desc(
  initCb: init,
  frameCb: frame,
  cleanupCb: cleanup,
  windowTitle: "clear.nim",
  width: 400,
  height: 300,
  icon: IconDesc(sokol_default: true),
  logger: sapp.Logger(fn: slog.fn)
))
