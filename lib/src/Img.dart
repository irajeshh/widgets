// ignore_for_file: public_member_api_docs

import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    final BorderRadius borderRadius = widget.shape ?? BorderRadius.circular(widget.radius ?? 8);
    return Container(
      height: widget.height,
      width: widget.width,
      padding: EdgeInsets.all(widget.outterPadding ?? 0),
      child: Material(
        elevation: widget.elevation ?? 1.5,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        color: widget.imgColor ?? Colors.white,
        child: imgWidget(),
      ),
    );
  }

  Widget? imgWidget() {
    final Widget imgWidget = widget.imgUrl == null
        ? errorWidget()
        : CachedNetworkImage(
            imageUrl: widget.imgUrl!,
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

  Future<void> onTap() async {
    debugPrint(widget.imgUrl);
    if (widget.onTap != null) {
      //  ignore: avoid_dynamic_calls
      widget.onTap!();
    } else {
      if (widget.imgUrl != null) {
        await showImage(context, widget.imgUrl!);
      }
    }
  }

  Future<void> clearCache() async {
    if (widget.clearCache && widget.imgUrl != null) {
      // await CachedNetworkImage.evictFromCache(widget.imgUrl!);
    }
  }
}
