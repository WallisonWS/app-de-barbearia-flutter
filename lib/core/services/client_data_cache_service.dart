import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Serviço de Cache de Dados do Cliente
/// 
/// Diferencial competitivo vs Booksy:
/// - Salva automaticamente dados do cliente
/// - Nunca pede telefone repetidamente
/// - Auto-preenchimento inteligente
/// - Sincroniza entre dispositivos (futuro)
class ClientDataCacheService {
  static const String _keyClientName = 'client_name';
  static const String _keyClientPhone = 'client_phone';
  static const String _keyClientEmail = 'client_email';
  static const String _keyClientAddress = 'client_address';
  static const String _keyFavoriteBarbershops = 'favorite_barbershops';
  static const String _keyRecentBookings = 'recent_bookings';
  static const String _keyPreferences = 'client_preferences';
  
  late SharedPreferences _prefs;
  
  /// Inicializa o serviço
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // ========== DADOS PESSOAIS ==========
  
  /// Salva nome do cliente
  Future<void> saveClientName(String name) async {
    await _prefs.setString(_keyClientName, name);
  }
  
  /// Recupera nome do cliente
  String? getClientName() {
    return _prefs.getString(_keyClientName);
  }
  
  /// Salva telefone do cliente
  Future<void> saveClientPhone(String phone) async {
    await _prefs.setString(_keyClientPhone, phone);
  }
  
  /// Recupera telefone do cliente
  String? getClientPhone() {
    return _prefs.getString(_keyClientPhone);
  }
  
  /// Salva email do cliente
  Future<void> saveClientEmail(String email) async {
    await _prefs.setString(_keyClientEmail, email);
  }
  
  /// Recupera email do cliente
  String? getClientEmail() {
    return _prefs.getString(_keyClientEmail);
  }
  
  /// Salva endereço do cliente
  Future<void> saveClientAddress(Map<String, dynamic> address) async {
    await _prefs.setString(_keyClientAddress, jsonEncode(address));
  }
  
  /// Recupera endereço do cliente
  Map<String, dynamic>? getClientAddress() {
    final addressJson = _prefs.getString(_keyClientAddress);
    if (addressJson == null) return null;
    return jsonDecode(addressJson) as Map<String, dynamic>;
  }
  
  /// Salva todos os dados de uma vez
  Future<void> saveAllClientData({
    required String name,
    required String phone,
    String? email,
    Map<String, dynamic>? address,
  }) async {
    await Future.wait([
      saveClientName(name),
      saveClientPhone(phone),
      if (email != null) saveClientEmail(email),
      if (address != null) saveClientAddress(address),
    ]);
  }
  
  /// Recupera todos os dados do cliente
  Map<String, dynamic> getAllClientData() {
    return {
      'name': getClientName(),
      'phone': getClientPhone(),
      'email': getClientEmail(),
      'address': getClientAddress(),
    };
  }
  
  /// Verifica se o cliente já tem dados salvos
  bool hasClientData() {
    return getClientName() != null && getClientPhone() != null;
  }
  
  // ========== BARBEARIAS FAVORITAS ==========
  
  /// Adiciona barbearia aos favoritos
  Future<void> addFavoriteBarbershop(String barbershopId) async {
    final favorites = getFavoriteBarbershops();
    if (!favorites.contains(barbershopId)) {
      favorites.add(barbershopId);
      await _saveFavoriteBarbershops(favorites);
    }
  }
  
  /// Remove barbearia dos favoritos
  Future<void> removeFavoriteBarbershop(String barbershopId) async {
    final favorites = getFavoriteBarbershops();
    favorites.remove(barbershopId);
    await _saveFavoriteBarbershops(favorites);
  }
  
  /// Verifica se barbearia está nos favoritos
  bool isFavorite(String barbershopId) {
    return getFavoriteBarbershops().contains(barbershopId);
  }
  
  /// Recupera lista de barbearias favoritas
  List<String> getFavoriteBarbershops() {
    final favoritesJson = _prefs.getString(_keyFavoriteBarbershops);
    if (favoritesJson == null) return [];
    final List<dynamic> decoded = jsonDecode(favoritesJson);
    return decoded.cast<String>();
  }
  
  /// Salva lista de favoritos
  Future<void> _saveFavoriteBarbershops(List<String> favorites) async {
    await _prefs.setString(_keyFavoriteBarbershops, jsonEncode(favorites));
  }
  
  // ========== AGENDAMENTOS RECENTES ==========
  
  /// Salva agendamento recente
  Future<void> saveRecentBooking(Map<String, dynamic> booking) async {
    final recents = getRecentBookings();
    
    // Adiciona no início da lista
    recents.insert(0, booking);
    
    // Mantém apenas os 10 mais recentes
    if (recents.length > 10) {
      recents.removeRange(10, recents.length);
    }
    
    await _prefs.setString(_keyRecentBookings, jsonEncode(recents));
  }
  
  /// Recupera agendamentos recentes
  List<Map<String, dynamic>> getRecentBookings() {
    final recentsJson = _prefs.getString(_keyRecentBookings);
    if (recentsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(recentsJson);
    return decoded.cast<Map<String, dynamic>>();
  }
  
  /// Limpa agendamentos recentes
  Future<void> clearRecentBookings() async {
    await _prefs.remove(_keyRecentBookings);
  }
  
  // ========== PREFERÊNCIAS ==========
  
  /// Salva preferência do cliente
  Future<void> savePreference(String key, dynamic value) async {
    final preferences = getPreferences();
    preferences[key] = value;
    await _prefs.setString(_keyPreferences, jsonEncode(preferences));
  }
  
  /// Recupera preferência específica
  dynamic getPreference(String key, {dynamic defaultValue}) {
    final preferences = getPreferences();
    return preferences[key] ?? defaultValue;
  }
  
  /// Recupera todas as preferências
  Map<String, dynamic> getPreferences() {
    final preferencesJson = _prefs.getString(_keyPreferences);
    if (preferencesJson == null) return {};
    return jsonDecode(preferencesJson) as Map<String, dynamic>;
  }
  
  // Preferências específicas
  
  /// Salva serviço favorito
  Future<void> saveFavoriteService(String serviceId) async {
    await savePreference('favorite_service', serviceId);
  }
  
  /// Recupera serviço favorito
  String? getFavoriteService() {
    return getPreference('favorite_service');
  }
  
  /// Salva profissional favorito
  Future<void> saveFavoriteProfessional(String professionalId) async {
    await savePreference('favorite_professional', professionalId);
  }
  
  /// Recupera profissional favorito
  String? getFavoriteProfessional() {
    return getPreference('favorite_professional');
  }
  
  /// Salva horário preferido
  Future<void> savePreferredTime(String time) async {
    await savePreference('preferred_time', time);
  }
  
  /// Recupera horário preferido
  String? getPreferredTime() {
    return getPreference('preferred_time');
  }
  
  // ========== LIMPEZA ==========
  
  /// Limpa todos os dados do cliente
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
  
  /// Limpa apenas dados pessoais (mantém favoritos e preferências)
  Future<void> clearPersonalData() async {
    await Future.wait([
      _prefs.remove(_keyClientName),
      _prefs.remove(_keyClientPhone),
      _prefs.remove(_keyClientEmail),
      _prefs.remove(_keyClientAddress),
    ]);
  }
}
