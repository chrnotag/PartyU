import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:intl/intl.dart';

class EventGuideScreen extends StatefulWidget {
  const EventGuideScreen({super.key});

  @override
  State<EventGuideScreen> createState() => _EventGuideScreenState();
}

class _EventGuideScreenState extends State<EventGuideScreen> {
  int _currentStep = 0;
  
  // Step 1: Event Type
  String _selectedEventType = '';
  final List<Map<String, dynamic>> _eventTypes = [
    {'id': 'wedding', 'name': 'Casamento', 'icon': LucideIcons.heart, 'color': const Color(0xFFEC4899)},
    {'id': 'birthday', 'name': 'Aniversário', 'icon': LucideIcons.cake, 'color': const Color(0xFFF59E0B)},
    {'id': 'corporate', 'name': 'Corporativo', 'icon': LucideIcons.briefcase, 'color': const Color(0xFF3B82F6)},
    {'id': 'graduation', 'name': 'Formatura', 'icon': LucideIcons.graduationCap, 'color': const Color(0xFF10B981)},
    {'id': 'party', 'name': 'Festa', 'icon': LucideIcons.music, 'color': const Color(0xFF8B5CF6)},
    {'id': 'other', 'name': 'Outro', 'icon': LucideIcons.moreHorizontal, 'color': const Color(0xFF6B7280)},
  ];

  // Step 2: Event Size
  String _selectedSize = '';
  final List<Map<String, String>> _eventSizes = [
    {'id': 'small', 'name': 'Pequeno', 'description': 'Até 30 pessoas'},
    {'id': 'medium', 'name': 'Médio', 'description': '30-100 pessoas'},
    {'id': 'large', 'name': 'Grande', 'description': '100-300 pessoas'},
    {'id': 'xlarge', 'name': 'Muito Grande', 'description': 'Mais de 300 pessoas'},
  ];

  // Step 3: Budget
  String _selectedBudget = '';
  final List<Map<String, String>> _budgetRanges = [
    {'id': 'low', 'name': 'Econômico', 'description': 'Até R\$ 2.000'},
    {'id': 'medium', 'name': 'Intermediário', 'description': 'R\$ 2.000 - R\$ 8.000'},
    {'id': 'high', 'name': 'Premium', 'description': 'R\$ 8.000 - R\$ 20.000'},
    {'id': 'luxury', 'name': 'Luxo', 'description': 'Acima de R\$ 20.000'},
  ];

  // Step 4: Services
  final Map<String, bool> _selectedServices = {};
  final Map<String, List<Map<String, dynamic>>> _servicesByCategory = {
    'Essenciais': [
      {'id': 'venue', 'name': 'Espaço/Local', 'icon': LucideIcons.building, 'priority': 'high'},
      {'id': 'catering', 'name': 'Buffet/Catering', 'icon': LucideIcons.utensils, 'priority': 'high'},
    ],
    'Audio e Visual': [
      {'id': 'dj', 'name': 'DJ/Música', 'icon': LucideIcons.music, 'priority': 'medium'},
      {'id': 'photography', 'name': 'Fotografia', 'icon': LucideIcons.camera, 'priority': 'medium'},
      {'id': 'video', 'name': 'Filmagem', 'icon': LucideIcons.video, 'priority': 'low'},
    ],
    'Decoração': [
      {'id': 'decoration', 'name': 'Decoração', 'icon': LucideIcons.sparkles, 'priority': 'medium'},
      {'id': 'flowers', 'name': 'Flores', 'icon': LucideIcons.flower, 'priority': 'low'},
      {'id': 'lighting', 'name': 'Iluminação', 'icon': LucideIcons.lightbulb, 'priority': 'low'},
    ],
    'Outros': [
      {'id': 'security', 'name': 'Segurança', 'icon': LucideIcons.shield, 'priority': 'low'},
      {'id': 'transport', 'name': 'Transporte', 'icon': LucideIcons.car, 'priority': 'low'},
      {'id': 'animation', 'name': 'Animação', 'icon': LucideIcons.smile, 'priority': 'low'},
    ],
  };

  // Step 5: Date and Summary
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    // Auto-select essential services
    _selectedServices['venue'] = true;
    _selectedServices['catering'] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              context.read<AppProvider>().navigateBack();
            }
          },
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: const Text('Guia Prático IA'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AppProvider>().navigateBack();
            },
            child: const Text('Pular'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress
          _buildProgress(),

          // Content
          Expanded(
            child: _buildStepContent(),
          ),

          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              final isActive = index <= _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.primaryPurple
                              : isActive
                                  ? AppTheme.primaryPurple
                                  : AppTheme.gray300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: isCompleted
                            ? const Icon(LucideIcons.check, color: Colors.white, size: 14)
                            : Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: isActive ? Colors.white : AppTheme.gray500,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                      if (index < 4)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: isCompleted ? AppTheme.primaryPurple : AppTheme.gray300,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Etapa ${_currentStep + 1} de 5',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildEventTypeStep();
      case 1:
        return _buildEventSizeStep();
      case 2:
        return _buildBudgetStep();
      case 3:
        return _buildServicesStep();
      case 4:
        return _buildSummaryStep();
      default:
        return Container();
    }
  }

  Widget _buildEventTypeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.sparkles, color: AppTheme.primaryPurple, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Que tipo de evento você está organizando?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Isso nos ajuda a recomendar os profissionais mais adequados',
            style: TextStyle(
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _eventTypes.length,
            itemBuilder: (context, index) {
              final eventType = _eventTypes[index];
              final isSelected = _selectedEventType == eventType['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEventType = eventType['id'];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryPurple : AppTheme.gray200,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (eventType['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          eventType['icon'] as IconData,
                          color: eventType['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        eventType['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppTheme.primaryPurple : AppTheme.gray900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventSizeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.users, color: AppTheme.primaryPurple, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Quantas pessoas você espera no evento?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'O tamanho do evento influencia na escolha do espaço e serviços',
            style: TextStyle(
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: _eventSizes.map((size) {
              final isSelected = _selectedSize == size['id'];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedSize = size['id']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryPurple : AppTheme.gray200,
                          width: isSelected ? 2 : 1,
                        ),
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
                          Icon(
                            isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
                            color: isSelected ? AppTheme.primaryPurple : AppTheme.gray400,
                            size: 20,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  size['name']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? AppTheme.primaryPurple : AppTheme.gray900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  size['description']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.gray600,
                                  ),
                                ),
                              ],
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

  Widget _buildBudgetStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.dollarSign, color: AppTheme.primaryPurple, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Qual é o seu orçamento aproximado?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Com base no orçamento, podemos filtrar as melhores opções para você',
            style: TextStyle(
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: _budgetRanges.map((budget) {
              final isSelected = _selectedBudget == budget['id'];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedBudget = budget['id']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryPurple : AppTheme.gray200,
                          width: isSelected ? 2 : 1,
                        ),
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
                          Icon(
                            isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
                            color: isSelected ? AppTheme.primaryPurple : AppTheme.gray400,
                            size: 20,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  budget['name']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? AppTheme.primaryPurple : AppTheme.gray900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  budget['description']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.gray600,
                                  ),
                                ),
                              ],
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.info, color: Colors.blue, size: 16),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Não se preocupe! Você sempre pode ajustar o orçamento durante as negociações.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
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

  Widget _buildServicesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.checkSquare, color: AppTheme.primaryPurple, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Quais serviços você precisa?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecione todos os serviços que você gostaria de contratar',
            style: TextStyle(
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: 24),
          ..._servicesByCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                const SizedBox(height: 12),
                ...entry.value.map((service) {
                  final isSelected = _selectedServices[service['id']] == true;
                  final isEssential = service['priority'] == 'high';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedServices[service['id']] = !isSelected;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryPurple : AppTheme.gray200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? LucideIcons.checkSquare : LucideIcons.square,
                                color: isSelected ? AppTheme.primaryPurple : AppTheme.gray400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.gray100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  service['icon'] as IconData,
                                  color: AppTheme.gray600,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  service['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isSelected ? AppTheme.primaryPurple : AppTheme.gray900,
                                  ),
                                ),
                              ),
                              if (isEssential)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Essencial',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    final selectedServicesCount = _selectedServices.values.where((selected) => selected).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.calendar, color: AppTheme.primaryPurple, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Quando será seu evento?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Escolha a data para encontrarmos profissionais disponíveis',
            style: TextStyle(
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: 24),

          // Date Picker
          GestureDetector(
            onTap: _showDatePicker,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.gray200),
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
                  const Icon(LucideIcons.calendar, color: AppTheme.primaryPurple),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'pt_BR').format(_selectedDate!)
                          : 'Selecionar data',
                      style: TextStyle(
                        color: _selectedDate != null ? AppTheme.gray900 : AppTheme.gray500,
                        fontWeight: _selectedDate != null ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight, color: AppTheme.gray400),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Summary
          const Text(
            'Resumo do Seu Evento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),

          Container(
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
                _buildSummaryRow('Tipo de Evento', _getEventTypeName(), LucideIcons.sparkles),
                _buildSummaryRow('Tamanho', _getEventSizeName(), LucideIcons.users),
                _buildSummaryRow('Orçamento', _getBudgetName(), LucideIcons.dollarSign),
                _buildSummaryRow('Serviços', '$selectedServicesCount selecionados', LucideIcons.checkSquare),
                if (_selectedDate != null)
                  _buildSummaryRow('Data', DateFormat('dd/MM/yyyy').format(_selectedDate!), LucideIcons.calendar),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // AI Recommendations Preview
          Container(
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
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.brain, color: Colors.green, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'IA Pronta para Ajudar!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.gray900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Com base nas suas respostas, nossa IA encontrará os melhores profissionais disponíveis para sua data e orçamento.',
                  style: TextStyle(
                    color: AppTheme.gray600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildAIFeature('🎯', 'Recomendações Personalizadas'),
                    const SizedBox(width: 16),
                    _buildAIFeature('⚡', 'Respostas Rápidas'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIFeature(String emoji, String text) {
    return Expanded(
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final canProceed = _canProceedToNextStep();

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
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.gray700,
                    side: const BorderSide(color: AppTheme.gray300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Voltar'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: canProceed ? _handleNextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentStep == 4 ? 'Encontrar Profissionais' : 'Continuar',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _selectedEventType.isNotEmpty;
      case 1:
        return _selectedSize.isNotEmpty;
      case 2:
        return _selectedBudget.isNotEmpty;
      case 3:
        return _selectedServices.containsValue(true);
      case 4:
        return _selectedDate != null;
      default:
        return false;
    }
  }

  void _handleNextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      _finishGuide();
    }
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _finishGuide() {
    // Navigate to multiple checkout with AI recommendations
    context.read<AppProvider>().navigateToScreen(AppScreen.multipleCheckout);
  }

  String _getEventTypeName() {
    final type = _eventTypes.firstWhere(
      (type) => type['id'] == _selectedEventType,
      orElse: () => {'name': 'Não selecionado'},
    );
    return type['name'];
  }

  String _getEventSizeName() {
    final size = _eventSizes.firstWhere(
      (size) => size['id'] == _selectedSize,
      orElse: () => {'name': 'Não selecionado'},
    );
    return size['name']!;
  }

  String _getBudgetName() {
    final budget = _budgetRanges.firstWhere(
      (budget) => budget['id'] == _selectedBudget,
      orElse: () => {'name': 'Não selecionado'},
    );
    return budget['name']!;
  }
}