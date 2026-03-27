import 'dart:async';
import 'dart:convert';

import 'package:receipt_app/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DiRestoApp());
}

class DiRestoApp extends StatelessWidget {
  const DiRestoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DiResto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC62828),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F2EC),
        useMaterial3: true,
      ),
      home: const DiRestoShellPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 900;

                  return stacked
                      ? Column(
                          children: [
                            _buildBrandPanel(),
                            const SizedBox(height: 20),
                            _buildLoginPanel(),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(flex: 6, child: _buildBrandPanel()),
                            const SizedBox(width: 20),
                            Expanded(flex: 5, child: _buildLoginPanel()),
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: heroDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'DiResto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Pesan makanan favoritmu dengan tampilan modern dan cepat.',
            style: TextStyle(
              fontSize: 38,
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Masuk ke aplikasi untuk melihat promo bergerak, menu lengkap, dan proses pembayaran yang terhubung ke kasir.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFFFDE7E7),
            ),
          ),
          SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _LoginChip(label: 'Promo Banner'),
              _LoginChip(label: 'Menu Interaktif'),
              _LoginChip(label: 'Cashless & Kasir'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPanel() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Login / Sign Up',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF201814),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Konsumen dapat masuk menggunakan Gmail atau nomor handphone.',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF6E625A),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _finishLogin,
              icon: const Icon(Icons.mail_outline_rounded),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Masuk dengan Gmail'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('atau'),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Nomor handphone',
              hintText: '08xxxxxxxxxx',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.phone_android_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _finishLogin,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Lanjut dengan Nomor Handphone'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _finishLogin() {
    Navigator.of(context).pop(true);
  }
}

class CashierLoginPage extends StatefulWidget {
  const CashierLoginPage({super.key});

  @override
  State<CashierLoginPage> createState() => _CashierLoginPageState();
}

class _CashierLoginPageState extends State<CashierLoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login Kasir',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF201814),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Masukkan username dan password untuk membuka halaman kasir.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF6E625A),
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        errorText!,
                        style: const TextStyle(
                          color: Color(0xFFC62828),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Masuk ke Kasir'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Demo login: username `kasir` dan password `diresto123`.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B6C63),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username == 'kasir' && password == 'diresto123') {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      errorText = 'Username atau password kasir salah.';
    });
  }
}

class _LoginChip extends StatelessWidget {
  const _LoginChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DiRestoShellPage extends StatefulWidget {
  const DiRestoShellPage({super.key});

  @override
  State<DiRestoShellPage> createState() => _DiRestoShellPageState();
}

class _DiRestoShellPageState extends State<DiRestoShellPage> {
  final List<MenuProduct> menu = const [
    MenuProduct(
      id: 'm1',
      name: 'Nasi Goreng Spesial',
      price: 15000,
      description: 'Nasi goreng gurih favorit dengan bumbu spesial DiResto.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'm2',
      name: 'Mie Goreng',
      price: 12000,
      description: 'Mie goreng lezat dengan rasa manis gurih yang khas.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'm3',
      name: 'Ayam Goreng',
      price: 18000,
      description: 'Ayam goreng renyah dengan daging yang tetap juicy.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'm4',
      name: 'Ayam Bakar',
      price: 20000,
      description: 'Ayam bakar manis gurih dengan aroma bakaran yang kuat.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'm5',
      name: 'Sate Ayam',
      price: 22000,
      description: 'Sate ayam empuk dengan bumbu kacang gurih manis.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'm6',
      name: 'Bakso',
      price: 12000,
      description: 'Bakso hangat berkuah dengan cita rasa yang familiar.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'm7',
      name: 'Soto Ayam',
      price: 15000,
      description: 'Soto ayam segar dengan kuah gurih dan taburan pelengkap.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'm8',
      name: 'Nasi Uduk',
      price: 10000,
      description: 'Nasi uduk harum gurih cocok untuk sarapan atau makan santai.',
      category: 'Makanan',
    ),
    MenuProduct(
      id: 'd1',
      name: 'Es Teh',
      price: 5000,
      description: 'Minuman segar sederhana yang cocok untuk semua menu.',
      category: 'Minuman',
    ),
    MenuProduct(
      id: 'd2',
      name: 'Teh Hangat',
      price: 4000,
      description: 'Teh hangat klasik untuk menemani makanan utama.',
      category: 'Minuman',
    ),
    MenuProduct(
      id: 'd3',
      name: 'Es Jeruk',
      price: 7000,
      description: 'Es jeruk segar dengan rasa manis asam yang pas.',
      category: 'Minuman',
    ),
    MenuProduct(
      id: 'd4',
      name: 'Jeruk Hangat',
      price: 6000,
      description: 'Minuman hangat yang nyaman diminum kapan saja.',
      category: 'Minuman',
    ),
    MenuProduct(
      id: 'd5',
      name: 'Air Mineral',
      price: 4000,
      description: 'Pilihan minuman paling simpel dan menyegarkan.',
      category: 'Minuman',
    ),
  ];

  final List<BannerPromo> promos = const [
    BannerPromo(
      title: 'Hidangan Favorit DiResto',
      subtitle: 'Pilih menu makan harian seperti nasi goreng, mie goreng, dan ayam favorit.',
      accent: 'Menu makanan terlaris',
      backgroundColor: Color(0xFF7B2D26),
      foregroundColor: Colors.white,
      imagePath: 'assets/nasigoreng.png',
    ),
    BannerPromo(
      title: 'Segar Untuk Setiap Pesanan',
      subtitle: 'Lengkapi makanan dengan es teh, es jeruk, atau teh hangat pilihanmu.',
      accent: 'Minuman paling sering dipesan',
      backgroundColor: Color(0xFF4E342E),
      foregroundColor: Colors.white,
      imagePath: 'assets/eskopi.png',
    ),
    BannerPromo(
      title: 'Menu Lengkap Untuk Semua',
      subtitle: 'Dari bakso, soto ayam, sampai nasi uduk, semua bisa langsung masuk keranjang.',
      accent: 'Pilihan menu harian',
      backgroundColor: Color(0xFFB5651D),
      foregroundColor: Colors.white,
      imagePath: 'assets/migoreng.png',
    ),
  ];

  final Map<String, int> cart = {};
  final Map<String, int> cashierDraft = {};
  final List<CustomerOrder> orders = [];
  final ValueNotifier<int> orderSignal = ValueNotifier<int>(0);
  int _selectedTab = 0;
  int _orderCounter = 1;
  bool _isLoggedIn = false;
  bool _isCashierLoggedIn = false;
  bool _isCashierMode = false;

  @override
  void dispose() {
    orderSignal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = cart.values.fold<int>(0, (sum, qty) => sum + qty);
    final cashierDraftCount =
        cashierDraft.values.fold<int>(0, (sum, qty) => sum + qty);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(122),
        child: Material(
          color: Colors.white,
          elevation: 1,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0E3D9)),
                    ),
                  ),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _openCashierAccess,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          side: const BorderSide(color: Color(0xFFE2CFC0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.point_of_sale_outlined,
                          size: 16,
                          color: Color(0xFFC62828),
                        ),
                        label: Text(
                          _isCashierLoggedIn ? 'Kasir' : 'Masuk Kasir',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2A211D),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (!_isCashierMode)
                        InkWell(
                          onTap: _openLoginPage,
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            children: [
                              Icon(
                                _isLoggedIn ? Icons.person_outline : Icons.login_rounded,
                                color: const Color(0xFFC62828),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isLoggedIn ? 'Akun Saya' : 'Login/Sign Up',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2A211D),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC62828),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            'DiResto',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _TopNavButton(
                                label: 'HOME',
                                selected: _selectedTab == 0,
                                onTap: () => _switchTab(0),
                              ),
                              _TopNavButton(
                                label: 'MENU',
                                selected: _selectedTab == 1,
                                onTap: () => _switchTab(1),
                              ),
                              _TopNavButton(
                                label: _isCashierMode ? 'TRANSAKSI' : 'BRAND STORY',
                                selected: _selectedTab == 2,
                                onTap: () => _switchTab(2),
                              ),
                            ],
                          ),
                        ),
                        if (!_isCashierMode)
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE7D9CE)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: Color(0xFFC62828)),
                                SizedBox(width: 8),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deliver To',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7B6C63),
                                      ),
                                    ),
                                    Text(
                                      'Choose Address',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        FilledButton(
                          onPressed: _isCashierMode
                              ? _returnToConsumerMode
                              : (cartCount > 0 ? _openPaymentPage : () => _switchTab(1)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFC62828),
                            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                          ),
                          child: Text(
                            _isCashierMode
                                ? 'Kembali ke Konsumen'
                                : 'Order Now${cartCount > 0 ? ' ($cartCount)' : ''}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: _isCashierMode
            ? [
                ConsumerHomePage(
                  promos: promos,
                  featuredMenu: menu.take(3).toList(),
                  cart: cart,
                  lastOrder: orders.isEmpty ? null : orders.last,
                  onGoToMenu: () => _switchTab(1),
                  onAddToCart: _addToCart,
                ),
                CashierMenuPage(
                  menu: menu,
                  draft: cashierDraft,
                  onAddToDraft: _addToCashierDraft,
                  onCreateSuccessOrder: _createManualSuccessOrder,
                  onCreatePendingOrder: _createManualPendingOrder,
                ),
                CashierTransactionsPage(
                  orders: orders,
                  onConfirmOrder: _confirmCashierOrder,
                ),
              ]
            : [
                ConsumerHomePage(
                  promos: promos,
                  featuredMenu: menu.take(3).toList(),
                  cart: cart,
                  lastOrder: orders.isEmpty ? null : orders.last,
                  onGoToMenu: () => _switchTab(1),
                  onAddToCart: _addToCart,
                ),
                MenuPage(
                  menu: menu,
                  cart: cart,
                  onAddToCart: _addToCart,
                  onOpenPayment: _openPaymentPage,
                ),
                const BrandStoryPage(),
              ],
      ),
    );
  }

  void _switchTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  Future<void> _openLoginPage() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => const LoginPage(),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _isLoggedIn = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil. Selamat datang di DiResto.'),
        ),
      );
    }
  }

  Future<void> _openCashierAccess() async {
    if (_isCashierLoggedIn) {
      setState(() {
        _isCashierMode = true;
        _selectedTab = 2;
      });
      return;
    }

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => const CashierLoginPage(),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _isCashierLoggedIn = true;
        _isCashierMode = true;
        _selectedTab = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login kasir berhasil.'),
        ),
      );
    }
  }

  void _returnToConsumerMode() {
    setState(() {
      _isCashierMode = false;
      _selectedTab = 0;
    });
  }

  void _addToCart(MenuProduct product) {
    setState(() {
      cart.update(product.id, (qty) => qty + 1, ifAbsent: () => 1);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang.'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _addToCashierDraft(MenuProduct product) {
    setState(() {
      cashierDraft.update(product.id, (qty) => qty + 1, ifAbsent: () => 1);
    });
  }

  void _openPaymentPage() {
    if (cart.isEmpty) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PaymentPage(
          entries: _buildCartEntries(),
          taxPercent: 10,
          onSubmitCashless: _submitCashlessOrder,
          onSubmitCashier: _submitCashierOrder,
        ),
      ),
    );
  }

  List<CartEntry> _buildCartEntries() {
    return cart.entries
        .map((entry) {
          final product = menu.firstWhere((item) => item.id == entry.key);
          return CartEntry(product: product, quantity: entry.value);
        })
        .where((entry) => entry.quantity > 0)
        .toList();
  }

  void _submitCashlessOrder(
    List<CartEntry> entries,
    CashlessMethod method, {
    EWalletProvider? eWalletProvider,
  }) {
    final order = _createOrder(
      entries: entries,
      paymentMode: PaymentMode.cashless,
      cashlessMethod: method,
      eWalletProvider: eWalletProvider,
      status: OrderStatus.success,
    );

    setState(() {
      orders.add(order);
      cart.clear();
    });
    orderSignal.value++;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => SuccessPage(order: order),
      ),
    );
  }

  void _submitCashierOrder(List<CartEntry> entries) {
    final order = _createOrder(
      entries: entries,
      paymentMode: PaymentMode.cashier,
      status: OrderStatus.waitingCashierConfirmation,
    );

    setState(() {
      orders.add(order);
      cart.clear();
      _selectedTab = 0;
    });
    orderSignal.value++;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => CashierWaitingPage(
          orderId: order.id,
          orderSignal: orderSignal,
          getOrderById: _getOrderById,
        ),
      ),
    );
  }

  void _createManualSuccessOrder() {
    final entries = _buildCashierDraftEntries();
    if (entries.isEmpty) {
      return;
    }

    final order = _createOrder(
      entries: entries,
      paymentMode: PaymentMode.cashless,
      cashlessMethod: CashlessMethod.qris,
      eWalletProvider: null,
      status: OrderStatus.success,
    );

    setState(() {
      orders.add(order);
      cashierDraft.clear();
      _selectedTab = 2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pesanan manual ${order.id} disimpan sebagai transaksi berhasil.')),
    );
  }

  void _createManualPendingOrder() {
    final entries = _buildCashierDraftEntries();
    if (entries.isEmpty) {
      return;
    }

    final order = _createOrder(
      entries: entries,
      paymentMode: PaymentMode.cashier,
      status: OrderStatus.waitingCashierConfirmation,
    );

    setState(() {
      orders.add(order);
      cashierDraft.clear();
      _selectedTab = 2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pesanan manual ${order.id} masuk ke daftar ACC kasir.')),
    );
  }

  CustomerOrder _createOrder({
    required List<CartEntry> entries,
    required PaymentMode paymentMode,
    required OrderStatus status,
    CashlessMethod? cashlessMethod,
    EWalletProvider? eWalletProvider,
  }) {
    final subtotal = entries.fold<int>(0, (sum, entry) => sum + entry.totalPrice);
    final tax = (subtotal * 0.1).round();
    final total = subtotal + tax;

    final order = CustomerOrder(
      id: 'DR-${_orderCounter.toString().padLeft(3, '0')}',
      items: entries
          .map(
            (entry) => OrderedItem(
              productName: entry.product.name,
              quantity: entry.quantity,
              price: entry.product.price,
            ),
          )
          .toList(),
      subtotal: subtotal,
      tax: tax,
      total: total,
      paymentMode: paymentMode,
      cashlessMethod: cashlessMethod,
      eWalletProvider: eWalletProvider,
      status: status,
      createdAt: DateTime.now(),
    );

    _orderCounter++;
    return order;
  }

  List<CartEntry> _buildCashierDraftEntries() {
    return cashierDraft.entries
        .map((entry) {
          final product = menu.firstWhere((item) => item.id == entry.key);
          return CartEntry(product: product, quantity: entry.value);
        })
        .where((entry) => entry.quantity > 0)
        .toList();
  }

  CustomerOrder? _getOrderById(String orderId) {
    for (final order in orders) {
      if (order.id == orderId) {
        return order;
      }
    }
    return null;
  }

  void _confirmCashierOrder(String orderId) {
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      return;
    }

    setState(() {
      orders[index] = orders[index].copyWith(status: OrderStatus.success);
    });
    orderSignal.value++;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pesanan $orderId berhasil dikonfirmasi kasir.')),
    );
  }
}

class ConsumerHomePage extends StatelessWidget {
  const ConsumerHomePage({
    super.key,
    required this.promos,
    required this.featuredMenu,
    required this.cart,
    required this.lastOrder,
    required this.onGoToMenu,
    required this.onAddToCart,
  });

  final List<BannerPromo> promos;
  final List<MenuProduct> featuredMenu;
  final Map<String, int> cart;
  final CustomerOrder? lastOrder;
  final VoidCallback onGoToMenu;
  final ValueChanged<MenuProduct> onAddToCart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroBannerCarousel(promos: promos, onGoToMenu: onGoToMenu),
                Transform.translate(
                  offset: const Offset(0, -34),
                  child: Row(
                    children: const [
                      Expanded(child: _QuickActionCard(icon: Icons.delivery_dining, title: 'Delivery')),
                      SizedBox(width: 18),
                      Expanded(child: _QuickActionCard(icon: Icons.shopping_bag_outlined, title: 'Takeaway')),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(
                        title: 'Pilihan Populer',
                        subtitle: 'Menu unggulan yang sering dipilih konsumen DiResto.',
                      ),
                      const SizedBox(height: 18),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final stacked = constraints.maxWidth < 900;
                          return stacked
                              ? Column(
                                  children: featuredMenu
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.only(bottom: 14),
                                          child: _FeaturedMenuTile(
                                            item: item,
                                            quantity: cart[item.id] ?? 0,
                                            onAdd: () => onAddToCart(item),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : Row(
                                  children: featuredMenu
                                      .map(
                                        (item) => Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: item == featuredMenu.last ? 0 : 14,
                                            ),
                                            child: _FeaturedMenuTile(
                                              item: item,
                                              quantity: cart[item.id] ?? 0,
                                              onAdd: () => onAddToCart(item),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: cardDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastOrder == null
                              ? 'Lanjut ke halaman menu untuk melihat semua makanan dan minuman DiResto.'
                              : 'Pesanan terakhir ${lastOrder!.id} berstatus ${lastOrder!.statusLabel}.',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF6E625A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      FilledButton(
                        onPressed: onGoToMenu,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                        ),
                        child: const Text('Lihat Semua Menu'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({
    super.key,
    required this.promos,
    required this.onGoToMenu,
  });

  final List<BannerPromo> promos;
  final VoidCallback onGoToMenu;

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients || widget.promos.isEmpty) {
        return;
      }

      final next = (_index + 1) % widget.promos.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.promos.length,
            onPageChanged: (value) {
              setState(() {
                _index = value;
              });
            },
            itemBuilder: (context, index) {
              final promo = widget.promos[index];
              return Container(
                padding: const EdgeInsets.all(34),
                decoration: BoxDecoration(
                  color: promo.backgroundColor,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 860;

                    return stacked
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPromoCopy(promo),
                              const Spacer(),
                              _buildPromoVisual(promo),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(flex: 5, child: _buildPromoCopy(promo)),
                              const SizedBox(width: 20),
                              Expanded(flex: 4, child: _buildPromoVisual(promo)),
                            ],
                          );
                  },
                ),
              );
            },
          ),
          Positioned(
            left: 30,
            bottom: 28,
            child: Row(
              children: List.generate(
                widget.promos.length,
                (dotIndex) => Container(
                  width: _index == dotIndex ? 28 : 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _index == dotIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCopy(BannerPromo promo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'PROMO DIRESTO',
          style: TextStyle(
            color: promo.foregroundColor.withOpacity(0.92),
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          promo.title,
          style: TextStyle(
            fontSize: 54,
            height: 0.94,
            fontWeight: FontWeight.w900,
            color: promo.foregroundColor,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            promo.accent,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFFC62828),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          promo.subtitle,
          style: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: promo.foregroundColor.withOpacity(0.95),
          ),
        ),
        const SizedBox(height: 26),
        FilledButton(
          onPressed: widget.onGoToMenu,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: promo.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          ),
          child: const Text(
            'Lanjut ke Menu',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoVisual(BannerPromo promo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 360,
          height: 360,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.14),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            promo.imagePath,
            width: 320,
            height: 320,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({
    super.key,
    required this.menu,
    required this.cart,
    required this.onAddToCart,
    required this.onOpenPayment,
  });

  final List<MenuProduct> menu;
  final Map<String, int> cart;
  final ValueChanged<MenuProduct> onAddToCart;
  final VoidCallback onOpenPayment;

  @override
  Widget build(BuildContext context) {
    final totalItems = cart.values.fold<int>(0, (sum, qty) => sum + qty);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: heroDecoration(),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Menu DiResto\nPilihan makanan dan minuman terbaik untukmu.',
                          style: TextStyle(
                            fontSize: 34,
                            height: 1.15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (totalItems > 0)
                        FilledButton.icon(
                          onPressed: onOpenPayment,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFC62828),
                          ),
                          icon: const Icon(Icons.shopping_cart_checkout),
                          label: Text('Pembayaran ($totalItems)'),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  itemCount: menu.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.86,
                  ),
                  itemBuilder: (context, index) {
                    final product = menu[index];
                    return _MenuCard(
                      product: product,
                      quantity: cart[product.id] ?? 0,
                      onAdd: () => onAddToCart(product),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrandStoryPage extends StatelessWidget {
  const BrandStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: _Panel(
              title: 'Brand Story DiResto',
              subtitle: 'Cerita singkat tentang pengalaman makan yang cepat, hangat, dan mudah diakses.',
              child: const Text(
                'DiResto dirancang sebagai pengalaman pesan makanan yang sederhana. Konsumen bisa melihat promo utama di home, memilih menu favorit, lalu menyelesaikan pembayaran secara cashless atau lewat kasir. Di sisi operasional, kasir juga bisa mencatat pesanan manual dan mengelola transaksi yang perlu di-ACC.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: Color(0xFF6E625A),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CashierMenuPage extends StatelessWidget {
  const CashierMenuPage({
    super.key,
    required this.menu,
    required this.draft,
    required this.onAddToDraft,
    required this.onCreateSuccessOrder,
    required this.onCreatePendingOrder,
  });

  final List<MenuProduct> menu;
  final Map<String, int> draft;
  final ValueChanged<MenuProduct> onAddToDraft;
  final VoidCallback onCreateSuccessOrder;
  final VoidCallback onCreatePendingOrder;

  @override
  Widget build(BuildContext context) {
    final draftEntries = draft.entries
        .map((entry) {
          final product = menu.firstWhere((item) => item.id == entry.key);
          return CartEntry(product: product, quantity: entry.value);
        })
        .where((entry) => entry.quantity > 0)
        .toList();
    final total = draftEntries.fold<int>(0, (sum, entry) => sum + entry.totalPrice);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _Panel(
                  title: 'Input Pesanan Konsumen',
                  subtitle: 'Kasir dapat menambahkan pesanan manual lalu menyimpannya sebagai transaksi berhasil atau pesanan yang menunggu ACC.',
                  child: GridView.builder(
                    itemCount: menu.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 320,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.05,
                    ),
                    itemBuilder: (context, index) {
                      final item = menu[index];
                      final qty = draft[item.id] ?? 0;

                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFE8D8CB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.category,
                              style: const TextStyle(
                                color: Color(0xFFC62828),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF221B17),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Color(0xFF6E625A),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatRupiah(item.price),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFC62828),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () => onAddToDraft(item),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFFC62828),
                                    ),
                                    child: const Text('Tambah'),
                                  ),
                                ),
                                if (qty > 0) ...[
                                  const SizedBox(width: 10),
                                  _QuantityPill(quantity: qty),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _Panel(
                  title: 'Ringkasan Pesanan Manual',
                  subtitle: 'Tinjau item yang sudah dipilih sebelum dikirim ke transaksi.',
                  child: Column(
                    children: [
                      if (draftEntries.isEmpty)
                        const _EmptyState(
                          message: 'Belum ada item di pesanan manual kasir.',
                        )
                      else
                        ...draftEntries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${entry.product.name} x${entry.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text(formatRupiah(entry.totalPrice)),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            formatRupiah(total),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFC62828),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: draftEntries.isEmpty ? null : onCreatePendingOrder,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text('Simpan ke ACC Kasir'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: FilledButton(
                              onPressed: draftEntries.isEmpty ? null : onCreateSuccessOrder,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFC62828),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text('Simpan Transaksi Berhasil'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopNavButton extends StatelessWidget {
  const _TopNavButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: selected ? const Color(0xFFC62828) : const Color(0xFF221B17),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFFCEAEA),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: const Color(0xFFC62828), size: 34),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF221B17),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedMenuTile extends StatelessWidget {
  const _FeaturedMenuTile({
    required this.item,
    required this.quantity,
    required this.onAdd,
  });

  final MenuProduct item;
  final int quantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D8CB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.category,
            style: const TextStyle(
              color: Color(0xFFC62828),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF221B17),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.description,
            style: const TextStyle(
              height: 1.5,
              color: Color(0xFF6E625A),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            formatRupiah(item.price),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFFC62828),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                  ),
                  child: const Text('Tambah ke Keranjang'),
                ),
              ),
              if (quantity > 0) ...[
                const SizedBox(width: 10),
                _QuantityPill(quantity: quantity),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.product,
    required this.quantity,
    required this.onAdd,
  });

  final MenuProduct product;
  final int quantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE8D8CB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFCEAEA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              product.category,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFFC62828),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF221B17),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.description,
            style: const TextStyle(
              height: 1.5,
              color: Color(0xFF6E625A),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 16),
          Text(
            formatRupiah(product.price),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFFC62828),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC62828),
                  ),
                  child: const Text('Tambah ke Keranjang'),
                ),
              ),
              if (quantity > 0) ...[
                const SizedBox(width: 10),
                _QuantityPill(quantity: quantity),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityPill extends StatelessWidget {
  const _QuantityPill({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF221B17),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$quantity',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.entries,
    required this.taxPercent,
    required this.onSubmitCashless,
    required this.onSubmitCashier,
  });

  final List<CartEntry> entries;
  final int taxPercent;
  final void Function(
    List<CartEntry> entries,
    CashlessMethod method, {
    EWalletProvider? eWalletProvider,
  })
      onSubmitCashless;
  final ValueChanged<List<CartEntry>> onSubmitCashier;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static int _paymentCounter = 1;

  PaymentMode _paymentMode = PaymentMode.cashless;
  CashlessMethod _cashlessMethod = CashlessMethod.qris;
  EWalletProvider _eWalletProvider = EWalletProvider.shopeepay;
  VABank _vaBank = VABank.bca;
  bool _isProcessingPayment = false;
  final PaymentApiService _paymentApi = const PaymentApiService();
  PaymentSession? _paymentSession;
  String? _paymentError;

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.entries.fold<int>(0, (sum, entry) => sum + entry.totalPrice);
    final tax = (subtotal * widget.taxPercent / 100).round();
    final total = subtotal + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                children: [
                  _Panel(
                    title: 'Ringkasan Pesanan',
                    subtitle: 'Cek kembali menu, harga, dan total pembayaran.',
                    child: Column(
                      children: [
                        ...widget.entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${entry.product.name} x${entry.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text(formatRupiah(entry.totalPrice)),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 30),
                        _summaryRow('Subtotal', formatRupiah(subtotal)),
                        const SizedBox(height: 8),
                        _summaryRow('Pajak ${widget.taxPercent}%', formatRupiah(tax)),
                        const SizedBox(height: 8),
                        _summaryRow('Total Bayar', formatRupiah(total), emphasized: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _Panel(
                    title: 'Metode Pembayaran',
                    subtitle: 'Pilih metode pembayaran seperti daftar checkout aplikasi.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PILIH METODE',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8A7A70),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildMethodTile(
                          icon: Icons.qr_code_2_rounded,
                          title: 'QRIS',
                          subtitle: 'Scan QR untuk pembayaran instan',
                          selected:
                              _paymentMode == PaymentMode.cashless &&
                              _cashlessMethod == CashlessMethod.qris,
                          onTap: () {
                            setState(() {
                              _paymentMode = PaymentMode.cashless;
                              _cashlessMethod = CashlessMethod.qris;
                            });
                          },
                        ),
                        _buildMethodTile(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'E-Wallet',
                          subtitle: _eWalletProvider.label,
                          selected:
                              _paymentMode == PaymentMode.cashless &&
                              _cashlessMethod == CashlessMethod.eWallet,
                          onTap: () {
                            setState(() {
                              _paymentMode = PaymentMode.cashless;
                              _cashlessMethod = CashlessMethod.eWallet;
                            });
                          },
                        ),
                        if (_paymentMode == PaymentMode.cashless &&
                            _cashlessMethod == CashlessMethod.eWallet)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: EWalletProvider.values.map((provider) {
                                final selected = _eWalletProvider == provider;
                                return ChoiceChip(
                                  label: Text(provider.label),
                                  selected: selected,
                                  onSelected: (_) {
                                    setState(() {
                                      _eWalletProvider = provider;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        _buildMethodTile(
                          icon: Icons.account_balance_outlined,
                          title: 'Transfer VA',
                          subtitle: '${_vaBank.label} Virtual Account',
                          selected:
                              _paymentMode == PaymentMode.cashless &&
                              _cashlessMethod == CashlessMethod.transferVa,
                          onTap: () {
                            setState(() {
                              _paymentMode = PaymentMode.cashless;
                              _cashlessMethod = CashlessMethod.transferVa;
                            });
                          },
                        ),
                        if (_paymentMode == PaymentMode.cashless &&
                            _cashlessMethod == CashlessMethod.transferVa)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: VABank.values.map((bank) {
                                return ChoiceChip(
                                  label: Text(bank.label),
                                  selected: _vaBank == bank,
                                  onSelected: (_) {
                                    setState(() {
                                      _vaBank = bank;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        _buildMethodTile(
                          icon: Icons.store_mall_directory_outlined,
                          title: 'Bayar di Kasir',
                          subtitle: 'Konfirmasi oleh kasir di tempat',
                          selected: _paymentMode == PaymentMode.cashier,
                          onTap: () {
                            setState(() {
                              _paymentMode = PaymentMode.cashier;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_paymentMode == PaymentMode.cashless)
                          _buildCashlessPaymentDetail(total)
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE9E9),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Text(
                              'Pesanan akan menunggu konfirmasi dari kasir. Setelah kasir menekan tombol konfirmasi, transaksi konsumen akan berubah menjadi berhasil.',
                              style: TextStyle(
                                height: 1.6,
                                color: Color(0xFF6E625A),
                              ),
                            ),
                          ),
                        if (_paymentSession != null) ...[
                          const SizedBox(height: 16),
                          _buildBackendSessionPanel(),
                        ],
                        if (_paymentError != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            _paymentError!,
                            style: const TextStyle(
                              color: Color(0xFFC62828),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isProcessingPayment
                                ? null
                                : () => _handlePaymentAction(total),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                _isProcessingPayment
                                    ? 'Memproses Pembayaran...'
                                    : _paymentMode == PaymentMode.cashless
                                        ? _cashlessMethod.buttonLabel
                                        : 'Lanjut Bayar di Kasir',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCashlessPaymentDetail(int total) {
    if (_cashlessMethod == CashlessMethod.qris) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7D9CE)),
        ),
        child: Row(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE0D5CB)),
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_2_rounded,
                  size: 70,
                  color: Color(0xFF221B17),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Scan QRIS untuk membayar ${formatRupiah(total)}. Setelah scan berhasil, tekan tombol pembayaran untuk menyelesaikan transaksi.',
                style: const TextStyle(
                  height: 1.6,
                  color: Color(0xFF6E625A),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_cashlessMethod == CashlessMethod.eWallet) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7D9CE)),
        ),
        child: Text(
          'Metode E-Wallet aktif melalui ${_eWalletProvider.label}. User akan membayar sebesar ${formatRupiah(total)} lewat aplikasi wallet yang dipilih.',
          style: const TextStyle(
            height: 1.6,
            color: Color(0xFF6E625A),
          ),
        ),
      );
    }

    if (_cashlessMethod == CashlessMethod.transferVa) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7D9CE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nomor Virtual Account',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF221B17),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _buildVirtualAccountNumber(total),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Transfer tepat sebesar ${formatRupiah(total)} ke ${_vaBank.label} Virtual Account di atas lalu lanjutkan pembayaran.',
              style: const TextStyle(
                height: 1.6,
                color: Color(0xFF6E625A),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7D9CE)),
      ),
      child: Text(
        'Metode ${_cashlessMethod.label} siap digunakan untuk membayar total ${formatRupiah(total)}. Tekan tombol pembayaran untuk memproses transaksi.',
        style: const TextStyle(
          height: 1.6,
          color: Color(0xFF6E625A),
        ),
      ),
    );
  }

  Widget _buildMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFCEAEA) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFC62828) : const Color(0xFFE7D9CE),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFC62828)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF221B17),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B6C63),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.chevron_right_rounded,
              color: selected ? const Color(0xFFC62828) : const Color(0xFF8B7B70),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePaymentAction(int total) async {
    if (_paymentMode == PaymentMode.cashier) {
      widget.onSubmitCashier(widget.entries);
      return;
    }

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Konfirmasi ${_cashlessMethod.label}'),
            content: Text(_cashlessMethod.confirmationMessage(total)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                ),
                child: const Text('Bayar'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _isProcessingPayment = true;
      _paymentError = null;
    });

    try {
      final orderId = 'WEB-${_paymentCounter.toString().padLeft(4, '0')}';
      _paymentCounter++;

      final session = await _paymentApi.createPayment(
        orderId: orderId,
        amount: total,
        entries: widget.entries,
        paymentMode: _paymentMode,
        cashlessMethod: _cashlessMethod,
        eWalletProvider:
            _cashlessMethod == CashlessMethod.eWallet ? _eWalletProvider : null,
        vaBank: _cashlessMethod == CashlessMethod.transferVa ? _vaBank : null,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _paymentSession = session;
      });

      await Future<void>.delayed(const Duration(milliseconds: 1200));
      await _paymentApi.simulatePaid(orderId);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isProcessingPayment = false;
        _paymentError =
            'Backend pembayaran belum terhubung. Pastikan server backend berjalan di localhost:8080.';
      });
      return;
    }

    if (!mounted) {
      return;
    }

    widget.onSubmitCashless(
      widget.entries,
      _cashlessMethod,
      eWalletProvider:
          _cashlessMethod == CashlessMethod.eWallet ? _eWalletProvider : null,
    );
  }

  Widget _buildBackendSessionPanel() {
    final instructions = _paymentSession!.instructions;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6D8CB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session Backend: ${_paymentSession!.orderId}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF221B17),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${_paymentSession!.status}',
            style: const TextStyle(color: Color(0xFF6E625A)),
          ),
          if (instructions['vaNumber'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'VA: ${instructions['vaNumber']}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (instructions['accountReference'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Ref: ${instructions['accountReference']}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildVirtualAccountNumber(int total) {
    final normalized = total.toString().padLeft(8, '0');
    return '${_vaBank.code} ${normalized.substring(normalized.length - 8)}';
  }

  Widget _summaryRow(String label, String value, {bool emphasized = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: emphasized ? FontWeight.w900 : FontWeight.w600,
              fontSize: emphasized ? 18 : 15,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
            fontSize: emphasized ? 18 : 15,
            color: emphasized ? const Color(0xFFC62828) : null,
          ),
        ),
      ],
    );
  }
}

class CashierWaitingPage extends StatelessWidget {
  const CashierWaitingPage({
    super.key,
    required this.orderId,
    required this.orderSignal,
    required this.getOrderById,
  });

  final String orderId;
  final ValueNotifier<int> orderSignal;
  final CustomerOrder? Function(String orderId) getOrderById;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: orderSignal,
      builder: (context, _, __) {
        final order = getOrderById(orderId);
        if (order == null) {
          return const Scaffold(body: Center(child: Text('Pesanan tidak ditemukan.')));
        }
        if (order.status == OrderStatus.success) {
          return SuccessPage(order: order);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Menunggu Konfirmasi Kasir'),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: cardDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.hourglass_top_rounded,
                          color: Color(0xFFC62828),
                          size: 74,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Pesanan $orderId sedang menunggu kasir',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF221B17),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Silakan lakukan pembayaran di meja kasir. Halaman ini akan berubah otomatis ketika pembayaran sudah dikonfirmasi.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF6E625A),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Total: ${formatRupiah(order.total)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.order});

  final CustomerOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Berhasil'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: cardDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 76,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pesanan ${order.id} berhasil diproses',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF221B17),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      order.paymentDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF6E625A),
                      ),
                    ),
                    const SizedBox(height: 22),
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text('${item.productName} x${item.quantity}')),
                            Text(formatRupiah(item.total)),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 28),
                    _doneRow('Subtotal', formatRupiah(order.subtotal)),
                    const SizedBox(height: 8),
                    _doneRow('Pajak', formatRupiah(order.tax)),
                    const SizedBox(height: 8),
                    _doneRow('Total', formatRupiah(order.total), emphasized: true),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Kembali ke Beranda'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _doneRow(String label, String value, {bool emphasized = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: emphasized ? FontWeight.w900 : FontWeight.w600,
              fontSize: emphasized ? 18 : 15,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: emphasized ? FontWeight.w900 : FontWeight.w700,
            fontSize: emphasized ? 18 : 15,
          ),
        ),
      ],
    );
  }
}

class CashierTransactionsPage extends StatelessWidget {
  const CashierTransactionsPage({
    super.key,
    required this.orders,
    required this.onConfirmOrder,
  });

  final List<CustomerOrder> orders;
  final ValueChanged<String> onConfirmOrder;

  @override
  Widget build(BuildContext context) {
    final pendingOrders = orders
        .where(
          (order) =>
              order.paymentMode == PaymentMode.cashier &&
              order.status == OrderStatus.waitingCashierConfirmation,
        )
        .toList();
    final finishedOrders =
        orders.where((order) => order.status == OrderStatus.success).toList().reversed.toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: _Panel(
              title: 'Transaksi Kasir',
              subtitle: 'Sisi kiri berisi history transaksi berhasil. Sisi kanan berisi pesanan bayar di kasir yang menunggu ACC.',
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 900) {
                    return Column(
                      children: [
                        _buildSuccessColumn(finishedOrders),
                        const SizedBox(height: 20),
                        _buildPendingColumn(pendingOrders),
                      ],
                    );
                  }

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildSuccessColumn(finishedOrders)),
                        const VerticalDivider(
                          width: 32,
                          thickness: 1,
                          color: Color(0xFFE3D4C7),
                        ),
                        Expanded(child: _buildPendingColumn(pendingOrders)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessColumn(List<CustomerOrder> finishedOrders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History Transaksi Berhasil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF221B17),
          ),
        ),
        const SizedBox(height: 14),
        if (finishedOrders.isEmpty)
          const _EmptyState(message: 'Belum ada transaksi berhasil.')
        else
          ...finishedOrders.take(8).map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _CashierOrderCard(
                    order: order,
                    actionLabel: 'Selesai',
                    onPressed: null,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildPendingColumn(List<CustomerOrder> pendingOrders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bayar di Kasir Menunggu ACC',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF221B17),
          ),
        ),
        const SizedBox(height: 14),
        if (pendingOrders.isEmpty)
          const _EmptyState(message: 'Belum ada pesanan yang menunggu ACC kasir.')
        else
          ...pendingOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _CashierOrderCard(
                    order: order,
                    actionLabel: 'ACC Pembayaran',
                    onPressed: () => onConfirmOrder(order.id),
                  ),
                ),
              ),
      ],
    );
  }
}

class _CashierOrderCard extends StatelessWidget {
  const _CashierOrderCard({
    required this.order,
    required this.actionLabel,
    required this.onPressed,
  });

  final CustomerOrder order;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8D8CB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE9E9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  order.statusLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFC62828),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.itemsSummary,
            style: const TextStyle(
              height: 1.5,
              color: Color(0xFF6E625A),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total ${formatRupiah(order.total)}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              FilledButton.tonal(
                onPressed: onPressed,
                child: Text(actionLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: title, subtitle: subtitle),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D8CB)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          height: 1.5,
          color: Color(0xFF6E625A),
        ),
      ),
    );
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
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF221B17),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Color(0xFF6E625A),
          ),
        ),
      ],
    );
  }
}

class BannerPromo {
  const BannerPromo({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String accent;
  final Color backgroundColor;
  final Color foregroundColor;
  final String imagePath;
}

class MenuProduct {
  const MenuProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  final String id;
  final String name;
  final int price;
  final String description;
  final String category;
}

class CartEntry {
  const CartEntry({
    required this.product,
    required this.quantity,
  });

  final MenuProduct product;
  final int quantity;

  int get totalPrice => product.price * quantity;
}

class OrderedItem {
  const OrderedItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  final String productName;
  final int quantity;
  final int price;

  int get total => quantity * price;
}

class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMode,
    required this.cashlessMethod,
    required this.eWalletProvider,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final List<OrderedItem> items;
  final int subtotal;
  final int tax;
  final int total;
  final PaymentMode paymentMode;
  final CashlessMethod? cashlessMethod;
  final EWalletProvider? eWalletProvider;
  final OrderStatus status;
  final DateTime createdAt;

  String get statusLabel {
    switch (status) {
      case OrderStatus.waitingCashierConfirmation:
        return 'Menunggu Kasir';
      case OrderStatus.success:
        return 'Berhasil';
    }
  }

  String get paymentDescription {
    if (paymentMode == PaymentMode.cashless && cashlessMethod != null) {
      if (cashlessMethod == CashlessMethod.eWallet && eWalletProvider != null) {
        return 'Pembayaran cashless berhasil melalui E-Wallet ${eWalletProvider!.label}.';
      }
      return 'Pembayaran cashless berhasil melalui ${cashlessMethod!.label}.';
    }
    return 'Pembayaran di kasir sudah dikonfirmasi dan transaksi berhasil.';
  }

  String get itemsSummary {
    return items.map((item) => '${item.productName} x${item.quantity}').join(', ');
  }

  CustomerOrder copyWith({OrderStatus? status}) {
    return CustomerOrder(
      id: id,
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      paymentMode: paymentMode,
      cashlessMethod: cashlessMethod,
      eWalletProvider: eWalletProvider,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

enum PaymentMode {
  cashless,
  cashier,
}

enum OrderStatus {
  waitingCashierConfirmation,
  success,
}

enum CashlessMethod {
  qris('QRIS'),
  eWallet('E-Wallet'),
  transferVa('Transfer VA');

  const CashlessMethod(this.label);

  final String label;
}

enum EWalletProvider {
  shopeepay('ShopeePay'),
  gopay('GoPay'),
  dana('DANA');

  const EWalletProvider(this.label);

  final String label;
}

enum VABank {
  bca('BCA', '8808 014'),
  bni('BNI', '8808 009'),
  bri('BRI', '8808 002');

  const VABank(this.label, this.code);

  final String label;
  final String code;
}

extension CashlessMethodPresentation on CashlessMethod {
  String get buttonLabel {
    switch (this) {
      case CashlessMethod.qris:
        return 'Bayar dengan QRIS';
      case CashlessMethod.eWallet:
        return 'Konfirmasi E-Wallet';
      case CashlessMethod.transferVa:
        return 'Konfirmasi Transfer VA';
    }
  }

  String confirmationMessage(int total) {
    switch (this) {
      case CashlessMethod.qris:
        return 'Pastikan QRIS sudah discan untuk pembayaran ${formatRupiah(total)}.';
      case CashlessMethod.eWallet:
        return 'Pastikan pembayaran E-Wallet sebesar ${formatRupiah(total)} sudah dilakukan.';
      case CashlessMethod.transferVa:
        return 'Apakah transfer virtual account sebesar ${formatRupiah(total)} sudah dilakukan?';
    }
  }
}

class PaymentApiService {
  const PaymentApiService();

  static const String baseUrl = AppConfig.apiBaseUrl;

  Future<PaymentSession> createPayment({
    required String orderId,
    required int amount,
    required List<CartEntry> entries,
    required PaymentMode paymentMode,
    required CashlessMethod? cashlessMethod,
    required EWalletProvider? eWalletProvider,
    required VABank? vaBank,
  }) async {
    final paymentMethod = switch (paymentMode) {
      PaymentMode.cashier => 'cashier',
      PaymentMode.cashless when cashlessMethod == CashlessMethod.qris => 'qris',
      PaymentMode.cashless when cashlessMethod == CashlessMethod.eWallet => 'e_wallet',
      _ => 'transfer_va',
    };

    final provider = switch (cashlessMethod) {
      CashlessMethod.eWallet => eWalletProvider?.name,
      CashlessMethod.transferVa => vaBank?.name,
      _ => null,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/payments/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderId': orderId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'provider': provider,
        'items': entries
            .map(
              (entry) => {
                'name': entry.product.name,
                'qty': entry.quantity,
                'price': entry.product.price,
              },
            )
            .toList(),
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal membuat payment session ke backend.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final payment = data['payment'] as Map<String, dynamic>;
    return PaymentSession.fromJson(payment);
  }

  Future<void> simulatePaid(String orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/payments/$orderId/simulate-paid'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal mensimulasikan pembayaran sukses.');
    }
  }
}

class PaymentSession {
  const PaymentSession({
    required this.orderId,
    required this.paymentMethod,
    required this.provider,
    required this.status,
    required this.instructions,
  });

  final String orderId;
  final String paymentMethod;
  final String? provider;
  final String status;
  final Map<String, dynamic> instructions;

  factory PaymentSession.fromJson(Map<String, dynamic> json) {
    return PaymentSession(
      orderId: json['orderId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      provider: json['provider'] as String?,
      status: json['status'] as String,
      instructions: (json['instructions'] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }
}

BoxDecoration cardDecoration() {
  return BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFFFDF7F1), Color(0xFFFFFBF7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
      BoxShadow(
        color: Color(0x12000000),
        blurRadius: 28,
        offset: Offset(0, 16),
      ),
    ],
    border: Border.all(color: const Color(0xFFFFF0E6)),
  );
}

BoxDecoration heroDecoration() {
  return BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFFC62828), Color(0xFFE53935)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(34),
    boxShadow: const [
      BoxShadow(
        color: Color(0x22C62828),
        blurRadius: 34,
        offset: Offset(0, 18),
      ),
    ],
  );
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
