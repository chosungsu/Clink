class Linkpage {
  final String link;

  Linkpage({required this.link});
}

class Linkspacepage {
  final String placestr;
  final int type;
  final String uniquecode;
  final String? date;

  Linkspacepage({
    required this.placestr,
    required this.type,
    required this.uniquecode,
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
  final String? date;

  Linkspacetreepage({
    required this.placestr,
    required this.uniqueid,
    this.subindex,
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
