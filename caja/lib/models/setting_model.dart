class SettingModel {
  late int id;
  late double value;
  late String name;

  SettingModel(double value, String name) {
    this.value = value;
    this.name = name;
  }

  SettingModel.empty() {
    //this.id = 0;
    this.value = 0;
    this.name = '';
  }

  int getId() {
    return this.id;
  }

  double getValue() {
    return this.value;
  }

  String getName() {
    return this.name;
  }

  void setId(int id) {
    this.id = id;
  }

  void setValue(double newValue) {
    this.value = newValue;
  }

  void setName(String newName) {
    this.name = newName;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = this.name;
    map['value'] = this.value;
    return map;
  }

  SettingModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.value = map['value'];
  }
}
