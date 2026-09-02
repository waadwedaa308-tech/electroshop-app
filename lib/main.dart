import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(ElectroShop());

class ElectroShop extends StatefulWidget {
  @override
  State<ElectroShop> createState() => _ElectroShopState();
}

class _ElectroShopState extends State<ElectroShop> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElectroShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: isDark? Brightness.dark : Brightness.light, primaryColor: Color(0xFF1E3A8A)),
      home: HomePage(toggleTheme: (){setState((){isDark =!isDark;});}, isDark: isDark),
    );
  }
}

class Product {
  final String name; final int price; final int discountPrice; final String image; final String specs; final String category;
  Product({required this.name, required this.price, required this.discountPrice, required this.image, required this.specs, required this.category});
}

class CartItem { Product product; int quantity; CartItem({required this.product, required this.quantity}); }

class HomePage extends StatefulWidget {
  final Function toggleTheme; final bool isDark;
  HomePage({required this.toggleTheme, required this.isDark});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [
    // ===== 5 لابتوبات =====
    Product(name: 'MacBook Air M2', price: 2500000, discountPrice: 2200000, image: 'https://picsum.photos/400/400?10', category: 'لابتوبات', specs: '13.6 بوصة | M2 | 16GB | 512GB SSD | 18 ساعة'),
    Product(name: 'Dell XPS 15', price: 3200000, discountPrice: 2950000, image: 'https://picsum.photos/400/400?11', category: 'لابتوبات', specs: '15.6 بوصة 4K | i9 | 32GB | 1TB | RTX 4070'),
    Product(name: 'HP Spectre x360', price: 1800000, discountPrice: 1650000, image: 'https://picsum.photos/400/400?12', category: 'لابتوبات', specs: '14 بوصة لمس | i7 | 16GB | 512GB | قلم'),
    Product(name: 'Lenovo Legion 5', price: 2100000, discountPrice: 1900000, image: 'https://picsum.photos/400/400?13', category: 'لابتوبات', specs: '16 بوصة 165Hz | Ryzen 7 | 16GB | 1TB | RTX 4060'),
    Product(name: 'ASUS ROG Zephyrus', price: 2800000, discountPrice: 2600000, image: 'https://picsum.photos/400/400?14', category: 'لابتوبات', specs: '14 بوصة 2K | Ryzen 9 | 32GB | 2TB | 1.65كجم'),
    // ===== 5 جوالات =====
    Product(name: 'ايفون 15 برو ماكس', price: 2300000, discountPrice: 2100000, image: 'https://picsum.photos/400/400?20', category: 'جوالات', specs: '6.7 بوصة | A17 Pro | 48MP | 256GB | 4422mAh'),
    Product(name: 'سامسونج S24 الترا', price: 1700000, discountPrice: 1500000, image: 'https://picsum.photos/400/400?21', category: 'جوالات', specs: '6.8 بوصة | Snapdragon 8 Gen3 | 200MP | 512GB | S Pen'),
    Product(name: 'Google Pixel 8 Pro', price: 1400000, discountPrice: 1250000, image: 'https://picsum.photos/400/400?22', category: 'جوالات', specs: '6.7 بوصة | Tensor G3 | 50MP | 256GB | AI'),
    Product(name: 'Xiaomi 14 Pro', price: 950000, discountPrice: 850000, image: 'https://picsum.photos/400/400?23', category: 'جوالات', specs: '6.67 بوصة 2K | Snapdragon 8 Gen3 | Leica 50MP | 120W'),
    Product(name: 'OnePlus 12', price: 1100000, discountPrice: 980000, image: 'https://picsum.photos/400/400?24', category: 'جوالات', specs: '6.82 بوصة | 16GB | 512GB | 100W شحن'),
    // ===== 5 سماعات =====
    Product(name: 'AirPods Pro 2', price: 200000, discountPrice: 180000, image: 'https://picsum.photos/400/400?30', category: 'سماعات', specs: 'ANC نشط | 6+30 ساعة | USB-C | IPX4'),
    Product(name: 'Sony WH-1000XM5', price: 250000, discountPrice: 220000, image: 'https://picsum.photos/400/400?31', category: 'سماعات', specs: 'افضل عزل | 30 ساعة | 8 مايكات | 250جرام'),
    Product(name: 'JBL Tune 760NC', price: 85000, discountPrice: 65000, image: 'https://picsum.photos/400/400?32', category: 'سماعات', specs: '50 ساعة | JBL Bass | USB-C | قابلة للطي'),
    Product(name: 'HyperX Cloud II', price: 120000, discountPrice: 95000, image: 'https://picsum.photos/400/400?33', category: 'سماعات', specs: '7.1 صوت محيطي | مايك قابل للفصل | للقيمنق'),
    Product(name: 'Soundcore Liberty 4', price: 110000, discountPrice: 90000, image: 'https://picsum.photos/400/400?34', category: 'سماعات', specs: '9+28 ساعة | ANC هجين | شحن لاسلكي | IPX4'),
    // ===== 4 كاميرات =====
    Product(name: 'Canon EOS R5', price: 3500000, discountPrice: 3200000, image: 'https://picsum.photos/400/400?40', category: 'كاميرات', specs: '45MP | 8K فيديو | تثبيت 5 محاور | شاشة لمس'),
    Product(name: 'Sony A7 IV', price: 2800000, discountPrice: 2600000, image: 'https://picsum.photos/400/400?41', category: 'كاميرات', specs: '33MP | 4K 60fps | تركيز تلقائي AI | مقاومة غبار'),
    Product(name: 'GoPro Hero 12', price: 450000, discountPrice: 380000, image: 'https://picsum.photos/400/400?42', category: 'كاميرات', specs: '5.3K 60fps | مقاومة ماء 10م | تثبيت HyperSmooth'),
    Product(name: 'DJI Osmo Pocket 3', price: 600000, discountPrice: 520000, image: 'https://picsum.photos/400/400?43', category: 'كاميرات', specs: '1 بوصة | 4K 120fps | تثبيت 3 محاور | شاشة دوارة'),
    // ===== 4 شاشات =====
    Product(name: 'LG 27 بوصة 2K', price: 380000, discountPrice: 350000, image: 'https://picsum.photos/400/400?50', category: 'شاشات', specs: '27 بوصة | 2K | 144Hz | 1ms | IPS'),
    Product(name: 'Samsung 32 بوصة 4K', price: 550000, discountPrice: 490000, image: 'https://picsum.photos/400/400?51', category: 'شاشات', specs: '32 بوصة | 4K | 60Hz | HDR10 | سمارت'),
    Product(name: 'Dell UltraWide 34', price: 750000, discountPrice: 680000, image: 'https://picsum.photos/400/400?52', category: 'شاشات', specs: '34 بوصة | UWQHD | 160Hz | منحنية | USB-C'),
    Product(name: 'ASUS ROG 24 بوصة', price: 320000, discountPrice: 280000, image: 'https://picsum.photos/400/400?53', category: 'شاشات', specs: '24.5 بوصة | FHD | 240Hz | 0.5ms | للقيمنق'),
    // ===== 4 فأرة =====
    Product(name: 'Logitech MX Master 3S', price: 85000, discountPrice: 75000, image: 'https://picsum.photos/400/400?60', category: 'فأرة', specs: '8000 DPI | بلوتوث + USB | 70 يوم بطارية | صامتة'),
    Product(name: 'Razer DeathAdder V3', price: 65000, discountPrice: 55000, image: 'https://picsum.photos/400/400?61', category: 'فأرة', specs: '30000 DPI | 63 جرام | سلكي | للقيمنق'),
    Product(name: 'Apple Magic Mouse', price: 55000, discountPrice: 45000, image: 'https://picsum.photos/400/400?62', category: 'فأرة', specs: 'لمس متعدد | شحن Lightning | للـ Mac'),
    Product(name: 'SteelSeries Rival 3', price: 35000, discountPrice: 25000, image: 'https://picsum.photos/400/400?63', category: 'فأرة', specs: '8500 DPI | 77 جرام | RGB | اقتصادية'),
    // ===== 3 لوحة مفاتيح =====
    Product(name: 'Logitech G915 TKL', price: 180000, discountPrice: 150000, image: 'https://picsum.photos/400/400?70', category: 'لوحة مفاتيح', specs: 'ميكانيكي | لاسلكي | RGB | 40 ساعة بطارية'),
    Product(name: 'Keychron K2', price: 120000, discountPrice: 95000, image: 'https://picsum.photos/400/400?71', category: 'لوحة مفاتيح', specs: 'ميكانيكي | بلوتوث + سلك | 75% | ماك + ويندوز'),
    Product(name: 'Redragon K552', price: 45000, discountPrice: 30000, image: 'https://picsum.photos/400/400?72', category: 'لوحة مفاتيح', specs: 'ميكانيكي | سلكي | RGB | مفاتيح Outemu'),
  ];

  List<CartItem> cart = []; List<Product> favorites = []; List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController(); String selectedCategory = 'الكل';

  @override
  void initState() { super.initState(); filteredProducts = products; searchController.addListener(() { filterProducts(); }); }

  void filterProducts() { String query = searchController.text.toLowerCase(); setState(() { filteredProducts = products.where((p) => p.name.toLowerCase().contains(query) && (selectedCategory == 'الكل' || p.category == selectedCategory)).toList(); }); }

  void addToCart(Product product) { setState(() { var existing = cart.where((e) => e.product.name == product.name).toList(); if (existing.isNotEmpty) { existing[0].quantity++; } else { cart.add(CartItem(product: product, quantity: 1)); } }); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت اضافة ${product.name}'), backgroundColor: Colors.green)); }

  void toggleFavorite(Product product) { setState(() { if(favorites.contains(product)){ favorites.remove(product); } else { favorites.add(product); } }); }

  int getTotalItems() { return cart.fold(0, (sum, item) => sum + item.quantity); }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF1E3A8A), title: Row(children: [Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.shopping_bag, color: Color(0xFF1E3A8A), size: 28)), SizedBox(width: 10), Text('متجري الالكتروني', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))])),
      actions: [IconButton(icon: Icon(widget.isDark? Icons.light_mode : Icons.dark_mode, color: Colors.white), onPressed: () => widget.toggleTheme()), IconButton(icon: Icon(Icons.favorite, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesPage(favorites: favorites, addToCart: addToCart)))), Stack(children: [IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(cart: cart, addToCart: addToCart)))), if(getTotalItems() > 0) Positioned(right: 6, top: 6, child: CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Text('${getTotalItems()}', style: TextStyle(fontSize: 12, color: Colors.white))))])]),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(10), child: TextField(controller: searchController, decoration: InputDecoration(hintText: 'ابحث عن كاميرا, شاشة, فأرة...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), filled: true))),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['الكل','جوالات','لابتوبات','سماعات','كاميرات','شاشات','فأرة','لوحة مفاتيح'].map((cat)=> Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: ChoiceChip(label: Text(cat), selected: selectedCategory == cat, onSelected: (v){setState((){selectedCategory = cat; filterProducts();});}))).toList())),
        Expanded(child: GridView.builder(padding: EdgeInsets.all(10), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.58), itemCount: filteredProducts.length, itemBuilder: (context, index) {
          var p = filteredProducts[index];
          return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: p, addToCart: addToCart, toggleFavorite: toggleFavorite, isFavorite: favorites.contains(p)))),
          child: Card(child: Column(children: [Stack(children: [Image.network(p.image, height: 90, fit: BoxFit.cover), Positioned(top: 5, left: 5, child: IconButton(icon: Icon(favorites.contains(p)? Icons.favorite : Icons.favorite_border, color: Colors.red), onPressed: () => toggleFavorite(p)))]), Padding(padding: EdgeInsets.all(5), child: Column(children: [Text(p.name, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2), Text('${p.discountPrice} جنيه', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)), if(p.price!= p.discountPrice) Text('${p.price} جنيه', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)), ElevatedButton(onPressed: () => addToCart(p), child: Text('اضافة'))]))])));
        })),
      ]),
    ));
  }
}

class ProductDetailPage extends StatelessWidget { final Product product; final Function(Product) addToCart; final Function(Product) toggleFavorite; final bool isFavorite; ProductDetailPage({required this.product, required this.addToCart, required this.toggleFavorite, required this.isFavorite}); @override Widget build(BuildContext context) { return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(product.name), backgroundColor: Color(0xFF1E3A8A)), body: SingleChildScrollView(child: Column(children: [Image.network(product.image, height: 250, width: double.infinity, fit: BoxFit.cover), Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text('${product.discountPrice} جنيه', style: TextStyle(fontSize: 22, color: Colors.green)), Divider(height: 30), Text('المواصفات:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(product.specs, style: TextStyle(fontSize: 16, height: 1.6)), SizedBox(height: 30), ElevatedButton(onPressed: (){addToCart(product); Navigator.pop(context);}, child: Text('اضافة للسلة'), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)))]))])))); } }
class FavoritesPage extends StatelessWidget { final List<Product> favorites; final Function(Product) addToCart; FavoritesPage({required this.favorites, required this.addToCart}); @override Widget build(BuildContext context) { return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text('المفضلة ❤️'), backgroundColor: Color(0xFF1E3A8A)), body: favorites.isEmpty? Center(child: Text('لا توجد منتجات مفضلة')) : ListView(children: favorites.map((p) => ListTile(leading: Image.network(p.image, width: 50), title: Text(p.name), trailing: ElevatedButton(onPressed: () => addToCart(p), child: Text('اضافة')))).toList()))); } }
class CartPage extends StatefulWidget { final List<CartItem> cart; final Function(Product) addToCart; CartPage({required this.cart, required this.addToCart}); @override _CartPageState createState() => _CartPageState(); }
class _CartPageState extends State<CartPage> { @override Widget build(BuildContext context) { int total = widget.cart.fold(0, (sum, item) => sum + (item.product.discountPrice * item.quantity)); return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text('سلة التسوق'), backgroundColor: Color(0xFF1E3A8A)), body: Column(children: [Expanded(child: widget.cart.isEmpty? Center(child: Text('السلة فاضية')) : ListView.builder(itemCount: widget.cart.length, itemBuilder: (context, i) => ListTile(leading: Image.network(widget.cart[i].product.image, width: 50), title: Text(widget.cart[i].product.name), subtitle: Text('الكمية: ${widget.cart[i].quantity}'), trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: (){setState((){widget.cart.removeAt(i);});})))), Container(padding: EdgeInsets.all(16), child: Column(children: [Text('الاجمالي: $total جنيه', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), ElevatedButton(onPressed: widget.cart.isEmpty? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutPage(total: total, cart: widget.cart))), child: Text('اتمام الطلب'), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)))]))]))); } }
class CheckoutPage extends StatefulWidget { final int total; final List<CartItem> cart; CheckoutPage({required this.total, required this.cart}); @override _CheckoutPageState createState() => _CheckoutPageState(); }
class _CheckoutPageState extends State<CheckoutPage> { TextEditingController name = TextEditingController(); TextEditingController phone = TextEditingController(); TextEditingController address = TextEditingController(); String paymentMethod = 'كاش'; void placeOrder() { showDialog(context: context, builder: (_) => AlertDialog(title: Text('تم الطلب بنجاح 🎉'), content: Text('شكرا ${name.text}\nالاجمالي: ${widget.total} جنيه\nطريقة الدفع: $paymentMethod'), actions: [TextButton(onPressed: (){Navigator.popUntil(context, (route) => route.isFirst);}, child: Text('موافق'))])); } @override Widget build(BuildContext context) { return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text('اتمام الطلب'), backgroundColor: Color(0xFF1E3A8A)), body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(children: [Text('الاجمالي: ${widget.total} جنيه', style: TextStyle(fontSize: 20)), TextField(controller: name, decoration: InputDecoration(labelText: 'الاسم')), TextField(controller: phone, decoration: InputDecoration(labelText: 'الهاتف')), TextField(controller: address, decoration: InputDecoration(labelText: 'العنوان')), SizedBox(height: 20), Text('طريقة الدفع:'), RadioListTile(title: Text('كاش'), value: 'كاش', groupValue: paymentMethod, onChanged: (v){setState((){paymentMethod = v.toString();});}), RadioListTile(title: Text('بنكك'), value: 'بنكك', groupValue: paymentMethod, onChanged: (v){setState((){paymentMethod = v.toString();});}), RadioListTile(title: Text('فوري'), value: 'فوري', groupValue: paymentMethod, onChanged: (v){setState((){paymentMethod = v.toString();});}), ElevatedButton(onPressed: placeOrder, child: Text('تأكيد'))])))); } }
