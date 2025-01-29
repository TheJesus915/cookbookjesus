import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

// Definimos el esquema de colores cálido como una constante global
final warmColorScheme = ColorScheme.light(
  primary: Color(0xFFFFB800), // Amarillo cálido principal
  primaryContainer: Color(0xFFFFE082), // Amarillo más claro para contenedores
  secondary: Color(0xFFFFA000), // Naranja amarillento
  secondaryContainer: Color(0xFFFFECB3), // Amarillo pálido
  tertiary: Color(0xFFFF9800), // Naranja cálido
  tertiaryContainer: Color(0xFFFFE0B2), // Naranja pálido
  surface: Color(0xFFFFF8E1), // Fondo muy suave
  background: Color(0xFFFFFDE7), // Fondo general
  error: Color(0xFFD32F2F), // Rojo para errores
  onPrimary: Colors.black, // Texto sobre color principal
  onSecondary: Colors.black, // Texto sobre color secundario
  onTertiary: Colors.black, // Texto sobre color terciario
  onSurface: Colors.black87, // Texto sobre superficie
  onBackground: Colors.black87, // Texto sobre fondo
);

class DesignPage extends StatefulWidget {
  const DesignPage({super.key});

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  final List<Map<String, dynamic>> sections = [
    {
      'title': 'Material Design 3',
      'description': 'Implementación de los últimos widgets de Material 3',
      'icon': Icons.style,
      'items': [
        {
          'title': 'Buttons',
          'widget': _ButtonsShowcase(),
        },
        {
          'title': 'Cards',
          'widget': _CardsShowcase(),
        },
        {
          'title': 'Color Scheme',
          'widget': _ColorSchemeShowcase(),
        },
      ],
    },
    {
      'title': 'Animaciones Personalizadas',
      'description': 'Ejemplos de animaciones implícitas y explícitas',
      'icon': Icons.animation,
      'items': [
        {
          'title': 'Container Animation',
          'widget': _AnimatedContainerShowcase(),
        },
        {
          'title': 'Loading Effects',
          'widget': _LoadingEffectsShowcase(),
        },
      ],
    },
    {
      'title': 'Temas Dinámicos',
      'description': 'Cambio de temas y colores en tiempo real',
      'icon': Icons.color_lens,
      'items': [
        {
          'title': 'Theme Switcher',
          'widget': _ThemeSwitcherShowcase(),
        },
      ],
    },
    {
      'title': 'Diseño Responsivo',
      'description': 'Adaptación a diferentes tamaños de pantalla',
      'icon': Icons.devices,
      'items': [
        {
          'title': 'Responsive Layout',
          'widget': _ResponsiveLayoutShowcase(),
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: warmColorScheme,
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 4,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: warmColorScheme.primaryContainer,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Modern UI Design',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: warmColorScheme.onPrimary,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Lottie.asset(
                      'assets/lottie/design.json',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            warmColorScheme.primaryContainer.withOpacity(0.3),
                            warmColorScheme.primaryContainer.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final section = sections[index];
                    return _buildSection(section);
                  },
                  childCount: sections.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: warmColorScheme.surface,
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: warmColorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            section['icon'] as IconData,
            color: warmColorScheme.primary,
          ),
        ),
        title: Text(
          section['title'] as String,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: warmColorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          section['description'] as String,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: warmColorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        children: [
          for (final item in (section['items'] as List<Map<String, dynamic>>))
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 32),
              title: Text(
                item['title'] as String,
                style: TextStyle(color: warmColorScheme.onSurface),
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: warmColorScheme.primary,
              ),
              onTap: () {
                _showItemDetails(
                  context,
                  item['title'] as String,
                  item['widget'] as Widget,
                );
              },
            ),
        ],
      ),
    );
  }

  void _showItemDetails(BuildContext context, String title, Widget content) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Theme(
          data: ThemeData(
            colorScheme: warmColorScheme,
            useMaterial3: true,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              backgroundColor: warmColorScheme.primaryContainer,
            ),
            body: content,
          ),
        ),
      ),
    );
  }
}

// Showcase de Botones
class _ButtonsShowcase extends StatefulWidget {
  @override
  _ButtonsShowcaseState createState() => _ButtonsShowcaseState();
}

class _ButtonsShowcaseState extends State<_ButtonsShowcase> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Elevated Button con estado de carga
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                setState(() => isLoading = true);
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) setState(() => isLoading = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: warmColorScheme.primary,
                foregroundColor: warmColorScheme.onPrimary,
                minimumSize: const Size(200, 50),
                elevation: 4,
                shadowColor: warmColorScheme.primary.withOpacity(0.4),
              ),
              child: isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: warmColorScheme.onPrimary,
                ),
              )
                  : const Text('Elevated Button'),
            ),
            const SizedBox(height: 16),

            // Filled Button con icono
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Filled Button'),
              style: FilledButton.styleFrom(
                backgroundColor: warmColorScheme.secondary,
                foregroundColor: warmColorScheme.onSecondary,
                minimumSize: const Size(200, 50),
                elevation: 2,
                shadowColor: warmColorScheme.secondary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 16),

            // Outlined Button con animación
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: warmColorScheme.primary,
                minimumSize: const Size(200, 50),
                side: BorderSide(
                  color: warmColorScheme.primary,
                  width: 2,
                ),
                shadowColor: warmColorScheme.primary.withOpacity(0.2),
              ),
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 16),

            // Text Button con tooltip
            Tooltip(
              message: 'Text Button Example',
              decoration: BoxDecoration(
                color: warmColorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: TextStyle(color: warmColorScheme.onPrimaryContainer),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: warmColorScheme.primary,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Text Button'),
              ),
            ),
            const SizedBox(height: 32),

            // Segmented Button
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('Opción 1'),
                  icon: Icon(Icons.looks_one),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Opción 2'),
                  icon: Icon(Icons.looks_two),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('Opción 3'),
                  icon: Icon(Icons.looks_3),
                ),
              ],
              selected: {0},
              onSelectionChanged: (Set<int> newSelection) {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return warmColorScheme.primaryContainer;
                    }
                    return warmColorScheme.surface;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return warmColorScheme.onPrimaryContainer;
                    }
                    return warmColorScheme.onSurface;
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // FAB showcase
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.small(
                  onPressed: () {},
                  backgroundColor: warmColorScheme.tertiary,
                  foregroundColor: warmColorScheme.onTertiary,
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: warmColorScheme.primary,
                  foregroundColor: warmColorScheme.onPrimary,
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton.large(
                  onPressed: () {},
                  backgroundColor: warmColorScheme.secondary,
                  foregroundColor: warmColorScheme.onSecondary,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Showcase de Cards
class _CardsShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Card básica con sombra
        Card(
          elevation: 4,
          color: warmColorScheme.surface,
          shadowColor: warmColorScheme.primary.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elevated Card',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: warmColorScheme.onSurface,
                  ),
                ),
                Text(
                  'This is an elevated card example',
                  style: TextStyle(
                    color: warmColorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: warmColorScheme.primary,
                  ),
                  child: const Text('ACCIÓN'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Card con imagen
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 6,
          shadowColor: warmColorScheme.primary.withOpacity(0.3),
          child: Column(
            children: [
              Image.network(
                'https://picsum.photos/500/200',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                color: warmColorScheme.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card con Imagen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: warmColorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Ejemplo de card con imagen y acciones',
                      style: TextStyle(
                        color: warmColorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: warmColorScheme.primary,
                          ),
                          child: const Text('CANCELAR'),
                        ),
                        FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: warmColorScheme.primary,
                            foregroundColor: warmColorScheme.onPrimary,
                          ),
                          child: const Text('ACEPTAR'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card interactiva
        Card(
          color: warmColorScheme.surface,
          child: InkWell(
            onTap: () {},
            splashColor: warmColorScheme.primary.withOpacity(0.1),
            highlightColor: warmColorScheme.primary.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: warmColorScheme.primary,
                    child: Icon(
                      Icons.person,
                      color: warmColorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Interactiva',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: warmColorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Toca para más información',
                          style: TextStyle(
                            color: warmColorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: warmColorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Showcase de Color Scheme
class _ColorSchemeShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        final colors = [
          warmColorScheme.primary,
          warmColorScheme.secondary,
          warmColorScheme.tertiary,
          warmColorScheme.error,
          warmColorScheme.primaryContainer,
          warmColorScheme.secondaryContainer,
          warmColorScheme.tertiaryContainer,
          warmColorScheme.errorContainer,
        ];
        final labels = [
          'Primary',
          'Secondary',
          'Tertiary',
          'Error',
          'Primary Container',
          'Secondary Container',
          'Tertiary Container',
          'Error Container',
        ];
        return Container(
          decoration: BoxDecoration(
            color: colors[index],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors[index].withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            labels[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors[index].computeLuminance() > 0.5
                  ? Colors.black87
                  : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

// Showcase de Animated Container
class _AnimatedContainerShowcase extends StatefulWidget {
  @override
  _AnimatedContainerShowcaseState createState() =>
      _AnimatedContainerShowcaseState();
}

class _AnimatedContainerShowcaseState
    extends State<_AnimatedContainerShowcase> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Toca o pasa el mouse por encima',
            style: TextStyle(
              color: warmColorScheme.onBackground,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                width: _isExpanded ? 200 : 100,
                height: _isExpanded ? 200 : 100,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? warmColorScheme.secondary
                      : warmColorScheme.primary,
                  borderRadius: BorderRadius.circular(_isExpanded ? 32 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? warmColorScheme.secondary.withOpacity(0.4)
                          : warmColorScheme.primary.withOpacity(0.4),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _isExpanded ? 0.125 : 0,
                    child: Icon(
                      _isExpanded ? Icons.remove : Icons.add,
                      color: warmColorScheme.onPrimary,
                      size: _isExpanded ? 48 : 32,
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
}

// Showcase de Loading Effects
class _LoadingEffectsShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(warmColorScheme.primary),
            strokeWidth: 4,
          ),
          const SizedBox(height: 32),
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: warmColorScheme.primaryContainer,
            ),
            child: LinearProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(warmColorScheme.primary),
              backgroundColor: warmColorScheme.primaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator.adaptive(
              valueColor:
              AlwaysStoppedAnimation<Color>(warmColorScheme.secondary),
              backgroundColor: warmColorScheme.secondaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          _buildPulsingContainer(),
        ],
      ),
    );
  }

  Widget _buildPulsingContainer() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: warmColorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: warmColorScheme.tertiary.withOpacity(0.3 * value),
                  blurRadius: 16 * value,
                  spreadRadius: 4 * value,
                ),
              ],
            ),
            child: Icon(
              Icons.refresh,
              color: warmColorScheme.tertiary,
              size: 40,
            ),
          ),
        );
      },
    );
  }
}

// Showcase de Theme Switcher
class _ThemeSwitcherShowcase extends StatefulWidget {
  @override
  _ThemeSwitcherShowcaseState createState() => _ThemeSwitcherShowcaseState();
}

class _ThemeSwitcherShowcaseState extends State<_ThemeSwitcherShowcase> {
  bool isDark = false;
  Color selectedColor = Color(0xFFFFB800);
  final List<Color> colorOptions = [
    Color(0xFFFFB800), // Amarillo cálido
    Color(0xFFFFA000), // Naranja amarillento
    Color(0xFFFF9800), // Naranja
    Color(0xFFFFD600), // Amarillo brillante
    Color(0xFFFBC02D), // Amarillo dorado
    Color(0xFFF57F17), // Ámbar oscuro
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        color: warmColorScheme.surface,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Theme Mode Switch
              SwitchListTile(
                title: Text(
                  'Modo Oscuro',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: warmColorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  'Cambiar entre tema claro y oscuro',
                  style: GoogleFonts.poppins(
                    color: warmColorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                value: isDark,
                activeColor: warmColorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    isDark = value;
                  });
                },
              ),
              const Divider(),
              // Color Picker
              Text(
                'Color del Tema',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: warmColorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color
                              ? warmColorScheme.onPrimary
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          if (selectedColor == color)
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: selectedColor == color
                          ? Icon(
                        Icons.check,
                        color: warmColorScheme.onPrimary,
                      )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey[850]
                      : warmColorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Vista Previa',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : warmColorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedColor,
                        foregroundColor: warmColorScheme.onPrimary,
                      ),
                      onPressed: () {},
                      child: const Text('Botón de Prueba'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Showcase de Responsive Layout
class _ResponsiveLayoutShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _wideLayout();
        } else {
          return _narrowLayout();
        }
      },
    );
  }

  Widget _wideLayout() {
    return Row(
      children: [
        Expanded(
          child: _buildContent(),
        ),
        Expanded(
          child: _buildContent(reverse: true),
        ),
      ],
    );
  }

  Widget _narrowLayout() {
    return _buildContent();
  }

  Widget _buildContent({bool reverse = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        final actualIndex = reverse ? 9 - index : index;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: warmColorScheme.surface,
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: warmColorScheme.primaryContainer,
              child: Text(
                '${actualIndex + 1}',
                style: TextStyle(
                  color: warmColorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              'Item ${actualIndex + 1}',
              style: TextStyle(
                color: warmColorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Description for item ${actualIndex + 1}',
              style: TextStyle(
                color: warmColorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: warmColorScheme.primary,
              size: 16,
            ),
          ),
        );
      },
    );
  }
}
