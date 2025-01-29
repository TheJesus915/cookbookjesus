import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

// Definición de la paleta de colores cálidos
class WarmColors {
  static const Color primary = Color(0xFFE65100); // Deep Orange
  static const Color secondary = Color(0xFFFF9800); // Orange
  static const Color background = Color(0xFFFFF3E0); // Orange 50
  static const Color surface = Color(0xFFFFECB3); // Orange 100
  static const Color accent = Color(0xFFFF5722); // Deep Orange
  static const Color text = Color(0xFF3E2723); // Brown 900
  static const Color cardBackground = Color(0xFFFFE0B2); // Orange 200
}

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final _scrollController = ScrollController();
  bool _showFloatingButton = false;
  final List<String> _imageCategories = [
    'Naturaleza',
    'Arquitectura',
    'Personas',
    'Tecnología'
  ];
  String _selectedCategory = 'Naturaleza';
  bool _isGridView = true;
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scrollController.addListener(() {
      setState(() {
        _showFloatingButton = _scrollController.offset > 100;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WarmColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          _buildCategoryList(),
          _buildImageGrid(),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showFloatingButton ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showFloatingButton ? 1 : 0,
          child: FloatingActionButton.extended(
            backgroundColor: WarmColors.accent,
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              color: Colors.white,
            ),
            label: Text(
              _isGridView ? 'Vista Lista' : 'Vista Cuadrícula',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar.large(
      backgroundColor: WarmColors.primary,
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Imagenes dinamicas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Lottie.asset(
              'assets/lottie/images.json',
              fit: BoxFit.cover,
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    WarmColors.primary.withOpacity(0.3),
                    WarmColors.primary.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SliverToBoxAdapter(
      child: Container(
        color: WarmColors.background,
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _imageCategories.length,
          itemBuilder: (context, index) {
            final category = _imageCategories[index];
            final isSelected = category == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : WarmColors.text,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: WarmColors.accent,
                  backgroundColor: WarmColors.surface,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  elevation: isSelected ? 4 : 0,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return _buildImageCard(
            context,
            'https://picsum.photos/500?image=${index + 1}',
            index,
          );
        },
        childCount: 10,
      ),
    );
  }

  Widget _buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildImageListItem(
              context,
              'https://picsum.photos/500?image=${index + 1}',
              index,
            ),
          );
        },
        childCount: 10,
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String imageUrl, int index) {
    return Hero(
      tag: 'image_$index',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showImageDetail(context, imageUrl, index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()..scale(_currentScale),
            child: Card(
              color: WarmColors.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildShimmerEffect(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: WarmColors.accent),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              WarmColors.primary.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Text(
                          'Imagen ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageListItem(BuildContext context, String imageUrl, int index) {
    return Hero(
      tag: 'image_$index',
      child: Material(
        color: Colors.transparent,
        child: Card(
          color: WarmColors.cardBackground,
          child: InkWell(
            onTap: () => _showImageDetail(context, imageUrl, index),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildShimmerEffect(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: WarmColors.accent),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Imagen ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: WarmColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Categoría: $_selectedCategory',
                          style: TextStyle(
                            color: WarmColors.secondary,
                          ),
                        ),
                      ],
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

  Widget _buildShimmerEffect() {
    return Container(
      decoration: BoxDecoration(
        color: WarmColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: WarmColors.accent,
        ),
      ),
    );
  }

  void _showImageDetail(BuildContext context, String imageUrl, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageDetailScreen(
          imageUrl: imageUrl,
          index: index,
          heroTag: 'image_$index',
        ),
      ),
    );
  }
}

class ImageDetailScreen extends StatefulWidget {
  final String imageUrl;
  final int index;
  final String heroTag;

  const ImageDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.index,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  final double _minScale = 1.0;
  final double _maxScale = 4.0;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      _transformationController.value = _animation!.value;
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    Matrix4 endMatrix;
    if (_transformationController.value != Matrix4.identity()) {
      endMatrix = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: WarmColors.primary.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Hero(
          tag: widget.heroTag,
          child: GestureDetector(
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: _minScale,
              maxScale: _maxScale,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: WarmColors.accent,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: WarmColors.accent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
