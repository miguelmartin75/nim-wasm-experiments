# wasm-experiments

```
nimble setup
```


## run server

```
nim c -r src/server.nim --port 3001
```

## compile wasm

```
nim -d:emscripten c src/app.nim
```

### wasmrt tests

```
nim c -d:wasm src/t_wasmrt.nim
```

Visit http://localhost:3000/t_wasmrt


## references
- https://surma.dev/things/c-to-webassembly/
- wasmrt: https://github.com/yglukhov/wasmrt
- https://github.com/aduros/wasm4/pull/167/files
- https://aransentin.github.io/cwasm/


## notes

rough edges:
- emscripten websocket API is not async, but [ws](https://github.com/treeform/ws) is.
- Separate JS bindings need to be made with jsbind/wasmrt when compiling to WASM via emscripten or emscripten-less
