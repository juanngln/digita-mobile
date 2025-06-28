import 'package:digita_mobile/presentation/common_widgets/buttons/onboarding_action_button.dart';
import 'package:digita_mobile/viewmodels/login_viewmodel.dart';
import 'package:digita_mobile/presentation/common_widgets/bottom_sheets/role_selector_bottom_sheet.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/password_input_field.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginViewModel? _viewModelInstance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _viewModelInstance = Provider.of<LoginViewModel>(
          context,
          listen: false,
        );

        _viewModelInstance?.addListener(_handleLoginStateChanges);
      }
    });
  }

  Future<void> _launchPasswordResetURL() async {
    final Uri url =
    Uri.parse('https://digita-admin-api.onrender.com/users/auth/password-reset/');
    try {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } catch (e) {
      _showSnackBar('Tidak dapat membuka link: $e');
    }
  }

  void _handleLoginStateChanges() {
    if (_viewModelInstance == null || !mounted) return;
    final viewModel = _viewModelInstance!;

    if (viewModel.state == ViewState.error && viewModel.errorMessage != null) {
      _showSnackBar(viewModel.errorMessage!, isError: true);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          viewModel.resetLoginStatus();
        }
      });
    } else if (viewModel.state == ViewState.success) {
      _showSnackBar("Login berhasil!", isError: false);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;

        bool didNavigate = false;
        switch (viewModel.loginResult) {
          case LoginResult.successMahasiswaHome:
            Navigator.pushReplacementNamed(context, '/home_mahasiswa');
            didNavigate = true;
            break;
          case LoginResult.successMahasiswaCariDosen:
            Navigator.pushReplacementNamed(context, '/cari_dosen');
            didNavigate = true;
            break;
          case LoginResult.successMahasiswaStatusPengajuan:
            Navigator.pushReplacementNamed(context, '/status_pengajuan_dosen');
            didNavigate = true;
            break;
          case LoginResult.successDosenHome:
            Navigator.pushReplacementNamed(context, '/home_dosen');
            didNavigate = true;
            break;
          case LoginResult.failed:
          case LoginResult.idle:
            viewModel.resetLoginStatus();
            break;
        }

        if (didNavigate) {
          viewModel.resetLoginStatus();
        }
      });
    }
  }

  @override
  void dispose() {
    _viewModelInstance?.removeListener(_handleLoginStateChanges);

    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- UI Helper Methods  ---
  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _showRoleSelectionSheetSelectRole(LoginViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      backgroundColor: const Color(0xFFD9EEFF),
      builder: (BuildContext builderContext) {
        return RoleSelectionBottomSheet(
          roles: viewModel.roles,
          initialSelectedRole: viewModel.selectedRole,
          onRoleSelected: (role) {
            viewModel.setSelectedRole(role);

            final navigator = Navigator.of(builderContext);
            final isMounted = mounted;

            Future.delayed(const Duration(milliseconds: 50), () {
              if (isMounted && navigator.canPop()) {
                navigator.pop();
              }
            });
          },
        );
      },
    );
  }

  void _showRoleSelectionSheetRegister(BuildContext context) {
    final bool isLoading = _viewModelInstance?.isLoading ?? false;

    if (isLoading) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: const Color(0xFFD9EEFF),
      builder: (BuildContext builderContext) {
        return RoleSelectionBottomSheet(
          roles: const ['Mahasiswa', 'Dosen'],
          initialSelectedRole: null,
          onRoleSelected: (selectedRole) {
            Navigator.pop(builderContext);

            if (!context.mounted) {
              return;
            }

            final routeName =
                selectedRole.toLowerCase() == 'mahasiswa'
                    ? '/register_mahasiswa'
                    : '/register_dosen';

            Navigator.pushNamed(context, routeName);
          },
        );
      },
    );
  }

  // --- Build Method  ---
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        bool isLoading = viewModel.isLoading;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset('assets/img/digita.png', height: 250)),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9EEFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Header Texts ---
                        const SizedBox(height: 14),
                        Text(
                          'MULAI BIMBINGAN',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Masuk ke DigiTA',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- Role Selection ---
                        GestureDetector(
                          onTap:
                              isLoading
                                  ? null
                                  : () => _showRoleSelectionSheetSelectRole(
                                    viewModel,
                                  ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isLoading
                                      ? Colors.grey.shade200
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  viewModel.selectedRole ?? "Pilih Peran",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        viewModel.selectedRole != null
                                            ? Colors.black
                                            : Colors.black54,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color:
                                      isLoading ? Colors.grey : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Form Fields ---
                        CustomTextField(
                          controller: _identifierController,
                          hintText: "NIM/NIK",
                          enabled: !isLoading,
                          keyboardType: TextInputType.number, readOnly: false,
                        ),
                        const SizedBox(height: 16),
                        PasswordInputField(
                          controller: _passwordController,
                          hintText: "Kata Sandi",
                          enabled: !isLoading,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading ? null : _launchPasswordResetURL,
                            child: Text(
                              "Lupa Password?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: isLoading ? Colors.grey : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // --- Login Button ---
                        OnboardingActionButton(
                          text: "MASUK",
                          isLoading: isLoading,
                          onPressed: () {
                            FocusScope.of(context).unfocus(); // Hide keyboard
                            // Use stored instance if available, otherwise lookup (safer with stored)
                            final vm =
                                _viewModelInstance ??
                                Provider.of<LoginViewModel>(
                                  context,
                                  listen: false,
                                );
                            vm.handleLogin(
                              identifier: _identifierController.text.trim(),
                              password: _passwordController.text,
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // --- Registration Link ---
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Belum punya akun ? ",
                                style: TextStyle(
                                  color: isLoading ? Colors.grey : Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    isLoading
                                        ? null
                                        : () => _showRoleSelectionSheetRegister(
                                          context,
                                        ),
                                child: Text(
                                  "Daftar Sekarang",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color:
                                        isLoading ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
