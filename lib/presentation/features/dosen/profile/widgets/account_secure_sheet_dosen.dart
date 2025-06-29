import 'package:digita_mobile/models/jurusan_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';

void showAccountInfoSheetDosen(BuildContext context, ProfileViewModel viewModel) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ChangeNotifierProvider.value(
      value: viewModel,
      child: const AccountInfoSheetDosen(),
    ),
  );
}

class AccountInfoSheetDosen extends StatefulWidget {
  const AccountInfoSheetDosen({super.key});

  @override
  State<AccountInfoSheetDosen> createState() => _AccountInfoSheetDosenState();
}

class _AccountInfoSheetDosenState extends State<AccountInfoSheetDosen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _nikController;
  Jurusan? _selectedJurusan;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _nikController = TextEditingController();

    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

    if (viewModel.loggedInDosenProfile != null) {
      final profile = viewModel.loggedInDosenProfile!;
      _nameController.text = profile.namaLengkap;
      _emailController.text = profile.email;
      _nikController.text = profile.nik;
      _selectedJurusan = profile.jurusan;
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) => viewModel.fetchJurusan());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

    if (_selectedJurusan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih jurusan Anda.")),
      );
      return;
    }

    final success = await viewModel.updateDosenProfile(
      namaLengkap: _nameController.text,
      email: _emailController.text,
      jurusanId: _selectedJurusan!.id.toString(),
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text(viewModel.updateErrorMessage ?? "Gagal memperbarui profil."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<ProfileViewModel>();

    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 153,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Informasi Akun",
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 24),
                _buildEditableTextField(
                  textTheme: textTheme,
                  controller: _nameController,
                  label: "Nama lengkap",
                  hint: "Masukkan nama lengkap Anda",
                  validator: (value) =>
                  value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                _buildEditableTextField(
                  textTheme: textTheme,
                  controller: _emailController,
                  label: "Email",
                  hint: "Masukkan email Anda",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Email tidak boleh kosong';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildEditableTextField(
                  textTheme: textTheme,
                  controller: _nikController,
                  label: "NIK",
                  hint: "NIK tidak dapat diubah",
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildJurusanDropdown(textTheme: textTheme, viewModel: viewModel),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: viewModel.updateState == UpdateProfileState.loading
                        ? null
                        : _handleSaveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    child: viewModel.updateState == UpdateProfileState.loading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                        : const Text("SIMPAN PERUBAHAN"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextTheme textTheme,
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: textTheme.bodyMedium?.copyWith(
            color: readOnly ? Colors.grey.shade700 : Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? Colors.grey.shade200 : Colors.blue.shade50,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            hintText: hint,
            hintStyle:
            textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildJurusanDropdown(
      {required TextTheme textTheme, required ProfileViewModel viewModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Jurusan",
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        if (viewModel.jurusanState == ProfileState.loading)
          const Center(child: CircularProgressIndicator())
        else if (viewModel.jurusanState == ProfileState.error)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(viewModel.jurusanErrorMessage ?? "Gagal memuat data",
                style: const TextStyle(color: Colors.red)),
          )
        else
          DropdownButtonFormField<Jurusan>(
            value: _selectedJurusan,
            items: viewModel.jurusanList
                .map<DropdownMenuItem<Jurusan>>((Jurusan jurusan) {
              return DropdownMenuItem<Jurusan>(
                value: jurusan,
                child: Text(jurusan.namaJurusan),
              );
            }).toList(),
            onChanged: (Jurusan? newValue) {
              setState(() {
                _selectedJurusan = newValue;
              });
            },
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
            validator: (value) =>
            value == null ? 'Jurusan tidak boleh kosong' : null,
          ),
      ],
    );
  }
}
