import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks_extra/flutter_hooks_extra.dart';

Future _queryUserInfo(dynamic params) async {
  await Future.delayed(
    const Duration(milliseconds: 1000),
    () => '',
  );
  return {'name': 'Tom', 'id': '$params'};
}

/// useFutureState
class _HooksUseFutureStateDemo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _queryUserInfoFuture = useFutureState(
      _queryUserInfo,
      options: FutureHookOptions(
        defaultParams: 1,
        loadingDelay: 3000,
      ),
    );
    return MaterialApp(
      title: 'HooksUseFutureStateDemo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HooksUseFutureStateDemo'),
        ),
        body: Column(children: [
          if (_queryUserInfoFuture.loading) ...[
            const Text('loading')
          ] else ...[
            Text('${_queryUserInfoFuture.data}'),
            Column(
              children: [
                TextButton(
                    onPressed: () {
                      _queryUserInfoFuture.run(2);
                    },
                    child: const Text('user id: 2'))
              ],
            ),
          ]
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _queryUserInfoFuture.refresh(),
          child: const Text('refresh'),
        ),
      ),
    );
  }
}

/// useDebounceState
class _HooksUseDebounceStateDemo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _debouncedValue = useDebounceState(0);
    return MaterialApp(
      title: 'HooksUseDebounceStateDemo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HooksUseDebounceStateDemo'),
        ),
        body: Column(children: [Text('${_debouncedValue.value}')]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _debouncedValue.value++;
          },
          child: const Text('refresh'),
        ),
      ),
    );
  }
}

/// useEmitter
class _HooksUseEmitterDemo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _emitter = useEmitter('demo');
    final _num = useState(0);

    void _addNumHandler(step) {
      _num.value += step;
    }

    useEffect(() {
      // _emitter.on('addNum', _addNumHandler);
      _emitter.once('addNum', _addNumHandler);
      return () {
        _emitter.off('addNum');
      };
    }, []);
    return MaterialApp(
      title: 'HooksUseEmitterDemo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HooksUseEmitterDemo'),
        ),
        body: Column(children: [Text('${_num.value}')]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _emitter.emit('addNum', 2);
          },
          child: const Text('refresh'),
        ),
      ),
    );
  }
}

/// useCounter
class _HooksUseCounterDemo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _counter = useCounter(0, step: 2, max: 10);
    return MaterialApp(
      title: 'HooksUseCounterDemo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HooksUseCounterDemo'),
        ),
        body: Column(children: [
          Text('${_counter.current}'),
          TextButton(
            onPressed: _counter.reset,
            child: const Text('Reset'),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: _counter.inc,
          child: const Text('refresh'),
        ),
      ),
    );
  }
}

/// useCountdown
class _HooksUseCountDownDemo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _countdown = useCountdown(DateTime(2022, 6, 30), onEnd: () {
      print('timesup!');
    });
    return MaterialApp(
      title: 'HooksUseCountDownDemo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HooksUseCountDownDemo'),
        ),
        body: Column(children: [
          Text(
              '${_countdown.formattedResult.days} / ${_countdown.formattedResult.hours}:${_countdown.formattedResult.minutes}:${_countdown.formattedResult.seconds}'),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _countdown.setTarget(DateTime.now());
          },
          child: const Text('End'),
        ),
      ),
    );
  }
}

void main() {
  runApp(_HooksUseCountDownDemo());
  // runApp(_HooksUseCounterDemo());
  // runApp(_HooksUseEmitterDemo());
  // runApp(_HooksUseDebounceStateDemo());
  // runApp(_HooksUseFutureStateDemo());
}
