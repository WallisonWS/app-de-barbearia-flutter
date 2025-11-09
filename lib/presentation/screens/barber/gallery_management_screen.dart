import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class GalleryManagementScreen extends StatefulWidget {
  const GalleryManagementScreen({super.key});

  @override
  State<GalleryManagementScreen> createState() =>
      _GalleryManagementScreenState();
}

class _GalleryManagementScreenState extends State<GalleryManagementScreen> {
  // Mock data - em produção virá do backend
  List<GalleryPhoto> photos = [
    GalleryPhoto(
      id: '1',
      url: 'https://via.placeholder.com/300',
      uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    GalleryPhoto(
      id: '2',
      url: 'https://via.placeholder.com/300',
      uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    GalleryPhoto(
      id: '3',
      url: 'https://via.placeholder.com/300',
      uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  bool _isLoading = false;

  Future<void> _addPhoto() async {
    setState(() {
      _isLoading = true;
    });

    // Simular upload de foto
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      photos.insert(
        0,
        GalleryPhoto(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          url: 'https://via.placeholder.com/300',
          uploadedAt: DateTime.now(),
        ),
      );
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto adicionada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _deletePhoto(String photoId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir esta foto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        photos.removeWhere((photo) => photo.id == photoId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto excluída com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _viewPhoto(GalleryPhoto photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        photo.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            color: AppColors.surface,
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: AppColors.textHint,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Adicionada em ${_formatDate(photo.uploadedAt)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: AppColors.error,
                            onPressed: () {
                              Navigator.pop(context);
                              _deletePhoto(photo.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Galeria'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
      ),
      body: Column(
        children: [
          // Header com informações
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.photo_library,
                  size: 60,
                  color: AppColors.textWhite,
                ),
                const SizedBox(height: 16),
                Text(
                  '${photos.length} ${photos.length == 1 ? 'foto' : 'fotos'} na galeria',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione fotos para mostrar seu trabalho',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textWhite.withOpacity(0.9),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Grid de fotos
          Expanded(
            child: photos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 80,
                          color: AppColors.textHint.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma foto na galeria',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione fotos para começar',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textHint,
                                  ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      return GestureDetector(
                        onTap: () => _viewPhoto(photo),
                        child: Hero(
                          tag: photo.id,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    photo.url,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        color: AppColors.surface,
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: AppColors.textHint,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () => _deletePhoto(photo.id),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _addPhoto,
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textWhite,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textWhite,
                  ),
                ),
              )
            : const Icon(Icons.add_photo_alternate),
        label: Text(_isLoading ? 'Adicionando...' : 'Adicionar Foto'),
      ),
    );
  }
}

class GalleryPhoto {
  final String id;
  final String url;
  final DateTime uploadedAt;

  GalleryPhoto({
    required this.id,
    required this.url,
    required this.uploadedAt,
  });
}
