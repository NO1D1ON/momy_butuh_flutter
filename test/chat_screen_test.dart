// File: test/chat_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

// Sesuaikan path ini dengan struktur proyek Anda
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/chatScreen.dart';
import 'package:momy_butuh_flutter/app/utils/constants.dart'; // Pastikan AppConstants diimpor

import 'chat_screen_test.mocks.dart';

@GenerateMocks([AuthService, http.Client])
void main() {
  late MockAuthService mockAuthService;
  late MockClient mockHttpClient;

  setUp(() {
    mockAuthService = MockAuthService();
    mockHttpClient = MockClient();
  });

  Widget createTestableWidget() {
    return MaterialApp(
      home: ChatScreen(
        conversationId: 1,
        otherPartyName: 'Budi',
        otherPartyId: 2,
        authService: mockAuthService,
        httpClient: mockHttpClient,
      ),
    );
  }

  // Data palsu untuk respons API
  final emptyMessagesJson = '{"data": []}';
  final broadcastAuthJson = '{"auth": "fake_auth_key_for_testing"}';
  final sendMessageSuccessJson =
      '{"id": 3, "body": "Halo dari saya", "sender_id": 1}';

  // --- SKENARIO PENGUJIAN ---

  testWidgets('Menampilkan UI dengan benar setelah data berhasil dimuat', (
    WidgetTester tester,
  ) async {
    // ARRANGE: Siapkan jawaban palsu untuk SEMUA panggilan API di initState
    when(mockAuthService.getToken()).thenAnswer((_) async => 'fake_token');
    when(mockAuthService.getProfile()).thenAnswer(
      (_) async => {
        'success': true,
        'data': {'id': 1, 'name': 'User Test'},
      },
    );

    // Mock untuk GET riwayat pesan
    when(
      mockHttpClient.get(
        Uri.parse('${AppConstants.baseUrl}/conversations/1/messages'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => http.Response(emptyMessagesJson, 200));

    // Mock untuk POST markAsRead
    when(
      mockHttpClient.post(
        Uri.parse('${AppConstants.baseUrl}/conversations/1/read'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => http.Response('{"message": "ok"}', 200));

    // Mock untuk POST otorisasi broadcast
    when(
      mockHttpClient.post(
        Uri.parse(
          '${AppConstants.baseUrl.replaceFirst('/api', '')}/broadcasting/auth',
        ),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => http.Response(broadcastAuthJson, 200));

    // ACT: Render widget
    await tester.pumpWidget(createTestableWidget());
    await tester.pumpAndSettle();

    // ASSERT: Verifikasi hasilnya
    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
      reason: 'Indikator loading seharusnya sudah hilang',
    );
    expect(
      find.text('Budi'),
      findsOneWidget,
      reason: 'Nama lawan bicara harus ada di AppBar',
    );
    expect(
      find.byType(TextField),
      findsOneWidget,
      reason: 'Kolom input pesan harus tampil',
    );
  });

  testWidgets('Mengetik dan mengirim pesan berhasil (UI Optimis)', (
    WidgetTester tester,
  ) async {
    // ARRANGE: Siapkan mock seperti tes sebelumnya untuk melewati initState
    when(mockAuthService.getToken()).thenAnswer((_) async => 'fake_token');
    when(mockAuthService.getProfile()).thenAnswer(
      (_) async => {
        'success': true,
        'data': {'id': 1, 'name': 'User Test'},
      },
    );
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(emptyMessagesJson, 200));
    when(
      mockHttpClient.post(
        Uri.parse(
          '${AppConstants.baseUrl.replaceFirst('/api', '')}/broadcasting/auth',
        ),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => http.Response(broadcastAuthJson, 200));
    when(
      mockHttpClient.post(
        Uri.parse('${AppConstants.baseUrl}/conversations/1/read'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => http.Response('{"message": "ok"}', 200));

    // PERBAIKAN: Mock spesifik untuk panggilan pengiriman pesan
    when(
      mockHttpClient.post(
        Uri.parse('${AppConstants.baseUrl}/messages'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => http.Response(sendMessageSuccessJson, 201));

    await tester.pumpWidget(createTestableWidget());
    await tester.pumpAndSettle();

    // ACT
    expect(find.text('Halo dari saya'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Halo dari saya');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    // ASSERT
    expect(find.text('Halo dari saya'), findsOneWidget);
  });
}
