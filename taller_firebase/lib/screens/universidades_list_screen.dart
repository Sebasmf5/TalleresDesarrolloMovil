import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad.dart';
import '../services/firebase_service.dart';

class UniversidadesListScreen extends StatefulWidget {
  const UniversidadesListScreen({super.key});

  @override
  State<UniversidadesListScreen> createState() =>
      _UniversidadesListScreenState();
}

class _UniversidadesListScreenState extends State<UniversidadesListScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _eliminarUniversidad(String id, String nombre) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminacion'),
        content: Text('Desea eliminar la universidad "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _firebaseService.eliminarUniversidad(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Universidad eliminada correctamente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('universidades')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'No hay universidades registradas',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final id = docs[index].id;
            final uni = Universidad.fromMap(id, data);
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                title: Text(uni.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NIT: ${uni.nit}'),
                    Text('Direccion: ${uni.direccion}'),
                    Text('Telefono: ${uni.telefono}'),
                    Text('Web: ${uni.paginaWeb}',
                        style: const TextStyle(color: Colors.blue)),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _eliminarUniversidad(id, uni.nombre),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
