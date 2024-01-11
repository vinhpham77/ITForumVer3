// ignore_for_file: unused_import

import 'dart:html';

import 'package:it_forum/dtos/notify_type.dart';
import 'package:it_forum/repositories/post_repository.dart';
import 'package:it_forum/repositories/series_repository.dart';
import 'package:it_forum/ui/router.dart';
import 'package:it_forum/ui/widgets/notification.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';

class MoreHoriz extends StatefulWidget {
  final String username;
  final String authorname;

  const MoreHoriz(
      {super.key,
      required this.type,
      required this.idContent,
      required this.username,
      required this.authorname});

  final String type;
  final int idContent;

  @override
  State<MoreHoriz> createState() => _MoreHorizState();
}

class _MoreHorizState extends State<MoreHoriz> {
  SeriesRepository seriesRepository = SeriesRepository();
  PostRepository postRepository = PostRepository();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [widgetMoreHoriz()],
    );
  }

  Widget widgetMoreHoriz() => Row(
        children: [
          widget.username == widget.authorname ? _myMenuAnchor() : _menuAnchor()
        ],
      );

  Widget _myMenuAnchor() {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz),
          iconSize: 24,
          splashRadius: 16,
          tooltip: 'Thêm hành động',
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            if(widget.type=='series') {
              appRouter.go("/series/${widget.idContent}/edit");
            } else {
              appRouter.go("/posts/${widget.idContent}/edit");
            }

          },
          child: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 20),
              Text("Sửa"),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () {
            showDeleteConfirmationDialog(context);
            // Action for "Xóa bài viết" item
          },
          child: Row(
            children: [
              const Icon(Icons.delete),
              const SizedBox(width: 20),
              Text("Xóa ${widget.type}"),
            ],
          ),
        ),
        // Add more MenuItemButton widgets as needed
      ],
    );
  }

  Widget _menuAnchor() {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz),
          iconSize: 24,
          splashRadius: 16,
          tooltip: 'Thêm hành động',
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            // Action for "Sửa" item
          },
          child: const Row(
            children: [
              Icon(Icons.flag),
              SizedBox(width: 20),
              Text("Báo cáo"),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa ${widget.type}"),
          content: Text("Bạn có chắc chắn muốn xóa ${widget.type} không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                deleteSeries(widget.idContent, widget.type);
              },
              child: Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showAddPostConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Bạn muốn thêm bài viết này vào series nào"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                deleteSeries(widget.idContent, widget.type);
              },
              child: Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSeries(int id, String type) async {
    Response future;
    if (type == 'bài viết') {
      var future =  postRepository.delete(id);
      future.then((respone) {
        if (respone.statusCode == 204) {
          showTopRightSnackBar(context, "Xóa bài viết thành công", NotifyType.success);
          appRouter.go("/");

        } else {
          print('Lỗi khi xóa: ${respone.data}');
        }
      }).catchError((error){
        print("lỗi xóa bài viết");
      });



    } else {
      if (type == 'series') {
        var future =  seriesRepository.delete(id);
        future.then((respone) {
          if (respone.statusCode == 204) {
            showTopRightSnackBar(context, "Xóa series thành công", NotifyType.success);
            appRouter.go("/");

          } else {
            print('Lỗi khi xóa: ${respone.data}');
          }
        }).catchError((error){
          print("lỗi xóa series");
        });



      }
    }
  }
}
