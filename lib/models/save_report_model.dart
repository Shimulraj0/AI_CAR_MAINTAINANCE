import 'dart:convert';

class SaveReportModel {
  final String id;
  final String title;
  final String subtitle;
  final String filePath;
  final DateTime date;

  SaveReportModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.filePath,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'filePath': filePath,
      'date': date.toIso8601String(),
    };
  }

  factory SaveReportModel.fromMap(Map<String, dynamic> map) {
    return SaveReportModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      filePath: map['filePath'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveReportModel.fromJson(String source) => SaveReportModel.fromMap(json.decode(source));
}
