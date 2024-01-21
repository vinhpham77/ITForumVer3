// ignore_for_file: unused_import
import 'package:flutter/foundation.dart';
import 'package:it_forum/models/user.dart';

import 'FollowId.dart';

@immutable
class Follow {
  FollowId id;
  User follower;
  User followed;
  DateTime createdAt;

  Follow({
    required this.id,
    required this.follower,
    required this.followed,
    required this.createdAt,
  });

  Follow.empty()
      : id = FollowId.empty(),
        followed = User.empty(),
        follower = User.empty(),
        createdAt = DateTime.now();

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
        id: json['id'] ?? '',
        follower: json['follower'] ?? '',
        followed: json['followed'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now());
  }
}
