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
            // ignore: avoid_dynamic_calls
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
      title: 'HooksUseDebounceStateDemo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HooksUseDebounceStateDemo'),
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

void main() {
  runApp(_HooksUseEmitterDemo());
  // runApp(_HooksUseDebounceStateDemo());
  // runApp(_HooksUseFutureStateDemo());
}
