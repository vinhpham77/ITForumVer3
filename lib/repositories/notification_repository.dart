import 'package:it_forum/api_config.dart';
import 'package:it_forum/dtos/limit_page.dart';
import 'package:it_forum/models/notification.dart';
import 'package:it_forum/ui/common/utils/jwt_interceptor.dart';
import 'package:dio/dio.dart';

class NotificationRepository {
  late Dio dio;

  // Tạo một constructor để khởi tạo đối tượng dio
  NotificationRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.userServiceBaseUrl}/${ApiConfig.notificationsEndpoint}"));
  }

  // Tạo một phương thức để thêm một thông báo mới
  Future<Response<dynamic>> add(Notification notification) async {
    // Thêm một interceptor để kiểm tra jwt token
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);

    // Gửi một yêu cầu post đến api với dữ liệu là đối tượng notification
    return dio.post('/create', data: notification.toJson());
  }

  // Tạo một phương thức để xóa một thông báo theo id
  Future<Response<dynamic>> delete(int id) {
    // Thêm một interceptor để kiểm tra jwt token
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);

    // Gửi một yêu cầu delete đến api với tham số là id của thông báo
    return dio.delete('/$id/delete');
  }

  // Tạo một phương thức để lấy ra một danh sách các thông báo theo các tiêu chí
  Future<Response<dynamic>> get({
    required int page,
    int? limit,
    String username = "",
    String type = "",
    bool? isRead,
    DateTime? timeSent,
  }) async {
    // Gửi một yêu cầu get đến api với các tham số là các tiêu chí
    return dio.get('/get', queryParameters: {
      'page': page,
      'limit': limit ?? limitPage,
      'username': username,
      'type': type,
      'isRead': isRead,
      'timeSent': timeSent,
    });
  }

  // Tạo một phương thức để lấy ra một thông báo theo id
  Future<Response<dynamic>> getOne(int id) async {
    // Thêm một interceptor để kiểm tra jwt token
    dio = JwtInterceptor().addInterceptors(dio);

    // Gửi một yêu cầu get đến api với tham số là id của thông báo
    return dio.get('/$id');
  }

  // Tạo một phương thức để cập nhật một thông báo theo id
  Future<Response<dynamic>> update(int id, Notification notification) async {
    // Thêm một interceptor để kiểm tra jwt token
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);

    // Gửi một yêu cầu put đến api với tham số là id của thông báo và dữ liệu là đối tượng notification
    return dio.put('/$id/update', data: notification.toJson());
  }

  // Tạo một phương thức để tìm kiếm các thông báo theo nội dung
  Future<Response<dynamic>> search({
    required String searchContent,
    required int page,
    int? limit,
  }) async {
    // Gửi một yêu cầu get đến api với các tham số là nội dung tìm kiếm, số trang và số lượng
    return dio.get('/search?search=$searchContent&page=$page&limit=${limit ?? limitPage}');
  }

  sendNotification({required String username, required String content, required String type}) {}

  Future<Response<dynamic>> getNotificationsByUsername(String? username) {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);

    return dio.get('/get');
  }
}