import 'package:flutter/material.dart';

import 'app.dart';
import 'services/prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService.instance.load();
  runApp(const RubikGoApp());
}
