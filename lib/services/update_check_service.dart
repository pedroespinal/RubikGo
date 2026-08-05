import 'dart:convert';

import 'package:http/http.dart' as http;

/// The GitHub repository RubikGo is published to.
const String kGitHubRepo = 'pedroespinal/RubikGo';

class UpdateCheckResult {
  final bool hasUpdate;
  final String latestVersion;
  final String releaseUrl;

  const UpdateCheckResult({
    required this.hasUpdate,
    required this.latestVersion,
    required this.releaseUrl,
  });
}

/// Checks GitHub Releases for a version newer than the one currently
/// installed. Never downloads or installs anything itself — it only
/// reports whether an update exists and where its release page is, so the
/// user can open GitHub and download it themselves.
class UpdateCheckService {
  final http.Client _client;
  final String repo;

  UpdateCheckService({http.Client? client, this.repo = kGitHubRepo}) : _client = client ?? http.Client();

  Future<UpdateCheckResult?> check(String currentVersion) async {
    try {
      final response = await _client
          .get(
            Uri.parse('https://api.github.com/repos/$repo/releases/latest'),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tag = (json['tag_name'] as String?)?.trim();
      final url = json['html_url'] as String?;
      if (tag == null || url == null) return null;

      final latestVersion = tag.startsWith('v') ? tag.substring(1) : tag;

      return UpdateCheckResult(
        hasUpdate: isNewerVersion(latestVersion, currentVersion),
        latestVersion: latestVersion,
        releaseUrl: url,
      );
    } catch (_) {
      return null;
    }
  }

  /// Compares two `major.minor.patch(+build)` version strings.
  /// Returns true if [remote] is strictly newer than [local].
  static bool isNewerVersion(String remote, String local) {
    List<int> parse(String v) {
      final core = v.split('+').first;
      return core.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    }

    final r = parse(remote);
    final l = parse(local);
    for (var i = 0; i < 3; i++) {
      final rv = i < r.length ? r[i] : 0;
      final lv = i < l.length ? l[i] : 0;
      if (rv != lv) return rv > lv;
    }
    return false;
  }
}
