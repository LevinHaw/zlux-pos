import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../features/report/domain/entities/daily_report_detail_entity.dart';

class DailyReportPdfService {
  const DailyReportPdfService();

  static final _currency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  static final _dateFormat = DateFormat('d MMMM yyyy');

  Future<void> exportAndShare({
    required DailyReportDetailEntity report,
    String? merchantName,
  }) async {
    final document = _buildDocument(report: report, merchantName: merchantName);
    await Printing.sharePdf(
      bytes: await document.save(),
      filename:
          'laporan-harian-${DateFormat('yyyy-MM-dd').format(report.date)}.pdf',
    );
  }

  /// Opens the native print/preview dialog for the report.
  Future<void> printDocument({
    required DailyReportDetailEntity report,
    String? merchantName,
  }) async {
    final document = _buildDocument(report: report, merchantName: merchantName);
    await Printing.layoutPdf(onLayout: (_) => document.save());
  }

  pw.Document _buildDocument({
    required DailyReportDetailEntity report,
    String? merchantName,
  }) {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            merchantName ?? 'Laporan Harian',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(_dateFormat.format(report.date)),
          pw.SizedBox(height: 20),

          _sectionTitle('Detail Transaksi per Produk'),
          pw.SizedBox(height: 6),
          _productTable(report),
          pw.SizedBox(height: 8),
          _kvRow('Total Transaksi', '${report.totalTransactions}'),
          _kvRow(
            'Pendapatan Transaksi',
            _currency.format(report.transactionIncome),
          ),
          pw.SizedBox(height: 20),

          _sectionTitle('Metode Pembayaran'),
          pw.SizedBox(height: 6),
          _kvRow('Cash', _currency.format(report.cashTotal)),
          _kvRow('Transfer', _currency.format(report.transferTotal)),
          pw.SizedBox(height: 20),

          _sectionTitle('Income Entry'),
          pw.SizedBox(height: 6),
          if (report.incomeEntries.isEmpty) pw.Text('-'),
          for (final entry in report.incomeEntries)
            _entryRow(
              entry.incomeName,
              _currency.format(entry.amount),
              entry.note,
            ),
          pw.SizedBox(height: 20),

          _sectionTitle('Expense Entry'),
          pw.SizedBox(height: 6),
          if (report.expenseEntries.isEmpty) pw.Text('-'),
          for (final entry in report.expenseEntries)
            _entryRow(
              entry.expenseName,
              _currency.format(entry.amount),
              entry.note,
            ),
          pw.SizedBox(height: 20),

          pw.Divider(),
          _kvRow(
            'Total Pemasukan',
            _currency.format(report.totalIncome),
            bold: true,
          ),
          _kvRow(
            'Total Pengeluaran',
            _currency.format(report.totalExpense),
            bold: true,
          ),
          _kvRow('Laba', _currency.format(report.profit), bold: true),
        ],
      ),
    );

    return doc;
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
    );
  }

  pw.Widget _kvRow(String label, String value, {bool bold = false}) {
    final style = bold
        ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
        : const pw.TextStyle();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(value, style: style),
        ],
      ),
    );
  }

  pw.Widget _entryRow(String label, String value, String note) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label),
              pw.Text(value),
            ],
          ),
          if (note.trim().isNotEmpty)
            pw.Text(
              note,
              style: pw.TextStyle(
                fontSize: 9,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey700,
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _productTable(DailyReportDetailEntity report) {
    if (report.productSummaries.isEmpty) {
      return pw.Text('-');
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _cell('Produk', bold: true),
            _cell('Jumlah', bold: true, alignRight: true),
            _cell('Jumlah Harga', bold: true, alignRight: true),
          ],
        ),
        for (final product in report.productSummaries)
          pw.TableRow(
            children: [
              _cell(product.productName),
              _cell('${product.quantity}', alignRight: true),
              _cell(_currency.format(product.amount), alignRight: true),
            ],
          ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false, bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: bold
            ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
            : const pw.TextStyle(),
      ),
    );
  }
}
