package fr.sellsy.cordova;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;


import java.io.Console;
import java.io.UnsupportedEncodingException;
import java.util.Locale;
import java.util.TimeZone;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;


import com.ionicframework.bluetoothprinter306825.R;
import com.starmicronics.stario.PortInfo;
import com.starmicronics.stario.StarIOPort;
import com.starmicronics.stario.StarIOPortException;
import com.starmicronics.stario.StarPrinterStatus;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.provider.Settings;
import android.util.Log;
import android.widget.EditText;
import android.widget.Spinner;


/**
 * This class echoes a string called from JavaScript.
 */
public class StarIOPlugin extends CordovaPlugin {


    String strInterface;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("checkStatus")) {
            String portName = args.getString(0);
            String portSettings = getPortSettingsOption(portName);
            this.checkStatus(portName, portSettings, callbackContext);
            return true;
        }else if (action.equals("portDiscovery")) {
                this.portDiscovery(callbackContext);
                return true;
        }else {
            String portName = args.getString(0);
            String portSettings = getPortSettingsOption(portName);
            String receipt = args.getString(1);

            this.printReceipt(portName, portSettings, receipt, callbackContext);
            return true;
        }
    }


    public void checkStatus(String portName, String portSettings, CallbackContext callbackContext) {

        final Context context = this.cordova.getActivity();
        final CallbackContext _callbackContext = callbackContext;

        final String _portName = portName;
        final String _portSettings = portSettings;

        cordova.getThreadPool()
                .execute(new Runnable() {
                    public void run() {

                        StarIOPort port = null;
                        try {

                            port = StarIOPort.getPort(_portName, _portSettings, 10000, context);

                            // A sleep is used to get time for the socket to completely open
                            try {
                                Thread.sleep(500);
                            } catch (InterruptedException e) {
                            }

                            StarPrinterStatus status;
                            status = port.retreiveStatus();

                            JSONObject json = new JSONObject();
                            try {
                                json.put("offline", status.offline);
                                json.put("coverOpen", status.coverOpen);
                                json.put("cutterError", status.cutterError);
                                json.put("receiptPaperEmpty", status.receiptPaperEmpty);
                            } catch (JSONException ex) {

                            } finally {
                                _callbackContext.success(json);
                            }


                        } catch (StarIOPortException e) {
                            _callbackContext.error("Failed to connect to printer :" + e.getMessage());
                        } finally {

                            if (port != null) {
                                try {
                                    StarIOPort.releasePort(port);
                                } catch (StarIOPortException e) {
                                    _callbackContext.error("Failed to connect to printer" + e.getMessage());
                                }
                            }

                        }


                    }
                });



    }


    private void portDiscovery(CallbackContext callbackContext) {

        final CallbackContext _callbackContext = callbackContext;

        Context context = this.cordova.getActivity();
        final String item_list[] = new String[] { "LAN", "Bluetooth", "USB", "All" };

        strInterface = "LAN";

        Builder portDiscoveryDialog = new AlertDialog.Builder(context);
        portDiscoveryDialog.setIcon(android.R.drawable.checkbox_on_background);
        portDiscoveryDialog.setTitle("Port Discovery List");
        portDiscoveryDialog.setCancelable(false);
        portDiscoveryDialog.setSingleChoiceItems(item_list, 0, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                strInterface = item_list[whichButton];
            }
        });

        portDiscoveryDialog.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                ((AlertDialog) dialog).getButton(DialogInterface.BUTTON_POSITIVE).setEnabled(false);
                ((AlertDialog) dialog).getButton(DialogInterface.BUTTON_NEGATIVE).setEnabled(false);

                cordova.getThreadPool()
                        .execute(new Runnable() {
                            public void run() {

                                JSONArray result = new JSONArray();
                                try {

                                    if (strInterface.equals("LAN")) {
                                        result = getPortDiscovery("LAN");
                                    } else if (strInterface.equals("Bluetooth")) {
                                        result = getPortDiscovery("Bluetooth");
                                    } else if (strInterface.equals("USB")) {
                                        result = getPortDiscovery("USB");
                                    } else {
                                        result = getPortDiscovery("All");
                                    }

                                } catch (StarIOPortException exception) {
                                    _callbackContext.error(exception.getMessage());

                                } catch (JSONException e) {

                                } finally {

                                    Log.d("Discovered ports", result.toString());
                                    _callbackContext.success(result);
                                }

                            }
                        });


            }
        }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int whichButton) {
                //
            }
        });

        portDiscoveryDialog.show();
    }


    private JSONArray getPortDiscovery(String interfaceName) throws StarIOPortException, JSONException {
        List<PortInfo> BTPortList;
        List<PortInfo> TCPPortList;
        List<PortInfo> USBPortList;

        final Context context = this.cordova.getActivity();
        final ArrayList<PortInfo> arrayDiscovery = new ArrayList<PortInfo>();

        JSONArray arrayPorts = new JSONArray();


        if (interfaceName.equals("Bluetooth") || interfaceName.equals("All")) {
            BTPortList = StarIOPort.searchPrinter("BT:");

            for (PortInfo portInfo : BTPortList) {
                arrayDiscovery.add(portInfo);
            }
        }
        if (interfaceName.equals("LAN") || interfaceName.equals("All")) {
            TCPPortList = StarIOPort.searchPrinter("TCP:");

            for (PortInfo portInfo : TCPPortList) {
                arrayDiscovery.add(portInfo);
            }
        }
        if (interfaceName.equals("USB") || interfaceName.equals("All")) {
            USBPortList = StarIOPort.searchPrinter("USB:", context);

            for (PortInfo portInfo : USBPortList) {
                arrayDiscovery.add(portInfo);
            }
        }

        for (PortInfo discovery : arrayDiscovery) {
            String portName;

            JSONObject port = new JSONObject();
            port.put("name", discovery.getPortName());

            if (!discovery.getMacAddress().equals("")) {

                port.put("macAddress", discovery.getMacAddress());

                if (!discovery.getModelName().equals("")) {
                    port.put("modelName", discovery.getModelName());
                }
            } else if (interfaceName.equals("USB") || interfaceName.equals("All")) {
                if (!discovery.getModelName().equals("")) {
                    port.put("modelName", discovery.getModelName());
                }
                if (!discovery.getUSBSerialNumber().equals(" SN:")) {
                    port.put("USBSerialNumber", discovery.getUSBSerialNumber());
                }
            }

            arrayPorts.put(port);
        }

        return arrayPorts;
    }




    private String getPortSettingsOption(String portName) {
        String portSettings = "";

        if (portName.toUpperCase(Locale.US).startsWith("TCP:")) {
            portSettings += ""; // retry to yes
        } else if (portName.toUpperCase(Locale.US).startsWith("BT:")) {
            portSettings += ";p"; // or ";p"
            portSettings += ";l"; // standard
        }

        return portSettings;
    }


    private void printReceipt(String portName, String portSettings, String receipt, CallbackContext callbackContext) throws JSONException {

        Context context = this.cordova.getActivity();


        ArrayList<byte[]> list = new ArrayList<byte[]>();
        list.add(new byte[] { 0x1b, 0x1d, 0x74, (byte)0x80 });
        /*int len = receipt.length();
        for (int i=0;i<len;i++){
            String msg = receipt.getString(i);

        }*/

        list.add(createCpUTF8(receipt));

        /*
        ArrayList<byte[]> list = new ArrayList<byte[]>();
        list.add(new byte[] { 0x1b, 0x1d, 0x74, (byte)0x80 }); // Code Page UTF-8


        list.add(new byte[] { 0x1b, 0x1d, 0x61, 0x01 }); // Alignment (center)

        // list.add("[If loaded.. Logo1 goes here]\r\n".getBytes());
        // list.add(new byte[]{0x1b, 0x1c, 0x70, 0x01, 0x00, '\r', '\n'}); //Stored Logo Printing
        // Notice that we use a unicode representation because that is
        // how Java expresses these bytes as double byte unicode

        // Character expansion
        list.add(new byte[] { 0x06, 0x09, 0x1b, 0x69, 0x01, 0x01 });
        list.add(createCpUTF8("\nORANGE\r\n"));
        list.add(new byte[] { 0x1b, 0x69, 0x00, 0x00 }); // Cancel Character Expansion
        list.add(createCpUTF8("36 AVENUE LA MOTTE PICQUET\r\n\r\n"));


        list.add(new byte[] { 0x1b, 0x44, 0x02, 0x06, 0x0a, 0x10, 0x14, 0x1a, 0x22, 0x00 }); // Set horizontal tab
        list.add(createCpUTF8("------------------------------------------------\r\n"));
        list.add(createCpUTF8("Date: MM/DD/YYYY    Heure: HH:MM\r\n"));
        list.add(createCpUTF8("Boutique: OLUA23    Caisse: 0001\r\n"));
        list.add(createCpUTF8("Conseiller: 002970  Ticket: 3881\r\n"));
        list.add(createCpUTF8("------------------------------------------------\r\n\r\n"));

        list.add(new byte[] { 0x1b, 0x1d, 0x61, 0x00 }); // Alignment
        list.add(createCpUTF8("Vous avez été servi par : Souad\r\n\r\n"));
        list.add(createCpUTF8("CAC IPHONE ORANGE\r\n"));
        list.add(createCpUTF8("3700615033581 \t1\t X\t 19.99€\t  19.99€\r\n\r\n"));
        list.add(createCpUTF8("dont contribution environnementale :\r\n"));
        list.add(createCpUTF8("CAC IPHONE ORANGE\t\t  0.01€\r\n"));
        list.add(createCpUTF8("------------------------------------------------\r\n"));
        list.add(createCpUTF8("1 Piéce(s) Total :\t\t\t  19.99€\r\n"));
        list.add(createCpUTF8("Mastercard Visa  :\t\t\t  19.99€\r\n\r\n"));


        list.add(new byte[] { 0x1b, 0x1d, 0x61, 0x01 }); // Alignment (center)
        list.add(createCpUTF8("Taux TVA    Montant H.T.   T.V.A\r\n"));
        list.add(createCpUTF8("  20%          16.66€      3.33€\r\n"));
        list.add(createCpUTF8("Merci de votre visite et. à bientôt.\r\n"));
        list.add(createCpUTF8("Conservez votre ticket il\r\n"));
        list.add(createCpUTF8("vous sera demandé pour tout échange.\r\n"));

        // 1D barcode example
        //list.add(new byte[] { 0x1b, 0x1d, 0x61, 0x01 });
        //list.add(new byte[] { 0x1b, 0x62, 0x06, 0x02, 0x02 });
        //list.add(createCpUTF8(" 12ab34cd56\u001e\r\n"));


        */

        list.add(new byte[] { 0x1b, 0x64, 0x02 }); // Cut
        list.add(new byte[]{0x07}); // Kick cash drawer

        sendCommand(context, portName, portSettings, list);
    }

    private void sendCommand(Context context, String portName, String portSettings, ArrayList<byte[]> byteList) {
        StarIOPort port = null;
        try {
			/*
			 * using StarIOPort3.1.jar (support USB Port) Android OS Version: upper 2.2
			 */
            port = StarIOPort.getPort(portName, portSettings, 10000, context);
			/*
			 * using StarIOPort.jar Android OS Version: under 2.1 port = StarIOPort.getPort(portName, portSettings, 10000);
			 */
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
            }

			/*
			 * Using Begin / End Checked Block method When sending large amounts of raster data,
			 * adjust the value in the timeout in the "StarIOPort.getPort" in order to prevent
			 * "timeout" of the "endCheckedBlock method" while a printing.
			 *
			 * If receipt print is success but timeout error occurs(Show message which is "There
			 * was no response of the printer within the timeout period." ), need to change value
			 * of timeout more longer in "StarIOPort.getPort" method.
			 * (e.g.) 10000 -> 30000
			 */
            StarPrinterStatus status = port.beginCheckedBlock();

            if (true == status.offline) {
                throw new StarIOPortException("A printer is offline");
            }

            byte[] commandToSendToPrinter = convertFromListByteArrayTobyteArray(byteList);
            port.writePort(commandToSendToPrinter, 0, commandToSendToPrinter.length);

            port.setEndCheckedBlockTimeoutMillis(30000);// Change the timeout time of endCheckedBlock method.
            status = port.endCheckedBlock();

            if (status.coverOpen == true) {
                showAlert("Sellsy", "Printer cover is open");
            } else if (status.receiptPaperEmpty == true) {
                showAlert("Sellsy", "Receipt paper is empty");
            } else if (status.offline == true) {
                showAlert("Sellsy", "Printer is offline");
            }

        } catch (StarIOPortException e) {
            showAlert("Sellsy", e.getMessage());
        } finally {
            if (port != null) {
                try {
                    StarIOPort.releasePort(port);
                } catch (StarIOPortException e) {
                }
            }
        }
    }


    private void showAlert(String Title, String Message) {

        Context context = this.cordova.getActivity();
        Builder dialog = new AlertDialog.Builder(context);
        dialog.setNegativeButton("Ok", null);
        AlertDialog alert = dialog.create();
        alert.setTitle(Title);
        alert.setMessage(Message);
        alert.setCancelable(false);
        alert.show();

    }

    private byte[] createCpUTF8(String inputText) {
        byte[] byteBuffer = null;

        try {
            byteBuffer = inputText.getBytes("UTF-8");
        } catch (UnsupportedEncodingException e) {
            byteBuffer = inputText.getBytes();
        }

        return byteBuffer;
    }


    private byte[] convertFromListByteArrayTobyteArray(List<byte[]> ByteArray) {
        int dataLength = 0;
        for (int i = 0; i < ByteArray.size(); i++) {
            dataLength += ByteArray.get(i).length;
        }

        int distPosition = 0;
        byte[] byteArray = new byte[dataLength];
        for (int i = 0; i < ByteArray.size(); i++) {
            System.arraycopy(ByteArray.get(i), 0, byteArray, distPosition, ByteArray.get(i).length);
            distPosition += ByteArray.get(i).length;
        }

        return byteArray;
    }

}



