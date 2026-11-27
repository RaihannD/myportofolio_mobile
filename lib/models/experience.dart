import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Experience entry returned by the Django REST API.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    this.category = 'full-time',
    this.categoryDisplay = '',
    this.thumbnail,
    this.startedAt,
    this.endedAt,
    this.isOngoing = false,
    this.starCount = 0,
    this.isStarred = false,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;
  final String category;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryDisplay;
  final String? thumbnail;
  @JsonKey(includeToJson: false)
  final DateTime? startedAt;
  final DateTime? endedAt;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
