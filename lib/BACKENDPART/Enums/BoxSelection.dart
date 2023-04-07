// ignore_for_file: file_names

class BoxSelection {
  final String title;
  final String isavailable;
  final String content;

  BoxSelection(
      {required this.title, required this.isavailable, required this.content});
}

List<Map> boxtypedatamap = [
  {"title": "Url", "isavailable": "open", "content": ""},
  {"title": "Calendar", "isavailable": "open", "content": ""},
  {"title": "Simple memo", "isavailable": "close", "content": ""},
  {"title": "Map", "isavailable": "update", "content": ""},
];
