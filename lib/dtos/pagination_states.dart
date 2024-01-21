class PaginationStates {
  final int range;
  final int size;
  final int currentPage;
  final int count;
  final String path;
  final Map<String, dynamic> params;

  PaginationStates({
    required this.range,
    required this.size,
    required this.currentPage,
    required this.count,
    required this.path,
    required this.params,
  });
}
