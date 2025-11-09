import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/barbershop_model.dart';

/// Serviço Firestore para gerenciar barbearias
/// HIERARQUIA: Admin pode tudo, Barbearia gerencia seus próprios dados
class FirestoreBarbershopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'barbershops';

  // ==================== CREATE ====================

  /// Criar nova barbearia
  Future<String> createBarbershop(Barbershop barbershop) async {
    try {
      final docRef = await _firestore.collection(_collection).add(barbershop.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao criar barbearia: $e');
    }
  }

  // ==================== READ ====================

  /// Buscar barbearia por ID
  Future<Barbershop?> getBarbershopById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (!doc.exists) {
        return null;
      }

      return Barbershop.fromMap({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Erro ao buscar barbearia: $e');
    }
  }

  /// Stream de uma barbearia
  Stream<Barbershop?> getBarbershopStream(String id) {
    return _firestore.collection(_collection).doc(id).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      return Barbershop.fromMap({...doc.data()!, 'id': doc.id});
    });
  }

  /// Listar todas as barbearias
  Future<List<Barbershop>> getAllBarbershops() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      
      return snapshot.docs
          .map((doc) => Barbershop.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar barbearias: $e');
    }
  }

  /// Stream de todas as barbearias
  Stream<List<Barbershop>> getAllBarbershopsStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Barbershop.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  /// Buscar barbearias por dono
  Future<List<Barbershop>> getBarbershopsByOwner(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .get();
      
      return snapshot.docs
          .map((doc) => Barbershop.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar barbearias do dono: $e');
    }
  }

  /// Buscar barbearias por cidade
  Future<List<Barbershop>> getBarbershopsByCity(String city) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('address.city', isEqualTo: city)
          .get();
      
      return snapshot.docs
          .map((doc) => Barbershop.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar barbearias por cidade: $e');
    }
  }

  /// Buscar barbearias próximas (por estado)
  Future<List<Barbershop>> getBarbershopsByState(String state) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('address.state', isEqualTo: state)
          .get();
      
      return snapshot.docs
          .map((doc) => Barbershop.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar barbearias por estado: $e');
    }
  }

  /// Buscar barbearias com avaliação mínima
  Future<List<Barbershop>> getBarbershopsByMinRating(double minRating) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('rating', isGreaterThanOrEqualTo: minRating)
          .orderBy('rating', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Barbershop.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar barbearias por avaliação: $e');
    }
  }

  // ==================== UPDATE ====================

  /// Atualizar barbearia
  Future<void> updateBarbershop(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar barbearia: $e');
    }
  }

  /// Atualizar avaliação da barbearia
  Future<void> updateRating(String id, double rating, int reviewCount) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'rating': rating,
        'reviewCount': reviewCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar avaliação: $e');
    }
  }

  // ==================== DELETE ====================

  /// Deletar barbearia
  Future<void> deleteBarbershop(String id) async {
    try {
      // Deletar subcoleções primeiro
      await _deleteSubcollections(id);
      
      // Deletar documento principal
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar barbearia: $e');
    }
  }

  /// Deletar subcoleções
  Future<void> _deleteSubcollections(String barbershopId) async {
    try {
      // Deletar serviços
      final servicesSnapshot = await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('services')
          .get();
      
      for (final doc in servicesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Deletar galeria
      final gallerySnapshot = await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('gallery')
          .get();
      
      for (final doc in gallerySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Erro ao deletar subcoleções: $e');
    }
  }

  // ==================== SERVIÇOS ====================

  /// Adicionar serviço à barbearia
  Future<String> addService(String barbershopId, Map<String, dynamic> service) async {
    try {
      service['createdAt'] = FieldValue.serverTimestamp();
      final docRef = await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('services')
          .add(service);
      
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar serviço: $e');
    }
  }

  /// Listar serviços da barbearia
  Future<List<Map<String, dynamic>>> getServices(String barbershopId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('services')
          .get();
      
      return snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar serviços: $e');
    }
  }

  /// Stream de serviços
  Stream<List<Map<String, dynamic>>> getServicesStream(String barbershopId) {
    return _firestore
        .collection(_collection)
        .doc(barbershopId)
        .collection('services')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    });
  }

  /// Atualizar serviço
  Future<void> updateService(
    String barbershopId,
    String serviceId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('services')
          .doc(serviceId)
          .update(data);
    } catch (e) {
      throw Exception('Erro ao atualizar serviço: $e');
    }
  }

  /// Deletar serviço
  Future<void> deleteService(String barbershopId, String serviceId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('services')
          .doc(serviceId)
          .delete();
    } catch (e) {
      throw Exception('Erro ao deletar serviço: $e');
    }
  }

  // ==================== GALERIA ====================

  /// Adicionar foto à galeria
  Future<String> addGalleryImage(
    String barbershopId,
    String imageUrl,
  ) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('gallery')
          .add({
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar foto: $e');
    }
  }

  /// Listar fotos da galeria
  Future<List<Map<String, dynamic>>> getGallery(String barbershopId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('gallery')
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar galeria: $e');
    }
  }

  /// Stream da galeria
  Stream<List<Map<String, dynamic>>> getGalleryStream(String barbershopId) {
    return _firestore
        .collection(_collection)
        .doc(barbershopId)
        .collection('gallery')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    });
  }

  /// Deletar foto da galeria
  Future<void> deleteGalleryImage(String barbershopId, String imageId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(barbershopId)
          .collection('gallery')
          .doc(imageId)
          .delete();
    } catch (e) {
      throw Exception('Erro ao deletar foto: $e');
    }
  }

  // ==================== BUSCA ====================

  /// Buscar barbearias por nome
  Future<List<Barbershop>> searchBarbershops(String query) async {
    try {
      // Firestore não tem busca full-text nativa
      // Esta é uma solução simples usando startAt/endAt
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();
      
      return snapshot.docs
          .map((doc) => Barbershop.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar barbearias: $e');
    }
  }

  // ==================== ESTATÍSTICAS ====================

  /// Contar total de barbearias
  Future<int> countBarbershops() async {
    try {
      final snapshot = await _firestore.collection(_collection).count().get();
      return snapshot.count;
    } catch (e) {
      throw Exception('Erro ao contar barbearias: $e');
    }
  }

  /// Contar barbearias por dono
  Future<int> countBarbershopsByOwner(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .count()
          .get();
      return snapshot.count;
    } catch (e) {
      throw Exception('Erro ao contar barbearias do dono: $e');
    }
  }
}
