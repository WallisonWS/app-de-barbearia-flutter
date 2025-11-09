import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review_model.dart';

/// Serviço para gerenciar avaliações localmente
/// 
/// Hierarquia respeitada:
/// - Cliente: pode criar avaliação
/// - Barbearia: pode ver suas avaliações
/// - Admin: pode ver todas as avaliações
/// 
/// Nota: Em produção, isso será substituído por Firebase
class LocalReviewService {
  static const String _reviewsKey = 'local_reviews';
  
  /// Adiciona uma nova avaliação
  /// Apenas clientes podem avaliar barbearias
  Future<bool> addReview(ReviewModel review) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reviews = await getAllReviews();
      
      // Verifica se o cliente já avaliou esta barbearia
      final existingIndex = reviews.indexWhere(
        (r) => r.barbershopId == review.barbershopId && 
               r.clientId == review.clientId,
      );
      
      if (existingIndex != -1) {
        // Atualiza avaliação existente
        reviews[existingIndex] = review;
      } else {
        // Adiciona nova avaliação
        reviews.add(review);
      }
      
      // Salva no SharedPreferences
      final jsonList = reviews.map((r) => r.toJson()).toList();
      await prefs.setString(_reviewsKey, jsonEncode(jsonList));
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Retorna todas as avaliações (apenas para Admin)
  Future<List<ReviewModel>> getAllReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_reviewsKey);
      
      if (jsonString == null) return [];
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  /// Retorna avaliações de uma barbearia específica
  /// Barbearia pode ver suas próprias avaliações
  Future<List<ReviewModel>> getReviewsByBarbershop(String barbershopId) async {
    final allReviews = await getAllReviews();
    return allReviews
        .where((review) => review.barbershopId == barbershopId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Mais recentes primeiro
  }
  
  /// Retorna avaliações feitas por um cliente
  /// Cliente pode ver suas próprias avaliações
  Future<List<ReviewModel>> getReviewsByClient(String clientId) async {
    final allReviews = await getAllReviews();
    return allReviews
        .where((review) => review.clientId == clientId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
  
  /// Retorna uma avaliação específica por ID
  Future<ReviewModel?> getReviewById(String reviewId) async {
    final allReviews = await getAllReviews();
    try {
      return allReviews.firstWhere((review) => review.id == reviewId);
    } catch (e) {
      return null;
    }
  }
  
  /// Verifica se um cliente já avaliou uma barbearia
  Future<bool> hasClientReviewed({
    required String barbershopId,
    required String clientId,
  }) async {
    final reviews = await getReviewsByBarbershop(barbershopId);
    return reviews.any((review) => review.clientId == clientId);
  }
  
  /// Retorna a avaliação de um cliente para uma barbearia
  Future<ReviewModel?> getClientReview({
    required String barbershopId,
    required String clientId,
  }) async {
    final reviews = await getReviewsByBarbershop(barbershopId);
    try {
      return reviews.firstWhere((review) => review.clientId == clientId);
    } catch (e) {
      return null;
    }
  }
  
  /// Calcula estatísticas de avaliações de uma barbearia
  Future<ReviewStats> getBarbershopStats(String barbershopId) async {
    final reviews = await getReviewsByBarbershop(barbershopId);
    return ReviewStats.fromReviews(reviews);
  }
  
  /// Exclui uma avaliação
  /// Apenas o próprio cliente ou Admin podem excluir
  Future<bool> deleteReview(String reviewId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reviews = await getAllReviews();
      
      reviews.removeWhere((review) => review.id == reviewId);
      
      final jsonList = reviews.map((r) => r.toJson()).toList();
      await prefs.setString(_reviewsKey, jsonEncode(jsonList));
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Limpa todas as avaliações (apenas para Admin ou desenvolvimento)
  Future<bool> clearAllReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_reviewsKey);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Retorna as N avaliações mais recentes de uma barbearia
  Future<List<ReviewModel>> getRecentReviews({
    required String barbershopId,
    int limit = 5,
  }) async {
    final reviews = await getReviewsByBarbershop(barbershopId);
    return reviews.take(limit).toList();
  }
  
  /// Retorna as avaliações com melhor nota de uma barbearia
  Future<List<ReviewModel>> getTopReviews({
    required String barbershopId,
    int limit = 5,
  }) async {
    final reviews = await getReviewsByBarbershop(barbershopId);
    reviews.sort((a, b) => b.rating.compareTo(a.rating));
    return reviews.take(limit).toList();
  }
  
  /// Retorna avaliações filtradas por nota mínima
  Future<List<ReviewModel>> getReviewsByMinRating({
    required String barbershopId,
    required double minRating,
  }) async {
    final reviews = await getReviewsByBarbershop(barbershopId);
    return reviews.where((review) => review.rating >= minRating).toList();
  }
  
  /// Adiciona avaliações mockadas para demonstração
  /// Útil para testes e desenvolvimento
  Future<void> seedMockReviews(String barbershopId) async {
    final mockReviews = [
      ReviewModel(
        id: 'review_1',
        barbershopId: barbershopId,
        clientId: 'client_1',
        clientName: 'João Silva',
        rating: 5.0,
        comment: 'Excelente atendimento! Corte perfeito e ambiente agradável.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'review_2',
        barbershopId: barbershopId,
        clientId: 'client_2',
        clientName: 'Maria Santos',
        rating: 4.5,
        comment: 'Muito bom! Profissionais qualificados e preço justo.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ReviewModel(
        id: 'review_3',
        barbershopId: barbershopId,
        clientId: 'client_3',
        clientName: 'Pedro Oliveira',
        rating: 5.0,
        comment: 'Melhor barbearia da região! Sempre saio satisfeito.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ReviewModel(
        id: 'review_4',
        barbershopId: barbershopId,
        clientId: 'client_4',
        clientName: 'Ana Costa',
        rating: 4.0,
        comment: 'Bom atendimento, mas o tempo de espera foi um pouco longo.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      ReviewModel(
        id: 'review_5',
        barbershopId: barbershopId,
        clientId: 'client_5',
        clientName: 'Carlos Ferreira',
        rating: 5.0,
        comment: 'Profissionais excelentes! Recomendo muito!',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
    
    for (final review in mockReviews) {
      await addReview(review);
    }
  }
}
