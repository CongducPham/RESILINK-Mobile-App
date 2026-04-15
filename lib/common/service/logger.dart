import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Initialize the logger instance with a PrettyPrinter for better formatting.
final Logger _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,          // Do not print method calls in stack trace.
    errorMethodCount: 5,     // Number of error stack trace lines.
    lineLength: 80,          // Maximum line length.
    colors: false,           // Disable colors.
    printEmojis: false,      // Disable emojis.
    printTime: false,        // Do not print timestamps (we handle it ourselves).
  ),
);

// Send log to a remote server (in production mode only).
// This function should be implemented to use HTTP or any other networking client.
void _logToServer(String level, String message, Map<String, dynamic> data) {
  // Example: Send log via POST request to your server
  // This is just a placeholder for your real implementation
}

// Log an informational message.
void info(String message, {Map<String, dynamic> data = const {}}) {
  _log("Info", message, data);
}

// Log a warning message.
void warning(String message, {Map<String, dynamic> data = const {}}) {
  _log("Warning", message, data);
}

// Log an error message.
void error(String message, {Map<String, dynamic> data = const {}}) {
  _log("Error", message, data);
}

// Internal log function that decides whether to log to console (debug) or send to server (production).
void _log(String level, String message, Map<String, dynamic> data) {
  final logMessage = "$level - ${DateTime.now()} - $message - $data";

  if (kDebugMode) {
    // In debug mode, print logs to console.
    _logger.i(logMessage);
  } else {
    // In production mode (when running from APK), send logs to server.
    _logToServer(level, message, data);
  }
}
