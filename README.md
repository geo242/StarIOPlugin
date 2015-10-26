# StarIOPlugin

Install with cordova
```
cordova plugin add https://github.com/InteractiveObject/StarIOPlugin.git
```


## API

Printer discovery
```
window.starPrinter.portDiscovery(function(printerList){
  console.log(printerList[0].name);
  console.log(printerList[0].port);
});
```


Printer status
```
window.starPrinter.checkStatus(port, function(result){
  console.log(result ? "printer is online : "printer is offline);
});
```


Print receipt
```
var myReceipt = "Title \n\n -- Price\r\r\r 20$\n\n ---\n";
window.starPrinter.printReceipt(port, myReceipt, function(result){
  console.log(result ? "printer is online : "printer is offline);
});
```



