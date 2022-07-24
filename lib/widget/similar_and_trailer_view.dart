import 'package:flutter/material.dart';
import 'package:flutter_movie_db/widget/poster_view.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../dao/movie_response.dart';
import 'package:flutter_movie_db/dao/video_response.dart';

class SimilarAndTrailerTabView extends StatefulWidget {
  final Future<MovieResponse> futureSimilarData;
  final Future<VideoResponse> futureVideos;

  SimilarAndTrailerTabView({
    Key key,
    @required this.futureSimilarData,
    @required this.futureVideos,
  }) : super(key: key);

  @override
  _SimilarAndTrailerTabViewState createState() =>
      _SimilarAndTrailerTabViewState();
}

class _SimilarAndTrailerTabViewState extends State<SimilarAndTrailerTabView> {
  int _currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildTab(0, "Similar"),
            _buildTab(1, "Trailer"),
          ],
        ),
        (_currentTab == 0)
            ? _buildSimilarView(widget.futureSimilarData)
            : _buildTrailersView()
      ],
    );
  }

  Widget _buildTab(int currentTab, String tabName) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _onTabSelected(currentTab);
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          height: 48.0,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              (_currentTab == currentTab)
                  ? _buildSelectedTab(_currentTab)
                  : Container(),
              Center(
                child: Text(
                  tabName,
                  style: TextStyle(
                      color: (_currentTab == currentTab)
                          ? Colors.white
                          : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTab(_currentTab) {
    return SizedBox(
        width: double.infinity,
        height: 4.0,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(color: Colors.red)));
  }

  Widget _buildSimilarView(Future<MovieResponse> futureSimilarData) {
    return FutureBuilder(
      future: futureSimilarData,
      builder: (BuildContext context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.movieDetails.isNotEmpty) {
            return _buildSimilarGrid(
                snapshot.data.movieDetails.take(12).toList());
          } else {
            return Container(
              height: 200.0,
              child: Center(
                child: Text('No related movies'),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSimilarGrid(List<MovieDetails> movieDetails) {
    return GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: (movieDetails.length > 12) ? 12 : movieDetails.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 2 / 3),
        itemBuilder: (BuildContext context, int index) =>
            PosterView(item: movieDetails[index]));
  }

  Widget _buildTrailersView() {
    return FutureBuilder(
      future: widget.futureVideos,
      builder: (BuildContext context, AsyncSnapshot<VideoResponse> snapshot) {
        if (snapshot.hasData)
          return _buildVideoTrailer(snapshot.data.results);
        else
          return Container();
      },
    );
  }

  Widget _buildVideoTrailer(List<Video> results) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: GestureDetector(
            onTap: () {
              // _openYoutubeVideo(results[index].key);
            },
            child: Card(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey),
                child: Center(
                  child: Text(results[index].name),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // _openYoutubeVideo(String key) {
  //   return FlutterYoutube.playYoutubeVideoById(
  //       apiKey: "AIzaSyD2aa7VZe5y_W9KnByvUFzRAr5-VuePTng",
  //       videoId: key,
  //       autoPlay: true,
  //       fullScreen: true);
  // }

  void _onTabSelected(int currentTab) {
    if (_currentTab == currentTab) return;
    setState(() {
      _currentTab = currentTab;
    });
  }
}

// ignore: must_be_immutable
class YoutubePlayer extends StatelessWidget {
  YoutubePlayer({
    Key key,
    @required this.videoId,
  }) : super(key: key);

  final String videoId;

  YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: '5U9Q3UlO5gM',
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ));

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}
