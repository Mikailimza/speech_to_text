// ignore_for_file: unused_import, null_check_always_fails, unused_local_variable, prefer_const_constructors
//Mikail imza - 30.10.20.22 ---- mikailimza@gmail.com 
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Command {
  static final all = [
    admin,
    browser,
    profil,
    anasayfa,
  ];

  static const admin = 'open admin';
  static const browser = 'open';
  static const profil = 'profil';
  static const anasayfa = 'anasayfa';
}

class Utils {
  static void scanText(String rawText) {
    final text = rawText.toLowerCase();

    if (text.contains(Command.admin)) {
      final body = _getTextAfterCommand(text: text, command: Command.admin);

      openEmail(body: body);
    } else if (text.contains(Command.browser)) {
      final url = _getTextAfterCommand(text: text, command: Command.browser);
      log("Google");

      openLink(url: url);
    } else if (text.contains(Command.profil)) {
      log("Acılan Sayfa Profilim");
    }
  }

  static String _getTextAfterCommand({
    required String text,
    required String command,
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return null!;
    } else {
      return text.substring(indexAfter).trim();
    }
  }

  static Future openLink({
    required String url,
  }) async {
    if (url.trim().isEmpty) {
    } else {}
  }

  static Future openEmail({
    required String body,
  }) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
  }
}
