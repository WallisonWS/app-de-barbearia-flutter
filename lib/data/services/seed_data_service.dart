import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/barbershop_model.dart';

/// Serviço para popular dados iniciais no Firestore
class SeedDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Popular todos os dados iniciais
  Future<void> seedAllData() async {
    try {
      print('🌱 Iniciando seed de dados...');

      // 1. Criar usuários de teste
      await _seedUsers();

      // 2. Criar barbearias de exemplo
      await _seedBarbershops();

      // 3. Criar serviços para cada barbearia
      await _seedServices();

      print('✅ Seed de dados concluído com sucesso!');
    } catch (e) {
      print('❌ Erro ao fazer seed de dados: $e');
      rethrow;
    }
  }

  /// Criar usuários de teste
  Future<void> _seedUsers() async {
    print('👥 Criando usuários de teste...');

    final users = [
      {
        'email': 'admin@barbershop.com',
        'password': 'admin123',
        'name': 'Admin Sistema',
        'role': 'admin',
      },
      {
        'email': 'barbearia1@email.com',
        'password': 'barber123',
        'name': 'Barbearia Premium',
        'role': 'barbershop',
      },
      {
        'email': 'barbeiro1@email.com',
        'password': 'barber123',
        'name': 'João Silva',
        'role': 'barber',
      },
      {
        'email': 'cliente1@email.com',
        'password': 'cliente123',
        'name': 'Carlos Santos',
        'role': 'client',
      },
    ];

    for (final userData in users) {
      try {
        // Verificar se usuário já existe
        final existingUser = await _firestore
            .collection('users')
            .where('email', isEqualTo: userData['email'])
            .get();

        if (existingUser.docs.isEmpty) {
          // Criar usuário no Authentication
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: userData['email'] as String,
            password: userData['password'] as String,
          );

          // Criar documento no Firestore
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'name': userData['name'],
            'email': userData['email'],
            'role': userData['role'],
            'photoUrl': null,
            'phone': null,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          print('✅ Usuário criado: ${userData['email']}');
        } else {
          print('⚠️  Usuário já existe: ${userData['email']}');
        }
      } catch (e) {
        print('❌ Erro ao criar usuário ${userData['email']}: $e');
      }
    }
  }

  /// Criar barbearias de exemplo
  Future<void> _seedBarbershops() async {
    print('🏢 Criando barbearias de exemplo...');

    // Buscar ID do dono (barbearia1@email.com)
    final ownerQuery = await _firestore
        .collection('users')
        .where('email', isEqualTo: 'barbearia1@email.com')
        .get();

    if (ownerQuery.docs.isEmpty) {
      print('❌ Dono da barbearia não encontrado');
      return;
    }

    final ownerId = ownerQuery.docs.first.id;

    final barbershops = [
      {
        'name': 'Barbearia Premium',
        'description': 'A melhor barbearia da cidade! Cortes modernos, ambiente aconchegante e profissionais experientes.',
        'ownerId': ownerId,
        'address': {
          'street': 'Rua das Flores',
          'number': '123',
          'complement': 'Sala 1',
          'neighborhood': 'Centro',
          'city': 'São Paulo',
          'state': 'SP',
          'zipCode': '01310-100',
        },
        'contact': {
          'phone': '(11) 98765-4321',
          'email': 'contato@barbeariapremium.com',
          'whatsapp': '5511987654321',
        },
        'hours': {
          'monday': '09:00 - 19:00',
          'tuesday': '09:00 - 19:00',
          'wednesday': '09:00 - 19:00',
          'thursday': '09:00 - 19:00',
          'friday': '09:00 - 20:00',
          'saturday': '09:00 - 18:00',
          'sunday': 'Fechado',
        },
        'rating': 4.8,
        'reviewCount': 127,
        'photoUrl': null,
      },
      {
        'name': 'Barbearia Tradicional',
        'description': 'Tradição e qualidade há mais de 20 anos. Cortes clássicos e modernos.',
        'ownerId': ownerId,
        'address': {
          'street': 'Av. Paulista',
          'number': '1000',
          'complement': null,
          'neighborhood': 'Bela Vista',
          'city': 'São Paulo',
          'state': 'SP',
          'zipCode': '01310-200',
        },
        'contact': {
          'phone': '(11) 91234-5678',
          'email': 'contato@tradicional.com',
          'whatsapp': '5511912345678',
        },
        'hours': {
          'monday': '08:00 - 18:00',
          'tuesday': '08:00 - 18:00',
          'wednesday': '08:00 - 18:00',
          'thursday': '08:00 - 18:00',
          'friday': '08:00 - 19:00',
          'saturday': '08:00 - 17:00',
          'sunday': 'Fechado',
        },
        'rating': 4.5,
        'reviewCount': 89,
        'photoUrl': null,
      },
      {
        'name': 'Barbearia Moderna',
        'description': 'Estilo e inovação! Os cortes mais modernos da cidade.',
        'ownerId': ownerId,
        'address': {
          'street': 'Rua Augusta',
          'number': '500',
          'complement': 'Loja 2',
          'neighborhood': 'Consolação',
          'city': 'São Paulo',
          'state': 'SP',
          'zipCode': '01305-000',
        },
        'contact': {
          'phone': '(11) 99876-5432',
          'email': 'contato@moderna.com',
          'whatsapp': '5511998765432',
        },
        'hours': {
          'monday': '10:00 - 20:00',
          'tuesday': '10:00 - 20:00',
          'wednesday': '10:00 - 20:00',
          'thursday': '10:00 - 20:00',
          'friday': '10:00 - 21:00',
          'saturday': '10:00 - 20:00',
          'sunday': '10:00 - 16:00',
        },
        'rating': 4.9,
        'reviewCount': 203,
        'photoUrl': null,
      },
    ];

    for (final barbershopData in barbershops) {
      try {
        // Verificar se barbearia já existe
        final existingBarbershop = await _firestore
            .collection('barbershops')
            .where('name', isEqualTo: barbershopData['name'])
            .get();

        if (existingBarbershop.docs.isEmpty) {
          barbershopData['createdAt'] = FieldValue.serverTimestamp();
          barbershopData['updatedAt'] = FieldValue.serverTimestamp();

          await _firestore.collection('barbershops').add(barbershopData);
          print('✅ Barbearia criada: ${barbershopData['name']}');
        } else {
          print('⚠️  Barbearia já existe: ${barbershopData['name']}');
        }
      } catch (e) {
        print('❌ Erro ao criar barbearia ${barbershopData['name']}: $e');
      }
    }
  }

  /// Criar serviços para cada barbearia
  Future<void> _seedServices() async {
    print('✂️  Criando serviços...');

    final barbershops = await _firestore.collection('barbershops').get();

    final services = [
      {
        'name': 'Corte Simples',
        'description': 'Corte de cabelo tradicional',
        'price': 35.0,
        'durationMinutes': 30,
        'isActive': true,
      },
      {
        'name': 'Corte + Barba',
        'description': 'Corte de cabelo e barba',
        'price': 50.0,
        'durationMinutes': 45,
        'isActive': true,
      },
      {
        'name': 'Barba',
        'description': 'Apenas barba',
        'price': 25.0,
        'durationMinutes': 20,
        'isActive': true,
      },
      {
        'name': 'Corte Premium',
        'description': 'Corte diferenciado com finalização',
        'price': 60.0,
        'durationMinutes': 60,
        'isActive': true,
      },
      {
        'name': 'Pacote Completo',
        'description': 'Corte, barba, sobrancelha e hidratação',
        'price': 90.0,
        'durationMinutes': 90,
        'isActive': true,
      },
    ];

    for (final barbershop in barbershops.docs) {
      for (final serviceData in services) {
        try {
          // Verificar se serviço já existe
          final existingService = await barbershop.reference
              .collection('services')
              .where('name', isEqualTo: serviceData['name'])
              .get();

          if (existingService.docs.isEmpty) {
            serviceData['createdAt'] = FieldValue.serverTimestamp();

            await barbershop.reference.collection('services').add(serviceData);
          }
        } catch (e) {
          print('❌ Erro ao criar serviço: $e');
        }
      }

      print('✅ Serviços criados para: ${barbershop.data()['name']}');
    }
  }

  /// Limpar todos os dados (usar com cuidado!)
  Future<void> clearAllData() async {
    print('🗑️  Limpando todos os dados...');

    try {
      // Deletar barbearias
      final barbershops = await _firestore.collection('barbershops').get();
      for (final doc in barbershops.docs) {
        await doc.reference.delete();
      }

      // Deletar agendamentos
      final appointments = await _firestore.collection('appointments').get();
      for (final doc in appointments.docs) {
        await doc.reference.delete();
      }

      // Deletar usuários do Firestore
      final users = await _firestore.collection('users').get();
      for (final doc in users.docs) {
        await doc.reference.delete();
      }

      print('✅ Dados limpos com sucesso!');
    } catch (e) {
      print('❌ Erro ao limpar dados: $e');
    }
  }

  /// Verificar se já existem dados
  Future<bool> hasData() async {
    try {
      final barbershops = await _firestore.collection('barbershops').limit(1).get();
      return barbershops.docs.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar dados: $e');
      return false;
    }
  }
}
