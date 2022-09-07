class Asign {
  late int id;
  late int bus;
  late String asign;

  Asign(int bus, String asign) {
    this.bus = bus;
    this.asign = asign;
  }

  Asign.empty() {
    this.id = 0;
    this.bus = 0;
    this.asign = '';
  }

  int getId() {
    return this.id;
  }

  int getBus() {
    return this.bus;
  }

  String getAsign() {
    return this.asign;
  }

  void setId(int id) {
    this.id = id;
  }

  void setBus(int newBus) {
    this.bus = newBus;
  }

  void setAsign(String newAsign) {
    this.asign = newAsign;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['bus'] = this.bus;
    map['asign'] = this.asign;
    return map;
  }

  Asign.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.bus = map['bus'];
    this.asign = map['asign'];
  }
}
