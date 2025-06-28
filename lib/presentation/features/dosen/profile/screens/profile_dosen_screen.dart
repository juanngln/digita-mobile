import 'package:flutter/material.dart';

// Pastikan semua path ini benar sesuai struktur proyek Anda
// Asumsi dialog dan sheet berada di lokasi umum
import 'package:digita_mobile/presentation/common_widgets/dialogs/logout_dialog.dart';
import 'package:digita_mobile/presentation/common_widgets/bottom_sheets/account_secure_sheet.dart';


class ProfileDosenScreen extends StatefulWidget {
  const ProfileDosenScreen({super.key});

  @override
  State<ProfileDosenScreen> createState() => _ProfileDosenScreenState();
}

class _ProfileDosenScreenState extends State<ProfileDosenScreen> {
  bool _isNotificationOn = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: textTheme.headlineMedium?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Anda bisa mengganti gambar ini dengan aset gambar dosen
              const CircleAvatar(
                radius: 95.5,
                backgroundImage: AssetImage('assets/img/dosen_pria.png'), // CONTOH ASET
              ),
              const SizedBox(height: 20),
              
              //==================================================================
              //== DATA INFO DOSEN
              //==================================================================
              Text(
                "Dr. Budi Santoso",
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "214765",
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Dosen Teknik Informatika",
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              _buildMenuCard(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
      ),
      //==================================================================
      //== PENYESUAIAN MENU UNTUK DOSEN
      //==================================================================
      child: Column(
        children: [
          _buildMenuListItem(
            textTheme: textTheme,
            icon: Icons.notifications_outlined,
            title: "Notifikasi",
            trailing: Switch(
              value: _isNotificationOn,
              onChanged: (value) {
                setState(() {
                  _isNotificationOn = value;
                });
              },
              activeColor: Colors.blue.shade700,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
          const Divider(color: Colors.black, thickness: 1, height: 1),
          _buildMenuListItem(
            textTheme: textTheme,
            icon: Icons.shield_outlined,
            title: "Keamanan Akun",
            onTap: () {
              // Fungsi ini akan memanggil bottom sheet yang sudah kita buat
              showAccountSecureSheet(context);
            },
          ),
          const Divider(color: Colors.black, thickness: 1, height: 1),
          _buildMenuListItem(
            textTheme: textTheme,
            icon: Icons.exit_to_app_outlined,
            title: "Keluar Akun",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
            onTap: () async {
              // Fungsi ini akan memanggil dialog logout yang sudah kita buat
              final bool? shouldLogout = await showLogoutDialog(context);
              if (shouldLogout == true && mounted) {
                // Logika logout dan navigasi ke LoginScreen
                // Navigator.of(context).pushAndRemoveUntil(...);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuListItem({
    required TextTheme textTheme,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54, size: 26),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      dense: true,
    );
  }
}
