part of 'widgets.dart';

///Class to configure certain details which are varrying based on the parent project
class WidgetsConfig {
  WidgetsConfig._privateConstructor();
  static final WidgetsConfig _instance = WidgetsConfig._privateConstructor();

  ///Quick instance of the class
  static WidgetsConfig get instance => _instance;

  ///Returns the current font family set by parent project
  static String _fontFamily = 'Roboto';

  ///getter
  static String get fontFamily => _fontFamily;

  ///To make the text selectable to give a native web feeling
  ///But this should be [true] only on customer web
  static bool _selectableText = false;

  ///getter
  static bool get selectableText => _selectableText;

  ///Colors to be configured
  static Color _primaryColor = Colors.purpleAccent;

  ///getter
  static Color get primaryColor => _primaryColor;

  ///Considering the primary color as buttonColor
  static Color get buttonColor => primaryColor;

  ///Rendering a dark shade from primary color
  static Color get dark => buttonColor.dark();

  ///Initiating the paramters which may varry for each parent project
  static void initiate({
    final Color? primaryColor,
    final String? fontFamily,
    final bool? selectableText,
  }) {
    _primaryColor = primaryColor ?? _primaryColor;
    _fontFamily = fontFamily ?? _fontFamily;
    _selectableText = selectableText ?? _selectableText;
  }
}
