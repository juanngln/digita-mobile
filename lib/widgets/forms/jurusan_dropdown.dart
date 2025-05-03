import 'package:digita_mobile/models/jurusan.dart';
import 'package:digita_mobile/viewmodels/registration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JurusanDropdown extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final bool isFormEnabled;

  const JurusanDropdown({
    super.key,
    required this.viewModel,
    required this.isFormEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final bool canInteract =
        isFormEnabled && (viewModel.jurusanFetchState == ViewState.success);

    // --- State 1: Loading Jurusan ---
    if (viewModel.jurusanFetchState == ViewState.busy) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Memuat Jurusan...',
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
    // --- State 2: Error Loading Jurusan ---
    else if (viewModel.jurusanFetchState == ViewState.error) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Jurusan',
          errorText: viewModel.jurusanFetchError ?? "Gagal memuat",
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
              // Call fetchJurusan on retry
              onPressed: isFormEnabled ? () => viewModel.fetchJurusan() : null,
              tooltip: "Coba lagi muat data",
              splashRadius: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    }
    // --- State 3: Successfully Loaded Jurusan ---
    else {
      return DropdownButtonFormField<int>(
        value: viewModel.selectedJurusanId,
        hint: Text(
          'PILIH JURUSAN',
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
                ? (int? newValue) => viewModel.setSelectedJurusanId(newValue)
                : null,

        items:
            viewModel.jurusanList.map<DropdownMenuItem<int>>((Jurusan jurusan) {
              return DropdownMenuItem<int>(
                value: jurusan.id,

                child: Text(
                  jurusan.namaJurusan,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),

        validator:
            (value) => value == null ? 'Jurusan tidak boleh kosong' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
    }
  }
}
