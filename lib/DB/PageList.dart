class CompanyPageList {
  final String title;
  final String date;

  CompanyPageList({
    required this.title,
    required this.date,
  });
}

class PageList {
  final String title;
  String? username;
  String? email;
  String? id;
  String? setting;

  PageList(
      {required this.title, this.email, this.username, this.id, this.setting});
}

class PageviewList {
  final String title;
  final int type;
  final String uniquecode;
  String? username;
  String? calendarcontent;
  List? urlcontent;
  List? todolistcontent;
  List? memocontent;
  int? seperatedindex;
  int? boxseperatedindex;

  PageviewList(
      {required this.title,
      required this.type,
      required this.uniquecode,
      this.seperatedindex,
      this.username,
      this.boxseperatedindex,
      this.calendarcontent,
      this.urlcontent,
      this.todolistcontent,
      this.memocontent});
}
