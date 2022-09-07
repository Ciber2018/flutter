class Products {
  late int id;
  late String name;
  late double price;

  Products(String name, double price) {
    this.price = price;
    this.name = name;
  }

  Products.empty() {
    this.id = 0;
    this.price = 0;
    this.name = '';
  }

  int getId() {
    return this.id;
  }

  double getPrice() {
    return this.price;
  }

  String getName() {
    return this.name;
  }

  void setId(int id) {
    this.id = id;
  }

  void setPrice(double newPrice) {
    this.price = newPrice;
  }

  void setName(String newName) {
    this.name = newName;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = this.name;
    map['price'] = this.price;
    return map;
  }

  Products.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.price = map['price'];
  }
}
