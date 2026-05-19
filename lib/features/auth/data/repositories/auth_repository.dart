import 'dart:math';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final response = await _apiService.get('${AppConstants.loginEndpoint}/1');
      final user = UserModel.fromJson(response);
      final token = 'mock_token_${Random().nextInt(100000)}';
      final userWithToken = user.copyWith(token: token);

      await LocalStorageService.setString(AppConstants.tokenKey, token);
      await LocalStorageService.setObject(AppConstants.userKey, userWithToken.toJson());

      return userWithToken;
    } catch (e) {
      final fallbackUser = UserModel(
        id: 1,
        name: 'Demo User',
        email: email,
        token: 'offline_token',
      );
      await LocalStorageService.setString(AppConstants.tokenKey, 'offline_token');
      await LocalStorageService.setObject(AppConstants.userKey, fallbackUser.toJson());
      return fallbackUser;
    }
  }

  Future<void> logout() async {
    await LocalStorageService.remove(AppConstants.tokenKey);
    await LocalStorageService.remove(AppConstants.userKey);
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorageService.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<UserModel?> getCurrentUser() async {
    final userData = LocalStorageService.getObject(AppConstants.userKey);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }
}