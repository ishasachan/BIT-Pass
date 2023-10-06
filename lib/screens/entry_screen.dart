import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  EntryScreenState createState() => EntryScreenState();
}

class EntryScreenState extends State<EntryScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = ''; // Store scanned data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'), // Set the app bar title
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4, // Adjust the flex to control the camera's size
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1, // Adjust the flex to control the dialog's size
            child: Center(
              child: Text(
                'Scanned Data: $scannedData', // Display the scanned data
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    // Listen for scanned QR code data
    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data here
      debugPrint('Scanned QR Code: ${scanData.code}');

      setState(() {
        scannedData = scanData.code ?? ''; // Update the scanned data
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose(); // Dispose of the controller to release resources
    super.dispose();
  }
}
