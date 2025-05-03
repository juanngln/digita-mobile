import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/jurusan.dart';
// Adjust import paths as needed
import '../../viewmodels/register_viewmodel.dart';

class JurusanDropdown extends StatelessWidget {
  final RegistrationViewModel viewModel;
  final bool isFormEnabled; // To disable interaction during registration

  const JurusanDropdown({
    super.key,
    required this.viewModel,
    required this.isFormEnabled,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the dropdown itself can be interacted with
    // Use Jurusan fetch state here
    final bool canInteract =
        isFormEnabled && (viewModel.jurusanFetchState == ViewState.success);

    // --- State 1: Loading Jurusan ---
    if (viewModel.jurusanFetchState == ViewState.busy) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Memuat Jurusan...', // Changed text
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
          labelText: 'Jurusan', // Changed text
          errorText:
              viewModel.jurusanFetchError ??
              "Gagal memuat", // Use Jurusan error
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
        // Use Jurusan state
        value: viewModel.selectedJurusanId,
        hint: Text(
          'PILIH JURUSAN',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
        ), // Changed text
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
        // Call setSelectedJurusanId on change
        onChanged:
            canInteract
                ? (int? newValue) => viewModel.setSelectedJurusanId(newValue)
                : null,
        // Build items from jurusanList
        items:
            viewModel.jurusanList.map<DropdownMenuItem<int>>((Jurusan jurusan) {
              // Use Jurusan type
              return DropdownMenuItem<int>(
                value: jurusan.id,
                // Use namaJurusan (or whatever the field name is in your Jurusan model)
                child: Text(
                  jurusan.namaJurusan,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
        // Update validator message
        validator:
            (value) => value == null ? 'Jurusan tidak boleh kosong' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
    }
  }
}
