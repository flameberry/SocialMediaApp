import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isURL(String text) {
    final RegExp urlRegex = RegExp(
        r'^(?:http|https):\/\/[\w\-]+(?:\.[\w\-]+)+[\w\-.,@?^=%&:/~\+#]*[\w\-@?^=%&/~\+#]$');
    return urlRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
            returnImage: true,
          ),
          onDetect: (capture) {
            List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              print('Barcode Found! ${barcode.rawValue}');
            }

            if (image != null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    String barcodeText = barcodes.first.rawValue ?? "";
                    bool isURL = this.isURL(barcodeText);

                    return AlertDialog(
                      // Check if the barcode is a URL and display it in a webview
                      title: isURL
                          ? InkWell(
                              child: Text(barcodeText),
                              onTap: () => launchUrlString(barcodeText))
                          : Text(barcodeText),
                      content: Image.memory(image),
                    );
                  });
            }
          }),
    );
  }
}
