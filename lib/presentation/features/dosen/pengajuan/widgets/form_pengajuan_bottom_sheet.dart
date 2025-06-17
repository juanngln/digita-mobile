import 'package:digita_mobile/models/list_request_pembimbing_dari_mahasiswa_model.dart';
import 'package:digita_mobile/presentation/common_widgets/base_bottom_sheet.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_display_field.dart';
import 'package:digita_mobile/services/list_request_pembimbing_dari_mahasiswa_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/presentation/common_widgets/dialog.dart';
import 'package:flutter/material.dart';

class FormPengajuanMahasiswaWidget extends StatefulWidget {
  final ListRequestPembimbingDariMahasiswaModel selectedRequest;

  const FormPengajuanMahasiswaWidget({
    super.key,
    required this.selectedRequest,
  });

  @override
  State<FormPengajuanMahasiswaWidget> createState() =>
      _FormPengajuanMahasiswaWidgetState();
}

class _FormPengajuanMahasiswaWidgetState
    extends State<FormPengajuanMahasiswaWidget> {
  final ListRequestPembimbingDariMahasiswaService _service =
  ListRequestPembimbingDariMahasiswaService();
  final SecureStorageService _storage = SecureStorageService();
  final _rejectionReasonController = TextEditingController();

  bool _isAccepting = false;
  bool _isRejecting = false;

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }

  Future<void> _handleRespond(String status, String message) async {
    if (_isAccepting || _isRejecting) return;

    setState(() {
      if (status == 'ACCEPTED') _isAccepting = true;
      if (status == 'REJECTED') _isRejecting = true;
    });

    try {
      final token = await _storage.getAccessToken();
      if (token == null) {
        throw Exception("Token tidak ditemukan.");
      }

      await _service.respondToRequest(
        requestId: widget.selectedRequest.id,
        status: status,
        responseMessage: message,
        token: token,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pengajuan telah berhasil di-$status.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAccepting = false;
          _isRejecting = false;
        });
      }
    }
  }

  void _showRejectionDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Tolak Pengajuan',
        contentWidget: TextField(
          controller: _rejectionReasonController,
          decoration: const InputDecoration(
            hintText: 'Masukkan alasan penolakan...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        cancelText: 'Batal',
        confirmText: 'Kirim',
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          if (_rejectionReasonController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Alasan tidak boleh kosong.'),
              backgroundColor: Colors.orange,
            ));
            return;
          }
          Navigator.pop(context);
          _handleRespond('REJECTED', _rejectionReasonController.text);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BaseBottomSheet(
      title: 'Pengajuan Dosen Pembimbing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDisplayField(
            label: 'Nama Mahasiswa',
            value: widget.selectedRequest.mahasiswaNama,
          ),
          const SizedBox(height: 20),
          CustomDisplayField(
            label: 'Alasan Memilih Dosen',
            value: widget.selectedRequest.alasanMemilihDosen,
          ),
          const SizedBox(height: 20),
          CustomDisplayField(
            label: 'Rencana Judul TA',
            value: widget.selectedRequest.rencanaJudul,
          ),
          const SizedBox(height: 20),
          CustomDisplayField(
            label: 'Deskripsi Singkat',
            value: widget.selectedRequest.deskripsiSingkat,
          ),
          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isRejecting ? null : _showRejectionDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB3BA),
                    foregroundColor: const Color(0xFFE20030),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isRejecting
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Tolak',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isAccepting
                      ? null
                      : () => _handleRespond('ACCEPTED',
                      'Saya terima pengajuan Anda. Silakan siapkan proposal awal.'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB7FCC9),
                    foregroundColor: const Color(0xFF0A7D0C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isAccepting
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Setuju',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}