# 🎉 PartyU - Plataforma de Eventos e Profissionais

<div align="center">

![PartyU Logo](https://img.shields.io/badge/PartyU-Eventos%20%26%20Profissionais-blue?style=for-the-badge&logo=flutter)

**A plataforma completa para conectar organizadores de eventos aos melhores profissionais da área**

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-blue?style=flat&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-blue?style=flat&logo=dart)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=flat)](https://flutter.dev/)

</div>

## 📱 Sobre o Projeto

O **PartyU** é uma plataforma inovadora que revoluciona a forma como eventos são organizados e profissionais são contratados. Nossa missão é facilitar a vida de organizadores de eventos, desde pequenas festas de aniversário até grandes shows ao vivo, conectando-os aos melhores profissionais da área através de um sistema seguro e transparente.

### ✨ Principais Funcionalidades

- 🎯 **Guia Interativo de Eventos**: Sistema inteligente para montar eventos rapidamente
- 🔍 **Busca Avançada**: Encontre profissionais, espaços e serviços por categoria e preço
- ⭐ **Sistema de Avaliações**: Analise feedback de outros usuários
- 📅 **Calendários Integrados**: Verifique disponibilidade em tempo real
- 💳 **Pagamento Seguro**: Sistema de sinal com proteção para ambas as partes
- 🚀 **Interface Intuitiva**: Design moderno e fácil de usar

## 🏗️ Arquitetura e Tecnologias

### Frontend
- **Flutter 3.8.1+** - Framework cross-platform para desenvolvimento mobile
- **Dart 3.8.1+** - Linguagem de programação moderna e eficiente
- **Material Design 3** - Design system do Google para interfaces consistentes

### Gerenciamento de Estado
- **Provider 6.1.5+** - Gerenciamento de estado reativo e eficiente
- **ChangeNotifier** - Padrão para notificações de mudanças de estado

### Armazenamento Local
- **SQLite (sqflite 2.4.2)** - Banco de dados local para cache e dados offline
- **SharedPreferences 2.5.3** - Armazenamento de configurações e preferências

### UI/UX
- **Google Fonts 6.3.0** - Tipografia personalizada e profissional
- **Lucide Icons 0.257.0** - Ícones modernos e consistentes
- **Lottie 3.3.1** - Animações fluidas e engajantes
- **Cached Network Image 3.4.1** - Carregamento otimizado de imagens

### Utilitários
- **HTTP 1.5.0** - Cliente HTTP para APIs REST
- **UUID 4.5.1** - Geração de identificadores únicos
- **Intl 0.20.2** - Internacionalização e formatação de dados
- **Path 1.9.1** - Manipulação de caminhos de arquivo

### Internacionalização
- **Flutter Localizations** - Suporte completo para português brasileiro e inglês

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK 3.8.1 ou superior
- Dart SDK 3.8.1 ou superior
- Android Studio / VS Code com extensões Flutter
- Emulador Android ou dispositivo físico
- iOS Simulator (para desenvolvimento iOS)

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/partyu.git
cd partyu
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o projeto**
```bash
flutter run
```

### Build para Produção

**Android (APK)**
```bash
flutter build apk --release
```

**Android (App Bundle)**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 📱 Funcionalidades Principais

### 🎯 Sistema de Eventos
- Criação rápida de eventos com guia interativo
- Seleção de categorias e profissionais recomendados
- Orçamento baseado em preços de mercado
- Personalização completa do evento

### 👥 Gestão de Profissionais
- Perfis detalhados com portfólio
- Sistema de categorização por especialidade
- Avaliações e comentários verificados
- Calendários de disponibilidade integrados

### 💰 Sistema de Pagamento Seguro
- **Sinal (10-50%)**: Pago no ato da contratação e retido pela plataforma
- **Prazo de Resposta**: 48h para confirmação do profissional
- **Proteção ao Usuário**: Devolução integral em caso de cancelamento
- **Pagamento Final**: Restante pago diretamente ao profissional após o evento
- **Confirmação Dupla**: Liberação do sinal após confirmação de ambas as partes

### 🔍 Busca e Descoberta
- Filtros avançados por categoria, preço e localização
- Sistema de recomendações inteligentes
- Avaliações e feedback de outros usuários
- Comparação de profissionais e serviços

## 🏛️ Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── booking_model.dart    # Modelo de reservas
│   ├── review_model.dart     # Modelo de avaliações
│   ├── user_model.dart       # Modelo de usuários
│   └── venue_model.dart      # Modelo de espaços
├── providers/                # Gerenciamento de estado
│   ├── app_provider.dart     # Estado global da aplicação
│   └── auth_provider.dart    # Estado de autenticação
├── screens/                  # Telas da aplicação
│   ├── auth/                 # Autenticação
│   ├── home/                 # Tela principal
│   ├── search/               # Busca e resultados
│   ├── booking/              # Sistema de reservas
│   ├── profile/              # Perfis de usuário
│   ├── reviews/              # Sistema de avaliações
│   ├── chat/                 # Comunicação
│   ├── calendar/             # Calendários
│   ├── events/               # Guia de eventos
│   ├── payment/              # Sistema de pagamento
│   └── settings/             # Configurações
├── services/                 # Serviços externos
│   └── database_service.dart # Serviço de banco de dados
├── utils/                    # Utilitários
│   ├── app_theme.dart        # Temas da aplicação
│   ├── settings_constants.dart # Constantes de configuração
│   └── settings_helpers.dart # Funções auxiliares
└── widgets/                  # Componentes reutilizáveis
    ├── bottom_navigation.dart # Navegação inferior
    ├── custom_button.dart     # Botões personalizados
    ├── venue_card.dart        # Cards de espaços
    └── category_card.dart     # Cards de categorias
```

## 🎨 Design System

O PartyU utiliza o **Material Design 3** com:
- **Temas Claro e Escuro** com transição suave
- **Paleta de Cores** personalizada e acessível
- **Tipografia** hierárquica e legível
- **Componentes** consistentes e reutilizáveis
- **Animações** fluidas e responsivas

## 🌍 Internacionalização

- **Português Brasileiro (pt_BR)** - Idioma principal
- **Inglês (en)** - Idioma de fallback
- Formatação de datas, números e moedas localizadas
- Interface adaptada para diferentes culturas

## 🔒 Segurança e Privacidade

- **Autenticação Segura** com tokens JWT
- **Criptografia** de dados sensíveis
- **Validação** rigorosa de entrada de dados
- **Proteção** contra ataques comuns
- **Conformidade** com LGPD e GDPR

## 📊 Banco de Dados

- **SQLite Local** para cache e dados offline
- **Sincronização** automática com servidor
- **Backup** automático de dados importantes
- **Migração** de esquemas versionada

## 🧪 Testes

```bash
# Executar testes unitários
flutter test

# Executar testes de integração
flutter test integration_test/

# Executar testes com cobertura
flutter test --coverage
```

## 📈 Roadmap

### Versão 1.1
- [ ] Sistema de notificações push
- [ ] Integração com redes sociais
- [ ] Modo offline completo
- [ ] Analytics e métricas

### Versão 1.2
- [ ] Sistema de fidelidade
- [ ] Marketplace de produtos
- [ ] Integração com sistemas de pagamento
- [ ] API pública para desenvolvedores

### Versão 2.0
- [ ] Inteligência artificial para recomendações
- [ ] Realidade aumentada para visualização de espaços
- [ ] Sistema de eventos híbridos
- [ ] Integração com IoT para automação

## 🤝 Contribuição

Contribuições são sempre bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Padrões de Código
- Siga as convenções do Flutter
- Use o `flutter_lints` para qualidade
- Documente funções complexas
- Escreva testes para novas funcionalidades

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

- **Email**: suporte@partyu.com
- **Documentação**: [docs.partyu.com](https://docs.partyu.com)
- **Issues**: [GitHub Issues](https://github.com/seu-usuario/partyu/issues)
- **Discord**: [Comunidade PartyU](https://discord.gg/partyu)

## 🙏 Agradecimentos

- **Flutter Team** pelo framework incrível
- **Comunidade Flutter** pelo suporte contínuo
- **Contribuidores** que ajudaram a construir o PartyU
- **Usuários** que testaram e deram feedback

---

<div align="center">

**Feito com ❤️ pela equipe PartyU**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/seu-usuario)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/felippe-pinheiro-de-almeida-739383184/)

</div>
