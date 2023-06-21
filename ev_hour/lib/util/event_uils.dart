import 'package:event_bus/event_bus.dart';

class EventUtils {
  static EventBus? _eventBus;
  static EventUtils? _instance;

  EventUtils._();

  static EventUtils getInstance() {
    _instance ??= EventUtils._();

    return _instance!;
  }

  EventBus getEventBus() {
    _eventBus ??= EventBus();

    return _eventBus!;
  }

  void fire(event) {
    getEventBus().fire(event);
  }
}
