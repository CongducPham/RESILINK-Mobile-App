import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(Uri url) async {
  // First with WebView
  final init = await launchUrl(url, mode: LaunchMode.platformDefault);

  // If not possible or for whatsapp, in externalApplication
  if (!init) {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Impossible d'ouvrir l'URL : $url");
    }
  }
}