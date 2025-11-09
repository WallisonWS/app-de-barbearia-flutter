import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

/// Serviço Firebase Storage para upload e gerenciamento de imagens
/// HIERARQUIA: Cada usuário pode fazer upload apenas de suas próprias imagens
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // ==================== SELEÇÃO DE IMAGEM ====================

  /// Selecionar imagem da galeria
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        return null;
      }

      return File(image.path);
    } catch (e) {
      throw Exception('Erro ao selecionar imagem: $e');
    }
  }

  /// Selecionar imagem da câmera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) {
        return null;
      }

      return File(image.path);
    } catch (e) {
      throw Exception('Erro ao capturar imagem: $e');
    }
  }

  /// Selecionar múltiplas imagens
  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultipleImages(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      throw Exception('Erro ao selecionar imagens: $e');
    }
  }

  // ==================== UPLOAD ====================

  /// Upload de foto de perfil de usuário
  Future<String> uploadUserProfileImage(String userId, File imageFile) async {
    try {
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final Reference ref = _storage.ref().child('users/$userId/profile/$fileName');

      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload da foto de perfil: $e');
    }
  }

  /// Upload de foto para galeria da barbearia
  Future<String> uploadBarbershopGalleryImage(
    String barbershopId,
    File imageFile,
  ) async {
    try {
      final String fileName = 'gallery_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final Reference ref = _storage.ref().child('barbershops/$barbershopId/gallery/$fileName');

      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'barbershopId': barbershopId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload da foto da galeria: $e');
    }
  }

  /// Upload de foto de serviço
  Future<String> uploadServiceImage(
    String barbershopId,
    String serviceId,
    File imageFile,
  ) async {
    try {
      final String fileName = 'service_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final Reference ref = _storage.ref().child('barbershops/$barbershopId/services/$serviceId/$fileName');

      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'barbershopId': barbershopId,
            'serviceId': serviceId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Erro ao fazer upload da foto do serviço: $e');
    }
  }

  /// Upload com progresso
  Stream<double> uploadWithProgress(String uploadPath, File imageFile) {
    final Reference ref = _storage.ref().child(uploadPath);
    final UploadTask uploadTask = ref.putFile(imageFile);

    return uploadTask.snapshotEvents.map((snapshot) {
      return snapshot.bytesTransferred / snapshot.totalBytes;
    });
  }

  // ==================== DELETE ====================

  /// Deletar imagem por URL
  Future<void> deleteImageByUrl(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Erro ao deletar imagem: $e');
    }
  }

  /// Deletar foto de perfil de usuário
  Future<void> deleteUserProfileImage(String userId, String imageUrl) async {
    try {
      await deleteImageByUrl(imageUrl);
    } catch (e) {
      throw Exception('Erro ao deletar foto de perfil: $e');
    }
  }

  /// Deletar foto da galeria da barbearia
  Future<void> deleteBarbershopGalleryImage(String imageUrl) async {
    try {
      await deleteImageByUrl(imageUrl);
    } catch (e) {
      throw Exception('Erro ao deletar foto da galeria: $e');
    }
  }

  /// Deletar todas as fotos de uma pasta
  Future<void> deleteFolder(String folderPath) async {
    try {
      final Reference ref = _storage.ref().child(folderPath);
      final ListResult result = await ref.listAll();

      // Deletar todos os arquivos
      for (final Reference fileRef in result.items) {
        await fileRef.delete();
      }

      // Deletar subpastas recursivamente
      for (final Reference folderRef in result.prefixes) {
        await deleteFolder(folderRef.fullPath);
      }
    } catch (e) {
      throw Exception('Erro ao deletar pasta: $e');
    }
  }

  // ==================== LISTAGEM ====================

  /// Listar imagens de uma pasta
  Future<List<String>> listImages(String folderPath) async {
    try {
      final Reference ref = _storage.ref().child(folderPath);
      final ListResult result = await ref.listAll();

      final List<String> urls = [];
      for (final Reference fileRef in result.items) {
        final String url = await fileRef.getDownloadURL();
        urls.add(url);
      }

      return urls;
    } catch (e) {
      throw Exception('Erro ao listar imagens: $e');
    }
  }

  /// Listar fotos da galeria da barbearia
  Future<List<String>> listBarbershopGalleryImages(String barbershopId) async {
    try {
      return await listImages('barbershops/$barbershopId/gallery');
    } catch (e) {
      throw Exception('Erro ao listar fotos da galeria: $e');
    }
  }

  // ==================== METADADOS ====================

  /// Obter metadados de uma imagem
  Future<FullMetadata> getImageMetadata(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Erro ao obter metadados: $e');
    }
  }

  /// Atualizar metadados de uma imagem
  Future<void> updateImageMetadata(
    String imageUrl,
    Map<String, String> customMetadata,
  ) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.updateMetadata(
        SettableMetadata(customMetadata: customMetadata),
      );
    } catch (e) {
      throw Exception('Erro ao atualizar metadados: $e');
    }
  }

  // ==================== HELPERS ====================

  /// Verificar se arquivo é uma imagem válida
  bool isValidImageFile(File file) {
    final String extension = path.extension(file.path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(extension);
  }

  /// Obter tamanho do arquivo em MB
  double getFileSizeInMB(File file) {
    final int bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// Verificar se arquivo excede tamanho máximo (5MB)
  bool exceedsMaxSize(File file, {double maxSizeMB = 5.0}) {
    return getFileSizeInMB(file) > maxSizeMB;
  }

  // ==================== COMPRESSÃO ====================

  /// Nota: Para compressão de imagens, recomenda-se usar o pacote flutter_image_compress
  /// Este método é um placeholder para referência futura
  
  /*
  Future<File> compressImage(File imageFile) async {
    // Implementar com flutter_image_compress
    // final result = await FlutterImageCompress.compressAndGetFile(
    //   imageFile.absolute.path,
    //   targetPath,
    //   quality: 85,
    // );
    // return File(result.path);
    throw UnimplementedError('Compressão de imagem não implementada');
  }
  */
}
