import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class AnimationPage extends StatelessWidget {
  const AnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animaciones',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7), // Lavanda pastel
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF), // Blanco rosado muy suave
              Color(0xFFF5F0FF), // Lavanda muy claro
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAnimationCard(
              context,
              'Contenedor Animado',
              'Ejemplo de AnimatedContainer',
              const AnimatedContainerDemo(),
            ),
            _buildAnimationCard(
              context,
              'Fade In Imágenes',
              'Animación de desvanecimiento de imágenes',
              const FadeInDemo(),
            ),
            _buildAnimationCard(
              context,
              'Física de Animación',
              'Simulación física con Spring',
              const PhysicsCardDragDemo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationCard(
      BuildContext context,
      String title,
      String description,
      Widget page,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFE0B2), // Melocotón pastel
              Color(0xFFC8E6C9), // Verde menta pastel
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A5568), // Gris oscuro suave
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(
              color: Color(0xFF718096), // Gris medio
              fontSize: 14,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF4A5568), // Gris oscuro suave
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
        ),
      ),
    );
  }
}

// Animated Container Demo
class AnimatedContainerDemo extends StatefulWidget {
  const AnimatedContainerDemo({super.key});

  @override
  State<AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contenedor Animado',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selected = !selected;
            });
          },
          child: Center(
            child: AnimatedContainer(
              width: selected ? 200.0 : 100.0,
              height: selected ? 100.0 : 200.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    selected ? Color(0xFFB3E5FC) : Color(0xFFFFC8C8),
                    selected ? Color(0xFFC8E6C9) : Color(0xFFFFE0B2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(selected ? 20 : 10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              alignment: selected ? Alignment.center : Alignment.topCenter,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: const FlutterLogo(size: 75),
            ),
          ),
        ),
      ),
    );
  }
}

// Fade In Demo
class FadeInDemo extends StatefulWidget {
  const FadeInDemo({super.key});

  @override
  State<FadeInDemo> createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<FadeInDemo> {
  double opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fade In Demo',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://picsum.photos/250?image=9',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3E5FC),
                foregroundColor: const Color(0xFF4A5568),
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child: const Text(
                'Fade In/Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () =>
                  setState(() => opacity = opacity == 0 ? 1.0 : 0.0),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Image.network(
                  'https://picsum.photos/250?image=9',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Physics Card Drag Demo
class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Physics Animation',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFF5F0FF),
            ],
          ),
        ),
        child: const DraggableCard(
          child: FlutterLogo(
            size: 128,
            style: FlutterLogoStyle.stacked,
          ),
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({super.key, required this.child});
  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;
  Alignment _dragAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB3E5FC),
                  Color(0xFFC8E6C9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
