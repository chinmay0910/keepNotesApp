import 'package:keepnotebook/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<void> initialize();
  Future<void> logOut();
  Future<void> sendEmailVerification();

}