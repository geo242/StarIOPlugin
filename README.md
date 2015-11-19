# StarIOPlugin
Phonegap plugin for Star Micronics bluetooth printers. It works with Android and iOS


How to use :

* Integrate the SDK into your project. Visit the [Star Micronics developer section](http://www.starmicronics.com/support/sdkdocumentation.aspx) and follow the appropriate documentation.

* Install the plugin: `cordova plugin add https://github.com/InteractiveObject/StarIOPlugin.git`

## API

### Printer discovery
```
window.plugins.starPrinter.portDiscovery('All', function(error, printerList){
  if (error) {
    console.error(error);
  } else {
    console.log(printerList[0].name);
    console.log(printerList[0].macAddress);
  }
});
```
Port types are: 'All', 'Bluetooth', 'USB', 'LAN'

### Printer status
```
window.plugins.starPrinter.checkStatus(portName, function(error, result){
  if (error) {
    console.error(error);
  } else {
    console.log(result.offline ? "printer is offline : "printer is online);
  }
});
```

### Print receipt
```
var myReceipt = "Title \n\n -- Price\r\r\r 20$\n\n ---\n";
window.plugins.starPrinter.printReceipt(portName, myReceipt, function(error, result){
  if (error) {
    console.error(error);
  } else {
    console.log("printReceipt finished");
  }
});
```

### Connect and listen for hardware events (mPOP on iOS only)
```
window.plugins.starPrinter.connect(portName, function(error, result){
  if (error) {
    console.error(error);
  } else {
    console.log("connect finished");    
  }
});
window.addEventListener('starIOPluginData', function (e) {
  switch (e.dataType) {
    case 'printerCoverOpen':
      break;
    case 'printerCoverClose':
      break;
    case 'printerImpossible':
      break;
    case 'printerOnline':
      break;
    case 'printerOffline':
      break;
    case 'printerPaperEmpty':
      break;
    case 'printerPaperNearEmpty':
      break;
    case 'printerPaperReady':
      break;
    case 'barcodeReaderConnect':
      break;
    case 'barcodeDataReceive':
      break;
    case 'barcodeReaderImpossible':
      break;
    case 'cashDrawerOpen':
      break;
    case 'cashDrawerClose':
      break;
  }
});
```

### Open cash drawer (mPOP on iOS only)
```
window.plugins.starPrinter.openCashDrawer(name, function(error, result){
  if (error) {
    console.error(error);
  } else {
    console.log("openCashDrawer finished");
  }
});
```

[Demo application](https://github.com/InteractiveObject/StarIOPluginDemo)
