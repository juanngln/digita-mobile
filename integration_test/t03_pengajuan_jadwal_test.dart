import 'package:digita_mobile/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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

  testWidgets('Mahasiswa mengajukan jadwal bimbingan', (tester) async {
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

    // home mahasiswa screen
    final imgAvatarMahasiwaFinder = find.byKey(Key('imgAvatarMahasiswa'));
    expect(imgAvatarMahasiwaFinder, findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));

    final navJadwalFinder = find.byKey(Key('navSchedule'));
    await tester.tap(navJadwalFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    // jadwal mahasiswa screen
    final titleJadwalFinder = find.text('Jadwal Bimbingan');
    expect(titleJadwalFinder, findsOneWidget);

    final fabJadwalFinder = find.byKey(Key('fabJadwal'));
    await tester.tap(fabJadwalFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    final fieldJudulFinder = find.byKey(Key('fieldJudul'));
    await tester.enterText(fieldJudulFinder, 'Diskusi Perancangan Sistem');
    await tester.pumpAndSettle(Duration(seconds: 1));

    final fieldTanggalFinder = find.byKey(Key('fieldTanggal'));
    expect(fieldTanggalFinder, findsOneWidget);
    await tester.tap(fieldTanggalFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));
    final dateFinder = find.text('28');
    await tester.tap(dateFinder);
    await tester.pumpAndSettle();
    final btnConfirmDateTimeFinder = find.text('OK');
    await tester.tap(btnConfirmDateTimeFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));
    
    final fieldWaktuFinder = find.byKey(Key('fieldWaktu'));
    expect(fieldWaktuFinder, findsOneWidget);
    await tester.tap(fieldWaktuFinder);
    await tester.pumpAndSettle();
    await tester.tap(btnConfirmDateTimeFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    final dropdownLokasiFinder = find.byKey(Key('dropdownLokasi'));
    await tester.tap(dropdownLokasiFinder);
    await tester.pumpAndSettle();
    final locationFinder = find.text('GU 705');
    await tester.tap(locationFinder);
    await tester.pumpAndSettle(Duration(seconds: 1));

    final btnSubmitJadwalFinder = find.byKey(Key('btnSubmitJadwal'));
    await tester.tap(btnSubmitJadwalFinder);
    await customPumpAndSettle(tester);

    final snackbarJadwalFinder = find.byKey(Key('snackbarJadwal'));
    expect(snackbarJadwalFinder, findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));
  });
}
