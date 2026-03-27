import 'package:flutter/material.dart';

void main() {
  runApp(const ReceiptApp());
}

class ReceiptApp extends StatelessWidget {
  const ReceiptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Receipt App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB8542A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5EFE6),
        useMaterial3: true,
      ),
      home: const ReceiptPage(),
    );
  }
}

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final storeNameController = TextEditingController(text: 'Rumah Makan Nusantara');
  final customerNameController = TextEditingController(text: 'Meja 07');
  final cashierNameController = TextEditingController(text: 'Aldi');
  final taxController = TextEditingController(text: '10');
  final serviceController = TextEditingController(text: '5');
  final discountController = TextEditingController(text: '0');
  final amountPaidController = TextEditingController(text: '100000');

  late final TextEditingController transactionTimeController;
  final List<ReceiptItem> items = [
    ReceiptItem(name: 'Nasi Goreng', qty: 2, price: 18000),
    ReceiptItem(name: 'Es Teh Manis', qty: 2, price: 5000),
    ReceiptItem(name: 'Ayam Bakar', qty: 1, price: 25000),
  ];

  @override
  void initState() {
    super.initState();
    transactionTimeController = TextEditingController(text: formatNowForInput());
  }

  @override
  void dispose() {
    storeNameController.dispose();
    customerNameController.dispose();
    cashierNameController.dispose();
    taxController.dispose();
    serviceController.dispose();
    discountController.dispose();
    amountPaidController.dispose();
    transactionTimeController.dispose();

    for (final item in items) {
      item.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = calculateSummary();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 980;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHero(),
                      const SizedBox(height: 20),
                      isCompact
                          ? Column(
                              children: [
                                _buildFormCard(summary),
                                const SizedBox(height: 20),
                                _buildPreviewCard(summary),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 6, child: _buildFormCard(summary)),
                                const SizedBox(width: 20),
                                Expanded(flex: 5, child: _buildPreviewCard(summary)),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aplikasi Struk Rumah Makan',
            style: TextStyle(
              color: Color(0xFFB8542A),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Buat struk pembayaran dengan Flutter.',
            style: TextStyle(
              fontSize: 34,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: Color(0xFF211A16),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Isi data rumah makan, tambahkan menu yang dipesan, lalu lihat preview struk pembayaran secara langsung.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF6A5D54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(ReceiptSummary summary) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Data Struk',
            subtitle: 'Atur identitas toko dan detail transaksi.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _field(storeNameController, 'Nama rumah makan'),
              _field(customerNameController, 'No. meja / pelanggan'),
              _field(cashierNameController, 'Kasir'),
              _field(transactionTimeController, 'Tanggal transaksi'),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  title: 'Daftar Pesanan',
                  subtitle: 'Tambahkan atau hapus item menu.',
                ),
              ),
              FilledButton.tonal(
                onPressed: () {
                  setState(() {
                    items.add(ReceiptItem(name: '', qty: 1, price: 0));
                  });
                },
                child: const Text('+ Tambah Item'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ItemEditor(
                item: item,
                onChanged: () => setState(() {}),
                onDelete: items.length == 1
                    ? null
                    : () {
                        setState(() {
                          item.dispose();
                          items.removeAt(index);
                        });
                      },
              ),
            );
          }),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _field(taxController, 'Pajak (%)', number: true),
              _field(serviceController, 'Biaya servis (%)', number: true),
              _field(discountController, 'Diskon (Rp)', number: true),
              _field(amountPaidController, 'Uang bayar (Rp)', number: true),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: () => setState(() {}),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Text('Perbarui Struk'),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Project Flutter sudah siap. Untuk fitur cetak di Flutter web, kita bisa tambah package print pada langkah berikutnya.',
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Text('Cetak Struk'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SummaryChips(summary: summary),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(ReceiptSummary summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'Preview Struk',
            subtitle: 'Isi struk mengikuti data yang Anda masukkan.',
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAF2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x332D201A)),
            ),
            child: SelectableText(
              buildReceiptText(summary),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.7,
                color: Color(0xFF231C18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool number = false,
  }) {
    return SizedBox(
      width: 260,
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.78),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  ReceiptSummary calculateSummary() {
    final activeItems = items.where((item) => item.cleanedName.isNotEmpty).toList();
    final subtotal = activeItems.fold<int>(0, (sum, item) => sum + item.total);
    final tax = (subtotal * parseDouble(taxController.text) / 100).round();
    final service = (subtotal * parseDouble(serviceController.text) / 100).round();
    final discount = parseInt(discountController.text);
    final total = ((subtotal + tax + service - discount).clamp(0, 1 << 31) as num).toInt();
    final paid = parseInt(amountPaidController.text);
    final change = ((paid - total).clamp(0, 1 << 31) as num).toInt();

    return ReceiptSummary(
      items: activeItems,
      subtotal: subtotal,
      tax: tax,
      service: service,
      discount: discount,
      total: total,
      paid: paid,
      change: change,
    );
  }

  String buildReceiptText(ReceiptSummary summary) {
    final lines = <String>[
      nonEmpty(storeNameController.text, 'Rumah Makan'),
      '==================================',
      'Pelanggan : ${nonEmpty(customerNameController.text, '-')}',
      'Kasir     : ${nonEmpty(cashierNameController.text, '-')}',
      'Waktu     : ${formatDisplayDate(transactionTimeController.text)}',
      '----------------------------------',
    ];

    if (summary.items.isEmpty) {
      lines.add('Belum ada pesanan.');
    } else {
      for (final item in summary.items) {
        lines.add(item.cleanedName);
        lines.add(padLine('${item.qtyValue} x ${formatRupiah(item.priceValue)}', formatRupiah(item.total)));
      }
    }

    lines.add('----------------------------------');
    lines.add(padLine('Subtotal', formatRupiah(summary.subtotal)));
    lines.add(padLine('Pajak ${trimPercent(taxController.text)}%', formatRupiah(summary.tax)));
    lines.add(padLine('Servis ${trimPercent(serviceController.text)}%', formatRupiah(summary.service)));
    lines.add(padLine('Diskon', formatRupiah(summary.discount)));
    lines.add('==================================');
    lines.add(padLine('TOTAL', formatRupiah(summary.total)));
    lines.add(padLine('Bayar', formatRupiah(summary.paid)));
    lines.add(padLine('Kembali', formatRupiah(summary.change)));
    lines.add('==================================');
    lines.add('Terima kasih, selamat menikmati.');

    return lines.join('\n');
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF211A16),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6A5D54),
          ),
        ),
      ],
    );
  }
}

class _ItemEditor extends StatelessWidget {
  const _ItemEditor({
    required this.item,
    required this.onChanged,
    required this.onDelete,
  });

  final ReceiptItem item;
  final VoidCallback onChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x225C483B)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
            width: 240,
            child: TextField(
              controller: item.nameController,
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(
                labelText: 'Nama menu',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: TextField(
              controller: item.qtyController,
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(
                labelText: 'Qty',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: 160,
            child: TextField(
              controller: item.priceController,
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(
                labelText: 'Harga',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          FilledButton.tonal(
            onPressed: onDelete,
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _SummaryChips extends StatelessWidget {
  const _SummaryChips({required this.summary});

  final ReceiptSummary summary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _chip('Subtotal', formatRupiah(summary.subtotal)),
        _chip('Total', formatRupiah(summary.total)),
        _chip('Bayar', formatRupiah(summary.paid)),
        _chip('Kembali', formatRupiah(summary.change)),
      ],
    );
  }

  Widget _chip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x14B8542A),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF8D381B),
        ),
      ),
    );
  }
}

class ReceiptItem {
  ReceiptItem({
    required String name,
    required int qty,
    required int price,
  })  : nameController = TextEditingController(text: name),
        qtyController = TextEditingController(text: '$qty'),
        priceController = TextEditingController(text: '$price');

  final TextEditingController nameController;
  final TextEditingController qtyController;
  final TextEditingController priceController;

  String get cleanedName => nameController.text.trim();
  int get qtyValue => (parseInt(qtyController.text).clamp(0, 999999) as num).toInt();
  int get priceValue => (parseInt(priceController.text).clamp(0, 999999999) as num).toInt();
  int get total => qtyValue * priceValue;

  void dispose() {
    nameController.dispose();
    qtyController.dispose();
    priceController.dispose();
  }
}

class ReceiptSummary {
  const ReceiptSummary({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.service,
    required this.discount,
    required this.total,
    required this.paid,
    required this.change,
  });

  final List<ReceiptItem> items;
  final int subtotal;
  final int tax;
  final int service;
  final int discount;
  final int total;
  final int paid;
  final int change;
}

BoxDecoration cardDecoration() {
  return BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xF7FFF9F3), Color(0xEDFFF7EF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(28),
    boxShadow: const [
      BoxShadow(
        color: Color(0x29483018),
        blurRadius: 28,
        offset: Offset(0, 18),
      ),
    ],
    border: Border.all(color: const Color(0x40FFFFFF)),
  );
}

int parseInt(String text) => int.tryParse(text.trim()) ?? 0;

double parseDouble(String text) => double.tryParse(text.trim()) ?? 0;

String nonEmpty(String text, String fallback) {
  final value = text.trim();
  return value.isEmpty ? fallback : value;
}

String formatNowForInput() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute';
}

String formatDisplayDate(String text) {
  final normalized = text.trim().replaceFirst(' ', 'T');
  final parsed = DateTime.tryParse(normalized) ?? DateTime.now();
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  final day = parsed.day.toString().padLeft(2, '0');
  final month = months[parsed.month - 1];
  final year = parsed.year.toString();
  final hour = parsed.hour.toString().padLeft(2, '0');
  final minute = parsed.minute.toString().padLeft(2, '0');
  return '$day $month $year, $hour.$minute';
}

String trimPercent(String text) {
  final value = parseDouble(text);
  return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

String formatRupiah(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
  }

  return 'Rp $buffer';
}

String padLine(String left, String right, {int width = 34}) {
  final gap = (width - left.length - right.length).clamp(1, width);
  final spaces = List.filled(gap, ' ').join();
  return '$left$spaces$right';
}
