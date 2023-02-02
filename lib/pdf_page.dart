//import 'dart:math';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:invoive_generator/model/invoice.dart';
import 'package:lottie/lottie.dart';
import 'API/pdf_api.dart';
import 'API/pdf_invoice_api.dart';
import 'package:pdf/pdf.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

final invoice = Invoice(
  items: [
    InvoiceItem(
      description: 'Services: Add type of service',
      quantity: 0,
      unitPrice: 0,
    ),
    InvoiceItem(
      description: 'Labour: \n Description if to be added \n \n  ',
      quantity: 2.30,
      unitPrice: 710,
    ),
    InvoiceItem(
      description: 'Materials \n Description if to be added \n \n  ',
      quantity: 2.30,
      unitPrice: 280,
    ),
  ],
);

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Invoive'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  final pdfFile = await PdfInvoiceApi.generate(invoice);
                  log(pdfFile.toString());

                  PdfApi.openFile(pdfFile);
                },
                child: Text('Invoive pdf'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
}
