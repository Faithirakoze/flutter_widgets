import 'package:flutter/material.dart';


class CartService {
  CartService._();
  static final instance = CartService._();

  final _items = <String>[];
  static final itemCount = ValueNotifier<int>(0);

  void add(String name) {
    _items.add(name);
    itemCount.value = _items.length;
  }

  void remove(int index) {
    _items.removeAt(index);
    itemCount.value = _items.length;
  }

  void clear() {
    _items.clear();
    itemCount.value = 0;
  }

  List<String> get items => List.unmodifiable(_items);
}


void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      home: const ShopScreen(),
    ));


class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const _products = [
    ('Keyboard', Icons.keyboard,  Colors.indigo),
    ('Mouse',    Icons.mouse,     Colors.teal),
    ('Monitor',  Icons.monitor,   Colors.orange),
    ('Webcam',   Icons.videocam,  Colors.pink),
    ('Lamp',     Icons.lightbulb, Colors.amber),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(fontWeight: FontWeight.w700)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: CartService.itemCount,
            builder: (context, count, child) => IconButton(
              icon: Badge(
                isLabelVisible: count > 0,
                backgroundColor: Colors.indigo,
                label: Text('$count'),
                child: child,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
            ),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final (name, icon, color) = _products[i];
          return Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: .2)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withValues(alpha: .15),
                child: Icon(icon, color: color, size: 20),
              ),
              title: Text(name,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.indigo,
                onPressed: () {
                  CartService.instance.add(name);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text('$name added to cart'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(fontWeight: FontWeight.w700)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: CartService.itemCount,
        builder: (context, count, _) {
          final items = CartService.instance.items;

          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 48, color: Colors.black26),
                  SizedBox(height: 12),
                  Text('Your cart is empty',
                      style: TextStyle(color: Colors.black45)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.indigo.withValues(alpha: .05),
                child: const Row(
                  children: [
                    Icon(Icons.swipe_left_outlined,
                        size: 16, color: Colors.indigo),
                    SizedBox(width: 6),
                    Text('Swipe left to remove',
                        style:
                            TextStyle(fontSize: 12, color: Colors.indigo)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final name = items[i];
                    return Dismissible(
                      key: Key('$name-$i'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => CartService.instance.remove(i),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete_outline,
                                color: Colors.white, size: 22),
                            SizedBox(height: 4),
                            Text('Remove',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo.withValues(alpha: .04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.indigo.withValues(alpha: .15)),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFE8EAF6),
                            child: Icon(Icons.shopping_bag_outlined,
                                color: Colors.indigo, size: 18),
                          ),
                          title: Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.chevron_left,
                              color: Colors.black26, size: 18),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom bar
      