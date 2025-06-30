import 'package:digita_mobile/services/biometric_service.dart';
import 'package:digita_mobile/services/login_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthViewModel>(context, listen: false).initializeApp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Added logo, similar to LandingScreen
              Image.asset('assets/img/digita_logo.png', height: 300),
              const SizedBox(height: 48),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text("Cek Sesi Login..."),
            ],
          ),
        ),
      ),
    );
  }
}

// Create a provider for the AuthViewModel
Widget createAuthCheckScreen() {
  return ChangeNotifierProvider(
    create: (context) => AuthViewModel(
      loginService: LoginService(),
      secureStorageService: SecureStorageService(),
      biometricService: BiometricService(),
    ),
    child: const AuthCheckScreen(),
  );
}