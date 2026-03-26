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
        scaffoldBackgroundColor: const Color(0xFF141414),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF8B0000)),
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
  // 1. Variable de estado inicial requerida
  String _appBarTitle = 'Hola, Flutter';
  bool _isTitleChanged = false;

  // 2. Función setState requerida
  void _toggleTitle() {
    setState(() {
      _isTitleChanged = !_isTitleChanged;
      _appBarTitle = _isTitleChanged
          ? '¡Título cambiado!'
          : 'Hola, Flutter';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Título actualizado'),
        backgroundColor: Color(0xFF225533),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBarTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(34, 85, 51, 1.0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 3. Text centrado con tu nombre
            const Text(
              'Sebastián Morales Flórez',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Row con Image.network e Image.asset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Imagen de Red
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://th.bing.com/th/id/R.6c2197449e6fd4e3cf4ea65e75342b15?rik=Kg1PE9T1xs9Sxg&riu=http%3a%2f%2f3.bp.blogspot.com%2f-VwPCqX1emt4%2fUnDDcTtbRaI%2fAAAAAAAAAeE%2fq3logHHgG0U%2fs1600%2fEscudo%2blegion%2bde%2bexploraci%c3%b3n%2b%5bwww.codezeroft.com.mx%5d.png&ehk=vnUjrDhVqGHDdo2Rqz7i3BVxxHB1NQnmGV1Eu2jy3YU%3d&risl=&pid=ImgRaw&r=0',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                // Imagen Local (¡Asegúrate de tenerla en pubspec.yaml!)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/Erwin.jpg',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 5. ElevatedButton con setState()
            ElevatedButton(
              onPressed: _toggleTitle,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF225533),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Cambiar Título',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Titanes Cambiantes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 6. Widget Adicional #1: ListView (dentro de un Expanded para evitar errores de renderizado)
            Expanded(
              child: ListView(
                children: [
                  _buildTitanCard(
                    'Titán de Ataque',
                    'Portador: Eren Jaeger',
                    'assets/titanAtaque.jpg', // <-- Nombre de tu imagen descargada
                  ),
                  _buildTitanCard(
                    'Titán Colosal',
                    'Portador: Armin Arlert',
                    'assets/colosal.jpg', // <-- Nombre de tu imagen descargada
                  ),
                  _buildTitanCard(
                    'Titán Acorazado',
                    'Portador: Reiner Braun',
                    'assets/acorazado.jpg', // <-- Nombre de tu imagen descargada
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 7. Widget Adicional #2: Stack (Superponer elementos en la tarjeta)
  
  Widget _buildTitanCard(String title, String subtitle, String imagePath) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Aquí le puse el verde que estabas usando (0xFF225533)
        border: Border.all(color: const Color(0xFF225533), width: 2), 
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ⚠️ AQUÍ ESTÁ EL CAMBIO CLAVE: Image.asset ⚠️
          Image.asset(imagePath, fit: BoxFit.cover),
          
          // Capa oscura para legibilidad
          Container(color: Colors.black.withOpacity(0.5)),
          // Textos superpuestos
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
