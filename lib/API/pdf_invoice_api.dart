import 'dart:developer';
import 'dart:io';
import 'package:invoive_generator/API/pdf_api.dart';
import 'package:invoive_generator/model/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    String pdfName = 'cc';

    pdf.addPage(MultiPage(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
      build: (context) => [
        buildHeader(),
        buildInvoiceTable(invoice),
        Divider(),
        SizedBox(height: 5),
        buildTotal(invoice),
        buildDueDate(
            date: '31 Jan 2000',
            bankName: 'Name of the bank',
            sortCodeNbr: '12-34-56',
            accountNbr: '12345678'),
        SizedBox(height: 10),
        buildAdvice(
            companyName: 'companyName',
            subContractorName: 'subContractorName',
            fullAddress: 'fullAddress'),
        buildFooter(
            companyName: 'companyName',
            invoiceNbr: 'invoiceNbr',
            dueDate: 'dueDate',
            amountEnclosed: 'amountEnclosed',
            invoice: invoice)
      ],
    ));

    return PdfApi.saveDocument(name: '$pdfName.pdf', pdf: pdf);
  }

  static Widget buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 50,
              width: 50,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: 'number',
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTitle(
                  companyName: 'charikat dajadj', fullAddress: 'Sienna, italy'),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInvoiceInfo(
                      invoiceDate: '29 Jan 2023',
                      invoiceNumber: 'INV-001',
                      vatNumber: '1234567890'),
                  SizedBox(width: 20),
                  buildSubContractorInfo()
                ],
              )
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTitle(
          {required String companyName, required String fullAddress}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE to',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(companyName),
          Text(fullAddress),
        ],
      );

  static Widget buildInvoiceInfo(
          {required String invoiceDate,
          required String invoiceNumber,
          required String vatNumber}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSimpleText(title: 'Invoice Date', value: invoiceDate),
          SizedBox(height: 10),
          buildSimpleText(title: 'Invoice Number', value: invoiceNumber),
          SizedBox(height: 10),
          buildSimpleText(title: 'VAT Number', value: vatNumber),
        ],
      );

  static Widget buildSubContractorInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subcontractor'),
          Text('name/ company'),
          Text('name'),
          Text('Full address'),
          Text('UTR: 1234567890'),
          Text('NIN: 1234567890'),
          Text('Email'),
          Text('Email'),
          Text('Telephone'),
        ],
      );

  static Widget buildInvoiceTable(Invoice invoice) {
    final headers = ['Description', 'Quantity', 'Unit Price', 'Amount GBP'];

    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity;

      return [
        item.description,
        '${item.quantity}\h',
        '${item.unitPrice}',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder(
        horizontalInside: BorderSide(),
      ),
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = 0.2;
    double vat = double.parse((netTotal * vatPercent).toStringAsFixed(2));
    final total = netTotal - vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    title: 'Subtotal',
                    value: netTotal.toString(),
                    boldTitle: false),
                Divider(),
                buildText(
                  title: 'Total GPB ',
                  value: netTotal.toString(),
                ),
                SizedBox(height: 5),
                buildText(
                    title: 'Less CIS Deduction ',
                    value: vat.toString(),
                    boldTitle: false),
                Divider(),
                buildText(
                  title: 'AMOUNT DUE GBP',
                  boldValue: true,
                  value: total.toString(),
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDueDate(
          {required String date,
          required String bankName,
          required String sortCodeNbr,
          required String accountNbr}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Due Date: $date',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          //SizedBox(height: 10),
          Text('Bank account: $bankName'),
          Text('Sort code n. $sortCodeNbr'),
          Text('Account n. $accountNbr'),
        ],
      );

  static Widget buildAdvice({
    required String companyName,
    required String subContractorName,
    required String fullAddress,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAYMENT ADVICE:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // SizedBox(height: 10),
          Text(subContractorName),
          Text(companyName),
          Text(fullAddress),
        ],
      );

  static Widget buildFooter(
      {required String companyName,
      required String invoiceNbr,
      required String dueDate,
      required String amountEnclosed,
      required Invoice invoice}) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = 0.2;
    final vat = netTotal * vatPercent;
    final amountDue = netTotal - vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          //Text('text')
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(title: 'Customer', value: companyName.toString()),
                buildText(title: 'Invoice Number', value: invoiceNbr.toString()),
                Divider(),
                buildText(
                    title: 'Amount Due',
                    value: amountDue.toString(),
                    boldValue: true),
                buildText(
                  title: 'Due Date ',
                  value: dueDate.toString(),
                ),
                Divider(),
                buildText(
                    title: 'Amount Enclosed ',
                    value: '______'.toString(),
                    boldValue: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildSimpleText({required String title, required String value}) {
    final style = TextStyle(fontWeight: FontWeight.bold);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText(
      {required String title,
      required String value,
      bool boldTitle = true,
      bool boldValue = false}) {
    return Container(
      //width: double.infinity,
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            style: boldTitle ? TextStyle(fontWeight: FontWeight.bold) : null,
          )),
          Text(value,
              style: boldValue ? TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
