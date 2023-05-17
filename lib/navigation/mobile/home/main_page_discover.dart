import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../extension.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/navigator_provider.dart';
import '../../../providers/personalized_playlist_provider.dart';
import '../../../repository.dart';
import '../../common/buttons.dart';
import '../../common/image.dart';
import '../../common/navigation_target.dart';
import '../../common/playlist/track_list_container.dart';
import '../mobile_window.dart';
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
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.cyan, Colors.blue, Colors.purple];
    return SafeArea(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          _AppBar(controller: scrollController),
          SliverList(delegate: SliverChildListDelegate([
            const Padding(
              padding: EdgeInsets.all(8),
              child: BannersWidget(),
            ),
            // _Header('欢迎新人', () {}),
            // _WelcomeNewcomer(),
            // _Header('诗班/敬拜团', () {}),
            // _Choir(),
            _NavigationLine(),
            _Header('推荐歌单', () {}),
            _SingleRowPlayListWidget(),
            _Header('根据 夜间的歌曲 推荐', () {}),
            _GridPlaylist(),
            _Header('排行榜', () {}),
            _RankWidget(),
            _Header('星评馆', () {}),
            _ReviewSelectionWidget(),
            _Header('从Amen的歌词听起', () {}),
            _AmenLyricWidget(),
            _Header('优质Cover(翻唱)', () {}),
            _AmenLyricWidget(),
            _Header('根据 新心音乐 推荐', () {}),
            _SectionPlaylist(),
            _Header('最新音乐', () {}),
            _SectionNewSongs(),
          ]),)
        ],
      ),
    );
  }
}

class BannersWidget extends StatefulWidget {
  const BannersWidget({super.key});

  @override
  State<BannersWidget> createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<BannersWidget> {

  final banners = [
    'https://file.izanmei.net/store/2023/02/17/63eed71148792c70d7007e0a.jpg',
    'https://file.izanmei.net/store/2023/02/14/63eb6f5cd62ebf82e700790f.jpg',
    'https://file.izanmei.net/store/2023/02/07/63e1f01e4a415f34ee02a50b.jpg',
    'https://file.izanmei.net/store/2022/11/29/63857bf0617111e8a602e40d.jpg',
    'https://file.izanmei.net/store/2019/03/07/5c80ac63d963434a3e3297d5.jpg'
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final slider = CarouselSlider.builder(
      itemCount: banners.length,
      options: CarouselOptions(
        height: 140,
        viewportFraction: 1,
        autoPlay: true,
        onPageChanged: (page, _) {
          setState(() {
            currentIndex = page;
          });
        },
      ),
      itemBuilder: (
          BuildContext context,
          int index,
          int pageViewIndex,
          ) =>
          GestureDetector(
            onTap: () {
              final text = banners[index];
              final snackBar = SnackBar(
                content: Text(text),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => const Image(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/ytCover.png',
                  ),
                ),
                imageUrl: banners[index].toString(),
                placeholder: (context, url) => const Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/ytCover.png'),
                ),
              ),
            ),
          ),
    );
    return Stack(
      children: [
        slider,
        Positioned(
          left: 16,
          top: 120,
          child: AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            count: banners.length,
            // effect: const WormEffect(
            //   dotHeight: 7,
            //   dotWidth: 7,
            //   type: WormType.thinUnderground,
            // ),
            // effect: ScrollingDotsEffect(
            //   activeDotColor: Colors.white,
            //   dotColor: Colors.white.withOpacity(0.7),
            //   activeStrokeWidth: 2.6,
            //   activeDotScale: 1.3,
            //   maxVisibleDots: 5,
            //   radius: 4,
            //   spacing: 5,
            //   dotHeight: 6,
            //   dotWidth: 6,
            // ),
            effect: ExpandingDotsEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white.withOpacity(0.7),
                radius: 4,
                spacing: 5,
                dotHeight: 6,
                dotWidth: 6,
            ),
          ),
        ),
      ],
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
        onPressed: () =>  {
          rootScaffoldKey.currentState!.openDrawer()
        },
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
      color: Colors.grey.shade300.withOpacity(.4),
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: const [ 0.2, 0.9],
        colors: [
          // Colors are easy thanks to Flutter's Colors class.
          Colors.purple[100]!,
          Colors.purple[200]!,
        ],
      ),
    ),
    child: DefaultTextStyle(
      style: const TextStyle(
        color: Colors.grey,
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
              child: const Icon(Icons.search_rounded, size: 16, color: Colors.grey,),
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
                        duration: const Duration(seconds: 3),
                        fadeOutBegin: 0.9,
                        fadeInEnd: 0.7,),)
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
              child: const Icon(Icons.qr_code, size: 16,color: Colors.grey,),
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
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _ItemNavigator(
            Icons.today,
            context.strings.dailyRecommend,
                () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetDailyRecommend()),
          ),
          _ItemNavigator(
            Icons.radio,
            context.strings.personalFM,
            () => ref
                .read(navigatorProvider.notifier)
                .navigate(NavigationTargetFmPlaying()),
          ),
          _ItemNavigator(
            Icons.show_chart,
            context.strings.leaderboard,
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
            Icons.album,
            context.strings.album,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          InkWell(
            onTap: () {},
            child: const Icon(Icons.more_vert),
          )
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

class _SingleRowPlayListWidget extends ConsumerWidget {
  final snapshot = [
    'https://file.izanmei.net/box/2023/05/09/6459dc7bfec84f95e80f9a3a.jpg.webp',
    'https://file.izanmei.net/box/2023/04/28/644ab2223d4368e1be0f7973.jpg.webp',
    'https://file.izanmei.net/box/2023/04/25/6447f2152dfeb10b9c0c19a2.jpg.webp',
    'https://file.izanmei.net/box/2023/04/23/64453829ebfddc4b6600b34a.jpg.webp',
    'https://file.izanmei.net/box/2023/04/21/64416df2b370e61d8d01b595.jpg.webp'
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.length,
          itemBuilder: (BuildContext ctx, index) {
            if(index == 0) {
              return const SizedBox(
                  width: 140,
                  height: 140,
                  child: _RoamPlaylistWidget()
              );
            }
            index = index - 1;
            return InkWell(
              onTap: () {

              },
              child: SizedBox(
                width: 140,
                height: 140,
                child: Column(
                  children: [
                    Card (
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        errorWidget: (context, _, __) => const Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/song.png',
                          ),
                        ),
                        imageUrl: snapshot[index].toString(),
                        placeholder: (context, url) => const Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/song.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0).copyWith(top: 4),
                      child: const Text(
                        '上帝伟大奇妙、带我们出黑暗入光明， 神也是我们个人的神，喜欢我们与祂互动的神',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/* region [歌单漫游] */
class _RoamPlaylistWidget extends StatefulWidget {
  const _RoamPlaylistWidget({super.key});

  @override
  State<_RoamPlaylistWidget> createState() => _RoamPlaylistWidgetState();
}

class _RoamPlaylistWidgetState extends State<_RoamPlaylistWidget> {
  final banners = [
    'https://file.izanmei.net/box/2023/05/09/6459dc7bfec84f95e80f9a3a.jpg.webp',
    'https://file.izanmei.net/box/2023/04/28/644ab2223d4368e1be0f7973.jpg.webp',
    'https://file.izanmei.net/box/2023/04/25/6447f2152dfeb10b9c0c19a2.jpg.webp',
    'https://file.izanmei.net/box/2023/04/23/64453829ebfddc4b6600b34a.jpg.webp',
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final slider = CarouselSlider.builder(
      itemCount: banners.length,
      options: CarouselOptions(
        height: 140,
        viewportFraction: 1,
        autoPlay: true,
        scrollDirection: Axis.vertical,
        onPageChanged: (page, _) {
          setState(() {
            currentIndex = page;
          });
        },
      ),
      itemBuilder: (
          BuildContext context,
          int index,
          int pageViewIndex,
          ) =>
          GestureDetector(
            onTap: () {
              final text = banners[index];
              final snackBar = SnackBar(
                content: Text(text),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => const Image(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/song.png',
                  ),
                ),
                imageUrl: banners[index].toString(),
                placeholder: (context, url) => const Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/song.png'),
                ),
              ),
            ),
          ),
    );
    return Column(
      children: [
        slider,
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: currentIndex.isOdd ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Text(
                  '上帝伟大奇妙、带我们出黑暗入光明， 神也是我们个人的神，喜欢我们与祂互动的神',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              AnimatedOpacity(
                opacity: currentIndex.isEven ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Text(
                  '我们应当回应上帝的爱',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
/* endregion */

/* region [GRID布局 TODO: 用PageView代替] */
class _GridPlaylist extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(homePlaylistProvider.logErrorOnDebug());
    final axisWidth = (MediaQuery.of(context).size.width - 30).clamp(320.0, 360.0);
    const height = 200.0;//3 * 60 + (3-1)*10

    return snapshot.when(
      data: (list) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  maxCrossAxisExtent: 60,
                  mainAxisExtent: axisWidth,
              ),
              itemBuilder: (context, index) {
                return _GridItemView(playlist: list[index], width: axisWidth, height: 60);
              },
            ),
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

class _GridItemView extends ConsumerWidget {
  const _GridItemView({
    super.key,
    required this.playlist,
    required this.width,
    required this.height,
  });

  final RecommendedPlaylist playlist;

  final double width;

  final double height;

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
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: height,
                width: height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AppImage(url: playlist.picUrl),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 4)),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: SizedBox(
                  width: width - height - 4 - 8,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        playlist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/* endregion */

/* region [LayoutBuilder 平淡无奇的布局] */
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
                  return _PlayListItemWidget(playlist: p, width: width);
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

class _PlayListItemWidget extends ConsumerWidget {
  const _PlayListItemWidget({
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
/* endregion */

/*region 排行榜*/
class _RankWidget extends ConsumerWidget {
  final _controller = PageController(viewportFraction: .96);
  final titles = ['社区互动榜', '编辑精选榜', '热歌榜', '原创榜', 'MV榜', '热门视频榜'];
  final rows = [
    'https://file.izanmei.net/box/2023/05/09/6459dc7bfec84f95e80f9a3a.jpg.webp',
    'https://file.izanmei.net/box/2023/04/28/644ab2223d4368e1be0f7973.jpg.webp',
    'https://file.izanmei.net/box/2023/04/25/6447f2152dfeb10b9c0c19a2.jpg.webp',
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 252,
      child: PageView.builder(
        padEnds: false,
        controller: _controller,
        itemCount: titles.length,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(left: 4),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(titles[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(titles[index]),
                        ],
                      ),
                    ),
                    Column(
                      children: rows.map((e) => InkWell(
                        onTap: () {

                        },
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: Card (
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    errorWidget: (context, _, __) => const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/song.png',
                                      ),
                                    ),
                                    imageUrl: e,
                                    placeholder: (context, url) => const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/song.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(index.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '上帝伟大奇妙',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                        '刘冰',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14, color: context.colorScheme.textHint),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),).toList(),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
/*endregion*/

/*region 星评馆（请专业的人进行评论推荐） 后端评论分类后 可以像网易那样分类 PageView*/
class _ReviewSelectionWidget extends ConsumerWidget {
  static const px = 16.0;
  final _controller = PageController(viewportFraction: .96);
  final titles = ['你真伟大', '心的归属', '夜晚的歌曲'];
  final reviews = ['上帝伟大奇妙', '虽万千过往', '都随风飘去'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        padEnds: false,
        controller: _controller,
        itemCount: titles.length,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                ),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.brown,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: px),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(titles[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(titles[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(px),
                        child: Row(
                          children: [
                            Text(reviews[index]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: px),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('100人觉得赞', style: TextStyle(fontSize: 12, color: context.colorScheme.textHint)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.thumb_up_alt_outlined, size: 14),
                                Text(' 赞一下', style: TextStyle(fontSize: 12, color: context.colorScheme.textHint)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
/*endregion*/

/*region Amen Lyric PageView*/
class _AmenLyricWidget extends ConsumerWidget {
  static const px = 16.0;
  final _controller = PageController(viewportFraction: .7);
  final titles = ['你真伟大', '心的归属', '夜晚的歌曲'];
  final lyrics = ['上帝伟大奇妙\n虽万千过往\n哈哈哈\n哈哈', '虽万千过往', '都随风飘去'];
  final images = [
    'https://file.izanmei.net/box/2023/04/28/644ab2223d4368e1be0f7973.jpg.webp',
    'https://file.izanmei.net/box/2023/04/25/6447f2152dfeb10b9c0c19a2.jpg.webp',
    'https://file.izanmei.net/box/2023/04/23/64453829ebfddc4b6600b34a.jpg.webp',
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        padEnds: false,
        controller: _controller,
        itemCount: titles.length,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                ),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.brown,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: px),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(titles[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(titles[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: px, vertical: 4),
                        child: Row(
                          children: [
                            Text(lyrics[index],
                              maxLines: 4,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(height: 1.7, fontSize: 16)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
/*endregion*/

/*region 优质Cover/Feat */
class _HighQualityWidget extends ConsumerWidget {
  static const px = 16.0;
  final _controller = PageController(viewportFraction: .7);
  final titles = ['你真伟大', '心的归属', '夜晚的歌曲'];
  final lyrics = ['上帝伟大奇妙\n虽万千过往\n哈哈哈\n哈哈', '虽万千过往', '都随风飘去'];
  final images = [
    'https://file.izanmei.net/box/2023/04/28/644ab2223d4368e1be0f7973.jpg.webp',
    'https://file.izanmei.net/box/2023/04/25/6447f2152dfeb10b9c0c19a2.jpg.webp',
    'https://file.izanmei.net/box/2023/04/23/64453829ebfddc4b6600b34a.jpg.webp',
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        padEnds: false,
        controller: _controller,
        itemCount: titles.length,
        physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.brown.shade300,
                ),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.brown,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: px),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(titles[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(titles[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: px, vertical: 4),
                        child: Row(
                          children: [
                            Text(lyrics[index],
                                maxLines: 4,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(height: 1.7, fontSize: 16)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
/*endregion*/

/*region 心颂精选 Closable PageView*/

/*endregion*/

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
