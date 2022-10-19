part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.initiliaze() = Initiliaze;
  const factory SearchEvent.searchMovie({
    required String movieQuery,
  }) = SearchMovie;
}
