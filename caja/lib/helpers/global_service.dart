class GlobalService {
  static final GlobalService instance = GlobalService._internal();

  factory GlobalService() => instance;

  GlobalService._internal() {
    bus = -1;
  }

  late int bus;

  int getBus() {
    return bus;
  }

  void setBus(int newBus) {
    bus = newBus;
  }

  void reset() {
    bus = -1;
  }
}
