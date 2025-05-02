import 'dart:convert';
import 'dart:io';

import 'package:digita_mobile/widgets/role_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- Base URL Configuration ---
  // Gunakan 10.0.2.2 untuk Android emulator untuk access ke localhost/127.0.0.1
  /* jika menggunakan android device asli
     Ganti alamat ip menggunakan alamat ip laptop/komputermu
     contoh: static const String _baseUrl = "http://192.168.1.15:8000"; */
  static const String _baseUrl = "http://10.0.2.2:8000";

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _selectedRole;
  final List<String> _roles = ['Mahasiswa', 'Dosen'];

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

  // untuk menampilkan role selector bottom sheet saat pilih role
  void _showRoleSelectionSheetSelectRole() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      backgroundColor: const Color(0xFFD9EEFF),
      builder: (BuildContext builderContext) {
        return RoleSelectionBottomSheet(
          roles: _roles,
          initialSelectedRole: _selectedRole,
          onRoleSelected: (role) {
            setState(() {
              _selectedRole = role;
            });
          },
        );
      },
    );
  }

  // untuk menampilkan role selector bottom sheet saat tekan daftar sekarang
  void _showRoleSelectionSheetRegister(BuildContext context) {
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
          onRoleSelected: (selectedRole) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (!context.mounted) return;
              final routeName =
                  selectedRole.toLowerCase() == 'mahasiswa'
                      ? '/register_mahasiswa'
                      : '/register_dosen';
              Navigator.pushNamed(context, routeName);
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Check Request Status ---
  Future<void> _checkThesisRequestStatusAndNavigate(String token) async {
    final requestStatusUrl = Uri.parse(
      '$_baseUrl/api/thesis/request-dosen/pribadi/',
    );
    if (!mounted) {
      return;
    }

    try {
      final response = await http.get(
        requestStatusUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        if (responseData.isNotEmpty) {
          final requestData = responseData[0] as Map<String, dynamic>;
          final String? status = requestData['status'] as String?;

          if (status == 'PENDING') {
            Navigator.pushReplacementNamed(context, '/cari_dosen');
          } else if (status == 'ACCEPTED') {
            Navigator.pushReplacementNamed(context, '/home_mahasiswa');
          } else {
            _showSnackBar(
              "Status permintaan dosen: $status. Mengarahkan ke halaman utama.",
              isError: false,
            );
            Navigator.pushReplacementNamed(context, '/home_mahasiswa');
          }
        } else {
          _showSnackBar(
            "Anda belum mengajukan permintaan dosen pembimbing.",
            isError: false,
          );
          Navigator.pushReplacementNamed(context, '/cari_dosen');
        }
      } else {
        // Handle API error (e.g., 401 Unauthorized, 404 Not Found, 500 Server Error)
        _showSnackBar(
          "Gagal memeriksa status permintaan (Status: ${response.statusCode}). Anda mungkin perlu login ulang.",
          isError: true,
        );
      }
    } on SocketException {
      if (!mounted) return;
      _showSnackBar(
        "Tidak dapat terhubung ke server untuk memeriksa status. Periksa koneksi.",
      );
    } on HttpException {
      if (!mounted) return;
      _showSnackBar("Gagal menemukan layanan status. Periksa alamat server.");
    } on FormatException {
      if (!mounted) return;
      _showSnackBar("Format respons status dari server tidak valid.");
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        "Terjadi kesalahan tidak diketahui saat memeriksa status: $e",
      );
    } finally {
      if (mounted && _isLoading) {}
    }
  }

  // LOGIN LOGIC
  Future<void> _handleLogin() async {
    // Input Validation
    if (_selectedRole == null) {
      _showSnackBar("Silakan pilih peran Anda.");
      return;
    }
    if (_nimController.text.isEmpty) {
      _showSnackBar("NIM/NIK tidak boleh kosong.");
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackBar("Kata sandi tidak boleh kosong.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // API URL login
    final loginUrl = Uri.parse('$_baseUrl/api/users/login/');
    final String apiRole = _selectedRole!.toLowerCase();

    final Map<String, String> loginData = {
      "role": apiRole,
      "identifier": _nimController.text,
      "password": _passwordController.text,
    };

    String? authToken;

    try {
      final response = await http.post(
        loginUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginData),
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _showSnackBar("Login berhasil!", isError: false);

        try {
          final responseBody = jsonDecode(response.body);

          if (responseBody is Map &&
              responseBody.containsKey('tokens') &&
              responseBody['tokens'] is Map) {
            final tokensMap = responseBody['tokens'] as Map<String, dynamic>;
            if (tokensMap.containsKey('access')) {
              authToken = tokensMap['access'] as String?;

              if (authToken == null) {
                throw const FormatException(
                  "Token value ('tokens'.'access') is null in login response",
                );
              }
              // TODO: Store token menggunakan flutter secure storage
            } else {
              throw const FormatException(
                "Token key 'access' not found inside 'tokens' object",
              );
            }
          } else {
            throw const FormatException(
              "Token key 'tokens' not found or is not a Map in login response",
            );
          }
        } catch (e) {
          if (!mounted) return;
          _showSnackBar(
            "Login berhasil, tapi gagal memproses data sesi (token).",
            isError: true,
          );

          return;
        }

        // Navigasi berdassakan peran
        if (apiRole == 'mahasiswa') {
          await _checkThesisRequestStatusAndNavigate(authToken);
        } else if (apiRole == 'dosen') {
          Navigator.pushReplacementNamed(context, '/home_dosen');
        } else {
          _showSnackBar(
            "Login berhasil, tetapi peran tidak dikenal.",
            isError: true,
          );
        }
      } else {
        String errorMessage = "Login gagal.";
        try {
          final errorBody = jsonDecode(response.body);

          if (errorBody is Map &&
              errorBody.containsKey('detail') &&
              errorBody['detail'] is String) {
            errorMessage = errorBody['detail'];
          } else if (errorBody is Map &&
              errorBody.containsKey('error') &&
              errorBody['error'] is String) {
            errorMessage = errorBody['error'];
          } else {
            errorMessage =
                "Terjadi kesalahan login (Status: ${response.statusCode})";
          }
        } catch (e) {
          errorMessage = "Login gagal (Status: ${response.statusCode})";
        }
        _showSnackBar(errorMessage);
      }
    } on SocketException {
      if (!mounted) return;
      _showSnackBar(
        "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
      );
    } on HttpException {
      if (!mounted) return;
      _showSnackBar("Gagal menemukan layanan login. Periksa alamat server.");
    } on FormatException {
      if (!mounted) return;
      _showSnackBar("Format respons login dari server tidak valid.");
    } catch (e) {
      if (!mounted) return;
      _showSnackBar("Terjadi kesalahan yang tidak diketahui: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(child: Image.asset('assets/img/Digita.png', height: 250)),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    // Role Selection
                    GestureDetector(
                      onTap:
                          _isLoading ? null : _showRoleSelectionSheetSelectRole,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _isLoading ? Colors.grey.shade200 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedRole ?? "Pilih Peran",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    _selectedRole != null
                                        ? Colors.black
                                        : Colors.black54,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: _isLoading ? Colors.grey : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Form Fields
                    TextFormField(
                      controller: _nimController,
                      enabled: !_isLoading,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isLoading ? Colors.grey.shade600 : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "NIM/NIK",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor:
                            _isLoading ? Colors.grey.shade200 : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !_isLoading,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isLoading ? Colors.grey.shade600 : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Kata Sandi",
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor:
                            _isLoading ? Colors.grey.shade200 : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _isLoading ? Colors.grey : null,
                          ),
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          // Style for disabled state
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  // Lupa password
                                },
                        child: Text(
                          "Lupa Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: _isLoading ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Button Masuk
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: TextButton.styleFrom(
                          backgroundColor:
                              _isLoading
                                  ? Colors.grey
                                  : const Color(0xFF0F47AD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : const Text(
                                  "MASUK",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum punya akun ? ",
                            style: TextStyle(
                              color: _isLoading ? Colors.grey : Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                _isLoading
                                    ? null
                                    : () {
                                      _showRoleSelectionSheetRegister(context);
                                    },
                            child: Text(
                              "Daftar Sekarang",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: _isLoading ? Colors.grey : Colors.black,
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
  }
}
