// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieResponse _$MovieResponseFromJson(Map<String, dynamic> json) {
  return MovieResponse(
      page: json['page'] as int,
      totalResults: json['totalResults'] as int,
      totalPages: json['totalPages'] as int,
      movieDetails: (json['results'] as List)
          ?.map((e) => e == null
              ? null
              : MovieDetails.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$MovieResponseToJson(MovieResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'totalResults': instance.totalResults,
      'totalPages': instance.totalPages,
      'results': instance.movieDetails
    };

MovieDetails _$MovieDetailsFromJson(Map<String, dynamic> json) {
  return MovieDetails(
      id: json['id'] as int,
      title: json['title'] as String,
      voteAverage: (json['vote_average'] as num)?.toDouble(),
      posterPath: json['poster_path'] as String,
      overView: json['overview'] as String,
      releaseDate: json['release_date'] as String,
      backDropPath: json['backdrop_path'] as String,
      popularity: (json['popularity'] as num)?.toDouble());
}

Map<String, dynamic> _$MovieDetailsToJson(MovieDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'vote_average': instance.voteAverage,
      'poster_path': instance.posterPath,
      'overview': instance.overView,
      'release_date': instance.releaseDate,
      'backdrop_path': instance.backDropPath,
      'popularity': instance.popularity
    };
