import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/auth_provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/services/database_service.dart';
import 'package:partyu/models/booking_model.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      try {
        final bookings = await DatabaseService.instance.getUserBookings(authProvider.user!.id);
        if (mounted) {
          setState(() {
            _bookings = bookings;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            return const Center(
              child: Text('Usuário não encontrado'),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadBookings,
            child: CustomScrollView(
              slivers: [
                // Profile Header
                SliverToBoxAdapter(
                  child: _buildProfileHeader(authProvider),
                ),

                // Profile Stats
                SliverToBoxAdapter(
                  child: _buildProfileStats(),
                ),

                // Menu Options
                SliverToBoxAdapter(
                  child: _buildMenuOptions(),
                ),

                // Recent Bookings
                SliverToBoxAdapter(
                  child: _buildRecentBookings(),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider) {
    final user = authProvider.user!;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Settings Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          context.read<AppProvider>().navigateToScreen(AppScreen.settings);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Icon(
                          LucideIcons.settings,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: user.avatar?.isNotEmpty == true
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          user.avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar(user.name);
                          },
                        ),
                      )
                    : _buildDefaultAvatar(user.name),
              ),
              const SizedBox(height: 16),

              // User Info
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              if (user.isDemo) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '🎯 Modo Demo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildProfileStats() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Reservas',
              _bookings.length.toString(),
              LucideIcons.calendar,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.gray200,
          ),
          Expanded(
            child: _buildStatItem(
              'Avaliações',
              '0',
              LucideIcons.star,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.gray200,
          ),
          Expanded(
            child: _buildStatItem(
              'Favoritos',
              '0',
              LucideIcons.heart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryPurple,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.gray900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions() {
    final menuItems = [
      {
        'title': 'Minhas Reservas',
        'subtitle': 'Gerencie suas reservas',
        'icon': LucideIcons.calendar,
        'onTap': () {
          // Navigate to bookings
        },
      },
      {
        'title': 'Favoritos',
        'subtitle': 'Profissionais salvos',
        'icon': LucideIcons.heart,
        'onTap': () {
          // Navigate to favorites
        },
      },
      {
        'title': 'Histórico',
        'subtitle': 'Eventos realizados',
        'icon': LucideIcons.history,
        'onTap': () {
          // Navigate to history
        },
      },
      {
        'title': 'Avaliações',
        'subtitle': 'Suas avaliações',
        'icon': LucideIcons.star,
        'onTap': () {
          // Navigate to reviews
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        children: menuItems.map((item) {
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
            ),
            title: Text(
              item['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
            subtitle: Text(
              item['subtitle'] as String,
              style: const TextStyle(
                color: AppTheme.gray600,
                fontSize: 14,
              ),
            ),
            trailing: const Icon(
              LucideIcons.chevronRight,
              color: AppTheme.gray400,
              size: 20,
            ),
            onTap: item['onTap'] as VoidCallback,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentBookings() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reservas Recentes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_bookings.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Navigate to all bookings
                  },
                  child: const Text(
                    'Ver todas',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(
                  color: AppTheme.primaryPurple,
                ),
              ),
            )
          else if (_bookings.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
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
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.gray100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      LucideIcons.calendar,
                      color: AppTheme.gray400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhuma reserva ainda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore nossos profissionais e faça sua primeira reserva!',
                    style: TextStyle(
                      color: AppTheme.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Column(
              children: _bookings.take(3).map((booking) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildBookingCard(booking),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final date = DateFormat('dd/MM/yyyy').format(booking.date);
    final time = '${booking.startTime} - ${booking.endTime}';

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (booking.status) {
      case 'Confirmado':
        statusColor = Colors.green;
        statusText = 'Confirmado';
        statusIcon = LucideIcons.checkCircle;
        break;
      case 'Pendente':
        statusColor = Colors.orange;
        statusText = 'Pendente';
        statusIcon = LucideIcons.clock;
        break;
      case 'Cancelado':
        statusColor = Colors.red;
        statusText = 'Cancelado';
        statusIcon = LucideIcons.xCircle;
        break;
      default:
        statusColor = AppTheme.gray500;
        statusText = booking.status;
        statusIcon = LucideIcons.clock;
    }

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.venueName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Service
          Text(
            booking.service.name,
            style: const TextStyle(
              color: AppTheme.gray600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          // Date and Time
          Row(
            children: [
              const Icon(
                LucideIcons.calendar,
                color: AppTheme.gray400,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(
                  color: AppTheme.gray600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                LucideIcons.clock,
                color: AppTheme.gray400,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(
                  color: AppTheme.gray600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: R\$ ${booking.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
              if (booking.depositPaid) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Sinal pago',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}