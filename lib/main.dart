import 'package:flutter/material.dart';

void main() {
  runApp(const BazarBuku());
}

class BazarBuku extends StatelessWidget {
  const BazarBuku({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'perpustakaan buku sekolah',
      theme: ThemeData(
        // ignore: prefer_const_constructors
        primarySwatch: MaterialColor(
          0xFFFC0000,
          const <int, Color>{
            50: Color(0xFFFFEBEE),
            100: Color(0xFFFFCDD2),
            200: Color(0xFFEF9A9A),
            300: Color(0xFFE57373),
            400: Color(0xFFEF5350),
            500: Color(0xFFFC0000),
            600: Color(0xFFE53935),
            700: Color(0xFFD32F2F),
            800: Color(0xFFC62828),
            900: Color(0xFFB71C1C),
          },
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nomorinduksekolahController =
      TextEditingController();
  final TextEditingController _katasandiController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _login() {
    if (_nomorinduksekolahController.text == '085814051810' &&
        _katasandiController.text == 'arab' &&
        _emailController.text == 'vadel@gmail.com') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const ProductManagementScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid nomorinduksekolah, katasandi, or email.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('masuk ke akun anda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _nomorinduksekolahController,
              decoration:
                  const InputDecoration(labelText: 'Nomor Induk Sekolah'),
            ),
            TextField(
              controller: _katasandiController,
              decoration: const InputDecoration(labelText: 'Kata Sandi'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final List<Product> _products = [];
  String _searchQuery = '';

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil ditambahkan!')),
    );
  }

  void _editProduct(int index, Product product) {
    setState(() {
      _products[index] = product;
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mengelola produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfileScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Mencari Produk',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredProducts().length,
        itemBuilder: (context, index) {
          final product = _filteredProducts()[index];
          return Card(
            child: ListTile(
              leading: Image.network(product.imageUrl),
              title: Text(product.namabuku),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga: Rp${product.harga}'),
                  Text('Deskripsi: ${product.keteranganbuku}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showProductDialog(context, product, index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteProduct(index),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product)),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Product> _filteredProducts() {
    return _products.where((product) {
      return product.namabuku
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showProductDialog(BuildContext context,
      [Product? product, int? index]) {
    final TextEditingController nameController =
        TextEditingController(text: product?.namabuku);
    final TextEditingController priceController =
        TextEditingController(text: product?.harga.toString());
    final TextEditingController descriptionController =
        TextEditingController(text: product?.keteranganbuku);
    final TextEditingController imageUrlController =
        TextEditingController(text: product?.imageUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'nama buku'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'keterangan buku'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi!')),
                );
                return;
              }

              final newProduct = Product(
                namabuku: nameController.text,
                harga: double.tryParse(priceController.text) ?? 0,
                keteranganbuku: descriptionController.text,
                imageUrl: imageUrlController.text,
              );

              if (product == null) {
                _addProduct(newProduct);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produk berhasil ditambahkan!')),
                );
              } else {
                _editProduct(index!, newProduct);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produk berhasil diperbarui!')),
                );
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String namabuku;
  final double harga;
  final String keteranganbuku;
  final String imageUrl;

  Product({
    required this.namabuku,
    required this.harga,
    required this.keteranganbuku,
    required this.imageUrl,
  });
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _namasiswaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namasiswaController.text = 'Nama Siswa';
    _emailController.text = 'vadel@gmail.com';
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namasiswaController,
              decoration: const InputDecoration(labelText: 'Nama Pengguna'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.namabuku)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl),
            const SizedBox(height: 10),
            Text('Harga: Rp${product.harga}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Deskripsi: ${product.keteranganbuku}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
