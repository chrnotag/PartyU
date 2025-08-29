import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppScreen {
  login,
  register,
  forgotPassword,
  home,
  search,
  searchResults,
  profile,
  venueProfile,
  calendar,
  booking,
  checkout,
  multipleCheckout,
  reviews,
  chat,
  eventGuide,
  settings,
}

enum BottomTab { home, search, profile }

class AppProvider with ChangeNotifier {
  AppScreen _currentScreen = AppScreen.login;
  BottomTab _activeTab = BottomTab.home;
  bool _isDarkMode = false;

  // Navigation data
  String _selectedVenueId = '';
  String _selectedVenueName = '';
  String _selectedVenueAvatar = '';
  String _selectedBookingDate = '';
  String _searchQuery = '';
  String _searchCategory = '';

  // Getters
  AppScreen get currentScreen => _currentScreen;
  BottomTab get activeTab => _activeTab;
  bool get isDarkMode => _isDarkMode;
  String get selectedVenueId => _selectedVenueId;
  String get selectedVenueName => _selectedVenueName;
  String get selectedVenueAvatar => _selectedVenueAvatar;
  String get selectedBookingDate => _selectedBookingDate;
  String get searchQuery => _searchQuery;
  String get searchCategory => _searchCategory;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  void navigateToScreen(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void navigateToHome() {
    _currentScreen = AppScreen.home;
    _activeTab = BottomTab.home;
    notifyListeners();
  }

  void navigateToSearch() {
    _currentScreen = AppScreen.search;
    _activeTab = BottomTab.search;
    notifyListeners();
  }

  void navigateToProfile() {
    _currentScreen = AppScreen.profile;
    _activeTab = BottomTab.profile;
    notifyListeners();
  }

  void navigateToVenueProfile(String venueId) {
    _selectedVenueId = venueId;
    _currentScreen = AppScreen.venueProfile;
    notifyListeners();
  }

  void navigateToSearchResults({String? query, String? category}) {
    _searchQuery = query ?? '';
    _searchCategory = category ?? '';
    _currentScreen = AppScreen.searchResults;
    notifyListeners();
  }

  void navigateToChat(String venueName, [String? venueAvatar]) {
    _selectedVenueName = venueName;
    _selectedVenueAvatar = venueAvatar ?? '';
    _currentScreen = AppScreen.chat;
    notifyListeners();
  }

  void navigateToBooking(String date) {
    _selectedBookingDate = date;
    _currentScreen = AppScreen.booking;
    notifyListeners();
  }

  void setActiveTab(BottomTab tab) {
    _activeTab = tab;
    switch (tab) {
      case BottomTab.home:
        _currentScreen = AppScreen.home;
        break;
      case BottomTab.search:
        _currentScreen = AppScreen.search;
        break;
      case BottomTab.profile:
        _currentScreen = AppScreen.profile;
        break;
    }
    notifyListeners();
  }

  void setVenueName(String name) {
    _selectedVenueName = name;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dark_mode', _isDarkMode);
    } catch (e) {
      debugPrint('Error saving dark mode preference: $e');
    }
    notifyListeners();
  }

  void navigateBack() {
    // Simple back navigation logic
    switch (_currentScreen) {
      case AppScreen.venueProfile:
        if (_searchQuery.isNotEmpty || _searchCategory.isNotEmpty) {
          _currentScreen = AppScreen.searchResults;
        } else {
          _currentScreen = AppScreen.home;
          _activeTab = BottomTab.home;
        }
        break;
      case AppScreen.searchResults:
        _currentScreen = AppScreen.search;
        break;
      case AppScreen.calendar:
      case AppScreen.reviews:
      case AppScreen.chat:
        _currentScreen = AppScreen.venueProfile;
        break;
      case AppScreen.booking:
        _currentScreen = AppScreen.calendar;
        break;
      case AppScreen.checkout:
        _currentScreen = AppScreen.booking;
        break;
      case AppScreen.settings:
        _currentScreen = AppScreen.profile;
        break;
      case AppScreen.eventGuide:
        _currentScreen = AppScreen.home;
        break;
      default:
        _currentScreen = AppScreen.home;
        _activeTab = BottomTab.home;
    }
    notifyListeners();
  }

  bool get showBottomNav {
    return [AppScreen.home, AppScreen.search, AppScreen.profile].contains(_currentScreen);
  }
}