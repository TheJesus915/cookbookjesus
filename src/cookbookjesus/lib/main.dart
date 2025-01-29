import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cookbookjesus/pages/design_page.dart';
import 'package:cookbookjesus/pages/forms_page.dart';
import 'package:cookbookjesus/pages/images_page.dart';
import 'package:cookbookjesus/pages/lists_page.dart';
import 'package:cookbookjesus/pages/navigation_page.dart';
import 'package:cookbookjesus/pages/animation_page.dart';
import 'package:cookbookjesus/pages/persistence_page.dart';
import 'package:cookbookjesus/pages/NETWORKING/main_networking.dart';


void main() {
  runApp(const Cookbookjesus());
}

class Cookbookjesus extends StatelessWidget {
  const Cookbookjesus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Libro De cocina de Jesús De Teran',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFB5C7FF),
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFB5C7FF),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = true;

  final categories = [
    {
      'title': 'Modern UI Design',
      'icon': 'assets/lottie/design.json',
      'route': const DesignPage(),
      'color': const Color(0xFFFFB5B5),
      'description': 'Explore beautiful UI components and animations',
    },
    {
      'title': 'Smart Forms',
      'icon': 'assets/lottie/forms.json',
      'route': const FormsPage(),
      'color': const Color(0xFFB5FFB5),
      'description': 'Interactive and validated forms',
    },
    {
      'title': 'Dynamic Images',
      'icon': 'assets/lottie/images.json',
      'route': const ImagesPage(),
      'color': const Color(0xFFE0B5FF),
      'description': 'Advanced image handling techniques',
    },
    {
      'title': 'Animated Lists',
      'icon': 'assets/lottie/lists.json',
      'route': const ListsPage(),
      'color': const Color(0xFFFFE0B5),
      'description': 'Beautiful list animations and interactions',
    },
    {
      'title': 'Smooth Navigation',
      'icon': 'assets/lottie/navigation.json',
      'route': const NavigationPage(),
      'color': const Color(0xFFFFB5D8),
      'description': 'Seamless navigation patterns',
    },
    {
      'title': 'Animaciones',
      'icon': 'assets/lottie/animation.json',
      'route': const AnimationPage(),
      'color': const Color(0xFFB3E5FC), // Azul pastel
      'description': 'Ejemplos de animaciones en Flutter',
    },
    {
      'title': 'Persistencia',
      'icon': 'assets/lottie/persistence.json', // Necesitarás este archivo
      'route': const PersistencePage(),
      'color': const Color(0xFFC8E6C9),
      'description': 'Almacenamiento local y persistencia de datos',
    },
    {
      'title': 'Networking',
      'icon': 'assets/lottie/networking.json',
      'route': const MainNetworking(),
      'color': Colors.teal,
      'description': 'Rentadores y Rentadoras',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF0F3FF),
              const Color(0xFFE6E9FF),
              const Color(0xFFECF0FF),
              const Color(0xFFF5F7FF),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              expandedHeight: 200,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Libro de cocina de Jesús De Teran',
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFB5C7FF).withOpacity(0.7),
                        const Color(0xFFFFB5B5).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      'https://picsum.photos/800/400',
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(0.8),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _isLoading
                  ? SliverToBoxAdapter(
                child: _buildShimmerLoading(),
              )
                  : SliverGrid(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(category);
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 4,
      shadowColor: (category['color'] as Color).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => category['route'] as Widget),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (category['color'] as Color).withOpacity(0.9),
                (category['color'] as Color).withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (category['color'] as Color).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  category['icon'] as String,
                  height: 80,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  category['title'] as String,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  category['description'] as String,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
