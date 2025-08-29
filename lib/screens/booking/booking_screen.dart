import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/services/database_service.dart';
import 'package:partyu/models/venue_model.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Venue? _venue;
  Service? _selectedService;
  String _startTime = '09:00';
  String _endTime = '18:00';
  int _numberOfPeople = 50;
  bool _isLoading = true;

  final List<String> _timeSlots = [
    '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
    '14:00', '15:00', '16:00', '17:00', '18:00', '19:00',
    '20:00', '21:00', '22:00', '23:00'
  ];

  @override
  void initState() {
    super.initState();
    _loadVenueData();
  }

  Future<void> _loadVenueData() async {
    final appProvider = context.read<AppProvider>();
    try {
      final venue = await DatabaseService.instance.getVenueById(appProvider.selectedVenueId);
      if (mounted && venue != null) {
        setState(() {
          _venue = venue;
          if (venue.services.isNotEmpty) {
            _selectedService = venue.services.first;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _calculateTotalPrice() {
    if (_selectedService == null) return 0.0;

    final duration = _calculateDuration();
    switch (_selectedService!.pricingType) {
      case 'hourly':
        return _selectedService!.price * duration;
      case 'per-person':
        return _selectedService!.price * _numberOfPeople;
      case 'daily':
        return _selectedService!.price;
      default:
        return _selectedService!.price;
    }
  }

  int _calculateDuration() {
    final start = TimeOfDay(
      hour: int.parse(_startTime.split(':')[0]),
      minute: int.parse(_startTime.split(':')[1]),
    );
    final end = TimeOfDay(
      hour: int.parse(_endTime.split(':')[0]),
      minute: int.parse(_endTime.split(':')[1]),
    );

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return ((endMinutes - startMinutes) / 60).round();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryPurple,
          ),
        ),
      );
    }

    if (_venue == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.read<AppProvider>().navigateBack();
            },
            icon: const Icon(LucideIcons.arrowLeft),
          ),
        ),
        body: const Center(
          child: Text('Profissional não encontrado'),
        ),
      );
    }

    final appProvider = context.watch<AppProvider>();
    final selectedDate = DateTime.parse(appProvider.selectedBookingDate);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Nova Reserva'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            appProvider.navigateBack();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Info
                  _buildDateInfo(selectedDate),
                  const SizedBox(height: 16),

                  // Service Selection
                  _buildServiceSelection(),
                  const SizedBox(height: 16),

                  // Time Selection
                  _buildTimeSelection(),
                  const SizedBox(height: 16),

                  // Additional Options
                  _buildAdditionalOptions(),
                  const SizedBox(height: 16),

                  // Summary
                  _buildSummary(),
                ],
              ),
            ),
          ),

          // Continue Button
          _buildContinueButton(appProvider),
        ],
      ),
    );
  }

  Widget _buildDateInfo(DateTime date) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.calendar,
              color: AppTheme.primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data do Evento',
                  style: TextStyle(
                    color: AppTheme.gray600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'pt_BR').format(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Container(
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
          const Text(
            'Selecione o Serviço',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: _venue!.services.map((service) {
              final isSelected = _selectedService?.id == service.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedService = service;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : AppTheme.gray50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryPurple : AppTheme.gray200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
                            color: isSelected ? AppTheme.primaryPurple : AppTheme.gray400,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? AppTheme.primaryPurple : AppTheme.gray900,
                                  ),
                                ),
                                if (service.description.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    service.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.gray600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            'R\$ ${service.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppTheme.primaryPurple : AppTheme.gray900,
                            ),
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

  Widget _buildTimeSelection() {
    return Container(
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
          const Text(
            'Horário',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Início',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.gray700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _startTime,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.gray50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.gray200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.gray200),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _timeSlots.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _startTime = value;
                            // Adjust end time if needed
                            final startIndex = _timeSlots.indexOf(_startTime);
                            final endIndex = _timeSlots.indexOf(_endTime);
                            if (endIndex <= startIndex) {
                              _endTime = _timeSlots[startIndex + 1];
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fim',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.gray700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _endTime,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.gray50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.gray200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.gray200),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _timeSlots.where((time) {
                        final startIndex = _timeSlots.indexOf(_startTime);
                        final timeIndex = _timeSlots.indexOf(time);
                        return timeIndex > startIndex;
                      }).map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _endTime = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Duração: ${_calculateDuration()} horas',
              style: const TextStyle(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Container(
      width: double.infinity,
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
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Informações Adicionais',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                const Icon(
                  LucideIcons.users,
                  color: AppTheme.gray600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Número de pessoas:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.gray700,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.gray200),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _numberOfPeople > 1 ? () {
                          setState(() {
                            _numberOfPeople--;
                          });
                        } : null,
                        icon: const Icon(LucideIcons.minus, size: 16),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _numberOfPeople.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.gray900,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _numberOfPeople++;
                          });
                        },
                        icon: const Icon(LucideIcons.plus, size: 16),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final totalPrice = _calculateTotalPrice();
    final depositPercentage = _selectedService?.depositPercentage ?? 10;
    final depositAmount = totalPrice * (depositPercentage / 100);

    return Container(
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
          const Text(
            'Resumo da Reserva',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Serviço', _selectedService?.name ?? ''),
          _buildSummaryRow('Duração', '${_calculateDuration()} horas'),
          _buildSummaryRow('Horário', '$_startTime - $_endTime'),
          _buildSummaryRow('Pessoas', _numberOfPeople.toString()),
          const Divider(height: 24),
          _buildSummaryRow('Total', 'R\$ ${totalPrice.toStringAsFixed(2)}', isTotal: true),
          _buildSummaryRow('Sinal ($depositPercentage%)', 'R\$ ${depositAmount.toStringAsFixed(2)}', isHighlighted: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.gray600,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlighted 
                  ? AppTheme.primaryPurple 
                  : isTotal 
                      ? AppTheme.gray900 
                      : AppTheme.gray700,
              fontWeight: isTotal || isHighlighted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(AppProvider appProvider) {
    if (_selectedService == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to checkout with booking data
              appProvider.navigateToScreen(AppScreen.checkout);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Prosseguir para Pagamento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}