console.log("Started worker.");

var Module = {};
var result = {};

onmessage = function(msg) {
  console.log("Run main.");
  result = {
    stdout: "",
    file: ""
  };
  var romBlob = msg.data.romBlob;
  var args = "rom.bin " + msg.data.args;
  var stdout = "";

  // Emscripten uses 'Module' to both import and export
  Module = {
    arguments: args.split(" "),
    preRun: function download() {
      FS.createDataFile('/', "rom.bin", romBlob, true, true);
    },
    postRun: function returnResult() {
      result['stdout'] = stdout;
      result['romBlob'] = FS.readFile('rom.bin');
      self.postMessage(result);
    },
    print: function log(text) {
      console.log(text)
      stdout = stdout + text.split("\t").map(function(v) {
        return "\"" + v + "\"";
      }).join(",") + "\n";
    },
    printErr: function error(text) {
      console.error(text);
    }
  };
  importScripts("cbfstool.js");
};
