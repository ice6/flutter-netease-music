import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../extension.dart';
import '../../../providers/navigator_provider.dart';
import '../../common/navigation_target.dart';
// #enddocregion platform_imports

class MainPagePublishWidget extends ConsumerWidget
{
  const MainPagePublishWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('发表'),
      ),
      body: Column(
          children: [_NavigationLine(),],
      ),
    );
  }
}

class _NavigationLine extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _ItemNavigator(
            Icons.today,
            context.strings.playlist,
                () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetDailyRecommend()),
          ),
          _ItemNavigator(
            Icons.radio,
            context.strings.album,
                () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetFmPlaying()),
          ),
          _ItemNavigator(
            Icons.show_chart,
            context.strings.songs,
                () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetLeaderboard()),
          ),
          _ItemNavigator(
            Icons.person_2,
            context.strings.artists,
                () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetLeaderboard()),
          ),
          _ItemNavigator(
            Icons.group,
            context.strings.group,
                () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetLeaderboard()),
          ),
          _ItemNavigator(
            Icons.text_snippet,
            context.strings.lyric,
                () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetLeaderboard()),
          ),
        ],
      ),
    );
  }
}

class _ItemNavigator extends StatelessWidget {
  const _ItemNavigator(this.icon, this.text, this.onTap, {this.iconSize = 30});

  final IconData icon;

  final double iconSize;

  final String text;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: <Widget>[
            Material(
              shape: const CircleBorder(),
              elevation: 5,
              child: ClipOval(
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  color: Theme.of(context).primaryColor.withOpacity(.85),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryIconTheme.color?.withOpacity(.85),
                    size: iconSize * 0.7,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
