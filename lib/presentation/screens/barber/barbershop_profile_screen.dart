import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/whatsapp_helper.dart';
import 'edit_barbershop_profile_screen.dart';
import 'reviews_screen.dart';
import 'gallery_management_screen.dart';
import 'services_management_screen.dart';

class BarbershopProfileScreen extends StatelessWidget {
  const BarbershopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - em produção virá do backend
    final barbershop = {
      'name': 'Barbearia Premium',
      'description':
          'A melhor barbearia da região! Especializada em cortes modernos e clássicos, barba e tratamentos capilares.',
      'rating': 4.8,
      'reviews': 120,
      'address': 'Rua das Flores, 123 - Centro',
      'phone': '(11) 98765-4321',
      'email': 'contato@barbeariapremi um.com',
      'workingHours': 'Seg-Sex: 9h-20h | Sáb: 9h-18h',
      'photoUrl': null,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil da Barbearia'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditBarbershopProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com foto e informações básicas
            Container(
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
                  // Foto da barbearia
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.textWhite,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: barbershop['photoUrl'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  barbershop['photoUrl'] as String,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.store,
                                size: 60,
                                color: AppColors.primary,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nome
                  Text(
                    barbershop['name'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Avaliação
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsScreen(
                            barbershopId: 'barbershop_1',
                            barbershopName: barbershop['name'] as String,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${barbershop['rating']} (${barbershop['reviews']} avaliações)',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.textWhite.withOpacity(0.8),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Descrição
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sobre',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    barbershop['description'] as String,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),

                  const SizedBox(height: 32),

                  // Informações de contato
                  Text(
                    'Informações de Contato',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _InfoCard(
                    icon: Icons.location_on,
                    label: 'Endereço',
                    value: barbershop['address'] as String,
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.phone,
                    label: 'Telefone',
                    value: barbershop['phone'] as String,
                    trailing: IconButton(
                      icon: const Icon(Icons.chat, color: AppColors.success),
                      onPressed: () async {
                        final success = await WhatsAppHelper.openWhatsApp(
                          phone: barbershop['phone'] as String,
                          message: 'Olá! Gostaria de mais informações.',
                        );
                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não foi possível abrir o WhatsApp'),
                            ),
                          );
                        }
                      },
                      tooltip: 'Abrir WhatsApp',
                    ),
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.email,
                    label: 'Email',
                    value: barbershop['email'] as String,
                  ),
                  const SizedBox(height: 12),

                  _InfoCard(
                    icon: Icons.access_time,
                    label: 'Horário de Funcionamento',
                    value: barbershop['workingHours'] as String,
                  ),

                  const SizedBox(height: 32),

                  // Galeria de fotos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Galeria',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GalleryManagementScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Adicionar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.textHint.withOpacity(0.2),
                            ),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: AppColors.textHint,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Serviços
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Serviços Oferecidos',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ServicesManagementScreen(),
                            ),
                          );
                        },
                        child: const Text('Gerenciar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _ServiceCard(
                    name: 'Corte de Cabelo',
                    price: 'R\$ 45,00',
                    duration: '30 min',
                  ),
                  const SizedBox(height: 12),
                  _ServiceCard(
                    name: 'Barba',
                    price: 'R\$ 30,00',
                    duration: '20 min',
                  ),
                  const SizedBox(height: 12),
                  _ServiceCard(
                    name: 'Corte + Barba',
                    price: 'R\$ 65,00',
                    duration: '45 min',
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String name;
  final String price;
  final String duration;

  const _ServiceCard({
    required this.name,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textHint.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.content_cut,
              color: AppColors.secondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            price,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
