import 'package:digita_mobile/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> customPumpAndSettle(
  WidgetTester tester, {
  int maxTries = 5,
  Duration step = const Duration(seconds: 2),
}) async {
  for (int i = 0; i < maxTries; i++) {
    await tester.pumpAndSettle(step);
    if (tester.binding.hasScheduledFrame == false) {
      break;
    }
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Tidak ada dosen pembimbing, mahasiswa mengajukan dosen pembimbing',
    (tester) async {
      await Firebase.initializeApp();

      await tester.pumpWidget(MyApp());

      // auth check screen
      final logoFinder = find.byKey(Key('imgLogo'));
      expect(logoFinder, findsOneWidget);
      await customPumpAndSettle(tester);

      // login screen
      final textLoginFinder = find.text('Masuk ke DigiTA');
      expect(textLoginFinder, findsOneWidget);

      final roleSelectorFinder = find.byKey(Key('roleSelector'));
      await tester.tap(roleSelectorFinder);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final roleMahasiswaFinder = find.text('Mahasiswa');
      await tester.tap(roleMahasiswaFinder);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final btnRoleSelectFinder = find.byKey(Key('btnRoleSelect'));
      await tester.tap(btnRoleSelectFinder);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final fieldNimFinder = find.byKey(Key('fieldNimNik'));
      expect(fieldNimFinder, findsOneWidget);
      await tester.enterText(fieldNimFinder, '3312301000');
      await tester.pumpAndSettle(Duration(seconds: 1));

      final fieldPasswordFinder = find.byKey(Key('fieldPassword'));
      expect(fieldPasswordFinder, findsOneWidget);
      await tester.enterText(fieldPasswordFinder, 'mahasiswa1234');
      await tester.pumpAndSettle(Duration(seconds: 1));

      final btnSubmitLoginFinder = find.byKey(Key('btnSubmitLogin'));
      await tester.ensureVisible(btnSubmitLoginFinder);
      await tester.tap(btnSubmitLoginFinder);
      await customPumpAndSettle(tester);

      final snackbarFinder = find.text('Login berhasil!');
      expect(snackbarFinder, findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // cari dosen screen
      final cariDosenTextFinder = find.byKey(Key('imgWaduh'));
      expect(cariDosenTextFinder, findsOneWidget);

      final btnCariDospemFinder = find.byKey(Key('btnCariDospem'));
      await tester.tap(btnCariDospemFinder);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // daftar dosen screen
      final cardDosenFinder = find.byKey(Key('dosen_card_0'));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.tap(cardDosenFinder);

      // form pengajuan dospem bottom sheet
      final fieldAlasanFinder = find.byKey(Key('fieldAlasan'));
      expect(fieldAlasanFinder, findsOneWidget);
      await tester.enterText(fieldAlasanFinder, 'Dosen baik');
      await tester.pumpAndSettle(Duration(seconds: 1));

      final fieldJudulFinder = find.byKey(Key('fieldJudul'));
      expect(fieldJudulFinder, findsOneWidget);
      await tester.enterText(
        fieldJudulFinder,
        'Pengembangan Aplikasi Bimbingan TA',
      );
      await tester.pumpAndSettle(Duration(seconds: 1));

      final fieldDeskripsiFinder = find.byKey(Key('fieldDeskripsi'));
      expect(fieldDeskripsiFinder, findsOneWidget);
      await tester.enterText(
        fieldDeskripsiFinder,
        'Sistem digital untuk bimbingan TA berbasis mobile',
      );
      await tester.pumpAndSettle(Duration(seconds: 1));

      final btnSubmitPengajuanFinder = find.byKey(Key('btnSubmitPengajuan'));
      await tester.ensureVisible(btnSubmitPengajuanFinder);
      await tester.tap(btnSubmitPengajuanFinder);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // status pengajuan screen
      final imgStatusTerkirimFinder = find.byKey(Key('imgStatusTerkirim'));
      expect(imgStatusTerkirimFinder, findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final btnStatusPengajuanFinder = find.byKey(Key('btnStatusPengajuan'));
      await tester.tap(btnStatusPengajuanFinder);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // status menunggu bottom sheet
      final imgStatusMenungguFinder = find.byKey(Key('imgStatusPengajuan'));
      expect(imgStatusMenungguFinder, findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 1));
    },
  );
}
