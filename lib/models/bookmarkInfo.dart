class BookmarkInfo {
  final int targetId;
  final bool type;

  BookmarkInfo({
    required this.targetId,
    required this.type,
  });

  factory BookmarkInfo.fromJson(Map<String, dynamic> json) {
    return BookmarkInfo(
        targetId: json['targetId'],
        type: json['type']);
  }
  Map<String, dynamic> toJson() {
    return {
      'targetId': targetId,
      'type': type,
    };
  }

// Sử dụng hàm parsePostDetailDTO để chuyển đổi response.data thành đối tượng PostDetailDTO
//   static  List<PostDetailDTO> parsePostDetailDTOList(String responseBody) {
//     List<dynamic> jsonDataList = json.decode(responseBody);
//     return jsonDataList.map((json) => PostDetailDTO.fromJson(json)).toList();
//   }
}
