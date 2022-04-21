// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// This class will help us in managing yes/no response data in our app

class Answer {
  
  /// The answer text
  final String answer;

  /// The GIF url
  final String image;
  Answer({
    required this.answer,
    required this.image,
  });

  Answer copyWith({
    String? answer,
    String? image,
  }) {
    return Answer(
      answer: answer ?? this.answer,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'answer': answer,
      'image': image,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      answer: map['answer'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Answer.fromJson(String source) => Answer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Answer(answer: $answer, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Answer &&
      other.answer == answer &&
      other.image == image;
  }

  @override
  int get hashCode => answer.hashCode ^ image.hashCode;
}
