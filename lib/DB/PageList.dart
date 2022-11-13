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

  PageList({required this.title, this.email, this.username});
}
