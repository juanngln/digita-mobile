import 'package:http/http.dart' as http;
import 'package:digita_mobile/models/pengumuman.dart';
import 'package:digita_mobile/services/base_url.dart';

class PengumumanService {
  Future<List<Pengumuman>> fetchAnnouncements() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/v1/announcements/all/'),
      headers: {
        'Content-Type': 'application/json',
      },
    ).timeout(AppConfig.apiTimeout);

    if (response.statusCode == 200) {
      return pengumumanFromJson(response.body);
    } else {
      throw Exception('Failed to load announcements');
    }
  }
}