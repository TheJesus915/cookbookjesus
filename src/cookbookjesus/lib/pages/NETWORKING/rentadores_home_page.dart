import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

// Definimos una clase para los colores cálidos que usaremos
class WarmColors {
  static const Color primary = Color(0xFFD4A373); // Marrón cálido
  static const Color secondary = Color(0xFFE9EDC9); // Verde suave
  static const Color background = Color(0xFFFEFAE0); // Crema cálido
  static const Color cardColor = Color(0xFFFAEDCD);
  static const Color textPrimary = Color(0xFF5C4033); // Marrón oscuro
  static const Color textSecondary = Color(0xFF8B7355); // Marrón medio
  static const Color accent = Color(0xFFCCD5AE); // Verde sage
}

class RentadoresHomePage extends StatefulWidget {
  const RentadoresHomePage({super.key});

  @override
  State<RentadoresHomePage> createState() => _RentadoresHomePageState();
}

class _RentadoresHomePageState extends State<RentadoresHomePage> {
  final String baseUrl = 'https://apirentz2-1.onrender.com/api/productos';
  List<dynamic> productos = [];
  bool isLoading = false;
  int currentPage = 1;
  final int limit = 10;
  bool hasMoreProducts = true;
  final ScrollController _scrollController = ScrollController();
  String currentUserLogin = 'TheJesus915';
  String currentDateTime = '';

  @override
  void initState() {
    super.initState();
    fetchProductos();
    _scrollController.addListener(_onScroll);
    _updateDateTime();
  }

  void _updateDateTime() {
    final now = DateTime.now().toUtc();
    currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMoreProducts) {
        fetchProductos(page: currentPage + 1);
      }
    }
  }

  Future<void> fetchProductos({int page = 1}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No se encontró el token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl?page=$page&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (page == 1) {
            productos = data['productos'];
          } else {
            productos.addAll(data['productos']);
          }
          currentPage = page;
          hasMoreProducts = data['productos'].length == limit;
          isLoading = false;
          _updateDateTime(); // Actualizar fecha y hora
        });
      } else if (response.statusCode == 401) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _refreshProductos() async {
    currentPage = 1;
    hasMoreProducts = true;
    await fetchProductos();
  }

  String formatPrice(dynamic price) {
    if (price == null) return '0.00';
    if (price is String) {
      try {
        return double.parse(price).toStringAsFixed(2);
      } catch (e) {
        return '0.00';
      }
    }
    if (price is int) {
      return price.toDouble().toStringAsFixed(2);
    }
    if (price is double) {
      return price.toStringAsFixed(2);
    }
    return '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: WarmColors.primary,
        scaffoldBackgroundColor: WarmColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: WarmColors.primary,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: WarmColors.cardColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Productos Disponibles',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Usuario: $currentUserLogin',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token');
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: WarmColors.secondary.withOpacity(0.3),
              child: Text(
                'Última actualización: $currentDateTime UTC',
                style: TextStyle(
                  color: WarmColors.textPrimary,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshProductos,
                color: WarmColors.primary,
                child: productos.isEmpty && !isLoading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_basket_outlined,
                        size: 80,
                        color: WarmColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay productos disponibles',
                        style: TextStyle(
                          fontSize: 18,
                          color: WarmColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12.0),
                  itemCount: productos.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == productos.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(WarmColors.primary),
                          ),
                        ),
                      );
                    }

                    final producto = productos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    producto['nombre'] ?? 'Sin nombre',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: WarmColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: WarmColors.accent.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '\$${formatPrice(producto['precio'])}',
                                    style: TextStyle(
                                      color: WarmColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              producto['descripcion'] ?? 'Sin descripción',
                              style: TextStyle(
                                fontSize: 14,
                                color: WarmColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${producto['nombre']} agregado al carrito',
                                    ),
                                    backgroundColor: WarmColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WarmColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.shopping_cart),
                                  SizedBox(width: 8),
                                  Text('Agregar al carrito'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Carrito de compras próximamente'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: WarmColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          backgroundColor: WarmColors.primary,
          icon: const Icon(Icons.shopping_cart_checkout),
          label: const Text('Carrito'),
        ),
      ),
    );
  }
}