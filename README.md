# StarIOPlugin

Install with cordova
```
cordova plugin add https://github.com/InteractiveObject/StarIOPlugin.git
```


## API

### Printer discovery
```
window.plugins.starPrinter.portDiscovery(function(error, printerList){
  if (error) {
    console.error(error);
  } else {
    console.log(printerList[0].name);
    console.log(printerList[0].macAddress);
  }
});
```


### Printer status
```
window.plugins.starPrinter.checkStatus(name, function(error, result){
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
window.plugins.starPrinter.printReceipt(name, myReceipt, function(error, result){
  if (error) {
    console.error(error);
  } else {
    console.log("printReceipt finished");
  }
  
});
```



