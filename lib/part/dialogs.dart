import 'package:flutter/material.dart';
import 'package:quiet/part/loader.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/netease.dart';

class DialogNoCopyRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(image: AssetImage("assets/no_copy_right.png")),
          Padding(padding: EdgeInsets.only(top: 16)),
          Text(
            "抱歉,该资源暂时不能播放.",
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.only(top: 16))
        ],
      ),
    );
  }
}

///dialog for select current login user'playlist
///
///pop with a int value which represent selected id
///or null indicate selected nothing
class PlaylistSelectorDialog extends StatelessWidget {
  Widget _buildTile(BuildContext context, Widget leading, Widget title,
      Widget subTitle, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                child: leading,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 8)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AnimatedDefaultTextStyle(
                    child: title,
                    style: Theme.of(context).textTheme.body1,
                    duration: Duration.zero),
                subTitle == null
                    ? null
                    : AnimatedDefaultTextStyle(
                        child: subTitle,
                        style: Theme.of(context).textTheme.caption,
                        duration: Duration.zero),
              ]..removeWhere((v) => v == null),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      height: 56,
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 16)),
          Expanded(
              child: Text(
            "收藏到歌单",
            style: Theme.of(context).textTheme.title,
          ))
        ],
      ),
    );
  }

  Widget _buildDialog(BuildContext context, Widget content) {
    return Container(
      height: 356,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: 280.0, maxHeight: 356),
              child: Material(
                elevation: 24.0,
                type: MaterialType.card,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Column(
                  children: <Widget>[
                    _buildTitle(context),
                    Expanded(
                      child: content,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!LoginState.of(context).isLogin) {
      return _buildDialog(context, Center(child: Text("当前未登陆")));
    }
    final userId = LoginState.of(context).userId;
    return Loader(
      loadTask: () => neteaseRepository.userPlaylist(userId),
      resultVerify: neteaseRepository.responseVerify,
      builder: (context, result) {
        final list = (result["playlist"] as List)
          ..removeWhere((p) => p["creator"]["userId"] != userId);

        final widgets = <Widget>[];

        widgets.add(_buildTile(
            context,
            Container(
              color: Color(0xFFdedede),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Text("新建歌单"),
            null,
            () {}));

        widgets.addAll(list.map((p) {
          return _buildTile(
              context,
              FadeInImage(
                image: NeteaseImage(p["coverImgUrl"]),
                placeholder: AssetImage("assets/playlist_playlist.9.png"),
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                fit: BoxFit.cover,
              ),
              Text(p["name"]),
              Text("共${p["trackCount"]}首"), () {
            Navigator.of(context).pop(p["id"]);
          });
        }));

        return _buildDialog(context, ListView(children: widgets));
      },
      loadingBuilder: (context) {
        return _buildDialog(
            context,
            Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }
}
