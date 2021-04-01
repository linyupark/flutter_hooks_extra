# flutter_hooks_extra

Some Flutter hooks base on [flutter_hooks](https://pub.dev/packages/flutter_hooks).

## useFutureState

Hook to manage asynchronous data

For the hooks for managing asynchronous data, the API is very close to the [useRequest of ahooks](https://ahooks.js.org/hooks/async), which achieves 70% of the functions, and will try to be fully transplanted in the future.

Example:

```dart

import 'package:flutter_hooks_extra/flutter_hooks_extra.dart';

Future<String> createOrderMessage(params) async {
  var order = await fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(
      Duration(seconds: 2),
      () => 'Large Latte',
    );

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final delayDataReq = useFutureState(createOrderMessage,
        options: FutureHookOptions(
            manual: true,
            onSuccess: (data, params) {
              print(data);
              print(params);
            }));

    useEffect(() {
      delayDataReq.run!();
      return;
    }, []);

```

---

More hooks will be added in the future...
