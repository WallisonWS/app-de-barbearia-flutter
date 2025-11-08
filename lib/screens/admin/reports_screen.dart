import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Últimos 7 dias';
  
  final List<String> _periods = [
    'Últimos 7 dias',
    'Últimos 30 dias',
    'Últimos 3 meses',
    'Último ano',
    'Todo período',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios e Estatísticas'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seletor de período
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF8B4513)),
                    const SizedBox(width: 12),
                    const Text(
                      'Período:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedPeriod,
                        isExpanded: true,
                        items: _periods.map((String period) {
                          return DropdownMenuItem<String>(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPeriod = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Visão Geral
            const Text(
              'Visão Geral',
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
                    'Total de Barbearias',
                    '156',
                    Icons.store,
                    Colors.blue,
                    '+12 esta semana',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Usuários Ativos',
                    '12.5K',
                    Icons.people,
                    Colors.green,
                    '+340 esta semana',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Agendamentos',
                    '3.2K',
                    Icons.calendar_month,
                    Colors.orange,
                    '+89 hoje',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Receita Total',
                    'R\$ 4.7K',
                    Icons.attach_money,
                    Colors.purple,
                    '+R\$ 450 esta semana',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Estatísticas Detalhadas
            const Text(
              'Estatísticas Detalhadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildDetailCard(
              'Barbearias por Status',
              [
                _buildDetailRow('Ativas', '142', Colors.green, '91%'),
                _buildDetailRow('Pendentes', '8', Colors.orange, '5%'),
                _buildDetailRow('Inativas', '6', Colors.red, '4%'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildDetailCard(
              'Usuários por Tipo',
              [
                _buildDetailRow('Clientes', '11.2K', Colors.blue, '90%'),
                _buildDetailRow('Barbeiros', '1.1K', Colors.purple, '9%'),
                _buildDetailRow('Administradores', '156', Colors.orange, '1%'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildDetailCard(
              'Agendamentos por Status',
              [
                _buildDetailRow('Confirmados', '2.1K', Colors.green, '66%'),
                _buildDetailRow('Pendentes', '890', Colors.orange, '28%'),
                _buildDetailRow('Cancelados', '210', Colors.red, '6%'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildDetailCard(
              'Receita por Plano',
              [
                _buildDetailRow('Plano Premium', 'R\$ 3.2K', Colors.purple, '68%'),
                _buildDetailRow('Plano Básico', 'R\$ 1.5K', Colors.blue, '32%'),
                _buildDetailRow('Comissões', 'R\$ 0', Colors.grey, '0%'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Top Barbearias
            const Text(
              'Top 5 Barbearias',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTopBarbershopCard(1, 'Barbearia Premium', '4.9⭐', '450 agendamentos'),
            _buildTopBarbershopCard(2, 'Corte Fino', '4.8⭐', '380 agendamentos'),
            _buildTopBarbershopCard(3, 'Estilo Masculino', '4.7⭐', '320 agendamentos'),
            _buildTopBarbershopCard(4, 'Barba & Bigode', '4.6⭐', '290 agendamentos'),
            _buildTopBarbershopCard(5, 'The Barber Shop', '4.5⭐', '250 agendamentos'),
            
            const SizedBox(height: 24),
            
            // Botões de Ação
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exportando relatório em PDF...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Exportar PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exportando relatório em Excel...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.table_chart),
                label: const Text('Exportar Excel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF8B4513),
                  side: const BorderSide(color: Color(0xFF8B4513)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, Color color, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              percentage,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopBarbershopCard(int position, String name, String rating, String bookings) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: position <= 3 ? const Color(0xFF8B4513) : Colors.grey,
          foregroundColor: Colors.white,
          child: Text(
            '$position',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(bookings),
        trailing: Text(
          rating,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
