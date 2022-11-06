class Linkpage {
  final String link;

  Linkpage({required this.link});
}

class Linkspacepage {
  final String placestr;
  final int index;
  final int? subindex;
  final String? date;

  Linkspacepage({
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
