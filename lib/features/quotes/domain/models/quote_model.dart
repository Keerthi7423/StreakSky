import 'package:flutter/foundation.dart';

enum QuoteCategory {
  discipline,
  resilience,
  vision,
  focus,
  health,
  growth,
  mindfulness,
  legacy,
  beginnings,
  milestone,
}

class QuoteModel {
  final String id;
  final String text;
  final String author;
  final QuoteCategory category;
  final String? attribution;
  final bool isBookmarked;

  QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    this.attribution,
    this.isBookmarked = false,
  });

  QuoteModel copyWith({
    String? id,
    String? text,
    String? author,
    QuoteCategory? category,
    String? attribution,
    bool? isBookmarked,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      category: category ?? this.category,
      attribution: attribution ?? this.attribution,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category.name,
      'attribution': attribution,
      'is_bookmarked': isBookmarked,
    };
  }

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      category: QuoteCategory.values.firstWhere((e) => e.name == json['category']),
      attribution: json['attribution'] as String?,
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
    );
  }
}
