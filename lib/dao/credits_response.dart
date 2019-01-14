import 'package:json_annotation/json_annotation.dart';

part 'credits_response.g.dart';

@JsonSerializable()
class CreditsResponse extends Object {
  int id;
  List<Crew> cast;
  List<Crew> crew;

  CreditsResponse({
    this.id,
    this.cast,
    this.crew,
  });

  factory CreditsResponse.fromJson(Map<String, dynamic> json) =>
      _$CreditsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreditsResponseToJson(this);
}

@JsonSerializable()
class Crew extends Object {
  @JsonKey(name: 'cast_id')
  int castId;
  String character;
  @JsonKey(name: 'credit_id')
  String creditId;
  String department;
  int gender;
  int id;
  String name;
  String job;
  int order;
  @JsonKey(name: 'profile_path')
  String profilePath;

  Crew({
    this.castId,
    this.character,
    this.creditId,
    this.department,
    this.gender,
    this.id,
    this.name,
    this.job,
    this.order,
    this.profilePath
  });

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
  Map<String, dynamic> toJson() => _$CrewToJson(this);
}
