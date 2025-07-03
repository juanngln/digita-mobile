import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/models/program_studi_model.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';

void showAccountInfoSheet(BuildContext context, ProfileViewModel viewModel) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder:
        (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const AccountInfoSheet(),
        ),
  );
}

class AccountInfoSheet extends StatefulWidget {
  const AccountInfoSheet({super.key});

  @override
  State<AccountInfoSheet> createState() => _AccountInfoSheetState();
}

class _AccountInfoSheetState extends State<AccountInfoSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _nimController;
  ProgramStudi? _selectedProdi;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _nimController = TextEditingController();

    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

    if (viewModel.mahasiswaProfile != null) {
      final profile = viewModel.mahasiswaProfile!;
      _nameController.text = profile.namaLengkap;
      _emailController.text = profile.email;
      _nimController.text = profile.nim;
      _selectedProdi = profile.programStudi;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => viewModel.fetchProgramStudi(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

    if (_selectedProdi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih program studi Anda.")),
      );
      return;
    }

    // Corrected the method name from updateUserProfile to updateMahasiswaUserProfile
    final success = await viewModel.updateMahasiswaUserProfile(
      namaLengkap: _nameController.text,
      email: _emailController.text,
      programStudiId: _selectedProdi!.id.toString(),
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
            content: Text(
              viewModel.updateErrorMessage ?? "Gagal memperbarui profil.",
            ),
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
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Kelola Akun',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildEditableTextField(
                  textTheme: textTheme,
                  controller: _nameController,
                  label: "Nama lengkap",
                  hint: "Masukkan nama lengkap Anda",
                  validator:
                      (value) =>
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
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildEditableTextField(
                  textTheme: textTheme,
                  controller: _nimController,
                  label: "NIM",
                  hint: "NIM tidak dapat diubah",
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildProdiDropdown(textTheme: textTheme, viewModel: viewModel),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: PrimaryActionButton(
                    label: 'SIMPAN',
                    onPressed:
                        viewModel.updateState == UpdateProfileState.loading
                            ? null
                            : _handleSaveChanges,
                    child:
                        viewModel.updateState == UpdateProfileState.loading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Text("SIMPAN"),
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
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          keyboardType: keyboardType,
          hintText: '',
          readOnly: readOnly,
          validator: validator,
          fillColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildProdiDropdown({
    required TextTheme textTheme,
    required ProfileViewModel viewModel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Program Studi",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (viewModel.prodiState == ProfileState.loading)
          const Center(child: CircularProgressIndicator())
        else if (viewModel.prodiState == ProfileState.error)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              viewModel.prodiErrorMessage ?? "Gagal memuat data",
              style: TextStyle(color: Colors.red),
            ),
          )
        else
          DropdownButtonFormField<ProgramStudi>(
            value: _selectedProdi,
            items:
                viewModel.programStudiList.map((ProgramStudi prodi) {
                  return DropdownMenuItem<ProgramStudi>(
                    value: prodi,
                    child: Text(prodi.namaProdi),
                  );
                }).toList(),
            onChanged: (ProgramStudi? newValue) {
              setState(() {
                _selectedProdi = newValue;
              });
            },
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            validator:
                (value) =>
                    value == null ? 'Program Studi tidak boleh kosong' : null,
          ),
      ],
    );
  }
}
