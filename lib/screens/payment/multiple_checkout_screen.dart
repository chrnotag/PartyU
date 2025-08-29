import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:intl/intl.dart';

class GuideBookingData {
  final String professionalId;
  final String professionalName;
  final String category;
  final String serviceName;
  final String serviceDescription;
  final double price;
  final int depositPercentage;
  final int estimatedDuration;
  final double totalPrice;

  GuideBookingData({
    required this.professionalId,
    required this.professionalName,
    required this.category,
    required this.serviceName,
    required this.serviceDescription,
    required this.price,
    required this.depositPercentage,
    required this.estimatedDuration,
    required this.totalPrice,
  });
}

class MultipleCheckoutScreen extends StatefulWidget {
  const MultipleCheckoutScreen({super.key});

  @override
  State<MultipleCheckoutScreen> createState() => _MultipleCheckoutScreenState();
}

class _MultipleCheckoutScreenState extends State<MultipleCheckoutScreen> {
  String _selectedPaymentMethod = 'credit_card';
  bool _isProcessing = false;

  // Demo data - seria passado via provider
  final List<GuideBookingData> _bookings = [
    GuideBookingData(
      professionalId: '1',
      professionalName: 'Espaço Premium Events',
      category: 'Espaços',
      serviceName: 'Salão Principal',
      serviceDescription: 'Capacidade para 100 pessoas',
      price: 800.0,
      depositPercentage: 15,
      estimatedDuration: 6,
      totalPrice: 800.0,
    ),
    GuideBookingData(
      professionalId: '2',
      professionalName: 'DJ Marcus Silva',
      category: 'DJs',
      serviceName: 'Som Completo',
      serviceDescription: 'Equipamentos profissionais + DJ',
      price: 450.0,
      depositPercentage: 10,
      estimatedDuration: 8,
      totalPrice: 450.0,
    ),
    GuideBookingData(
      professionalId: '3',
      professionalName: 'Foto & Arte',
      category: 'Fotógrafos',
      serviceName: 'Cobertura Completa',
      serviceDescription: 'Fotos + edição profissional',
      price: 600.0,
      depositPercentage: 20,
      estimatedDuration: 6,
      totalPrice: 600.0,
    ),
  ];

  final String _eventDate = '2024-02-15';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'credit_card',
      'name': 'Cartão de Crédito',
      'icon': LucideIcons.creditCard,
      'description': 'Parcelamento em até 12x',
    },
    {
      'id': 'debit_card',
      'name': 'Cartão de Débito',
      'icon': LucideIcons.creditCard,
      'description': 'À vista com desconto',
    },
    {
      'id': 'pix',
      'name': 'PIX',
      'icon': LucideIcons.qrCode,
      'description': 'Instantâneo com desconto',
    },
  ];

  double get _totalAmount => _bookings.fold(0, (sum, booking) => sum + booking.totalPrice);
  
  double get _totalDeposit => _bookings.fold(0, (sum, booking) => 
    sum + (booking.totalPrice * (booking.depositPercentage / 100)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Finalizar Reservas'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.read<AppProvider>().navigateBack();
          },
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Event Summary
                  _buildEventSummary(),
                  const SizedBox(height: 16),

                  // Bookings List
                  _buildBookingsList(),
                  const SizedBox(height: 16),

                  // Payment Summary
                  _buildPaymentSummary(),
                  const SizedBox(height: 16),

                  // Payment Methods
                  _buildPaymentMethods(),
                  const SizedBox(height: 16),

                  // Important Info
                  _buildImportantInfo(),
                ],
              ),
            ),
          ),

          // Pay Button
          _buildPayButton(),
        ],
      ),
    );
  }

  Widget _buildEventSummary() {
    final date = DateTime.parse(_eventDate);
    final formattedDate = DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'pt_BR').format(date);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Seu Evento Completo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_bookings.length} serviços',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date
          Row(
            children: [
              const Icon(
                LucideIcons.calendar,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valor Total',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              Text(
                'R\$ ${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profissionais Selecionados',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: _bookings.map((booking) => _buildBookingCard(booking)).toList(),
        ),
      ],
    );
  }

  Widget _buildBookingCard(GuideBookingData booking) {
    final depositAmount = booking.totalPrice * (booking.depositPercentage / 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  booking.category,
                  style: const TextStyle(
                    color: AppTheme.primaryPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'R\$ ${booking.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Name
          Text(
            booking.professionalName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),

          // Service
          Text(
            booking.serviceName,
            style: const TextStyle(
              color: AppTheme.gray600,
            ),
          ),
          if (booking.serviceDescription.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              booking.serviceDescription,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.gray500,
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Footer
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Sinal: R\$ ${depositAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '~${booking.estimatedDuration}h',
                style: const TextStyle(
                  color: AppTheme.gray500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.receipt,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Resumo do Pagamento',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Summary rows
          _buildSummaryRow('Valor Total dos Serviços', 'R\$ ${_totalAmount.toStringAsFixed(2)}'),
          _buildSummaryRow('Total de Sinais (hoje)', 'R\$ ${_totalDeposit.toStringAsFixed(2)}', isHighlighted: true),
          _buildSummaryRow('Restante (pago aos profissionais)', 'R\$ ${(_totalAmount - _totalDeposit).toStringAsFixed(2)}'),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(
                  LucideIcons.info,
                  color: Colors.blue,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Os sinais garantem suas reservas. O restante será pago diretamente a cada profissional.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.gray600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlighted ? AppTheme.primaryPurple : AppTheme.gray700,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
              fontSize: isHighlighted ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Forma de Pagamento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: _paymentMethods.map((method) {
              final isSelected = _selectedPaymentMethod == method['id'];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = method['id'];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : AppTheme.gray50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryPurple : AppTheme.gray200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryPurple : AppTheme.gray400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              method['icon'] as IconData,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? AppTheme.primaryPurple : AppTheme.gray900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  method['description'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
                            color: isSelected ? AppTheme.primaryPurple : AppTheme.gray400,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.alertCircle,
                color: Colors.orange,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Informações Importantes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem('⏰', 'Cada profissional tem até 48h para confirmar sua reserva'),
          _buildInfoItem('💰', 'Os sinais ficam retidos até a conclusão do evento'),
          _buildInfoItem('📞', 'Você pode conversar diretamente com cada profissional'),
          _buildInfoItem('📅', 'Alterações devem ser solicitadas com antecedência'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.gray600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Processando...'),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.creditCard, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Confirmar Pagamento - R\$ ${_totalDeposit.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ao confirmar, você aceita nossos Termos de Uso e concorda com os prazos estabelecidos',
              style: TextStyle(
                color: AppTheme.gray500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      _showPaymentSuccessDialog();
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                LucideIcons.checkCircle,
                color: Colors.green,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pagamento Confirmado!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Suas ${_bookings.length} reservas foram confirmadas! Os profissionais têm até 48h para responder.',
              style: const TextStyle(
                color: AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AppProvider>().navigateToProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ver Minhas Reservas'),
            ),
          ),
        ],
      ),
    );
  }
}