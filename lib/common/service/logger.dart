import 'package:logger/logger.dart';

// Initialize a Logger instance with a pretty printer for formatted output.
// Configured with no method count, 5 error method count, line length of 80, and no colors, emojis, or timestamps.
final Logger logger = Logger(
    printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: false,
        printEmojis: false,
        printTime: false
    )
);

// Logs an informational message with optional data, including a timestamp.
void info(String message, {Map<String, dynamic> data = const {}}) {
  logger.i("Info - ${DateTime.timestamp()} - $message - $data");
}

// Logs a warning message with optional data, including a timestamp.
void warning(String message, {Map<String, dynamic> data = const {}}) {
  logger.i("Warning - ${DateTime.timestamp()} - $message - $data");
}

// Logs an error message with optional data, including a timestamp.
void error(String message, {Map<String, dynamic> data = const {}}) {
  logger.i("Error - ${DateTime.timestamp()} - $message - $data");
}
