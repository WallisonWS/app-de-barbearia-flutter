import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BarbershopDetailsAdminScreen extends StatefulWidget {
  final Map<String, dynamic> barbershop;

  const BarbershopDetailsAdminScreen({
    super.key,
    required this.barbershop,
  });

  @override
  State<BarbershopDetailsAdminScreen> createState() =>
      _BarbershopDetailsAdminScreenState();
}

class _BarbershopDetailsAdminScreenState
    extends State<BarbershopDetailsAdminScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ownerController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  
  String? _selectedLatitude;
  String? _selectedLongitude;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.barbershop['name']);
    _ownerController = TextEditingController(text: widget.barbershop['owner']);
    _addressController = TextEditingController(text: widget.barbershop['address']);
    _phoneController = TextEditingController(text: widget.barbershop['phone']);
    _emailController = TextEditingController(text: widget.barbershop['email']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _openMapSelector() async {
    // Abre o Google Maps para o usuário selecionar a localização
    final address = _addressController.text.isEmpty 
        ? 'Brasil' 
        : Uri.encodeComponent(_addressController.text);
    
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      
      // Mostrar dialog explicativo
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Selecione a Localização'),
            content: const Text(
              'No Google Maps:\n\n'
              '1. Encontre a localização exata da barbearia\n'
              '2. Toque e segure no local para soltar um pin\n'
              '3. Copie as coordenadas que aparecem\n'
              '4. Cole aqui quando voltar ao app\n\n'
              'As coordenadas aparecem no formato:\n'
              '-23.550520, -46.633308'
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendi'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showCoordinatesDialog();
                },
                child: const Text('Inserir Coordenadas'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showCoordinatesDialog() {
    final latController = TextEditingController();
    final lngController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inserir Coordenadas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: '-23.550520',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lngController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: '-46.633308',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedLatitude = latController.text;
                _selectedLongitude = lngController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Coordenadas salvas!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _viewOnMap() async {
    if (_selectedLatitude != null && _selectedLongitude != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=$_selectedLatitude,$_selectedLongitude';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma coordenada definida. Use o botão "Selecionar no Mapa" primeiro.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Barbearia'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Card(
              color: _getStatusColor(widget.barbershop['status']),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(widget.barbershop['status']),
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.barbershop['status'] ?? 'Pendente',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Informações Básicas
            const Text(
              'Informações Básicas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da Barbearia',
                prefixIcon: Icon(Icons.store),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _ownerController,
              decoration: const InputDecoration(
                labelText: 'Proprietário',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: 24),
            
            // Localização
            const Text(
              'Localização',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Endereço Completo',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                helperText: 'Rua, número, bairro, cidade - UF',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            
            // Botões de Mapa
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openMapSelector,
                    icon: const Icon(Icons.map),
                    label: const Text('Selecionar no Mapa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _viewOnMap,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Ver no Mapa'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B4513),
                      side: const BorderSide(color: Color(0xFF8B4513)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            if (_selectedLatitude != null && _selectedLongitude != null) ...[
              const SizedBox(height: 12),
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Coordenadas Definidas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Lat: $_selectedLatitude, Lng: $_selectedLongitude',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Estatísticas
            const Text(
              'Estatísticas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Avaliação',
                    widget.barbershop['rating'] ?? '4.8',
                    Icons.star,
                    Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Avaliações',
                    widget.barbershop['reviews'] ?? '120',
                    Icons.rate_review,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Ações
            const Text(
              'Ações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (widget.barbershop['status'] == 'Pendente') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _changeStatus('Ativa'),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Aprovar Barbearia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _changeStatus('Rejeitada'),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Rejeitar Barbearia'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
            
            if (widget.barbershop['status'] == 'Ativa') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _changeStatus('Inativa'),
                  icon: const Icon(Icons.block),
                  label: const Text('Desativar Barbearia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
            
            if (widget.barbershop['status'] == 'Inativa') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _changeStatus('Ativa'),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Reativar Barbearia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _deleteBarbershop,
                icon: const Icon(Icons.delete_forever),
                label: const Text('Excluir Barbearia'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Ativa':
        return Colors.green;
      case 'Pendente':
        return Colors.orange;
      case 'Inativa':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Ativa':
        return Icons.check_circle;
      case 'Pendente':
        return Icons.pending;
      case 'Inativa':
        return Icons.block;
      default:
        return Icons.help;
    }
  }
  
  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alterações salvas com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _changeStatus(String newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alterar Status para $newStatus?'),
        content: Text('Tem certeza que deseja alterar o status desta barbearia para $newStatus?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Status alterado para $newStatus!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
  
  void _deleteBarbershop() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Barbearia'),
        content: const Text(
          'Tem certeza que deseja excluir esta barbearia?\n\n'
          'Esta ação não pode ser desfeita e todos os dados serão perdidos.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Volta para a lista
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Barbearia excluída!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
