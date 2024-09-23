import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ImgSlideshow extends StatefulWidget {
  final bool autoScroll;
  final List<String> imgUrls;
  final double? height;
  final double? borderRadius;

  ///To show a mini preview of available images
  final bool showIndicators;
  final VoidCallback? onTap;

  ///To show arrow to navigate
  final bool showNavigators;

  ///Custom widget to indicate the current image
  final Widget? selectedIndicator;

  ///To show custom icon for naviation buttons
  final IconData? navigatorIcon;

  ///Custom widget to indicate the other images
  final Widget? unSelectedIndicator;

  ///To show custom color of the navigation icon buttons
  final Color? navigatorIconColor;

  final BoxFit? fit;

  ///Color to be shown in background of the navigation icon
  final Color? navigatorIconBackgroundColor;

  ///Constructor
  const ImgSlideshow({
    super.key,
    required this.imgUrls,
    this.height,
    this.autoScroll = true,
    this.borderRadius,
    this.showIndicators = true,
    this.onTap,
    this.showNavigators = false,
    this.selectedIndicator,
    this.unSelectedIndicator,
    this.navigatorIcon,
    this.navigatorIconColor,
    this.fit,
    this.navigatorIconBackgroundColor,
  });
  @override
  _ImgSlideshowState createState() => _ImgSlideshowState();
}

class _ImgSlideshowState extends State<ImgSlideshow> {
  final PageController imgsPageController = PageController();
  int currentImgIndex = 0;

  @override
  void initState() {
    autoScroll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = widget.height ?? ((width / 16) * 9);
        return SizedBox(
          width: width,
          child: Column(
            children: <Widget>[
              pages(height, width),
              if (widget.showIndicators) indicator(),
            ],
          ),
        );
      },
    );
  }

  Widget pages(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: PageView.builder(
        controller: imgsPageController,
        onPageChanged: onImgsPageChanged,
        itemCount: widget.imgUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Img(
            imgUrl: widget.imgUrls[index],
            fit: widget.fit ?? BoxFit.contain,
            radius: widget.borderRadius ?? 0,
            height: height,
            width: width,
            onTap: widget.onTap,
            child: navigators(),
          );
        },
      ),
    );
  }

  Widget? navigators() {
    if (widget.showNavigators == false || widget.imgUrls.length < 2) {
      return null;
    } else {
      Widget button(bool backward) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RotatedBox(
            quarterTurns: backward ? 1 : 3,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.navigatorIconBackgroundColor,
              ),
              child: Iconbutton(
                icon: widget.navigatorIcon ?? Icons.arrow_drop_down_circle,
                tooltip: backward ? 'Previous' : 'Next',
                color: widget.navigatorIconColor ?? Colors.black26,
                size: MediaQuery.of(context).size.width < 600 ? null : 40,
                onPressed: () async {
                  _animateFn(backward ? currentImgIndex - 1 : currentImgIndex + 1);
                },
              ),
            ),
          ),
        );
      }

      return Row(
        children: <Widget>[
          button(true),
          const Spacer(),
          button(false),
        ],
      );
    }
  }

  Widget indicator() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imgUrls.map((String e) {
          final int index = widget.imgUrls.indexOf(e);
          final bool selected = currentImgIndex == widget.imgUrls.indexOf(e);
          final Widget img = Img(
            imgUrl: e,
            height: 60,
            width: 96,
            outterPadding: 8,
            radius: 6,
            imgColor: selected ? Colors.black45 : null,
            child: selected ? const Icon(Icons.check) : null,
          );

          return Flexible(
            child: Inkk(
              onTap: () async => _animateFn(index),
              child: (selected ? widget.selectedIndicator : widget.unSelectedIndicator) ?? img,
            ),
          );
        }).toList(),
      ),
    );
  }

  void onImgsPageChanged(int p) {
    if (mounted) {
      setState(() => currentImgIndex = p);
    }
  }

  Future<void> autoScroll() async {
    if (widget.autoScroll) {
      ///wait until scroll controller is attached
      await wait(2000);
      if (mounted == false || imgsPageController.hasClients == false) {
        return;
      }
      final int length = widget.imgUrls.length;
      bool reverse = false;

      while (length > 0) {
        await wait(3000);
        int nextPage;
        if (!reverse) {
          nextPage = (currentImgIndex + 1) % length;
        } else {
          nextPage = (currentImgIndex - 1) % length;
          if (nextPage < 0) {
            nextPage = length - 1;
          }
        }

        _animateFn(nextPage);

        if (nextPage == length - 1 || nextPage == 0) {
          reverse = !reverse;
        }
      }
    }
  }

  Future<void> _animateFn(int index) async {
    if (mounted) {
      try {
        await imgsPageController.animateToPage(
          index,
          duration: Durations.short1,
          curve: Curves.ease,
        );
      } on Exception catch (e) {
        print('Error auto scrolling banner :$e');
      }
      if (mounted) setState(() => currentImgIndex = index);
    }
  }
}
