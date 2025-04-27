function runNimWasm(w, ready) {
  for(const i of WebAssembly.Module.exports(w)) {
    const n=i.name;
    if(n[0]==';') {
      new Function('m','ready', n)(w, ready);
    }
  }
}
function runNimWasmAsync(data) {
  return new Promise((resolve, reject) => {
    runNimWasm(data, (result) => {
      // For a more robust solution, you might check for errors
      resolve(result);
    });
  });
}


async function init() {
  console.log("init");
  const module = await WebAssembly.compileStreaming(fetch("/t_wasmrt.wasm"));
  await runNimWasmAsync(module);

  const instance = _nimm;
  instance.exports.testWs("from js")
}
init();

