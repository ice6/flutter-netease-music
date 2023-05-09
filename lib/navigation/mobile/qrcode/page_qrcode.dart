import 'package:flutter/material.dart';

class PageQRCodeScanner extends StatelessWidget
{
  const PageQRCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    //FIXME
    return Scaffold(
      appBar: AppBar(title: Text('扫码'),),
      body: const Text('qrcode scan'),
    );
  }
}
