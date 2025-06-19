import 'package:digita_mobile/presentation/common_widgets/buttons/onboarding_action_button.dart';
import 'package:digita_mobile/viewmodels/registration_viewmodel.dart';
import 'package:digita_mobile/presentation/features/auth/register/widgets/animated_logo.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/auth_text_link.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/jurusan_dropdown.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/password_input_field.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterDosenScreen extends StatefulWidget {
  const RegisterDosenScreen({super.key});

  @override
  State<RegisterDosenScreen> createState() => _RegisterDosenScreenState();
}

class _RegisterDosenScreenState extends State<RegisterDosenScreen> {
  final _formKey = GlobalKey<FormState>();
  RegistrationViewModel? _viewModelInstance;
  bool _dependenciesInitialized = false;

  // --- Controllers ---
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dependenciesInitialized) {
      _viewModelInstance = Provider.of<RegistrationViewModel>(
        context,
        listen: false,
      );
      _viewModelInstance?.addListener(_handleRegistrationStatusChange);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // FETCH JURUSAN instead of Program Studi
          _viewModelInstance?.fetchJurusan();
        }
      });
      _dependenciesInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _handleRegistrationStatusChange() {
    if (!mounted) return;
    final viewModel = context.read<RegistrationViewModel>();

    if (viewModel.registrationStatus == RegistrationStatus.success) {
      _showSnackBar(
        "Registrasi Dosen berhasil! Anda akan diarahkan ke halaman Masuk.",
        isError: false,
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
          viewModel.resetRegistrationStatus();
        }
      });
    } else if (viewModel.registrationState == ViewState.error &&
        viewModel.registrationError != null) {
      _showSnackBar(viewModel.registrationError!, isError: true);
      if (mounted) {
        viewModel.resetRegistrationStatus();
      }
    }
  }

  @override
  void dispose() {
    _viewModelInstance?.removeListener(_handleRegistrationStatusChange);
    _namaController.dispose();
    _emailController.dispose();
    _nikController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
      ),
    );
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Harap periksa kembali data yang Anda masukkan.');
      return;
    }
    final viewModel = context.read<RegistrationViewModel>();

    viewModel.handleRegister(
      role: 'dosen',

      nik: _nikController.text,
      jurusanId: viewModel.selectedJurusanId,
      nim: null,
      programStudiId: null,

      namaLengkap: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
      password2: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationViewModel>(
      builder: (context, viewModel, child) {
        final bool isRegistering =
            viewModel.registrationState == ViewState.busy;
        final bool isFormEnabled = !isRegistering;

        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: AnimatedLogo(
                              imagePath: 'assets/img/digita.png',
                            ),
                          ),
            
                          // Form Section
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9EEFF),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.0),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(
                              30.0,
                              30.0,
                              30.0,
                              20.0,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header
                                  Text(
                                    'MULAI BIMBINGAN',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Daftar di DigiTA',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ), // Changed title
                                  const SizedBox(height: 30),
            
                                  // Input Fields
                                  CustomTextField(
                                    controller: _namaController,
                                    hintText: 'NAMA LENGKAP (Beserta Gelar)',
                                    enabled: isFormEnabled,
                                    validator:
                                        (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Nama Lengkap tidak boleh kosong'
                                                : null,
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    controller: _emailController,
                                    hintText: 'EMAIL',
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: isFormEnabled,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Email tidak boleh kosong';
                                      }
                                      if (!RegExp(
                                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                      ).hasMatch(v.trim())) {
                                        return 'Format email tidak valid';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
            
                                  // USE JURUSAN DROPDOWN
                                  JurusanDropdown(
                                    viewModel: viewModel,
                                    isFormEnabled: isFormEnabled,
                                  ),
                                  const SizedBox(height: 20),
            
                                  // NIK FIELD
                                  CustomTextField(
                                    controller: _nikController,
                                    hintText: 'NIK',
                                    keyboardType: TextInputType.number,
                                    enabled: isFormEnabled,
                                    validator:
                                        (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'NIK tidak boleh kosong'
                                                : null, // Changed message
                                  ),
                                  const SizedBox(height: 20),
            
                                  // Password fields
                                  PasswordInputField(
                                    controller: _passwordController,
                                    hintText: 'Kata Sandi',
                                    enabled: isFormEnabled,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Kata Sandi tidak boleh kosong';
                                      }
                                      if (v.length < 8) {
                                        return 'Kata Sandi minimal 8 karakter';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  PasswordInputField(
                                    controller: _confirmPasswordController,
                                    hintText: 'Konfirmasi Kata Sandi',
                                    enabled: isFormEnabled,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Konfirmasi tidak boleh kosong';
                                      }
                                      if (v != _passwordController.text) {
                                        return 'Kata Sandi tidak cocok';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 30),
            
                                  // Button & Link
                                  OnboardingActionButton(
                                    text: 'DAFTAR',
                                    isLoading: isRegistering,
                                    onPressed: _submitRegistration,
                                  ),
                                  const SizedBox(height: 20),
                                  SecondaryAuthLink(
                                    leadingText: 'Sudah punya akun? ',
                                    linkText: 'Masuk',
                                    isLoading: isRegistering,
                                    onPressed:
                                        () => Navigator.pushReplacementNamed(
                                          context,
                                          '/login',
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
