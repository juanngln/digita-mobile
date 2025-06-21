
import 'package:digita_mobile/models/dosen_model.dart';
import 'package:digita_mobile/presentation/common_widgets/buttons/primary_action_button.dart';
import 'package:digita_mobile/services/request_menjadi_dospem_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_area_input_field.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormPengajuanDosenWidget extends StatefulWidget {
  final Dosen selectedDosen;

  const FormPengajuanDosenWidget({super.key, required this.selectedDosen});

  @override
  State<FormPengajuanDosenWidget> createState() =>
      _FormPengajuanDosenWidgetState();
}

class _FormPengajuanDosenWidgetState extends State<FormPengajuanDosenWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dosenPembimbingController;
  final TextEditingController _alasanMemilihDosenController =
      TextEditingController();
  final TextEditingController _rencanaJudulController = TextEditingController();
  final TextEditingController _deskripsiSingkatController =
      TextEditingController();

  bool _isSubmitting = false;
  final RequestPembimbingKeDosenService _thesisSubmissionService =
  RequestPembimbingKeDosenService();
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _dosenPembimbingController = TextEditingController(
      text: widget.selectedDosen.nama,
    );
  }

  @override
  void dispose() {
    _dosenPembimbingController.dispose();
    _alasanMemilihDosenController.dispose();
    _rencanaJudulController.dispose();
    _deskripsiSingkatController.dispose();
    super.dispose();
  }

  Future<void> _submitPengajuan() async {
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() => _isSubmitting = true);

      try {
        final token = await _secureStorageService.getAccessToken();
        if (token == null) {
          throw Exception(
            "Token otentikasi tidak ditemukan. Silakan login kembali.",
          );
        }

        await _thesisSubmissionService.submitPengajuan(
          token: token,
          dosenId: widget.selectedDosen.userId,
          alasanMemilihDosen: _alasanMemilihDosenController.text,
          rencanaJudul: _rencanaJudulController.text,
          rencanaDeskripsi: _deskripsiSingkatController.text,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Pengajuan Berhasil Dikirim!",
              style: const TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
          ),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/status_pengajuan_dosen',
          ModalRoute.withName('/home_mahasiswa'),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengirim pengajuan: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the fill color for active fields, similar to your reference
    const activeFieldFillColor = Color(0xFFD9EEFF);
    final disabledFieldFillColor = Colors.grey[200];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20.0,
        left: 24.0,
        right: 24.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pengajuan Dosen Pembimbing',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Dosen Pembimbing',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _dosenPembimbingController,
                hintText: 'Nama Dosen Pembimbing',
                enabled: false,
                fillColor: disabledFieldFillColor,
              ),
              const SizedBox(height: 16),

              Text(
                'Alasan Memilih Dosen',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextAreaField(
                controller: _alasanMemilihDosenController,
                hintText: 'Jelaskan alasan Anda memilih dosen ini...',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alasan memilih dosen tidak boleh kosong';
                  }
                  return null;
                },
                fillColor: activeFieldFillColor, // Active field color
              ),
              const SizedBox(height: 16),

              Text(
                'Rencana Judul TA',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _rencanaJudulController,
                hintText: 'Masukkan rencana judul Tugas Akhir Anda',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Rencana Judul TA tidak boleh kosong';
                  }
                  return null;
                },
                fillColor: activeFieldFillColor,
              ),
              const SizedBox(height: 16),

              Text(
                'Deskripsi Singkat TA',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextAreaField(
                controller: _deskripsiSingkatController,
                hintText: 'Jelaskan secara singkat mengenai rencana TA Anda...',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi Singkat tidak boleh kosong';
                  }
                  return null;
                },
                fillColor: activeFieldFillColor,
              ),
              const SizedBox(height: 24),
              PrimaryActionButton(
                label: 'AJUKAN PENGAJUAN',
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _submitPengajuan,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
