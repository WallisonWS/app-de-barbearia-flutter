/// Modelo de avaliação de barbearia
/// 
/// Hierarquia: Cliente avalia Barbearia
/// Admin pode ver todas as avaliações
class ReviewModel {
  final String id;
  final String barbershopId;
  final String clientId;
  final String clientName;
  final double rating; // 1.0 a 5.0
  final String comment;
  final DateTime createdAt;
  final String? clientPhotoUrl;

  ReviewModel({
    required this.id,
    required this.barbershopId,
    required this.clientId,
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.clientPhotoUrl,
  });

  /// Converte para Map para armazenamento local
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barbershopId': barbershopId,
      'clientId': clientId,
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'clientPhotoUrl': clientPhotoUrl,
    };
  }

  /// Cria instância a partir de Map
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      barbershopId: json['barbershopId'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      clientPhotoUrl: json['clientPhotoUrl'] as String?,
    );
  }

  /// Cria cópia com modificações
  ReviewModel copyWith({
    String? id,
    String? barbershopId,
    String? clientId,
    String? clientName,
    double? rating,
    String? comment,
    DateTime? createdAt,
    String? clientPhotoUrl,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      barbershopId: barbershopId ?? this.barbershopId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      clientPhotoUrl: clientPhotoUrl ?? this.clientPhotoUrl,
    );
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, barbershopId: $barbershopId, clientName: $clientName, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Estatísticas de avaliações de uma barbearia
class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // {5: 50, 4: 30, 3: 15, 2: 3, 1: 2}

  ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  /// Calcula estatísticas a partir de uma lista de avaliações
  factory ReviewStats.fromReviews(List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return ReviewStats(
        averageRating: 0.0,
        totalReviews: 0,
        ratingDistribution: {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
      );
    }

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );

    final distribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in reviews) {
      final ratingInt = review.rating.round();
      distribution[ratingInt] = (distribution[ratingInt] ?? 0) + 1;
    }

    return ReviewStats(
      averageRating: totalRating / reviews.length,
      totalReviews: reviews.length,
      ratingDistribution: distribution,
    );
  }

  /// Retorna a porcentagem de cada nota
  Map<int, double> get ratingPercentages {
    if (totalReviews == 0) {
      return {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    }

    return ratingDistribution.map(
      (rating, count) => MapEntry(rating, (count / totalReviews) * 100),
    );
  }

  /// Formata a média para exibição (ex: "4.8")
  String get formattedAverage {
    return averageRating.toStringAsFixed(1);
  }
}
