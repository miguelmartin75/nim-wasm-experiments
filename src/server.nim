import
  std/[
    algorithm,
    times,
    os,
    monotimes,
    strformat,
    strutils,
    dirs,
    files,
    sugar,
    paths,
    tables,
    mimetypes
  ],
  karax/[karaxdsl, vdom, vstyles],
  mummy, mummy/routers

const mimeDb = newMimeTypes()

template resp(code: int, contentType: string, r: untyped): untyped =
  var headers: HttpHeaders
  headers["Content-Type"] = contentType
  request.respond(code, headers, r)

proc nowMs*(): float64 = getMonoTime().ticks.float64 / 1e6
template echoMs*(prefix: string, silent: bool, body: untyped) =
  let t1 = nowMs()
  body
  let
    t2 = nowMs()
    delta = t2 - t1

  if not silent:
    var deltaStr = ""
    deltaStr.formatValue(delta, ".3f")
    echo prefix, deltaStr, "ms"

type
  Ctx = object
    silent: bool
    serveDir: string

    dev: bool
    port: int


proc runServer(ctx: Ctx) =
  let silent = ctx.silent
  var router: Router

  template handleCode(code: int) =
    let key = $code
    request.respond(code)

  proc assetHandler(request: Request) =
    let
      name = request.path
      relPath = if name == "/":
        Path("/index.html")
      else:
        Path(name)

      relPathSplit = relPath.splitFile
      realExt = relPathSplit.ext
      ext = if realExt == "":
        ".html"
      else:
        realExt

      mime = getMimetype(mimeDb, ext, "")
      fp = ctx.serveDir.Path / relPathSplit.dir / Path(relPathSplit.name.string & ext)
      key = if name == "/":
        "index"
      else:
        relPath.string[1..^1]

    echo "key=", key.string
    echo "fp=", fp.string
    if not fp.fileExists:
      handleCode(404)
      return

    if mime == "":
      handleCode(403)
      return

    var headers: HttpHeaders
    headers["Content-Type"] = mime

    let content = readFile(fp.string)
    request.respond(200, headers, content)

  # TODO: reload
  proc websocketHandler(
    websocket: WebSocket,
    event: WebSocketEvent,
    message: Message
  ) =
    case event:
    of OpenEvent:
      echo "websocket opened"
      discard
    of MessageEvent:
      echo "message: ", message
      discard
    of ErrorEvent:
      discard
    of CloseEvent:
      discard

  proc upgradeHandler(request: Request) =
    let websocket = request.upgradeToWebSocket()
    websocket.send("Hello world from WebSocket!")

  router.get("/ws", upgradeHandler)
  router.get("/**", assetHandler)

  let server = newServer(router, websocketHandler)
  echo &"http://localhost:{ctx.port}"
  server.serve(Port(ctx.port))

const defaults = Ctx(
  silent: false,
  serveDir: "./public",
  port: 8080,
  dev: false,
)

when isMainModule:
  import cligen
  var app = initFromCL(defaults)
  app.runServer()
