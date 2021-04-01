part of 'hooks.dart';

ValueNotifier useDebounceState(dynamic value, {int? wait}) {
  return use(_DebounceState(value, wait: wait ?? 1000));
}

class _DebounceState extends Hook<ValueNotifier> {
  const _DebounceState(this.value, {this.wait});

  final dynamic value;
  final int? wait;

  @override
  _DebounceStateState createState() => _DebounceStateState();
}

class _DebounceStateState extends HookState<ValueNotifier, _DebounceState> {
  // Timer? _timer;
  late ValueNotifier<dynamic> _value;

  @override
  void initHook() {
    super.initHook();
    // if (_timer is Timer) {
    //   _timer!.cancel();
    //   _timer = null;
    // }
    // _timer = Timer(Duration(milliseconds: hook.wait!), () {});
    _value = useState(hook.value);
  }

  @override
  ValueNotifier build(BuildContext context) {
    print('hook.value ${_value.value}');
    return _value;
  }

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }
}
