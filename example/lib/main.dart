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

void main() {
  runApp(_HooksUseFutureStateDemo());
}
