import 'package:flutter/material.dart';

void main() {
  runApp(const PTNApp());
}

class PTNApp extends StatelessWidget {
  const PTNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perlengkapan TN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProductPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield, size: 90, color: Colors.blue),
            SizedBox(height: 12),
            Text(
              'Perlengkapan TN',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('by Adnan Developer'),
          ],
        ),
      ),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Map<String, dynamic>> items = [
    {'name': 'Topi OSIS', 'price': 40000},
    {'name': 'Baju OSIS', 'price': 200000},
    {'name': 'Dasi Pesiar', 'price': 80000},
    {'name': 'Kaos Kaki', 'price': 25000},
  ];

  final List<Map<String, dynamic>> cart = [];

  void addCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ditambahkan ke keranjang'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perlengkapan TN'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(cart: cart),
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .78,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, i) {
          final p = items[i];

          return Card(
            child: InkWell(
              onTap: () => addCart(p),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2,
                    size: 54,
                    color: Colors.blue,
                  ),
                  Text(p['name']),
                  Text('Rp ${p['price']}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => addCart(p),
                    child: const Text('+ Keranjang'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  const CartPage({
    super.key,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final total = cart.fold<int>(
      0,
      (a, b) => a + (b['price'] as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, i) {
                final c = cart[i];

                return ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(c['name']),
                  subtitle: Text('Rp ${c['price']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Total: Rp $total',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Checkout'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CheckoutPage(total: total),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final int total;

  const CheckoutPage({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Total Bayar: Rp $total',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => done(context, 'Tunai'),
              child: const Text('Tunai'),
            ),
            ElevatedButton(
              onPressed: () => done(context, 'Transfer'),
              child: const Text('Transfer'),
            ),
            ElevatedButton(
              onPressed: () => done(context, 'QRIS'),
              child: const Text('QRIS'),
            ),
          ],
        ),
      ),
    );
  }

  void done(BuildContext c, String metode) {
    showDialog(
      context: c,
      builder: (_) => AlertDialog(
        title: const Text('Pembayaran Berhasil'),
        content: Text('Metode: $metode'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(c, (r) => r.isFirst);
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }
}
