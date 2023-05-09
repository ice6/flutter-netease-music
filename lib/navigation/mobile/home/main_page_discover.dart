import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../extension.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/navigator_provider.dart';
import '../../../providers/personalized_playlist_provider.dart';
import '../../../repository.dart';
import '../../common/buttons.dart';
import '../../common/image.dart';
import '../../common/navigation_target.dart';
import '../../common/playlist/track_list_container.dart';
import '../widgets/track_tile.dart';

class MainPageDiscover extends ConsumerStatefulWidget {
  const MainPageDiscover({super.key});

  @override
  ConsumerState<MainPageDiscover> createState() => MainPageDiscoverState();
}

class MainPageDiscoverState extends ConsumerState<MainPageDiscover>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _Body();
  }
}

class _Body extends HookWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final headerHeight = const <double>[
      16,
      70 + 16, // PresetGridSection
      76,
      8,
    ].reduce((a, b) => a + b);
    return SafeArea(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          _AppBar(controller: scrollController),
          SliverList(delegate: SliverChildListDelegate([
            _Header('欢迎新人', () {}),
            _WelcomeNewcomer(),
            _Header('诗班/敬拜团', () {}),
            _Choir(),
            _NavigationLine(),
            _Header('推荐歌单', () {}),
            _SectionPlaylist(),
            _Header('最新音乐', () {}),
            _SectionNewSongs(),
          ]),)
        ],
      ),
    );
  }
}


class _AppBar extends HookConsumerWidget {
  const _AppBar({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollOffset = useListenable(controller).position.pixels;
    const maxOffset = 32;
    final t = scrollOffset.clamp(0.0, maxOffset) / maxOffset;
    final background = context.colorScheme.background.withOpacity(t);

    final user = ref.watch(userProvider);
    final texts = ['赞美祂名', '大家在搜索 基督徒婚礼', '安静/灵修/敬拜', '家务/骑行/汽车', '午后'];

    return SliverAppBar(
      leading: AppIconButton(
        color: context.colorScheme.textPrimary,
        onPressed: () => ref
            .read(navigatorProvider.notifier)
            .navigate(NavigationTargetSettings()),
        icon: Icons.menu,
      ),
      centerTitle: true,
      title: _searchBoxFadeText(texts, ref),
      titleSpacing: 0,
      backgroundColor: background,
      actions: [
        AppIconButton(
          color: context.colorScheme.textPrimary,
          onPressed: () => ref
              .read(navigatorProvider.notifier)
              .navigate(NavigationTargetSearch()),
          icon: Icons.add,
        )
      ],
      pinned: true,
      elevation: 0,
    );
  }
}

Widget _searchBoxFadeText(List<String> texts, WidgetRef ref) {
  return Container(
    height: 36,
    decoration: BoxDecoration(
      color: Colors.grey.shade300.withOpacity(.7),
      borderRadius: BorderRadius.circular(18),
    ),
    child: DefaultTextStyle(
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => ref
              .read(navigatorProvider.notifier)
              .navigate(NavigationTargetSearch()),
            child: Padding(
              padding: const EdgeInsets.all(8).copyWith(left: 14, right: 14),
              child: const Icon(Icons.search_rounded, size: 16,),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => ref
                  .read(navigatorProvider.notifier)
                  .navigate(NavigationTargetSearch()),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    onTap: () => ref
                        .read(navigatorProvider.notifier)
                        .navigate(NavigationTargetSearch()),
                    animatedTexts: texts.map((e) => FadeAnimatedText(e,
                        duration: const Duration(seconds: 3),fadeOutBegin: 0.9,fadeInEnd: 0.7,),)
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
           GestureDetector(
             onTap: () => ref
                 .read(navigatorProvider.notifier)
                 .navigate(NavigationTargetQRCodeScan()),
             child: Padding(
              padding: const EdgeInsets.all(8).copyWith(right: 14, left: 14),
              child: const Icon(Icons.qr_code, size: 16,),
          ),
           ),
        ],
      ),
    ),
  );
}

class _NavigationLine extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _ItemNavigator(
            Icons.radio,
            context.strings.personalFM,
            () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetFmPlaying()),
          ),
          _ItemNavigator(
            Icons.today,
            context.strings.dailyRecommend,
            () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetDailyRecommend()),
          ),
          _ItemNavigator(
            Icons.show_chart,
            context.strings.leaderboard,
            () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetLeaderboard()),
          ),
        ],
      ),
    );
  }
}

///common header for section
class _Header extends StatelessWidget {
  const _Header(this.text, this.onTap);

  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(left: 8)),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w800),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _ItemNavigator extends StatelessWidget {
  const _ItemNavigator(this.icon, this.text, this.onTap, {this.iconSize = 40});

  final IconData icon;

  final double? iconSize;

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
                  color: Theme.of(context).primaryColor,
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _SectionPlaylist extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(homePlaylistProvider.logErrorOnDebug());
    return snapshot.when(
      data: (list) {
        return LayoutBuilder(
          builder: (context, constraints) {
            assert(
              constraints.maxWidth.isFinite,
              'can not layout playlist item in infinite width container.',
            );
            final parentWidth = constraints.maxWidth - 8;
            const count = /* false ? 6 : */ 3;
            final width = (parentWidth / count).clamp(80.0, 200.0);
            final spacing = (parentWidth - width * count) / (count + 1);
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 4 + spacing.roundToDouble()),
              child: Wrap(
                spacing: spacing,
                children: list.map<Widget>((p) {
                  return _PlayListItemView(playlist: p, width: width);
                }).toList(),
              ),
            );
          },
        );
      },
      error: (error, stacktrace) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Text(context.formattedError(error)),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class _PlayListItemView extends ConsumerWidget {
  const _PlayListItemView({
    super.key,
    required this.playlist,
    required this.width,
  });

  final RecommendedPlaylist playlist;

  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GestureLongPressCallback? onLongPress;

    if (playlist.copywriter.isNotEmpty) {
      onLongPress = () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                playlist.copywriter,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          },
        );
      };
    }

    return InkWell(
      onTap: () => ref
          .read(navigatorProvider.notifier)
          .navigate(NavigationTargetPlaylist(playlist.id)),
      onLongPress: onLongPress,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: width,
              width: width,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AppImage(url: playlist.picUrl),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 4)),
            Text(
              playlist.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionNewSongs extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(personalizedNewSongProvider.logErrorOnDebug());
    return snapshot.when(
      data: (songs) {
        return TrackTileContainer.trackList(
          tracks: songs,
          id: 'playlist_main_newsong',
          child: Column(
            children: songs
                .mapIndexed(
                  (index, item) => TrackTile(
                    track: item,
                    index: index + 1,
                  ),
                )
                .toList(),
          ),
        );
      },
      error: (error, stacktrace) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Text(context.formattedError(error)),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

//欢迎新人
class _WelcomeNewcomer extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 0.0,
              color: Colors.grey.shade400,
            ),
          ),
          _ItemNavigator(
            Icons.looks_one,
            '相互了解',
                () => {},
            iconSize: 32,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 1.0,
              color: Colors.grey.shade400,
            ),
          ),
          _ItemNavigator(
            Icons.looks_two,
            '偏好设置',
                () => {},
            iconSize: 32,
          ),Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 1.0,
              color: Colors.grey.shade400,
            ),
          ),
          _ItemNavigator(
            Icons.looks_3,
            '开启旅程',
                () => {},
            iconSize: 32,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 0.0,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
  // {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //   );
  //   // return const Text('欢迎新人: '
  //   //     '1. 给”基督徒”熟悉的感觉 '
  //   //     '2. 当“复印朋友”打开此App时不会迷茫'
  //   //     '让新的使用者可以快熟熟悉App的用法。推荐适合他们听的诗歌');
  // }
}

// 使用matirail design里的stepper不能正常显示，不知道为啥
class _WelcomeNewbieWidget extends StatefulWidget {
  const _WelcomeNewbieWidget({super.key});

  @override
  State<_WelcomeNewbieWidget> createState() => _WelcomeNewbieState();
}

//欢迎新人
class _WelcomeNewbieState extends State<_WelcomeNewbieWidget> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(

      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Step 1 title'),
          content: Container(
              alignment: Alignment.centerLeft,
              child: const Text('Content for Step 1')),
        ),
        const Step(
          title: Text('Step 2 title'),
          content: Text('Content for Step 2'),
        ),
      ],
    );
  }
}


//诗班/敬拜团
class _Choir extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _ItemNavigator(
              Icons.calendar_view_week,
              '本周诗歌',
                  () => {},
            ),
            _ItemNavigator(
              Icons.dynamic_feed,
              '动态',
                  () => {},
            ),
            _ItemNavigator(
              Icons.queue_music,
              '曲库',
                  () => {},
            ),
            _ItemNavigator(
              Icons.schedule,
              '排表',
                  () => {},
            ),
          ],
        ),
      );
  }
}
