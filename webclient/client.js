// Setup the worker

var myWorker = new Worker("worker.js");
myWorker.addEventListener('message', resultCallback);

function resultCallback(msg) {
  console.log("Result received from worker");

  setResult("");
  var stdout = msg.data.stdout;
  setRomBlob(msg.data.romBlob);
  var rows = d3.csv.parseRows(stdout);
  if (!rows[0]) {
    print();
    return;
  }

  var tbl = d3.select("#resultTable")
    .append("table")
    .attr("class", "table table-hover table-striped table-bordered")

  // headers
  tbl.append("thead").append("tr")
    .selectAll("th")
    .data(rows[0])
    .enter().append("th")
    .text(function(d) {
      return d;
    });

  // data
  tbl.append("tbody")
    .selectAll("tr").data(rows.slice(1))
    .enter().append("tr")

  .selectAll("td")
    .data(function(d) {
      return d;
    })
    .enter().append("td")
    .text(function(d) {
      return d;
    })
}

function print() {
  runWithArgs("print -k");
}

function addItem() {
  runWithArgs("add-int -i 0xd091f000 -n etc/sdcard2");
}

function removeItem() {
  runWithArgs("remove -n etc/sdcard2");
}

function runWithArgs(args) {
  setResult("Loading...");
  myWorker.postMessage({
    romBlob: romBlob,
    args: args
  });
}

function setResult(value) {
  document.getElementById('resultTable').innerHTML = value;
}

// Manage files
var romBlob;
document.getElementById('files').addEventListener('change', addLocalFile, false);

function setRomBlob(blob) {
  console.log("Loaded ROM with length:" + blob.length);
  romBlob = blob;
}

function addLocalFile(event) {
  var file = event.target.files[0];
  console.log("Loading local ROM:" + file.name);
  var reader = new FileReader();

  reader.onload = (function(theFile) {
    return function(e) {
      setRomBlob(e.target.result);
    };
  })(file);

  reader.readAsBinaryString(file);
}

function updateProgress(evt)
{
   if (evt.lengthComputable)
   {  //evt.loaded the bytes browser receive
      //evt.total the total bytes seted by the header
      //
     var percentComplete = (evt.loaded / evt.total)*100;
     console.log("Progress:" + percentComplete);
   }
}

function addRemoteFile() {
  var url = document.getElementById('url').value;
  console.log("Loading remote ROM:" + url);
  url = "https://crossorigin.me/" + url;

  var oReq = new XMLHttpRequest();
  oReq.open("GET", url, true);
  oReq.onprogress=updateProgress;
  oReq.responseType = "arraybuffer";

  oReq.onload = function(oEvent) {
    var byteArray = new Uint8Array(oReq.response);
    setRomBlob(byteArray);
  };

  oReq.send(null);
}

function onUrlEnter(event) {
  if (event.keyCode === 13) {
    addRemoteFile();
  }
  event.preventDefault();
  return false;
}
