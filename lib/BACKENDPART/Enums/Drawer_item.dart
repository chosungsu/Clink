// ignore_for_file: file_names, non_constant_identifier_names
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'Variables.dart';

List<Map> drawerItems_view = [
  {
    'icon': SimpleLineIcons.home,
  },
  {
    'icon': notilist.isread == true
        ? Ionicons.notifications_outline
        : MaterialCommunityIcons.bell_badge_outline,
  },
  {
    'icon': Ionicons.ios_person_outline,
  },
  {
    'icon': Ionicons.settings_outline,
  },
];
