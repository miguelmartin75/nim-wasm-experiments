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


## notes
- https://surma.dev/things/c-to-webassembly/
- wasmrt: https://github.com/yglukhov/wasmrt
- https://github.com/aduros/wasm4/pull/167/files
