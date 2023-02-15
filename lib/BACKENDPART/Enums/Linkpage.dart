class Linkspacepageenter {
  ///Linkspacepageenter
  ///
  ///이 부분은 메인에서 박스를 생성할 때 호출되는 부분
  final String? placeentercode;
  final String? addname;
  final String? substrcode;

  Linkspacepageenter({this.placeentercode, this.addname, this.substrcode});
}

class Linkspacepage {
  ///Linkspacepage
  ///
  ///이 부분은 메인에서 박스를 생성할 때 호출되는 부분
  final String placestr;
  final int type;
  final int? index;
  final String uniquecode;
  final String familycode;
  final String? date;
  final String? codename;
  final String? canshow;

  Linkspacepage(
      {required this.placestr,
      required this.type,
      this.index,
      required this.uniquecode,
      required this.familycode,
      this.date,
      this.codename,
      this.canshow});
}

class Linkspacetreepage {
  ///Linkspacetreepage
  ///
  ///이 부분은 메인에서 박스내부 박스를 생성할 때 호출되는 부분
  final String placestr;
  final String uniqueid;
  final int? subindex;
  final String? mainid;
  final String? date;

  Linkspacetreepage({
    required this.placestr,
    required this.uniqueid,
    this.subindex,
    this.mainid,
    this.date,
  });
}

class LinkofPapers {
  ///LinkofPapers
  ///
  ///이 부분은 메인에서 박스내부 박스를 생성할 때 호출되는 부분
  final String placestr;
  final String uniqueid;
  final String? mainid;

  LinkofPapers({
    required this.placestr,
    required this.uniqueid,
    this.mainid,
  });
}
