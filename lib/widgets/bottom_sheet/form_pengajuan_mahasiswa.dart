import 'package:digita_mobile/models/list_request_pembimbing_dari_mahasiswa_model.dart';
import 'package:digita_mobile/services/list_request_pembimbing_dari_mahasiswa_service.dart';
import 'package:digita_mobile/services/secure_storage_service.dart';
import 'package:digita_mobile/widgets/dialog.dart';
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pengajuan telah berhasil di-$status.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengajuan Dosen Pembimbing',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection('Nama Mahasiswa',
                              widget.selectedRequest.mahasiswaNama),
                          const SizedBox(height: 20),
                          _buildInfoSection('Alasan Memilih Dosen',
                              widget.selectedRequest.alasanMemilihDosen),
                          const SizedBox(height: 20),
                          _buildInfoSection('Rencana Judul TA',
                              widget.selectedRequest.rencanaJudul),
                          const SizedBox(height: 20),
                          _buildInfoSection('Deskripsi Singkat',
                              widget.selectedRequest.deskripsiSingkat),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD9EEFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}