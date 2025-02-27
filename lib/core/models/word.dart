import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word with _$Word {
  const factory Word({
    int? id,
    required String word,
    @JsonKey(name: 'user_id') required String userID,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}
