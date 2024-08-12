import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

Future<void> generateVehiclePdf(Map<String, dynamic> vehicle) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Arac Raporu',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 16),
            pw.Divider(),
            pw.SizedBox(height: 16),

            pw.Text('Arac Detay', style: pw.TextStyle(fontSize: 22)),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              border: null,
              cellAlignment: pw.Alignment.centerLeft,
              headers: <String>['Attribute', 'Value'],
              data: <List<String>>[
                ['Plaka', vehicle['plate'].toString()],
                ['Cihaz ID', vehicle['deviceId'].toString()],
                ['Actif', vehicle['isActive'] ? 'Yes' : 'No'],
                ['Sensors', vehicle['sensors'].toString()],
                ['Hız', '${vehicle['speed'].toString()} km/h'],
                ['KM', '${vehicle['km'].toString()} km'],
                ['Yakıt Seviyesi', '${vehicle['fuelTankLevel'].toString()}%'],



              ],
            ),
            pw.SizedBox(height: 16),
            pw.Divider(),
            pw.SizedBox(height: 16),

            // Footer
            pw.Align(
              alignment: pw.Alignment.bottomRight,
              child: pw.Text(
                'Report generated on ${DateTime.now().toString().substring(0, 19)}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
