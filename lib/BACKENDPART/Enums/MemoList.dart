class MemoList {
  final String memocontent;
  final int contentindex;

  MemoList({
    required this.memocontent,
    required this.contentindex,
  });

  factory MemoList.fromJason(Map<String, dynamic> json) {
    return MemoList(
        memocontent: json['memotitle'], contentindex: json['memodate']);
  }

  dynamic toJson() => {'memotitle': memocontent};
}
