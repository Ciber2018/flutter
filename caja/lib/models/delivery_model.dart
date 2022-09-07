class DeliveryModel {
  late int bus;
  late String delivery;
  late int id;

  DeliveryModel(int bus, String delivery) {
    this.bus = bus;
    this.delivery = delivery;
  }

  DeliveryModel.empty() {
    this.bus = 0;
    this.delivery = '';
  }

  int getBus() {
    return this.bus;
  }

  String getDelivery() {
    return this.delivery;
  }

  int getId() {
    return this.id;
  }

  void setDelivery(String newDelivery) {
    this.delivery = newDelivery;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['bus'] = this.bus;
    map['delivery'] = this.delivery;
    return map;
  }

  DeliveryModel.fromMapObject(Map<String, dynamic> map) {
    this.bus = map['bus'];
    this.delivery = map['delivery'];
    this.id = map['id'];
  }
}
