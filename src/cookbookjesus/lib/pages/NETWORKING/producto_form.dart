import 'package:flutter/material.dart';

class ProductoForm extends StatefulWidget {
  final Map<String, dynamic>? producto;
  final Function(Map<String, dynamic>) onSubmit;

  const ProductoForm({
    Key? key,
    this.producto,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ProductoForm> createState() => _ProductoFormState();
}

class _ProductoFormState extends State<ProductoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _materialController = TextEditingController();
  final _imagenController = TextEditingController();
  bool _esPromocion = false;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _nombreController.text = widget.producto!['nombre'] ?? '';
      _descripcionController.text = widget.producto!['descripcion'] ?? '';
      _precioController.text = widget.producto!['precio']?.toString() ?? '';
      _cantidadController.text = widget.producto!['cantidad_disponible']?.toString() ?? '';
      _materialController.text = widget.producto!['tipo_material'] ?? '';
      _imagenController.text = widget.producto!['imagen_principal'] ?? '';
      _esPromocion = widget.producto!['es_promocion'] == 1 ? true : false;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    _materialController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF5C6BC0),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF5C6BC0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF5C6BC0), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.producto == null ? 'Nuevo Producto' : 'Editar Producto',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF303F9F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: _nombreController,
              decoration: _buildInputDecoration('Nombre del Producto', Icons.shopping_bag),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionController,
              decoration: _buildInputDecoration('Descripción', Icons.description),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _precioController,
                    decoration: _buildInputDecoration('Precio', Icons.attach_money),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese precio';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Precio inválido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cantidadController,
                    decoration: _buildInputDecoration('Cantidad', Icons.inventory),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese cantidad';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Cantidad inválida';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _materialController,
              decoration: _buildInputDecoration('Material', Icons.category),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el material';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagenController,
              decoration: _buildInputDecoration('URL de la imagen', Icons.image),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Producto en Promoción',
                  style: TextStyle(
                    color: Color(0xFF5C6BC0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: _esPromocion,
                activeColor: const Color(0xFF5C6BC0),
                onChanged: (bool value) {
                  setState(() {
                    _esPromocion = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final productoData = {
                    'nombre': _nombreController.text,
                    'descripcion': _descripcionController.text,
                    'precio': double.parse(_precioController.text),
                    'cantidad_disponible': int.parse(_cantidadController.text),
                    'tipo_material': _materialController.text,
                    'es_promocion': _esPromocion ? 1 : 0,
                    'imagen_principal': _imagenController.text.isEmpty
                        ? 'https://via.placeholder.com/150'
                        : _imagenController.text,
                  };
                  widget.onSubmit(productoData);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF303F9F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
              child: Text(
                widget.producto == null ? 'Agregar Producto' : 'Guardar Cambios',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}