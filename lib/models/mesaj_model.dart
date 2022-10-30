// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

MesajModel mesajModelFromJson(String str) =>
    MesajModel.fromJson(json.decode(str));

String mesajModelToJson(MesajModel data) => json.encode(data.toJson());

class MesajModel {
  MesajModel({
    required this.mesajId,
    required this.mesaj,
  });

  int? mesajId;
  String? mesaj;

  factory MesajModel.fromJson(Map<String, dynamic> json) => MesajModel(
        mesajId: json["mesajID"] == null ? null : json["mesajID"],
        mesaj: json["mesaj"] == null ? null : json["mesaj"],
      );

  Map<String, dynamic> toJson() => {
        "mesajID": mesajId == null ? null : mesajId,
        "mesaj": mesaj == null ? null : mesaj,
      };
}
