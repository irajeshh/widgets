library widgets;

import 'dart:async';

import 'package:extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as toast;

// export 'package:cached_network_image/cached_network_image.dart';

export './src/Boxer.dart';
export './src/Button.dart';
export './src/Constants.dart/Constants.dart';
export './src/Expasiontile.dart';
export './src/Iconbutton.dart';
export './src/IconsPack.dart';
export './src/Img.dart';
export './src/ImgProvider.dart';
export './src/ImgSlideshow.dart';
export './src/ImgViewerMixin.dart';
export './src/Inkk.dart';
export './src/Loader.dart';
export './src/RatingBar.dart';
export './src/Txt.dart';

part './config.dart';

///Showing a classic [Toast] to inform the [User] about
///the recent [actions] they [performed] or [requested]
///[Example] await read();
void showToast(final Object? m) {
  String message = '$m';
  debugPrint(message);
  if (message.contains('cloud_firestore/unavailable')) {
    message = 'Poor internet connection!';
  }
  if (message.contains('cloud_firestore/permission-denied')) {
    message = 'Permission denied!';
  }
  try {
    toast.showToast(message);
  } on Exception catch (e) {
    debugPrint('Error showing Toast: $e');
  }
}

///To run the execution after the given delay
Future<void> wait([final int? milliseconds = 350]) async {
  await Future<void>.delayed(Duration(milliseconds: milliseconds ?? 350));
}

///To print any given input
void printt(final Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

///Returns the maximum width of the current device
double mwidth(final BuildContext context) => MediaQuery.of(context).size.width;
