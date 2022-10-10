import 'package:artivatic_exercise/data_beans/InfoProperty.dart';
import 'package:json_annotation/json_annotation.dart';
part 'CountryInfo.g.dart';

@JsonSerializable(explicitToJson:true)
class CountryInfo{
  @JsonKey(disallowNullValue: true, defaultValue: "")
  String title;

  @JsonKey(name: "rows", disallowNullValue: true, defaultValue: [])
  List<InfoProperty> properties;

  CountryInfo({
    this.title = '',
    this.properties = const [],
});

  factory CountryInfo.fromJson(Map<String, dynamic> json) => _$CountryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CountryInfoToJson(this);

  CountryInfo clone(){
    return CountryInfo.fromJson(toJson());
  }

}