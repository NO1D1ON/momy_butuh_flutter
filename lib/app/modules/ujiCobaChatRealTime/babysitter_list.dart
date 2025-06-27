import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart'; // Sesuaikan path
import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/chatScreen.dart'; // Sesuaikan path
import 'package:momy_butuh_flutter/app/utils/constants.dart'; // Sesuaikan path

// Model sederhana untuk menampung data Babysitter
class Babysitter {
  final int id;
  final String name;
  final double rating;

  Babysitter({required this.id, required this.name, required this.rating});

  factory Babysitter.fromJson(Map<String, dynamic> json) {
    return Babysitter(
      id: json['id'],
      name: json['name'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
    );
  }
}

class BabysitterListScreen extends StatefulWidget {
  const BabysitterListScreen({Key? key}) : super(key: key);

  @override
  _BabysitterListScreenState createState() => _BabysitterListScreenState();
}

class _BabysitterListScreenState extends State<BabysitterListScreen> {
  late Future<List<Babysitter>> _babysittersFuture;
  final AuthService _authService = AuthService();
  final http.Client _httpClient = http.Client();

  @override
  void initState() {
    super.initState();
    _babysittersFuture = _fetchBabysitters();
  }

  Future<List<Babysitter>> _fetchBabysitters() async {
    // Panggil API untuk mendapatkan daftar semua babysitter
    final response = await _httpClient.get(
      Uri.parse('${AppConstants.baseUrl}/babysitters'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Babysitter.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat daftar babysitter');
    }
  }

  Future<void> _startChatWith(Babysitter babysitter) async {
    // Panggil API baru untuk memulai percakapan
    final token = await _authService.getToken();
    if (token == null) return;

    try {
      final response = await _httpClient.post(
        Uri.parse('${AppConstants.baseUrl}/conversations/initiate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'babysitter_id': babysitter.id}),
      );

      if (response.statusCode == 200) {
        final conversationData = json.decode(response.body);
        final conversationId = conversationData['id'];

        if (mounted) {
          // Navigasi ke ChatScreen dengan data yang diperlukan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversationId: conversationId,
                otherPartyName: babysitter.name,
                otherPartyId: babysitter.id,
                authService: _authService,
                httpClient: _httpClient,
              ),
            ),
          );
        }
      } else {
        throw Exception('Gagal memulai percakapan');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mulai Obrolan Baru')),
      body: FutureBuilder<List<Babysitter>>(
        future: _babysittersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada babysitter tersedia.'));
          }

          final babysitters = snapshot.data!;
          return ListView.builder(
            itemCount: babysitters.length,
            itemBuilder: (context, index) {
              final babysitter = babysitters[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(babysitter.name.substring(0, 1)),
                ),
                title: Text(babysitter.name),
                subtitle: Text('Rating: ${babysitter.rating}'),
                trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () => _startChatWith(babysitter),
              );
            },
          );
        },
      ),
    );
  }
}
