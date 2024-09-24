import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

///A commonly used imageprovider for builder mostly in Container decoration
ImageProvider imgProvider(final String imgUrl) {
  return CachedNetworkImageProvider(imgUrl);
}
