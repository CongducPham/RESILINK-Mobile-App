import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../models/RegisteredServer.dart';
import '../../../providers/main_provider.dart';
import '../service/server_list_services.dart';

class ServerListProvider extends ChangeNotifier {

  final ServerListServices _services = ServerListServices();

  List<RegisteredServer> _servers = [];
  Set<String> _favoriteUrls = {};

  bool _isLoadingServers = false;
  bool _isLoadingFavorites = false;
  bool _finishedFetchServers = false;
  bool _finishedFetchFavorites = false;

  // Per-server loading state for toggle animation
  Set<String> _togglingFavorites = {};

  List<RegisteredServer> get servers => _servers;
  Set<String> get favoriteUrls => _favoriteUrls;
  bool get isLoadingServers => _isLoadingServers;
  bool get isLoadingFavorites => _isLoadingFavorites;
  bool get isLoading => _isLoadingServers || _isLoadingFavorites;
  bool get finishedFetch => _finishedFetchServers && _finishedFetchFavorites;

  bool isFavorite(String serverUrl) => _favoriteUrls.contains(serverUrl);
  bool isToggling(String serverUrl) => _togglingFavorites.contains(serverUrl);

  List<RegisteredServer> get favoriteServers =>
      _servers.where((s) => _favoriteUrls.contains(s.serverUrl)).toList();

  List<RegisteredServer> get nonFavoriteServers =>
      _servers.where((s) => !_favoriteUrls.contains(s.serverUrl)).toList();

  Future<void> fetchAll(BuildContext context) async {
    await Future.wait([
      fetchServers(context),
      fetchFavorites(context),
    ]);
  }

  Future<void> fetchServers(BuildContext context) async {
    if (_finishedFetchServers) return;
    _isLoadingServers = true;
    _finishedFetchServers = true;
    notifyListeners();
    try {
      _servers = await _services.fetchRegisteredServers();
      _isLoadingServers = false;
    } catch (e) {
      _isLoadingServers = false;
      _showError(context, AppLocalizations.of(context)!.problemRetrievingLastOffers, e);
    }
    notifyListeners();
  }

  Future<void> fetchFavorites(BuildContext context) async {
    if (_finishedFetchFavorites) return;
    _isLoadingFavorites = true;
    _finishedFetchFavorites = true;
    notifyListeners();
    try {
      final username = context.read<MainProvider>().actualUser!.username!;
      final token = context.read<MainProvider>().actualUser!.accessToken;
      final list = await _services.fetchFavoriteServers(username, token);
      _favoriteUrls = list.toSet();
      _isLoadingFavorites = false;
    } catch (e) {
      _isLoadingFavorites = false;
      _showError(context, AppLocalizations.of(context)!.problemRetrievingLastOffers, e);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(BuildContext context, RegisteredServer server) async {
    final url = server.serverUrl;
    if (_togglingFavorites.contains(url)) return;

    _togglingFavorites.add(url);
    notifyListeners();

    try {
      final username = context.read<MainProvider>().actualUser!.username!;
      final token = context.read<MainProvider>().actualUser!.accessToken;

      if (_favoriteUrls.contains(url)) {
        await _services.removeFavoriteServer(username, url, token);
        _favoriteUrls.remove(url);
      } else {
        await _services.addFavoriteServer(username, url, token);
        _favoriteUrls.add(url);
      }
    } catch (e) {
      _showError(context, AppLocalizations.of(context)!.problemBlockingOffer, e);
    }

    _togglingFavorites.remove(url);
    notifyListeners();
  }

  void _showError(BuildContext context, String title, dynamic e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(e is TimeoutException
            ? AppLocalizations.of(context)!.popupFailConnexionTimeout
            : AppLocalizations.of(context)!.popupFailConnexionNoServer),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.textOk),
          ),
        ],
      ),
    );
  }
}