class HistoryList {
  int id;
  String name;
  int sum;
  String tanggal;

  HistoryList(this.id, this.name, this.sum, this.tanggal);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'sum': sum, 'tanggal': tanggal};
  }

  @override
  String toString() {
    return 'id : $id\nname : $name\nsum : $sum\ntanggal : $tanggal';
  }
}
