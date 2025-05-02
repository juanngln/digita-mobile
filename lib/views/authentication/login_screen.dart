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
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _selectedRole;

  final List<String> _roles = ['Mahasiswa', 'Dosen'];

  // untuk menampilkan snackbar
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
            // Fungsi ini dipanggil saat tombol LANJUT ditekan dan mengupdate role yang dipilih
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
            // Navigasi setelah bottom sheet ditutup
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
      _isLoading = true; // menampilkan loading indicator
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/users/login/');
    final String apiRole = _selectedRole!.toLowerCase();

    final Map<String, String> loginData = {
      "role": apiRole,
      "identifier": _nimController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginData), // Encode data ke JSON
      );

      // Handle Response
      if (!mounted) return; //

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // SUCCESS ( status code 200 OK, 201 Created)
        _showSnackBar("Login berhasil!", isError: false);

        /* Optional: Decode response if your API sends back data like a token
        final responseBody = jsonDecode(response.body);
        String token = responseBody['token']; // Example
        Store the token securely (e.g., using flutter_secure_storage)
        */
        if (apiRole == 'mahasiswa') {
          Navigator.pushReplacementNamed(
            context,
            '/home_mahasiswa',
          ); // navigasi ke home mahasiswa
        } else if (apiRole == 'dosen') {
          Navigator.pushReplacementNamed(
            context,
            '/home_dosen',
          ); // navigasi ke home dosen
        } else {
          _showSnackBar(
            "Login berhasil, tetapi peran tidak dikenal.",
            isError: true,
          );
        }
      } else {
        // FAILURE ( status code 400 Bad Request, 401 Unauthorized)
        String errorMessage = "Login gagal."; // pesan error
        try {
          // parse pesan error dari API response body
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map &&
              errorBody.containsKey('error') &&
              errorBody['error'] is String) {
            errorMessage = errorBody['error'];
          } else {
            errorMessage =
                "Terjadi kesalahan login (Status: ${response.statusCode})";
          }
        } catch (e) {
          // jika tidak ada pesan error dari API
          errorMessage = "Login gagal (Status: ${response.statusCode})";
        }
        _showSnackBar(errorMessage);
      }
    } on SocketException {
      // jika tidak bisa terhubung ke server
      if (!mounted) return;
      _showSnackBar(
        "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.",
      );
    } on HttpException {
      if (!mounted) return;
      _showSnackBar("Gagal menemukan layanan. Periksa alamat server.");
    } on FormatException {
      if (!mounted) return;
      _showSnackBar("Format respons dari server tidak valid.");
    } catch (e) {
      // menangani kesalahan lain yang tidak terduga
      if (!mounted) return;
      _showSnackBar("Terjadi kesalahan yang tidak diketahui.");
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
                      onTap: _showRoleSelectionSheetSelectRole,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                        ? Colors
                                            .black // Color when selected
                                        : Colors.black54, // Hint text color
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Form Fields
                    TextFormField(
                      controller: _nimController,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "NIM/NIK",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        filled: true,
                        fillColor: Colors.white,
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
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
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
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Lupa password
                        },
                        child: const Text(
                          "Lupa Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
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
                        // memanggil fungsi login
                        onPressed: _isLoading ? null : _handleLogin,
                        style: TextButton.styleFrom(
                          backgroundColor:
                              _isLoading
                                  ? Colors.grey
                                  : const Color(
                                    0xFF0F47AD,
                                  ), // berubah warna saat loading
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  //  menampilkan loading indicator
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : const Text(
                                  // menampilkan teks Masuk
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
                          const Text("Belum punya akun ? "),
                          GestureDetector(
                            onTap: () {
                              _showRoleSelectionSheetRegister(context);
                            },
                            child: Text(
                              "Daftar Sekarang",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
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
