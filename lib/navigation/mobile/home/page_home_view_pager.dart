import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extension.dart';
import '../../../providers/navigator_provider.dart';
import '../../common/navigation_target.dart';
import 'main_page_audiobook.dart';
import 'main_page_discover.dart';
import 'main_page_musiclibrary.dart';
import 'main_page_my.dart';
import 'main_page_publish.dart';

class PageHomeViewPager extends ConsumerWidget {

  // 工厂构造函数
  factory PageHomeViewPager(NavigationTarget selectedTab) {
    assert(selectedTab.isMobileHomeTab());
    _instance ??= const PageHomeViewPager._internal();
    final page = navTargetToPage(selectedTab);
    PageHomeViewPager._pageView?.controller.jumpToPage(page);
    return _instance!;
  }

  const PageHomeViewPager._internal({super.key});

  static PageHomeViewPager? _instance;

  static PageView? _pageView;

  // PageHomeViewPager({super.key, required this.selectedTab})
  //     : assert(selectedTab.isMobileHomeTab());

  // const PageHomeViewPager._internal();
  //
  // factory PageHomeViewPager(NavigationTarget selectedTab) => _instance;
  //
  // static late final PageHomeViewPager _instance => PageHomeViewPager._internal();


  NavigationTarget getTarget(int index)
  {
    switch (index) {
      case 0:
        return NavigationTargetDiscover();
      case 1:
        return NavigationTargetMusicLibrary();
      case 2:
        return NavigationTargetPublish();
      case 3:
        return NavigationTargetAudioBook();
      case 4:
        return NavigationTargetMine();
      default:
        return NavigationTargetDiscover();
    }
  }

  static int navTargetToPage(NavigationTarget target)
  {
    switch (target.runtimeType) {
      case NavigationTargetDiscover:
        return 0;
      case NavigationTargetMusicLibrary:
        return 1;
      case NavigationTargetPublish:
        return 2;
      case NavigationTargetAudioBook:
        return 3;
      case NavigationTargetMine:
        return 4;
      default:
        return 0;
    }
  }

  // MARK: 因为单例 下面的代码只会执行一次
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _pageView ??= PageView.builder(
      itemCount: 5,
      onPageChanged: (page) {
        final target = getTarget(page);
        ref.read(navigatorProvider.notifier).navigate(target);
      },
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const MainPageDiscover();
          case 1:
            return const MainPageMusicLibraryWidget();
          case 2:
            return const MainPagePublishWidget();
          case 3:
            return const MainPageAudioBookWidget();
          case 4:
            return const MainPageMy();
          default:
            assert(false, 'unsupported tab:');
            break;
        }
      },);

    return Scaffold(
      backgroundColor: context.colorScheme.backgroundSecondary,
      body: _pageView,
    );
  }
}
