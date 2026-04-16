import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resilink_mobile_application/l10n/app_localizations.dart';

import '../../../constants/global_variables.dart';
import '../../../models/RegisteredServer.dart';
import '../provider/server_list_provider.dart';

class ServerListPage extends StatelessWidget {
  const ServerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServerListProvider(),
      child: const _ServerListView(),
    );
  }
}

class _ServerListView extends StatefulWidget {
  const _ServerListView();

  @override
  State<_ServerListView> createState() => _ServerListViewState();
}

class _ServerListViewState extends State<_ServerListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServerListProvider>().fetchAll(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 52),
        child: Material(
          color: GlobalVariables.headerBackgroundColor,
          elevation: 4,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  // AppBar title → nothing to change ✅
                  title: Text(
                    AppLocalizations.of(context).serverPageTitle,
                    style: TextStyle(color: GlobalVariables.textHeaderColor),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // TabBar labels → style managed by Flutter/TabBarTheme → nothing to change ✅
                TabBar(
                  controller: _tabController,
                  indicatorColor: GlobalVariables.textHeaderColor,
                  indicatorWeight: 3,
                  labelColor: GlobalVariables.textHeaderColor,
                  unselectedLabelColor: GlobalVariables.textHeaderColor.withOpacity(0.5),
                  labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: AppLocalizations.of(context).serverPageSubTitle1),
                    Tab(text: AppLocalizations.of(context).serverPageSubTitle2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<ServerListProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _AllServersTab(provider: provider),
              _FavoritesTab(provider: provider),
            ],
          );
        },
      ),
    );
  }
}

class _AllServersTab extends StatelessWidget {
  final ServerListProvider provider;
  const _AllServersTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.servers.isEmpty) {
      return const _EmptyState(
        icon: Icons.dns_outlined,
        message: "No servers found",
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: provider.servers.length,
      itemBuilder: (context, index) {
        return _ServerCard(server: provider.servers[index], provider: provider);
      },
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  final ServerListProvider provider;
  const _FavoritesTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    final favorites = provider.favoriteServers;
    if (favorites.isEmpty) {
      return const _EmptyState(
        icon: Icons.star_outline_rounded,
        message: "No favorite servers yet.\nTap ★ on a server to add it.",
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return _ServerCard(server: favorites[index], provider: provider);
      },
    );
  }
}

class _ServerCard extends StatelessWidget {
  final RegisteredServer server;
  final ServerListProvider provider;

  const _ServerCard({required this.server, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isFav = provider.isFavorite(server.serverUrl);
    final isToggling = provider.isToggling(server.serverUrl);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isFav
            ? Border.all(color: const Color(0xFFFFB300), width: 1.5)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Server icon
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isFav
                    ? const Color(0xFFFFF8E1)
                    : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.dns_rounded,
                color: isFav ? const Color(0xFFFFB300) : const Color(0xFF5C6BC0),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Server info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          server.serverName,
                          // titleMedium (16, w500) + override w600
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isFav)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Favorite",
                            // labelSmall (11) pour badge compact
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    server.serverUrl,
                    // bodySmall (12) pour URL secondaire
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF8E8E93),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Favorite toggle button
            GestureDetector(
              onTap: isToggling ? null : () => provider.toggleFavorite(context, server),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isFav
                      ? const Color(0xFFFFB300).withOpacity(0.12)
                      : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isToggling
                    ? const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                    : Icon(
                  isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFav ? const Color(0xFFFFB300) : const Color(0xFFBDBDBD),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(0xFFD0D0D0)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            // bodyLarge (16) for a readable empty state message
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: const Color(0xFFAAAAAA),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}