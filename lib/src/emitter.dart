part of 'hooks.dart';

/// 事件监听函数类型声明
typedef EventListener = Function(dynamic event);

/// 可取消
class CancelledEvent {
  bool _isCancelled = false;

  /// 取消方法
  void cancel() => _isCancelled = true;

  /// 是否已取消
  bool isCancelled() => _isCancelled;
}

/// 异步
class AsynchronizedEvent extends CancelledEvent {
  /// 是否是异步
  bool isAsynchronized() => true;
}

/// 事件映射函数分发监听功能类
class EventEmitter {
  /// 静态实例化
  // static EventEmitter instance = EventEmitter();

  // 事件Map容器
  final Map<String, List<_EventContainer>> _containers = {};

  /// 持久化监听
  void on(String name, EventListener listener, {int? limit}) {
    // 默认 limit 0 = 没有次数限制
    final container = _EventContainer(listener, limit ?? 0);

    if (_containers.containsKey(name)) {
      _containers[name]!.add(container);
    } else {
      _containers[name] = [container];
    }
  }

  /// 取消监听
  void off(String name) {
    _containers[name] = [];
  }

  /// 只执行一次
  void once(String name, EventListener listener) =>
      on(name, listener, limit: 1);

  /// 发出事件触发
  Future<void> emit(String name, dynamic event) async {
    if (_containers.containsKey(name)) {
      final removeIndexes = <int>[];
      for (var i = 0; i < _containers[name]!.length; i++) {
        final container = _containers[name]![i];
        if (event is AsynchronizedEvent && event.isAsynchronized()) {
          await container.listener(event);
        } else {
          container.listener(event);
        }
        if (container.limit > 0) {
          container.limit--;
        }
        if (container.limit == 0) {
          removeIndexes.add(i);
        }
        if (event is CancelledEvent && event.isCancelled()) {
          break;
        }
      }
      removeIndexes.forEach(_containers[name]!.removeAt);
    }
  }
}

class _EventContainer {
  _EventContainer(this.listener, this.limit);
  final EventListener listener;
  int limit;
}

/// 全app就一个emitter
EventEmitter emitter = EventEmitter();

/// Emitter 钩子
EventEmitter useEmitter() {
  return use(_Emitter());
}

class _Emitter extends Hook<EventEmitter> {
  @override
  _EmitterState createState() => _EmitterState();
}

class _EmitterState extends HookState<EventEmitter, _Emitter> {
  @override
  void initHook() {
    super.initHook();
  }

  @override
  EventEmitter build(BuildContext context) {
    return emitter;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
