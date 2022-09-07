class Buses {
  late int id;
  late String location;

  Buses(String location) {
    this.location = location;
  }

  Buses.empty() {
    this.id = 0;
    this.location = '';
  }

  int getId() {
    return this.id;
  }

  String getLocation() {
    return this.location;
  }

  void setId(int id) {
    this.id = id;
  }

  void setLocation(String newLocation) {
    this.location = newLocation;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['location'] = this.location;
    return map;
  }

  Buses.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.location = map['location'];
  }
}
