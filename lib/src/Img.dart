// ignore_for_file: public_member_api_docs, unsafe_html

import 'dart:async';
import 'dart:convert' as convert;

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import '../widgets.dart';

///Customized Image widget to be shown using cache
class Img extends StatefulWidget {
  final String? imgUrl;

  final double? height;
  final double? width;
  final Widget? loader;
  final Widget? errorWidget;
  final BoxFit? fit;
  final Alignment? alignment;
  final Function? onTap;
  final Widget? child;
  final double? outterPadding;
  final double? radius;
  final Color? imgColor;
  final double? elevation;
  final bool enableRippleEffect;
  final BorderRadius? shape;
  final bool clearCache;
  final Color? blendColor;
  final BlendMode? blendMode;
  final Function? onHovered;
  const Img({
    super.key,
    required this.imgUrl,
    this.height,
    this.width,
    this.loader,
    this.errorWidget,
    this.fit,
    this.alignment,
    this.onTap,
    this.child,
    this.outterPadding,
    this.radius,
    this.imgColor,
    this.elevation,
    this.enableRippleEffect = true,
    this.shape,
    this.clearCache = false,
    this.blendColor,
    this.blendMode,
    this.onHovered,
  });
  @override
  _ImgState createState() => _ImgState();
}

class _ImgState extends State<Img> with AutomaticKeepAliveClientMixin, ImgViewerMixin {
  @override
  void initState() {
    clearCache();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Container(
      height: widget.height,
      width: widget.width,
      padding: EdgeInsets.all(widget.outterPadding ?? 0),
      child: Material(
        elevation: widget.elevation ?? 1.5,
        borderRadius: widget.shape ?? BorderRadius.circular(widget.radius ?? 8),
        clipBehavior: Clip.antiAlias,
        color: widget.imgColor ?? Colors.white,
        child: imgWidget(),
      ),
    );
  }

  Widget? imgWidget() {
    final Widget imgWidget = _imgUrl == null
        ? errorWidget()
        : CachedNetworkImage(
            imageUrl: _imgUrl!,
            fit: widget.fit ?? BoxFit.fill,
            color: widget.blendColor,
            colorBlendMode: widget.blendMode,
            height: widget.height,
            width: widget.width,
            progressIndicatorBuilder: progressIndicatorBuilder,
            errorWidget: errorLoader,
          );
    final Widget? childWidget = widget.child == null
        ? null
        : Container(
            color: widget.imgColor,
            height: widget.height,
            width: widget.width,
            alignment: widget.alignment ?? Alignment.center,
            child: widget.child,
          );
    final Widget stackWidget = Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: widget.alignment ?? Alignment.center,
      children: <Widget>[
        imgWidget,
        if (childWidget != null) childWidget,
      ],
    );

    if (childWidget != null) {
      return GestureDetector(
        onTap: onTap,
        child: stackWidget,
      );
    } else {
      return Inkk(
        onHovered: widget.onHovered,
        onTap: onTap,
        radius: widget.radius,
        url: onClicked,
        child: stackWidget,
      );
    }
  }

  Widget progressIndicatorBuilder(
    final BuildContext context,
    final String url,
    final DownloadProgress progress,
  ) {
    return widget.loader ??
        Container(
          alignment: Alignment.center,
          height: widget.height,
          width: widget.width,
          child: CircularProgressIndicator(
            value: progress.progress,
            color: Colors.grey.withOpacity(0.25),
          ),
        );
  }

  Widget errorLoader(final _, final __, final ___) {
    return widget.errorWidget ?? errorWidget();
  }

  Widget errorWidget() {
    return widget.errorWidget ??
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: Icon(
            Icons.shopping_bag,
            color: Colors.grey.withOpacity(0.5),
            size: 50,
          ),
        );
  }

  ///If onClicked is given, then call it alone!
  Future<void> onTap() async {
    debugPrint(_imgUrl);
    if (onClicked != null) {
      html.window.open(onClicked!, '_blank');
    } else if (widget.onTap != null) {
      widget.onTap!();
    } else {
      await showImage(context, _imgUrl);
    }
  }

  Future<void> clearCache() async {
    if (widget.clearCache && _imgUrl != null) {
      // await CachedNetworkImage.evictFromCache(_imgUrl!);
    }
  }

  String? get _imgUrl {
    String? u = widget.imgUrl;
    if (u != null) {
      ///Check if url is a JSON
      if (u.isJSON) {
        printt('$u is a JSON');

        ///Check the device type
        DeviceType deviceType = DeviceType.laptop;
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double aspectRatio = screenWidth / screenHeight;
        if (aspectRatio < 0.74) {
          deviceType = DeviceType.mobile;
        } else if (aspectRatio >= 0.74 && aspectRatio < 1.0) {
          deviceType = DeviceType.tablet;
        }
        printt('deviceType is ${deviceType.name}');

        ///Try to parse the json and retrive the respective URL
        try {
          printt('Trying to convert json from u');
          final Object? j = convert.jsonDecode(u);
          if (j is Json) {
            printt('j is Json');
            final String? mobile = j.nullableString(DeviceType.mobile.name);
            final String? tablet = j.nullableString(DeviceType.tablet.name);
            final String? laptop = j.nullableString(DeviceType.laptop.name);
            switch (deviceType) {
              case DeviceType.mobile:
                u = mobile ?? tablet ?? laptop;
              case DeviceType.laptop:
                u = laptop ?? tablet ?? mobile;
              case DeviceType.tablet:
                u = tablet ?? (aspectRatio >= 1.0 ? laptop : mobile);
            }
            printt('mobile: $mobile');
            printt('tablet: $tablet');
            printt('laptop: $laptop');
          } else {
            printt('j is not Json');
          }
        } on Exception catch (e) {
          printt('Error parsing JSON from ($u) :Error $e');
        }
      } else {
        printt('$u is not a JSON');
      }
    }
    return u?.replaceAll(' ', '');
  }

  String? get onClicked => _imgUrl?.split('onClicked=').lastOrNull;
}
