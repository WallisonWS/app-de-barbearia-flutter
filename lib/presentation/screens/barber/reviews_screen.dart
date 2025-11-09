import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/review_model.dart';
import '../../../data/services/local_review_service.dart';
import 'package:intl/intl.dart';

/// Tela de avaliações da barbearia
/// 
/// Hierarquia:
/// - Barbearia: visualiza suas avaliações
/// - Admin: visualiza todas as avaliações
class ReviewsScreen extends StatefulWidget {
  final String barbershopId;
  final String barbershopName;

  const ReviewsScreen({
    super.key,
    required this.barbershopId,
    required this.barbershopName,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _reviewService = LocalReviewService();
  List<ReviewModel> _reviews = [];
  ReviewStats? _stats;
  bool _isLoading = true;
  int _selectedFilter = 0; // 0: Todas, 5: 5 estrelas, 4: 4 estrelas, etc.

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);

    final reviews = await _reviewService.getReviewsByBarbershop(widget.barbershopId);
    final stats = await _reviewService.getBarbershopStats(widget.barbershopId);

    // Se não houver avaliações, adiciona dados mockados para demonstração
    if (reviews.isEmpty) {
      await _reviewService.seedMockReviews(widget.barbershopId);
      final newReviews = await _reviewService.getReviewsByBarbershop(widget.barbershopId);
      final newStats = await _reviewService.getBarbershopStats(widget.barbershopId);
      
      setState(() {
        _reviews = newReviews;
        _stats = newStats;
        _isLoading = false;
      });
    } else {
      setState(() {
        _reviews = reviews;
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  List<ReviewModel> get _filteredReviews {
    if (_selectedFilter == 0) return _reviews;
    return _reviews.where((r) => r.rating.round() == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reviews.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadReviews,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsHeader(),
                        _buildRatingDistribution(),
                        _buildFilterChips(),
                        _buildReviewsList(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outline,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma avaliação ainda',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seja o primeiro a avaliar!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    if (_stats == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            _stats!.formattedAverage,
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          _buildStars(_stats!.averageRating),
          const SizedBox(height: 12),
          Text(
            '${_stats!.totalReviews} avaliações',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 28);
        } else if (index < rating) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 28);
        } else {
          return Icon(Icons.star_outline, color: Colors.amber.withOpacity(0.5), size: 28);
        }
      }),
    );
  }

  Widget _buildRatingDistribution() {
    if (_stats == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribuição de Notas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final count = _stats!.ratingDistribution[rating] ?? 0;
            final percentage = _stats!.ratingPercentages[rating] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        Text(
                          '$rating',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.textHint.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildFilterChip('Todas', 0, _reviews.length),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final count = _reviews.where((r) => r.rating.round() == rating).length;
            return _buildFilterChip('$rating ⭐', rating, count);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int value, int count) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
        },
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    final filteredReviews = _filteredReviews;

    if (filteredReviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Text(
            'Nenhuma avaliação com este filtro',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ...filteredReviews.map((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: review.clientPhotoUrl != null
                    ? ClipOval(
                        child: Image.network(
                          review.clientPhotoUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        review.clientName[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.clientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      dateFormat.format(review.createdAt),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildCompactStars(review.rating),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index < rating) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        } else {
          return Icon(Icons.star_outline, color: Colors.amber.withOpacity(0.3), size: 16);
        }
      }),
    );
  }
}
