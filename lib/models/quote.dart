import 'dart:convert';

class Quote {
  final String q;
  final String a;

  Quote({required this.q, required this.a});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      q: json['q'],
      a: json['a'],
    );
  }
}