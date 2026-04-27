/*
*  This file is part of the RESILINK Mobile Application demonstrator developed by the PRIMA RESILINK (2022-2026) project. 
* RESILINK (2022-2026) is a project funded by the PRIMA Programme supported by the European Union. The project web site is https://resilink.eu/"
*  
*
*  Copyright (C) 2026 Axel Cazaux, University of Pau, UPPA
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with the program.  If not, see <http://www.gnu.org/licenses/>.
*
*****************************************************************************
*/
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