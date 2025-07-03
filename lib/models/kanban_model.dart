class Kanban {
  int? id;
  String section;
  String bab;
  String keterangan;
  String due;

  Kanban({this.id, required this.section, required this.bab, required this.keterangan, required this.due});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'section': section,
      'bab': bab,
      'keterangan': keterangan,
      'due': due,
    };
  }

  factory Kanban.fromMap(Map<String, dynamic> map) {
    return Kanban(
      id: map['id'],
      section: map['section'],
      bab: map['bab'],
      keterangan: map['keterangan'],
      due: map['due'],
    );
  }
}
