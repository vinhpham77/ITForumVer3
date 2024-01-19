import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:it_forum/models/series.dart';

import '../../../dtos/post_user.dart';

class SeriesContentWidget extends StatefulWidget {
  final Series series;
  final List<PostUser> postUsers;

  const SeriesContentWidget(
      {super.key, required this.series, required this.postUsers});

  @override
  State<SeriesContentWidget> createState() => _SeriesContentWidgetState();
}

class _SeriesContentWidgetState extends State<SeriesContentWidget> {
  List<String> listTag = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          widget.series.title,
          style: const TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Wrap(
            spacing: 8.0,
            children: listTags(widget.postUsers)
                .map((tag) => buildTagButton(tag))
                .toList(),
          ),
        ),
        BodyContentWidget(series: widget.series),
      ],
    );
  }

  Widget buildTagButton(String tag) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  List<String> listTags(List<PostUser> listPostUser) {
    for (var post in listPostUser) {
      // listTag.addAll(post.tags);
      listTag.addAll([]);
    }

    Map<String, int> uniqueTagCount = countUniqueTags(listTag);
    List<String> getTop5Tags = this.getTop5Tags(uniqueTagCount);
    listTag = getTop5Tags;
    return listTag;
  }

  List<String> getTop5Tags(Map<String, int> tagCount) {
    var sortedEntries = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var top5Entries = sortedEntries.take(5);
    List<String> top5Tags = top5Entries.map((entry) => entry.key).toList();

    return top5Tags;
  }

  Map<String, int> countUniqueTags(List<String> tags) {
    Map<String, int> tagCount = {};

    for (String tag in tags) {
      if (tagCount.containsKey(tag)) {
        tagCount[tag] = (tagCount[tag]! + 1);
      } else {
        tagCount[tag] = 1;
      }
    }

    return tagCount;
  }
}

class BodyContentWidget extends StatefulWidget {
  final Series series;

  const BodyContentWidget({Key? key, required this.series}) : super(key: key);

  @override
  State<BodyContentWidget> createState() => _BodyContentWidgetState();
}

class _BodyContentWidgetState extends State<BodyContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(),
          child: MarkdownBody(
            data: getMarkdown(),
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              // Các style tùy chọn của bạn ở đây
              textScaleFactor: 1.4,
              h1: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 32),
              h2: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 22),
              h3: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18),
              h6: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 13),
              p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
              blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
              // Custom blockquote style
              listBullet: const TextStyle(
                  fontSize: 16), // Custom list item bullet style
            ),
            softLineBreak: true,
          ),
        ),
      ],
    );
  }

  String getMarkdown() {
    String titleRaw = widget.series.title;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String content = widget.series.content;
    String tags = "#";
    return content;
  }
}
