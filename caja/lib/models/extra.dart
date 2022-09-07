class Extra {
  late String extra;
  late int id;
  late int bus;

  Extra(String extra, int bus) {
    this.extra = extra;
    this.bus = bus;
  }

  Extra.empty() {
    this.extra = '';
  }

  int getId() {
    return this.id;
  }

  int getBus() {
    return this.bus;
  }

  String getExtra() {
    return this.extra;
  }

  void setBus(int newBus) {
    this.bus = newBus;
  }

  void setExtra(String extra) {
    this.extra = extra;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['extra'] = this.extra;
    map['bus'] = this.bus;
    return map;
  }

  Extra.fromMapObject(Map<String, dynamic> map) {
    this.extra = map['extra'];
    this.bus = map['bus'];
    this.id = map['id'];
  }
}
