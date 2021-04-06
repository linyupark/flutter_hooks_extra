part of 'hooks.dart';

/// Counter number controller
class CounterController {
  /// Instance
  CounterController({
    required this.current,
    required this.step,
  });

  /// InitialValue number
  num current;

  /// Value change step
  final num step;

  /// Value +
  late final Function() inc;

  /// Value -
  late final Function() dec;

  /// Reset value
  late final Function() reset;
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
  late final CounterController result;

  @override
  void initHook() {
    super.initHook();
    result =
        CounterController(current: hook.initialValue, step: hook.step ?? 1);
    final _current = result.current;
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
      if (result.current != _current) {
        result.current = _current;
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
