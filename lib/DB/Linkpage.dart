class Linkpage {
  final String link;

  Linkpage({required this.link});
}

class Linkspacepage {
  final String placestr;
  final int type;
  final int? index;
  final String uniquecode;
  final String familycode;
  final String? date;

  Linkspacepage({
    required this.placestr,
    required this.type,
    this.index,
    required this.uniquecode,
    required this.familycode,
    this.date,
  });
  Map<String, dynamic> toMap() {
    return {
      'placestr': placestr,
      'index': type,
      'subindex': uniquecode,
      'date': date
    };
  }
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
  Map<String, dynamic> toMap() {
    return {
      'placestr': placestr,
      'index': uniqueid,
      'subindex': subindex,
      'date': date
    };
  }
}
