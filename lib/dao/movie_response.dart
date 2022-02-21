import 'package:json_annotation/json_annotation.dart';

part 'movie_response.g.dart';

@JsonSerializable()
class MovieResponse extends Object {
  int page;
  int totalResults;
  int totalPages;
  @JsonKey(name: 'results')
  List<MovieDetails> movieDetails;

  MovieResponse({
    this.page,
    this.totalResults,
    this.totalPages,
    this.movieDetails,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
class MovieDetails extends Object {
  int id;
  String title;
  @JsonKey(name: 'vote_average')
  double voteAverage;
  @JsonKey(name: 'poster_path')
  String posterPath;
  @JsonKey(name: 'overview')
  String overView;
  @JsonKey(name: 'release_date')
  String releaseDate;
  @JsonKey(name: 'backdrop_path')
  String backDropPath;
  double popularity;
  int runtime;
  List<Genre> genres;

  MovieDetails(
      {this.id,
      this.title,
      this.voteAverage,
      this.posterPath,
      this.overView,
      this.releaseDate,
      this.backDropPath,
      this.popularity,
      this.runtime});

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);
}

@JsonSerializable()
class Genre extends Object {
  int id;
  String name;

  Genre({this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
