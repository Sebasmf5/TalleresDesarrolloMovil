import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/universidad.dart';

class FirebaseService {
  final CollectionReference _universidades =
      FirebaseFirestore.instance.collection('universidades');

  Stream<List<Universidad>> obtenerUniversidades() {
    return _universidades.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Universidad.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> agregarUniversidad(Universidad universidad) {
    return _universidades.add(universidad.toMap());
  }

  Future<void> actualizarUniversidad(Universidad universidad) {
    return _universidades.doc(universidad.id).update(universidad.toMap());
  }

  Future<void> eliminarUniversidad(String id) {
    return _universidades.doc(id).delete();
  }
}
