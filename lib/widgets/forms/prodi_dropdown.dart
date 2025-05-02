// lib/widgets/program_studi_dropdown.dart
import 'package:digita_mobile/models/program_studi.dart';
import 'package:digita_mobile/viewmodels/registrasi_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgramStudiDropdown extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final bool isFormEnabled;

  const ProgramStudiDropdown({
    super.key,
    required this.viewModel,
    required this.isFormEnabled,
  });

  @override
  Widget build(BuildContext context) {
    // menentukan apakah dropdown dapat diinteraksi
    final bool canInteract =
        isFormEnabled && (viewModel.prodiFetchState == ViewState.success);

    // --- Loading prodi ---
    if (viewModel.prodiFetchState == ViewState.busy) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Memuat Program Studi...',
          labelStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 20.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Loading...'),
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      );
    }
    // ---  Error Loading prodi ---
    else if (viewModel.prodiFetchState == ViewState.error) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Program Studi',
          errorText: viewModel.prodiFetchError ?? "Gagal memuat",
          errorMaxLines: 2,
          filled: true,
          fillColor: Colors.red[50],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Gagal Memuat Data',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.red[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.red[700]),
              onPressed:
                  isFormEnabled ? () => viewModel.fetchProgramStudi() : null,
              tooltip: "Coba lagi muat data",
              splashRadius: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    }
    // Sukses loading prodi
    else {
      return DropdownButtonFormField<int>(
        value: viewModel.selectedProdiId,
        hint: Text(
          'PILIH PROGRAM STUDI',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
        ),
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: canInteract ? Colors.black : Colors.grey[700],
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: canInteract ? Colors.white : Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
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
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged:
            canInteract
                ? (int? newValue) => viewModel.setSelectedProdiId(newValue)
                : null, // Call VM method
        items:
            viewModel.programStudiList.map<DropdownMenuItem<int>>((
              ProgramStudi prodi,
            ) {
              return DropdownMenuItem<int>(
                value: prodi.id,
                child: Text(prodi.namaProdi, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
        validator:
            (value) =>
                value == null ? 'Program Studi tidak boleh kosong' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
    }
  }
}
