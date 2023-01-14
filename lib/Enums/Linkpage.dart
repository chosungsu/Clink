class Linkpage {
  final String link;

  Linkpage({required this.link});
}

class Linkspacepageenter {
  final String? placeentercode;
  final String? addname;
  final String? substrcode;

  Linkspacepageenter({this.placeentercode, this.addname, this.substrcode});
}

class Linkspacepage {
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
