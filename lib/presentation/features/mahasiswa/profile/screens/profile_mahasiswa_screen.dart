import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/presentation/common_widgets/dialogs/logout_dialog.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/profile/widgets/account_secure_sheet.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/profile/screens/dosen_pembimbing_info_screen.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';
import 'package:digita_mobile/models/mahasiswa_profile.dart';

class ProfileMahasiswaScreen extends StatefulWidget {
  const ProfileMahasiswaScreen({super.key});

  @override
  State<ProfileMahasiswaScreen> createState() => _ProfileMahasiswaScreen();
}

class _ProfileMahasiswaScreen extends State<ProfileMahasiswaScreen> {
  bool _isNotificationOn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final profileViewModel = Provider.of<ProfileViewModel>(context);

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
      body: _buildBody(context, profileViewModel),
    );
  }

  Widget _buildBody(BuildContext context, ProfileViewModel viewModel) {
    switch (viewModel.state) {
      case ProfileState.loading:
        return const Center(child: CircularProgressIndicator());
      case ProfileState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(viewModel.errorMessage ?? "Terjadi kesalahan"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.loadUserProfile(),
                child: const Text("Coba Lagi"),
              )
            ],
          ),
        );
      case ProfileState.success:
        if (viewModel.mahasiswaProfile == null) {
          return const Center(child: Text("Profil mahasiswa tidak ditemukan."));
        }
        return _buildProfileContent(context, viewModel.mahasiswaProfile!);
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildProfileContent(BuildContext context, MahasiswaProfile mahasiswa) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 95.5,
              backgroundImage: AssetImage('assets/img/mhs_pria.png'),
            ),
            const SizedBox(height: 20),
            Text(
              mahasiswa.namaLengkap,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mahasiswa.nim,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mahasiswa.programStudi.namaProdi,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            _buildMenuCard(context, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, TextTheme textTheme) {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    if (profileViewModel.mahasiswaProfile == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuListItem(
            textTheme: textTheme,
            icon: Icons.notifications_outlined,
            title: "Notifikasi",
            trailing: Switch(
              value: _isNotificationOn,
              onChanged: (value) => setState(() => _isNotificationOn = value),
              activeColor: Colors.blue.shade700,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
          const Divider(color: Colors.black, thickness: 1, height: 1),
          _buildMenuListItem(
            textTheme: textTheme,
            icon: Icons.person_search_outlined,
            title: "Informasi Dosen Pembimbing",
            onTap: () {
              final int? dosenId = profileViewModel.mahasiswaProfile?.dosenPembimbingId;

              if (dosenId != null && dosenId > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: profileViewModel,
                      child: DosenPembimbingInfoScreen(
                        dosenId: dosenId,
                      ),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Dosen Pembimbing belum ditentukan."),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
          const Divider(color: Colors.black, thickness: 1, height: 1),
          _buildMenuListItem(
            textTheme: textTheme,
            icon: Icons.shield_outlined,
            title: "Kelola Akun",
            onTap: () {
              showAccountInfoSheet(context, profileViewModel);
            },
          ),
          const Divider(color: Colors.black, thickness: 1, height: 1),
          _buildMenuListItem(
            textTheme: textTheme,
            icon: Icons.exit_to_app_outlined,
            title: "Keluar Akun",
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
            onTap: () async {
              final bool? shouldLogout = await showLogoutDialog(context);
              if (shouldLogout == true) {
                // Handle logout logic
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
