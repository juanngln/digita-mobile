import 'package:digita_mobile/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  testWidgets('Dosen menyetujui pangajuan mahasiswa', (tester) async {
    await Firebase.initializeApp();
    await initializeDateFormatting('id_ID', null);

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

    final roleDosenFinder = find.text('Dosen');
    await tester.tap(roleDosenFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    final btnRoleSelectFinder = find.byKey(Key('btnRoleSelect'));
    await tester.tap(btnRoleSelectFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    final fieldNikFinder = find.byKey(Key('fieldNimNik'));
    expect(fieldNikFinder, findsOneWidget);
    await tester.enterText(fieldNikFinder, '19902023');
    await tester.pumpAndSettle(Duration(seconds: 1));

    final fieldPasswordFinder = find.byKey(Key('fieldPassword'));
    expect(fieldPasswordFinder, findsOneWidget);
    await tester.enterText(fieldPasswordFinder, 'rani1234');
    await tester.pumpAndSettle(Duration(seconds: 1));

    final btnSubmitLoginFinder = find.byKey(Key('btnSubmitLogin'));
    await tester.ensureVisible(btnSubmitLoginFinder);
    await tester.tap(btnSubmitLoginFinder);
    await customPumpAndSettle(tester);

    final snackbarFinder = find.text('Login berhasil!');
    expect(snackbarFinder, findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));

    // home dosen screen
    final imgAvatarDosenFinder = find.byKey(Key('imgAvatarDosen'));
    expect(imgAvatarDosenFinder, findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));

    final navMahasiswaFinder = find.byKey(Key('navMahasiswa'));
    await tester.tap(navMahasiswaFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    // pengajuan mahasiswa screen
    final headerPengajuanMhsFinder = find.text('Pengajuan Mahasiswa');
    expect(headerPengajuanMhsFinder, findsOneWidget);

    final cardMahasiswaFinder = find.byKey(Key('card_mhs_0'));
    await tester.tap(cardMahasiswaFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    // form pengajuan mahasiswa bottom sheet
    final btnSetujuPengajuanFinder = find.byKey(Key('btnSetuju'));
    await tester.tap(btnSetujuPengajuanFinder);
    await customPumpAndSettle(tester);

    final snackbarPengajuanFinder = find.byKey(Key('snackbarPengajuan'));
    expect(snackbarPengajuanFinder, findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));
  });
}
