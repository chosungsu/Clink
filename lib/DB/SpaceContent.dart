class SpaceContent {
  final String title;
  final String date;
  final String startdate;
  final String finishdate;
  final List cname;
  final String alarm;
  final List share;
  final String code;
  final String summary;

  SpaceContent(
      {required this.title,
      required this.date,
      required this.startdate,
      required this.finishdate,
      required this.cname,
      required this.alarm,
      required this.share,
      required this.code,
      required this.summary});
}

class MemoContent {
  final bool security;
  final String Collection;
  final int color;
  final int colorfont;
  final String memoTitle;
  final String EditDate;
  final int securewith;
  final String pinnumber;
  final String Date;
  final String id;
  final List memoindex;
  final List photoUrl;
  final List memolist;

  MemoContent(
      {required this.security,
      required this.Date,
      required this.Collection,
      required this.color,
      required this.colorfont,
      required this.memoTitle,
      required this.EditDate,
      required this.securewith,
      required this.pinnumber,
      required this.memoindex,
      required this.photoUrl,
      required this.memolist,
      required this.id});
}
