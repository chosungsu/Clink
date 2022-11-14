class CompanyPageList {
  final String title;
  final String url;

  CompanyPageList({
    required this.title,
    required this.url,
  });
}

class PageList {
  final String title;
  String? username;
  String? email;
  String? id;

  PageList({required this.title, this.email, this.username, this.id});
}

class PageviewList {
  final String title;
  String? username;
  String? calendarcontent;
  List? urlcontent;
  List? todolistcontent;
  List? memocontent;
  int? seperatedindex;
  int? boxseperatedindex;

  PageviewList(
      {required this.title,
      this.seperatedindex,
      this.username,
      this.boxseperatedindex,
      this.calendarcontent,
      this.urlcontent,
      this.todolistcontent,
      this.memocontent});
}
