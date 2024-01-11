import 'package:flutter/material.dart';

@immutable
class FollowId {
  final String follower;
  final String followed;

  const FollowId({
    required this.follower,
    required this.followed,
  });
  // Phương thức tạo FollowId rỗng
  factory FollowId.empty() {
    return FollowId(follower: '', followed: '');
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FollowId &&
              runtimeType == other.runtimeType &&
              follower == other.follower &&
              followed == other.followed;

  @override
  int get hashCode => follower.hashCode ^ followed.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'follower': follower,
      'followed': followed,
    };
  }

  factory FollowId.fromMap(Map<String, dynamic> map) {
    return FollowId(
      follower: map['follower'],
      followed: map['followed'],
    );
  }
}
