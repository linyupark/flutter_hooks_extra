part of 'hooks.dart';

///
class FormattedRes {
  /// Days
  late final int days;

  /// Hours
  late final int hours;

  /// Minutes
  late final int minutes;

  /// Seconds
  late final int seconds;

  /// Milliseconds
  late final int milliseconds;
}

///
class CountdownResult {
  /// Timestamp to targetDate (milliseconds)
  late int countdown;

  /// Set targetDate
  late final void Function(DateTime target) setTarget;

  /// Format return time
  late final FormattedRes formattedResult;
}

///
CountdownResult useCountdown(DateTime targetDate,
    {int? interval, Function()? onEnd}) {
  return use(_Countdown(
    targetDate: targetDate,
    interval: interval ?? 1000,
    onEnd: onEnd,
  ));
}

class _Countdown extends Hook<CountdownResult> {
  const _Countdown({
    required this.targetDate,
    required this.interval,
    this.onEnd,
  });

  final DateTime targetDate;
  final int interval;
  final void Function()? onEnd;

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends HookState<CountdownResult, _Countdown> {
  late Timer _countTimer;
  DateTime? _targetDate;

  CountdownResult _counter() {
    final now = DateTime.now();
    final result = CountdownResult();
    final formattedRes = FormattedRes();
    final targetDate = _targetDate ?? hook.targetDate;

    result.setTarget = (target) {
      setState(() {
        _targetDate = target;
      });
    };

    final _onEnd = hook.onEnd ?? () {};

    var remaining =
        targetDate.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

    if (remaining <= 0) {
      remaining = 0;
      _onEnd.call();
      _countTimer.cancel();
    }

    final remainingms = Duration(milliseconds: remaining);
    result.countdown = remaining;
    formattedRes.days = remainingms.inDays;
    formattedRes.hours = remainingms.inHours - remainingms.inDays * 24;
    formattedRes.minutes = remainingms.inMinutes - remainingms.inHours * 60;
    formattedRes.seconds = remainingms.inSeconds - remainingms.inMinutes * 60;
    formattedRes.milliseconds =
        remainingms.inMilliseconds - remainingms.inSeconds * 1000;
    result.formattedResult = formattedRes;

    return result;
  }

  @override
  void initHook() {
    super.initHook();

    _countTimer = Timer.periodic(Duration(milliseconds: hook.interval), (_) {
      setState(() {});
    });
  }

  @override
  CountdownResult build(BuildContext context) {
    return _counter();
  }

  @override
  void dispose() {
    _countTimer.cancel();
    super.dispose();
  }
}
