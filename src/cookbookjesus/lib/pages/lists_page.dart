import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  // Paleta de colores pasteles y cálidos
  final List<Color> pastelColors = [
    Color(0xFFFFE4E1), // Misty Rose
    Color(0xFFF0E6FF), // Lavanda pastel
    Color(0xFFFFE4B5), // Moccasin
    Color(0xFFE6F3FF), // Azul cielo pastel
    Color(0xFFFFF0F5), // Rosa lavanda
    Color(0xFFF5FFE6), // Verde menta pastel
    Color(0xFFFFE8D6), // Melocotón claro
    Color(0xFFE6FFE6), // Menta claro
  ];

  final List<Map<String, dynamic>> _items = List.generate(
    20,
        (index) => {
      'id': index,
      'title': 'Novia ${index + 1}',
      'subtitle': 'Descripción del novia ${index + 1}',
      'isSelected': false,
      'color': Color(0xFFFFE4E1).withOpacity(0.7), // Color base pastel
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9F5), // Fondo crema muy suave
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Color(0xFFFFF0F5), // Rosa lavanda muy suave
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Mi Lista Especial',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF846B8A), // Color texto más cálido
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Lottie.asset(
                    'assets/lottie/lists.json',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xFFFFF0F5).withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = _items[index];
                return _buildListItem(item, index);
              },
              childCount: _items.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,
        backgroundColor: Color(0xFFE6B0AA), // Rosa melocotón suave
        label: Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Nuevo Item",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, int index) {
    return Dismissible(
      key: ValueKey(item['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Color(0xFFFFCDD2), // Rojo pastel suave
        child: Icon(Icons.delete, color: Color(0xFFE57373)),
      ),
      onDismissed: (_) => _removeItem(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(
          horizontal: item['isSelected'] ? 20 : 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: item['isSelected']
              ? pastelColors[index % pastelColors.length].withOpacity(0.7)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pastelColors[index % pastelColors.length],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: GoogleFonts.poppins(
                  color: Color(0xFF846B8A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          title: Text(
            item['title'],
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Color(0xFF846B8A),
            ),
          ),
          subtitle: Text(
            item['subtitle'],
            style: GoogleFonts.poppins(
              color: Color(0xFF9E9E9E),
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              item['isSelected'] ? Icons.favorite : Icons.favorite_border,
              color: item['isSelected'] ? Color(0xFFE6B0AA) : Color(0xFFBDBDBD),
            ),
            onPressed: () => _toggleSelection(index),
          ),
          onTap: () => _toggleSelection(index),
        ),
      ),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      _items[index]['isSelected'] = !_items[index]['isSelected'];
    });
  }

  void _addItem() {
    setState(() {
      _items.insert(0, {
        'id': _items.length,
        'title': 'Nuevo Item',
        'subtitle': 'Descripción del nuevo item',
        'isSelected': false,
        'color': pastelColors[Random().nextInt(pastelColors.length)],
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }
}
