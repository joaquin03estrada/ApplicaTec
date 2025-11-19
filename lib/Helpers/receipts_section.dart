import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiptsSection extends StatelessWidget {
  final List<ReceiptNotice> notices;
  final List<Receipt> receipts;
  final VoidCallback onHistoryPressed;
  final bool isLoading;

  const ReceiptsSection({
    Key? key,
    required this.notices,
    required this.receipts,
    required this.onHistoryPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...notices.map((notice) => NoticeCard(notice: notice)),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: const Text(
                  'Recibos',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A365D),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  HistoryButton(onPressed: onHistoryPressed),
                  const SizedBox(height: 8.0),
                  FacturaButton(onPressed: () {}),
                ],
              ),
            ],
          ),
        ),

        // Loading, empty state o receipts cards
        if (isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: CircularProgressIndicator(
                color: Color(0xFF1A365D),
              ),
            ),
          )
        else if (receipts.isEmpty)
          Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'No hay recibos disponibles',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...receipts.map((receipt) => ReceiptCard(receipt: receipt)),
      ],
    );
  }
}

// Modelo para los avisos
class ReceiptNotice {
  final String message;
  final String? linkText;
  final String? linkUrl;

  const ReceiptNotice({required this.message, this.linkText, this.linkUrl});
}

// Tarjeta de aviso (info cards)
class NoticeCard extends StatelessWidget {
  final ReceiptNotice notice;

  const NoticeCard({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: Color(0xFF2A4365), size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF2A4365),
                ),
                children: [
                  TextSpan(text: notice.message),
                  if (notice.linkText != null)
                    TextSpan(
                      text: ' ${notice.linkText}',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Botón para ver historial
class HistoryButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HistoryButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.history, size: 18.0),
      label: const Text('VER HISTÓRICO'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A365D),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
    );
  }
}

class FacturaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  static final Uri _facturarUri = Uri.parse(
    'https://forms.office.com/pages/responsepage.aspx?id=zIGvrnIJG0eM2jeAB5Arr1ABC_QwzRxKkZBJbLMBH5JUQkFNREZRVVBVUzBNOTRXV1VDOExSVDVHMi4u',
  );

  const FacturaButton({Key? key, this.onPressed}) : super(key: key);

  Future<void> _openFactura(BuildContext context) async {
    try {
      final launched = await launchUrl(
        _facturarUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el enlace de facturación.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al intentar abrir el enlace.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await _openFactura(context);
        if (onPressed != null) onPressed!();
      },
      icon: const Icon(Icons.receipt_long, size: 18.0),
      label: const Text('FACTURAR'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A365D),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
    );
  }
}

// Modelo para los recibos
class Receipt {
  final String title;
  final DateTime issueDate;
  final DateTime dueDate;
  final double amount;
  final bool isPaid;

  const Receipt({
    required this.title,
    required this.issueDate,
    required this.dueDate,
    required this.amount,
    required this.isPaid,
  });
}

// Tarjeta de recibo
class ReceiptCard extends StatelessWidget {
  final Receipt receipt;

  const ReceiptCard({Key? key, required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
      decimalDigits: 2,
    );

    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Emisión: ${dateFormatter.format(receipt.issueDate)}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Vigencia: ${dateFormatter.format(receipt.dueDate)}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Text(
                  currencyFormatter.format(receipt.amount),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8.0),

          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48.0,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      receipt.isPaid
                          ? const Color(0xFFF5F7FA)
                          : const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color:
                        receipt.isPaid
                            ? Colors.transparent
                            : const Color(0xFFF2C6C6),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  receipt.isPaid ? 'CUBIERTO' : 'PENDIENTE',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color:
                        receipt.isPaid
                            ? const Color(0xFF9AA6B2)
                            : const Color(0xFFC53030),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}