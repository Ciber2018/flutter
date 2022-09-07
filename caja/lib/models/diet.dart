class Diet {
  late int id;
  late int bus;
  late String diet;

  Diet(int bus, String diet) {
    this.diet = diet;
    this.bus = bus;
  }

  Diet.empty() {
    this.diet = '';
  }

  String getDiet() {
    return this.diet;
  }

  int getBus() {
    return this.bus;
  }

  int getId() {
    return this.id;
  }

  void setDiet(String newDiet) {
    this.diet = newDiet;
  }

  void setBus(int newBus) {
    this.bus = newBus;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['diet'] = this.diet;
    map['bus'] = this.bus;
    return map;
  }

  Diet.fromMapObject(Map<String, dynamic> map) {
    this.diet = map['diet'];
    this.bus = map['bus'];
    this.id = map['id'];
  }
}
