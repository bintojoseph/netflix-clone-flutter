import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix/application/home/home_bloc.dart';
import 'package:netflix/presentation/home/widgets/background_card.dart';

import '../../core/constants.dart';
import '../widgets/main_title_card.dart';
import 'widgets/number_title_card.dart';

ValueNotifier<bool> scrollNotifier = ValueNotifier(true);

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomeBloc>(context).add(const GetHomeScreenData());
    });
    return Scaffold(
        body: ValueListenableBuilder(
      valueListenable: scrollNotifier,
      builder: (BuildContext context, index, _) {
        return NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;
            print(direction);
            if (direction == ScrollDirection.reverse) {
              scrollNotifier.value = false;
            } else if (direction == ScrollDirection.forward) {
              scrollNotifier.value = true;
            }
            return true;
          },
          child: Stack(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  if (state.hasError) {
                    return const Center(
                      child: Text('Unable to get data'),
                    );
                  }
                  final _releasedPastYear = state.pastYearMovieList.map((m) {
                    return '$imageAppendUrl${m.posterPath}';
                  }).toList();
                  final _trending = state.trendingMovieList.map((m) {
                    return '$imageAppendUrl${m.posterPath}';
                  }).toList();
                  final _drama = state.tenseDramaMovieList.map((m) {
                    return '$imageAppendUrl${m.posterPath}';
                  }).toList();
                  final _southIndian = state.southIndianMovieList.map((m) {
                    return '$imageAppendUrl${m.posterPath}';
                  }).toList();
                  final _topTv = state.trendingTvList.map((m) {
                    return '$imageAppendUrl${m.posterPath}';
                  }).toList();
                  var random = Random();
                  int top = random.nextInt(20);
                  
                  return ListView(
                    children: [
                      BackgroundCard(
                        url: _southIndian[12],
                      ),
                      MainTitleCard(
                        title: 'Released in past year',
                        posterList: _releasedPastYear.sublist(0, 10),
                      ),
                      kHeight,
                      MainTitleCard(
                        title: 'Trending Now',
                        posterList: _trending.sublist(0, 10),
                      ),
                      kHeight,
                      NumberTitleCard(
                        posterList: _topTv.sublist(0, 10),
                      ),
                      kHeight,
                      MainTitleCard(
                        title: 'Tense Dramas',
                        posterList: _drama.sublist(0, 10),
                      ),
                      kHeight,
                      MainTitleCard(
                        title: 'South Indian Cinema',
                        posterList: _southIndian.sublist(0, 10),
                      ),
                      kHeight
                    ],
                  );
                },
              ),
              scrollNotifier.value == true
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 2000),
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        color: Colors.black.withOpacity(0.3),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  'https://venturebeat.com/wp-content/uploads/2016/06/netflix-logo.png?fit=750%2C750&strip=all',
                                  width: 60,
                                  height: 60,
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.cast,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                kWidth,
                                Container(
                                  width: 30,
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                kWidth
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'TV Shows',
                                  style: kTextStyle,
                                ),
                                Text(
                                  'Movies',
                                  style: kTextStyle,
                                ),
                                Text(
                                  'Categories',
                                  style: kTextStyle,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : kHeight,
            ],
          ),
        );
      },
    ));
  }
}
