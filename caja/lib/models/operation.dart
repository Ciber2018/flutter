class Operation {
  late int id;
  late String data;
  late String type;

  Operation(String data, String type) {
    this.data = data;
    this.type = type;
  }

  Operation.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.data = map['data'];
    this.type = map['type'];
  }

  int getId() {
    return this.id;
  }

  String getData() {
    return this.data;
  }

  String getType() {
    return this.type;
  }

  void setData(String data) {
    this.data = data;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['data'] = this.data;
    map['type'] = this.type;
    return map;
  }
}
