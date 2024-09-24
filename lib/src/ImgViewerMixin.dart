import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart' as cachedimg;
import 'package:easy_image_viewer/easy_image_viewer.dart' as image_viewer_lib;
import 'package:flutter/material.dart';

///To call the function from any other functions we created this mixin
mixin ImgViewerMixin {
  ///To show the given url of the image in zoomable page
  Future<void> showImage(final BuildContext context, final String imgUrl) async {
    await image_viewer_lib.showImageViewer(
      context,
      cachedimg.CachedNetworkImageProvider(imgUrl),
      swipeDismissible: true,
      doubleTapZoomable: true,
      backgroundColor: Colors.black12,
    );
  }
}
