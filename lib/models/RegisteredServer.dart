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
class RegisteredServer {
  final String id;
  final String serverName;
  final String serverUrl;
  final String? createdAt;
  final String? updatedAt;

  RegisteredServer({
    required this.id,
    required this.serverName,
    required this.serverUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory RegisteredServer.fromJson(Map<String, dynamic> json) {
    return RegisteredServer(
      id: json['_id'] ?? '',
      serverName: json['serverName'] ?? '',
      serverUrl: json['serverUrl'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'] ?? json['lastUpdated'],
    );
  }
}
