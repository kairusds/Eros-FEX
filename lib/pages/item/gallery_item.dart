import 'package:FEhViewer/common/global.dart';
import 'package:FEhViewer/models/galleryItem.dart';
import 'package:FEhViewer/models/states/ehconfig_model.dart';
import 'package:FEhViewer/route/navigator_util.dart';
import 'package:FEhViewer/values/const.dart';
import 'package:FEhViewer/values/theme_colors.dart';
import 'package:FEhViewer/widget/blur_image.dart';
import 'package:FEhViewer/widget/rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GalleryItemWidget extends StatefulWidget {
  final int index;
  final GalleryItem galleryItem;

  GalleryItemWidget({this.index, this.galleryItem});

  @override
  _GalleryItemWidgetState createState() => _GalleryItemWidgetState();
}

class _GalleryItemWidgetState extends State<GalleryItemWidget> {
  final double _padL = 8.0;

  Color _colorTap; // 按下时颜色反馈
  String _title; // 英语或者日语

  Widget _buildTitle() {
    return Selector<EhConfigModel, bool>(
      selector: (context, provider) => provider.isJpnTitle,
      builder: (context, value, child) {
//        Global.logger.v('Provider build title');
        _title = _getTitle(value);
        return Text(
          _title,
          maxLines: 4,
          textAlign: TextAlign.left, // 对齐方式
          overflow: TextOverflow.ellipsis, // 超出部分省略号
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  String _getTitle(bool isJpnTitle) {
    var _titleEn = widget?.galleryItem?.englishTitle ?? '';
    var _titleJpn = widget?.galleryItem?.japaneseTitle ?? '';

    // 日语标题判断
    var _title = isJpnTitle && _titleJpn != null && _titleJpn.isNotEmpty
        ? _titleJpn
        : _titleEn;

    return _title;
  }

  @override
  Widget build(BuildContext context) {
    Color _colorCategory = ThemeColors
            .nameColor[widget?.galleryItem?.category ?? "defaule"]["color"] ??
        CupertinoColors.white;

    Widget containerGallery = Container(
      color: _colorTap,
      // height: 200,
      padding: EdgeInsets.fromLTRB(_padL, 8, 8, 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 120.0, //最小高度
          // maxHeight: 200,
        ),
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              // 封面
              Container(
                width: 120,
//                height: 180,
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  // 圆角
                  borderRadius: BorderRadius.circular(8),
                  child: CoverImg(imgUrl: widget?.galleryItem?.imgUrl ?? ''),
                ),
              ),

              // 右侧
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 标题
                    _buildTitle(),
                    // 上传者
                    Text(
                      widget?.galleryItem?.uploader ?? '',
                      style: TextStyle(
                          fontSize: 12, color: CupertinoColors.systemGrey),
                    ),
                    // 标签
                    TagBox(
                      simpleTags: widget.galleryItem.simpleTags,
                      simpleTagsTranslat: widget.galleryItem.simpleTagsTranslat,
                    ),
                    // Spacer(),
                    // 评分和页数
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: StaticRatingBar(
                            size: 20.0,
                            rate: widget.galleryItem.rating,
                            radiusRatio: 1.5,
                          ),
                        ),
                        Text(
                          widget?.galleryItem?.rating.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        // 占位
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            widget.galleryItem.favTitle?.isNotEmpty ?? false
                                ? Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 2.5, right: 8),
                                    child: Icon(
                                      FontAwesomeIcons.solidHeart,
                                      size: 12,
                                      color: Colors.redAccent,
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 1),
                              child: Icon(
//                              EHCupertinoIcons.paper_solid,
                                Icons.panorama,
                                size: 13,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                widget?.galleryItem?.filecount ?? "",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.systemGrey),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 4,
                    ),
                    // 类型和时间
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
                            color: _colorCategory,
                            child: Text(
                              widget?.galleryItem?.category ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1,
                                color: CupertinoColors.white,
//                              backgroundColor: _colorCategory
                              ),
                            ),
                          ),
                        ),

                        // 上传时间
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget?.galleryItem?.postTime ?? "",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemGrey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );

    return GestureDetector(
      child: Column(
        children: <Widget>[
          containerGallery,
          Divider(
            height: 0.5,
            indent: _padL,
            color: CupertinoColors.systemGrey4,
          ),
        ],
      ),
      // 不可见区域点击有效
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Global.logger.v("onTap title: $_title");
        NavigatorUtil.goGalleryDetail(context, _title, widget.galleryItem);
      },
      onLongPress: () {
        Global.logger.v("onLongPress title: $_title ");
      },
      onTapDown: (_) => _updatePressedColor(),
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 150), () {
          _updateNormalColor();
        });
      },
      onTapCancel: () => _updateNormalColor(),
    );
  }

  void _updateNormalColor() {
    setState(() {
      _colorTap = CupertinoColors.systemBackground;
    });
  }

  void _updatePressedColor() {
    setState(() {
      _colorTap = CupertinoColors.systemGrey4;
    });
  }
}

class TagItem extends StatelessWidget {
  final text;

  const TagItem({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        // height: 18,
        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
        color: Color(0xffeeeeee),
        child: Text(
          text ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            height: 1,
            fontWeight: FontWeight.w400,
            color: Color(0xff444444),
          ),
          strutStyle: StrutStyle(height: 1),
        ),
      ),
    );
  }
}

/// 传入原始标签和翻译标签
/// 便于设置切换的时候变更
class TagBox extends StatelessWidget {
  final List<String> simpleTags;
  final List<String> simpleTagsTranslat;

  const TagBox(
      {Key key, @required this.simpleTags, @required this.simpleTagsTranslat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _simpleTags;
    return Selector<EhConfigModel, bool>(
      selector: (context, provider) => provider.isTagTranslat,
      builder: (context, value, child) {
        _simpleTags = value ? simpleTagsTranslat : simpleTags;
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
          child: Wrap(
            spacing: 4, //主轴上子控件的间距
            runSpacing: 4, //交叉轴上子控件之间的间距
            children: List<Widget>.from(_simpleTags
                .map((tagText) => TagItem(
                      text: tagText,
                    ))
                .toList()), //要显示的子控件集合
          ),
        );
      },
    );
  }
}

/// 封面图片Widget
class CoverImg extends StatelessWidget {
  final String imgUrl;

  const CoverImg({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _httpHeaders = {
      "Cookie": Global.profile?.token ?? '',
    };
    return Selector<EhConfigModel, bool>(
        selector: (context, provider) => provider.isGalleryImgBlur,
        builder: (BuildContext context, bool value, Widget child) {
          return imgUrl != null
              ? (value
                  ? BlurImage(
                      child: CachedNetworkImage(
                      httpHeaders: _httpHeaders,
                      imageUrl: imgUrl,
                    ))
                  : CachedNetworkImage(
                      httpHeaders: _httpHeaders,
                      imageUrl: imgUrl,
                    ))
              : Container();
        });
  }
}
