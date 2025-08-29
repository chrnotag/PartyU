import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsConstants {
  static const String version = '1.0.0';
  
  static final List<Map<String, dynamic>> accountItems = [
    {
      'title': 'Editar Perfil',
      'subtitle': 'Nome, foto e informações pessoais',
      'icon': LucideIcons.user,
      'key': 'edit_profile',
    },
    {
      'title': 'Alterar Senha',
      'subtitle': 'Mantenha sua conta segura',
      'icon': LucideIcons.lock,
      'key': 'change_password',
    },
    {
      'title': 'Notificações',
      'subtitle': 'Gerencie suas preferências',
      'icon': LucideIcons.bell,
      'key': 'notifications',
    },
    {
      'title': 'Privacidade',
      'subtitle': 'Controle seus dados',
      'icon': LucideIcons.shield,
      'key': 'privacy',
    },
  ];

  static final List<Map<String, dynamic>> supportItems = [
    {
      'title': 'Central de Ajuda',
      'icon': LucideIcons.helpCircle,
      'key': 'help',
    },
    {
      'title': 'Fale Conosco',
      'icon': LucideIcons.messageSquare,
      'key': 'contact',
    },
    {
      'title': 'Termos de Uso',
      'icon': LucideIcons.fileText,
      'key': 'terms',
    },
    {
      'title': 'Política de Privacidade',
      'icon': LucideIcons.shield,
      'key': 'privacy_policy',
    },
  ];
}