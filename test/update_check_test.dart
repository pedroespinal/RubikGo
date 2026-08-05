import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rubik_go/services/update_check_service.dart';

void main() {
  group('semver comparison', () {
    test('a higher patch version is newer', () {
      expect(UpdateCheckService.isNewerVersion('1.0.1', '1.0.0'), isTrue);
    });

    test('the same version is not newer', () {
      expect(UpdateCheckService.isNewerVersion('1.2.3', '1.2.3'), isFalse);
    });

    test('a lower version is not newer', () {
      expect(UpdateCheckService.isNewerVersion('1.0.0', '1.2.0'), isFalse);
    });

    test('build numbers are ignored, only major.minor.patch matter', () {
      expect(UpdateCheckService.isNewerVersion('1.0.0+42', '1.0.0+7'), isFalse);
    });

    test('a higher major version wins regardless of minor/patch', () {
      expect(UpdateCheckService.isNewerVersion('2.0.0', '1.9.9'), isTrue);
    });
  });

  group('check() against the GitHub Releases API', () {
    test('reports an update when the latest tag is newer', () async {
      final client = MockClient((request) async {
        expect(request.url.toString(), contains('api.github.com/repos/pedroespinal/RubikGo'));
        return http.Response(
          '{"tag_name": "v1.1.0", "html_url": "https://github.com/pedroespinal/RubikGo/releases/tag/v1.1.0"}',
          200,
        );
      });
      final service = UpdateCheckService(client: client);

      final result = await service.check('1.0.0');

      expect(result, isNotNull);
      expect(result!.hasUpdate, isTrue);
      expect(result.latestVersion, '1.1.0');
      expect(result.releaseUrl, contains('v1.1.0'));
    });

    test('reports no update when already on the latest version', () async {
      final client = MockClient((request) async {
        return http.Response('{"tag_name": "v1.0.0", "html_url": "https://example.com"}', 200);
      });
      final service = UpdateCheckService(client: client);

      final result = await service.check('1.0.0');

      expect(result, isNotNull);
      expect(result!.hasUpdate, isFalse);
    });

    test('returns null on a network error', () async {
      final client = MockClient((request) async => http.Response('error', 500));
      final service = UpdateCheckService(client: client);

      final result = await service.check('1.0.0');

      expect(result, isNull);
    });
  });
}
