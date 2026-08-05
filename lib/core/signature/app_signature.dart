/// Immutable creation and build identity of RubikGo.
///
/// None of these values can be changed from within the running app — there
/// is no settings entry that writes to them. [creationDate] and [author]
/// are source-code constants that only change if the source itself is
/// edited and recompiled. [buildSignature] is computed by
/// `scripts/build_release.ps1` at compile time (a SHA-256 fingerprint of
/// the version, author, creation date and git commit) and injected via
/// `--dart-define`, so it is only ever set by the official release build
/// process, never by the app itself.
class AppSignature {
  AppSignature._();

  static const String author = 'Pedro Espinal';

  /// The day this project was first created. Fixed forever.
  static const String creationDate = '2026-08-05';

  static const String buildSignature = String.fromEnvironment(
    'BUILD_SIGNATURE',
    defaultValue: 'dev-build (unsigned)',
  );

  static const String buildCommit = String.fromEnvironment(
    'BUILD_COMMIT',
    defaultValue: 'nogit',
  );
}
