import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  final Future<void> Function() onResumed;

  // Stores the timestamp when the app went to background
  DateTime? _backgroundedAt;

  // Minimum background duration before triggering onResumed
  static const Duration _minBackgroundDuration = Duration(minutes: 30);

  AppLifecycleObserver(this.onResumed) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App goes to background — store the timestamp
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      // App comes back to foreground — only trigger if background duration
      // exceeds the threshold, to avoid unnecessary calls when returning
      // from camera or gallery.
      if (_backgroundedAt != null) {
        final elapsed = DateTime.now().difference(_backgroundedAt!);
        if (elapsed > _minBackgroundDuration) {
          onResumed();
        }
      }
      _backgroundedAt = null;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}