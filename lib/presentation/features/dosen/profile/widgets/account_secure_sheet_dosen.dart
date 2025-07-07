import 'package:digita_mobile/models/jurusan_model.dart';
import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digita_mobile/viewmodels/profile_viewmodel.dart';

void showAccountInfoSheetDosen(
  BuildContext context,
  ProfileViewModel viewModel,
) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    enableDrag: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder:
        (context) => ChangeNotifierProvider.value(
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

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => viewModel.fetchJurusan(),
    );
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
                  controller: _nikController,
                  label: "NIK",
                  hint: "NIK tidak dapat diubah",
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                _buildJurusanDropdown(
                  textTheme: textTheme,
                  viewModel: viewModel,
                ),
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

  Widget _buildJurusanDropdown({
    required TextTheme textTheme,
    required ProfileViewModel viewModel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jurusan",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (viewModel.jurusanState == ProfileState.loading)
          const Center(child: CircularProgressIndicator())
        else if (viewModel.jurusanState == ProfileState.error)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              viewModel.jurusanErrorMessage ?? "Gagal memuat data",
              style: const TextStyle(color: Colors.red),
            ),
          )
        else
          DropdownButtonFormField<Jurusan>(
            value: _selectedJurusan,
            items:
                viewModel.jurusanList.map<DropdownMenuItem<Jurusan>>((
                  Jurusan jurusan,
                ) {
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
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
            validator:
                (value) => value == null ? 'Jurusan tidak boleh kosong' : null,
          ),
      ],
    );
  }
}
