/// Citrus - Windows-first file conversion and editing utility.

import 'package:flutter/material.dart';
import 'package:citrus/app/app.dart';
import 'package:citrus/features/image_tools/image_actions.dart';

void main() {
  // Register all conversion actions
  registerImageActions();

  // Initialize services
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CitrusApp());
}
