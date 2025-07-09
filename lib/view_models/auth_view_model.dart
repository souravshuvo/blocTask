
import '../repositories/auth_repository.dart';
import '../utils/token_storage.dart';
import '../models/login_request_model.dart';

class AuthViewModel {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  Future<String> login(LoginRequest request) async {
    final token = await _authRepository.login(request.email, request.password);
    await TokenStorage.saveToken(token);
    return token;
  }

  Future<void> logout() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      await _authRepository.logout(token);
      await TokenStorage.clearToken();
    }
  }
}
