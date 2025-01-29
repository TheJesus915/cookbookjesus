import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jesus');
  final _emailController =
  TextEditingController(text: 'jesusitogamboa@gmail.com');
  bool _isLoading = false;
  late AnimationController _animationController;

  // Colores del tema Pokémon
  final pokemonRed = const Color(0xFFE3350D);
  final pokemonDarkRed = const Color(0xFFCC0000);
  final pokemonWhite = const Color(0xFFFFFFF);
  final pokemonBlack = const Color(0xFF2B2B2B);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: pokemonRed,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Pokémon Trainer Form',
                style: GoogleFonts.rubikMonoOne(
                  // Cambiado a una fuente pixelada de Google Fonts
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Lottie.asset(
                    'assets/lottie/forms.json',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          pokemonRed.withOpacity(0.8),
                          pokemonDarkRed.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: pokemonRed.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '¡Regístrate Entrenador!',
                          style: GoogleFonts.rubikMonoOne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: pokemonDarkRed,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          style: GoogleFonts.poppins(
                            color: pokemonBlack,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Nombre de Entrenador',
                            hintText: 'Ingresa tu nombre de entrenador',
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            labelStyle: TextStyle(color: pokemonDarkRed),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: pokemonRed),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: pokemonRed),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: pokemonDarkRed,
                                width: 2,
                              ),
                            ),
                            prefixIcon:
                            Icon(Icons.person, color: pokemonDarkRed),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '¡Necesitas un nombre de entrenador!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          style: GoogleFonts.poppins(
                            color: pokemonBlack,
                          ),
                          decoration: InputDecoration(
                            labelText: 'PokéMail',
                            hintText: 'Ingresa tu email',
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            labelStyle: TextStyle(color: pokemonDarkRed),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: pokemonRed),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: pokemonRed),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: pokemonDarkRed,
                                width: 2,
                              ),
                            ),
                            prefixIcon:
                            Icon(Icons.email, color: pokemonDarkRed),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '¡Necesitamos tu PokéMail!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: pokemonRed,
                            elevation: 5,
                          ),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1 + 0.1 * _animationController.value,
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : Text(
                                  '¡Comenzar Aventura!',
                                  style: GoogleFonts.rubikMonoOne(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _animationController.repeat(reverse: true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _animationController.stop();
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Bienvenido al mundo Pokémon!',
              style: GoogleFonts.rubikMonoOne(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            backgroundColor: pokemonDarkRed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
