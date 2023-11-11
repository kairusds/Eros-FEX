import 'package:fehviewer/common/controller/log_controller.dart';
import 'package:fehviewer/common/service/layout_service.dart';
import 'package:fehviewer/fehviewer.dart';
import 'package:fehviewer/pages/setting/log_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class LogPage extends GetView<LogService> {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Log'),
        trailing: CupertinoButton(
          // 清除按钮
          padding: const EdgeInsets.all(0),
          minSize: 40,
          child: const Icon(
            CupertinoIcons.trash,
            size: 24,
          ),
          onPressed: controller.removeAll,
        ),
      ),
      child: CustomScrollView(slivers: [
        SliverSafeArea(
          bottom: false,
          sliver:
              CupertinoSliverRefreshControl(onRefresh: controller.refreshFiles),
        ),
        const SliverSafeArea(
          top: false,
          sliver: LogListView(),
        ),
      ]),
    );
  }
}

class LogListView extends GetView<LogService> {
  const LogListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const SliverFillRemaining(child: CupertinoActivityIndicator());
      }

      final logfiles = controller.logFiles;
      return SliverCupertinoListSection.insetGrouped(
        itemCount: logfiles.length,
        itemBuilder: (context, index) {
          final _file = logfiles[index];
          final fileName = path.basename(_file.path);
          return EhCupertinoListTile(
            title: Text(fileName),
            trailing: const CupertinoListTileChevron(),
            onTap: () {
              Get.to(
                () => LogViewPage(
                  title: fileName,
                  index: index,
                ),
                id: isLayoutLarge ? 2 : null,
                transition: isLayoutLarge ? Transition.rightToLeft : null,
              );
            },
          );
        },
      );
    });
  }
}
