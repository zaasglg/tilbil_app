// Thin re-export wrapper: use the external package's AnimatedButton directly.
// This avoids duplicate implementations and keeps the project's import path
// `package:til_bil_app/widgets/animated_button.dart` resolving to the
// package-provided widget.

export 'package:animated_button/animated_button.dart';
