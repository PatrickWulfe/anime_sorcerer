import 'package:equatable/equatable.dart';

class AnimeListing extends Equatable {
  const AnimeListing({
    required this.id,
    required this.title,
    this.picUrl,
  });
  final int id;
  final String title;
  final String? picUrl;

  /// represents an empty listing
  static const empty = AnimeListing(id: -1, title: '');

  /// convenience getters to determine if listing is empty
  bool get isEmpty => this == AnimeListing.empty;
  bool get isNotEmpty => this != AnimeListing.empty;

  @override
  List<Object?> get props => [id, title, picUrl];
}
