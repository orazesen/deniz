import 'package:flutter/material.dart';
import 'package:saray_pub/utils/size_config.dart';

class TransitionAppBar extends StatelessWidget {
  final Widget avatar;
  //final Widget title;
  final double extent;
  final Widget leading;

  TransitionAppBar({this.avatar, this.leading, this.extent = 100, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
          avatar: avatar, leading: leading, extent: extent),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  final _avatarMarginTween = EdgeInsetsTween(
    begin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 9, left: 0.0),
    end: EdgeInsets.only(
      left: 0.0,
      top: SizeConfig.heightMultiplier * 3,
    ),
  );
  final _avatarAlignTween =
      AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.topCenter);

  final Widget avatar;
  // final Widget title;
  final double extent;
  final Widget leading;

  _TransitionAppBarDelegate({this.avatar, this.leading, this.extent = 100})
      : assert(avatar != null),
        assert(extent == null || extent >= 100);
  // assert(title != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final media = MediaQuery.of(context);
    double tempVal = media.padding.top * maxExtent / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final avatarMargin = _avatarMarginTween.lerp(progress);
    final avatarAlign = _avatarAlignTween.lerp(progress);

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: shrinkOffset * 2,
          constraints: BoxConstraints(maxHeight: minExtent),
          // color: Colors.redAccent,
        ),
        Padding(
          padding: avatarMargin,
          child: Align(alignment: avatarAlign, child: avatar),
        ),
        // Padding(
        //   padding: EdgeInsets.only(bottom: 10),
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: title,
        //   ),
        // )
        leading,
      ],
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => (maxExtent * 80) / 100;

  @override
  bool shouldRebuild(_TransitionAppBarDelegate oldDelegate) {
    return avatar != oldDelegate.avatar; // || title != oldDelegate.title;
  }
}
