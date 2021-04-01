part of 'hooks.dart';

/// useDebounceState function
ValueNotifier<T> useDebounceState<T>(T initialData, {int? wait}) {
  return use(_StateHook(initialData: initialData, wait: wait ?? 500));
}

class _StateHook<T> extends Hook<ValueNotifier<T>> {
  const _StateHook({required this.initialData, required this.wait});

  final T initialData;
  final int wait;

  @override
  _StateHookState<T> createState() => _StateHookState();
}

class _StateHookState<T> extends HookState<ValueNotifier<T>, _StateHook<T>> {
  late final _state = ValueNotifier<T>(hook.initialData)
    ..addListener(_listener);

  late final Timer _timer;

  @override
  void initHook() {
    super.initHook();
  }

  @override
  void dispose() {
    _state.dispose();
  }

  @override
  ValueNotifier<T> build(BuildContext context) => _state;

  void _listener() {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: hook.wait), () {
      setState(() {});
    });
  }

  @override
  Object? get debugValue => _state.value;

  @override
  String get debugLabel => 'useState<$T>';
}
