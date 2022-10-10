import 'package:json_annotation/json_annotation.dart';

part 'InfoProperty.g.dart';

@JsonSerializable()
class InfoProperty {
  @JsonKey(defaultValue: "")
  String title;

  @JsonKey(defaultValue: "")
  String description;

  @JsonKey(name: "imageHref", defaultValue: "")
  String image;

  @JsonKey(readValue: _hasNoData)
  bool hasNoData;

  InfoProperty({
    this.title = '',
    this.image = '',
    this.description = '',
    this.hasNoData = false,
  });

  factory InfoProperty.fromJson(Map<String, dynamic> json) => _$InfoPropertyFromJson(json);

  Map<String, dynamic> toJson() => _$InfoPropertyToJson(this);

  InfoProperty clone() {
    return InfoProperty.fromJson(toJson());
  }

  static bool _hasNoData(json, _) {
    return json["title"] == null && json["description"] == null && json["imageHref"] == null;
  }
}
