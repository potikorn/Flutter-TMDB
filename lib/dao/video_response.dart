import 'package:json_annotation/json_annotation.dart';

part 'video_response.g.dart';

@JsonSerializable()
class VideoResponse extends Object {
  int id;
  List<Video> results;

  VideoResponse({this.id, this.results});

  factory VideoResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VideoResponseToJson(this);
}

@JsonSerializable()
class Video extends Object {
  String id;
  @JsonKey(name: 'iso_639_1')
  String iso6391;
  @JsonKey(name: 'iso_3166_1')
  String iso31661;
  String key;
  String name;
  String site;
  int size;
  String type;

  Video({
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
