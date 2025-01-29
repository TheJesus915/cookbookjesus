import 'package:flutter/material.dart';
import 'rentadoras_auth_page.dart';
import 'rentadores_auth_page.dart';

class MainNetworking extends StatelessWidget {
  const MainNetworking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cambiamos el fondo a un color cálido claro
      backgroundColor: const Color(0xFFFFF3E0), // Un tono beige cálido
      appBar: AppBar(
        title: const Text(
          'Networking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Color cálido para el AppBar
        backgroundColor: const Color(0xFFE65100), // Naranja oscuro
        elevation: 0, // Quitamos la sombra
      ),
      body: Container(
        // Agregamos un degradado al fondo
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E0), // Beige claro
              Color(0xFFFFE0B2), // Beige más oscuro
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón Rentadores
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 70),
                    backgroundColor: const Color(0xFFFF7043), // Naranja cálido
                    foregroundColor: Colors.white,
                    elevation: 8, // Agregamos sombra
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RentadoresAuthPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Rentadores',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Botón Rentadoras
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 70),
                    backgroundColor: const Color(0xFFF4511E), // Naranja más oscuro
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RentadorasAuthPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Rentadoras',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
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