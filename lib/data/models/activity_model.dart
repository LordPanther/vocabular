import 'package:equatable/equatable.dart';

class ActivityModel extends Equatable {
  final String id;
  final List<String> players;
  final int rating;
  final int playCount;

  const ActivityModel(
      {required this.id,
      required this.players,
      required this.rating,
      required this.playCount});

  static ActivityModel fromMap(Map<String, dynamic> data) {
    return ActivityModel(
      id: data["id"] ?? "",
      players: data["players"] ?? [],
      rating: data["rating"] ?? 0,
      playCount: data["playcount"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "players": players,
      "rating": rating,
      "playcount": playCount,
    };
  }

  ActivityModel cloneWith({
    id,
    players,
    rating,
    playCount,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      players: players ?? this.players,
      rating: rating ?? this.rating,
      playCount: playCount ?? this.playCount,
    );
  }

  @override
  String toString() {
    return "ActivityModel:{id:$id, players:$players, rating:$rating, playCount:$playCount}";
  }

  @override
  List<Object?> get props => [
        id,
        players,
        rating,
        playCount,
      ];
}
