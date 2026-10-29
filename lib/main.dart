import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Shoe {
  final int id;
  final String name;
  final double price;
  final String image;

  Shoe({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

class CartItem {
  final Shoe shoe;
  int quantity;

  CartItem({
    required this.shoe,
    required this.quantity,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
        ),
        useMaterial3: true,
      ),
      home: const ShoeStoreScreen(),
    );
  }
}

class ShoeStoreScreen extends StatefulWidget {
  const ShoeStoreScreen({super.key});

  @override
  State<ShoeStoreScreen> createState() => _ShoeStoreScreenState();
}

class _ShoeStoreScreenState extends State<ShoeStoreScreen> {
  final List<Shoe> products = [
    Shoe(
      id: 1,
      name: 'Nike Air Max',
      price: 120.0,
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    ),
    Shoe(
      id: 2,
      name: 'Adidas Ultraboost',
      price: 150.0,
      image: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
    ),
    Shoe(
      id: 3,
      name: 'Nike Air Max 2',
      price: 120.0,
      image: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
    ),
    Shoe(
      id: 4,
      name: 'Puma RS-X',
      price: 100.0,
      image: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
    ),
    Shoe(
      id: 5,
      name: 'Nike Air Max 4',
      price: 120.0,
      image: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
    ),
  ];

  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = [
      CartItem(shoe: products[0], quantity: 1),
      CartItem(shoe: products[1], quantity: 1),
      CartItem(shoe: products[2], quantity: 1),
      CartItem(shoe: products[4], quantity: 10),
    ];
  }

  void addToCart(Shoe shoe) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.shoe.id == shoe.id);
      if (index != -1) {
        cartItems[index].quantity += 1;
      } else {
        cartItems.add(CartItem(shoe: shoe, quantity: 1));
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity += 1;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item.shoe.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Shoe Store',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giỏ hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${cartItems.length} sản phẩm',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 56,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Giỏ hàng đang trống',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return CartItemWidget(
                          cartItem: item,
                          onIncrease: () => increaseQuantity(index),
                          onDecrease: () => decreaseQuantity(index),
                          onDelete: () => removeFromCart(index),
                        );
                      },
                    ),
            ),
            TotalSectionWidget(
              totalPrice: calculateTotalPrice(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: const Text(
                'Danh sách giày',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final shoe = products[index];
                  return ProductCardWidget(
                    shoe: shoe,
                    onAddToCart: () => addToCart(shoe),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 68,
              height: 68,
              color: const Color(0xFFF2F3F5),
              child: Image.network(
                cartItem.shoe.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey,
                    size: 32,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.shoe.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Giá: ${cartItem.shoe.price.toStringAsFixed(1)} \$',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Số lượng: ${cartItem.quantity}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: onDecrease,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F3F5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onIncrease,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F3F5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFFECEC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Color(0xFFE53935),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final Shoe shoe;
  final VoidCallback onAddToCart;

  const ProductCardWidget({
    super.key,
    required this.shoe,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      margin: const EdgeInsets.only(right: 14, bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF2F3F5),
                child: Image.network(
                  shoe.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.grey,
                      size: 40,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shoe.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${shoe.price.toStringAsFixed(1)} \$',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Thêm vào giỏ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TotalSectionWidget extends StatelessWidget {
  final double totalPrice;

  const TotalSectionWidget({
    super.key,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tổng tiền:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            '${totalPrice.toStringAsFixed(2)} \$',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}
