class Linkpage {
  final String link;

  Linkpage({required this.link});
}

class Linksapcepage {
  final String placestr;
  final int index;
  final int? subindex;
  final String? date;

  Linksapcepage({
    required this.placestr,
    required this.index,
    this.subindex,
    this.date,
  });
  Map<String, dynamic> toMap() {
    return {
      'placestr': placestr,
      'index': index,
      'subindex': subindex,
      'date': date
    };
  }
}
