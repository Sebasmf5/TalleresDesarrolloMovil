import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller 1 - Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

class _HomePageState extends State<HomePage> {
  // variables de estado
  String appBarTitle = 'Hola, Flutter';
  bool isTitleChanged = false;

  // ── método setState() ──
  void toggleTitle() {
    setState(() {
      isTitleChanged = !isTitleChanged;
      appBarTitle = isTitleChanged ? '¡Título cambiado!' : 'Hola, Flutter';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Título actualizado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Sebastián Morales Flórez',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 24),

            // ── Row con imágenes ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Image.network
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://images.wallpapersden.com/image/download/levi-ackerman-attack-on-titan_65300_1600x900.jpg',
                        width: 130,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            width: 130,
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Image.network',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),

                // Image.asset
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/hange.png', // imagen en assets/images/
                        width: 130,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Image.asset',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Widget adicional: Container ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                border: Border.all(color: Colors.deepPurple, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Widget adicional: Container\nCon color de fondo, borde y bordes redondeados.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
