part of 'hooks.dart';

/// Counter number controller
class CounterController {
  /// InitialValue number
  late num current;

  /// Value change step
  late num step;

  /// Value +
  late Function() inc;

  /// Value -
  late Function() dec;

  /// Reset value
  late Function() reset;
}

/// useCounter Hook
CounterController useCounter(
  num initialValue, {
  num? step,
  num? min,
  num? max,
}) {
  return use(
    _Counter(
      initialValue: initialValue,
      step: step ?? 1,
      min: min,
      max: max,
    ),
  );
}

class _Counter extends Hook<CounterController> {
  const _Counter({
    required this.initialValue,
    this.min,
    this.max,
    this.step,
  });

  final num initialValue;
  final num? min;
  final num? max;
  final num? step;

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends HookState<CounterController, _Counter> {
  late final CounterController result = CounterController();
  late num _initialValue;

  @override
  void didUpdateHook(_) {
    super.didUpdateHook(_);
    if (hook.initialValue != _.initialValue) {
      result.current = hook.initialValue;
      _initialValue = hook.initialValue;
    }
    if (hook.step != result.step) {
      result.step = hook.step ?? 1;
    }
  }

  @override
  void initHook() {
    super.initHook();
    result.current = hook.initialValue;
    _initialValue = hook.initialValue;
    result.step = hook.step ?? 1;
    result.inc = () {
      if (hook.max != null) {
        if (result.current + result.step > hook.max!) {
          return;
        }
      }
      result.current += result.step;
      setState(() {});
    };
    result.dec = () {
      if (hook.min != null) {
        if (result.current - result.step < hook.min!) {
          return;
        }
      }
      result.current -= result.step;
      setState(() {});
    };
    result.reset = () {
      if (result.current != _initialValue) {
        result.current = _initialValue;
        setState(() {});
      }
    };
  }

  @override
  CounterController build(BuildContext context) {
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
