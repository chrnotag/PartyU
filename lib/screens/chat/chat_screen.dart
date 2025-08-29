import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:intl/intl.dart';

class Message {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.isRead = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  // Demo messages
  final List<Message> _messages = [
    Message(
      id: '1',
      text: 'Olá! Vi sua consulta sobre nosso espaço para o dia 15/02. Tenho disponibilidade sim!',
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    Message(
      id: '2',
      text: 'Ótimo! Gostaria de saber mais detalhes sobre o pacote completo.',
      isFromUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isRead: true,
    ),
    Message(
      id: '3',
      text: 'Claro! O pacote inclui:\n• Espaço por 8 horas\n• Som básico\n• Iluminação ambiente\n• 2 garçons\n• Limpeza inclusa\n\nPara 100 pessoas fica R\$ 1.200,00 + 10% de sinal',
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isRead: true,
    ),
    Message(
      id: '4',
      text: 'Perfeito! Podemos agendar uma visita para eu conhecer o espaço?',
      isFromUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: true,
    ),
    Message(
      id: '5',
      text: 'Sim! Que tal amanhã às 14h? Posso mostrar todo o espaço e tirar suas dúvidas.',
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          'Entendi! Vou verificar essa informação para você.',
          'Ótima pergunta! Deixe-me te explicar melhor.',
          'Claro! Posso te ajudar com isso.',
          'Perfeito! Vamos acertar todos os detalhes.',
          'Pode deixar! Vou te enviar mais informações.',
        ];

        final response = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: responses[DateTime.now().millisecond % responses.length],
          isFromUser: false,
          timestamp: DateTime.now(),
        );

        setState(() {
          _messages.add(response);
          _isTyping = false;
        });

        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final venueName = appProvider.selectedVenueName;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            appProvider.navigateBack();
          },
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: Row(
          children: [
            // Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  venueName.isNotEmpty ? venueName[0].toUpperCase() : 'P',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Name and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venueName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.gray900,
                    ),
                  ),
                  const Text(
                    'Online agora',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showOptionsMenu();
            },
            icon: const Icon(LucideIcons.moreVertical),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isFromUser = message.isFromUser;
    final time = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: isFromUser ? 48 : 0,
          right: isFromUser ? 0 : 48,
        ),
        child: Column(
          crossAxisAlignment: isFromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromUser 
                    ? AppTheme.primaryPurple 
                    : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isFromUser ? const Radius.circular(4) : null,
                  bottomLeft: !isFromUser ? const Radius.circular(4) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isFromUser ? Colors.white : AppTheme.gray900,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
            
            // Time
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.gray500,
                  ),
                ),
                if (isFromUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? LucideIcons.checkCheck : LucideIcons.check,
                    size: 12,
                    color: message.isRead ? Colors.blue : AppTheme.gray400,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 48),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.gray400,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
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
            // Quick actions
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _showQuickActions,
                  borderRadius: BorderRadius.circular(12),
                  child: const Icon(
                    LucideIcons.plus,
                    color: AppTheme.gray600,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.gray50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.gray200),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    hintStyle: TextStyle(color: AppTheme.gray400),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Send button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _sendMessage,
                  borderRadius: BorderRadius.circular(12),
                  child: const Icon(
                    LucideIcons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildQuickActionItem(
                    LucideIcons.calendar,
                    'Agendar Visita',
                    'Marcar um horário para visitar',
                    () {
                      Navigator.pop(context);
                      _sendQuickMessage('Gostaria de agendar uma visita ao espaço. Qual a melhor data para vocês?');
                    },
                  ),
                  _buildQuickActionItem(
                    LucideIcons.helpCircle,
                    'Tirar Dúvidas',
                    'Fazer perguntas sobre o serviço',
                    () {
                      Navigator.pop(context);
                      _sendQuickMessage('Tenho algumas dúvidas sobre o serviço. Podem me ajudar?');
                    },
                  ),
                  _buildQuickActionItem(
                    LucideIcons.fileText,
                    'Solicitar Orçamento',
                    'Pedir um orçamento detalhado',
                    () {
                      Navigator.pop(context);
                      _sendQuickMessage('Gostaria de receber um orçamento detalhado para meu evento.');
                    },
                  ),
                  _buildQuickActionItem(
                    LucideIcons.clock,
                    'Verificar Disponibilidade',
                    'Consultar datas disponíveis',
                    () {
                      Navigator.pop(context);
                      _sendQuickMessage('Podem verificar a disponibilidade para o período que estou planejando?');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.gray200),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.gray900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  color: AppTheme.gray400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendQuickMessage(String text) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Options
            ListTile(
              leading: const Icon(LucideIcons.user, color: AppTheme.gray600),
              title: const Text('Ver Perfil'),
              onTap: () {
                Navigator.pop(context);
                context.read<AppProvider>().navigateBack();
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.phone, color: AppTheme.gray600),
              title: const Text('Ligar'),
              onTap: () {
                Navigator.pop(context);
                // Call functionality
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.alertTriangle, color: Colors.red),
              title: const Text('Reportar'),
              onTap: () {
                Navigator.pop(context);
                // Report functionality
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}