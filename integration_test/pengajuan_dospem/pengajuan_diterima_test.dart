import 'package:digita_mobile/presentation/features/auth/login/screens/login_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/main_layout_mahasiswa.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/tidak_ada_dospem/screens/cari_dospem_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/tidak_ada_dospem/screens/list_dospem_screen.dart';
import 'package:digita_mobile/presentation/features/mahasiswa/tidak_ada_dospem/screens/status_pengajuan_dospem_screen.dart';
import 'package:digita_mobile/presentation/features/onboarding/screens/landing_screen.dart';
import 'package:digita_mobile/services/login_service.dart';
import 'package:digita_mobile/viewmodels/login_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

Future<void> customPumpAndSettle(
  WidgetTester tester, {
  int maxTries = 5,
  Duration step = const Duration(seconds: 10),
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
    'Pengajuan diterima oleh dosen pembimbing, masuk ke halaman home',
    (tester) async {
      await Firebase.initializeApp();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => LoginViewModel(LoginService()),
            ),
          ],
          child: MaterialApp(
            home: const LandingScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/cari_dosen': (context) => const CariDosen(),
              '/daftar_dosen': (context) => const DaftarDosen(),
              '/status_pengajuan_dosen': (context) => const StatusPengajuan(),
              '/home_mahasiswa': (context) => const MainLayoutMahasiswa(),
            },
          ),
        ),
      );

      // landing screen
      final logoFinder = find.byKey(Key('imgLogo'));
      expect(logoFinder, findsOneWidget);
      await tester.pumpAndSettle();

      final btnLoginFinder = find.byKey(Key('btnLogin'));
      await tester.tap(btnLoginFinder);
      await tester.pumpAndSettle();

      // login screen
      final textLoginFinder = find.text('Masuk ke DigiTA');
      expect(textLoginFinder, findsOneWidget);
      await tester.pumpAndSettle();

      final roleSelectorFinder = find.byKey(Key('roleSelector'));
      await tester.tap(roleSelectorFinder);
      await tester.pumpAndSettle();

      final roleMahasiswaFinder = find.text('Mahasiswa');
      await tester.tap(roleMahasiswaFinder);
      await tester.pumpAndSettle();

      final btnRoleSelectFinder = find.byKey(Key('btnRoleSelect'));
      await tester.tap(btnRoleSelectFinder);
      await tester.pumpAndSettle();

      final fieldNimFinder = find.byKey(Key('fieldNim'));
      expect(fieldNimFinder, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(fieldNimFinder, '3312301000');
      await tester.pumpAndSettle();

      final fieldPasswordFinder = find.byKey(Key('fieldPassword'));
      expect(fieldPasswordFinder, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(fieldPasswordFinder, 'mahasiswa123');
      await tester.pumpAndSettle();

      final btnSubmitLoginFinder = find.byKey(Key('btnSubmitLogin'));
      await tester.ensureVisible(btnSubmitLoginFinder);
      await tester.tap(btnSubmitLoginFinder);
      await customPumpAndSettle(tester);

      // home mahasiswa screen
      final imgAvatarMahasiwaFinder = find.byKey(Key('imgAvatarMahasiswa'));
      expect(imgAvatarMahasiwaFinder, findsOneWidget);
      await tester.pumpAndSettle();
    },
  );
}
