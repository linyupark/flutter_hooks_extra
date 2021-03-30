part of 'hooks.dart';

/// 状态加手动执行函数
class FutureHookResult {
  /// 构建
  FutureHookResult({
    this.data,
    this.error,
    this.loading = false,
    this.run,
    this.params,
    this.refresh,
  });

  /// 返回数据
  dynamic? data;

  /// service 抛出的异常
  Error? error;

  /// service 是否正在执行
  bool? loading;

  /// 手动触发 service 执行，参数会传递给 service
  Function([dynamic params])? run;

  /// 当次执行的 service 的参数数组
  dynamic? params;

  /// 使用上一次的 params，重新执行 service
  Function<Future>()? refresh;
}

/// 所有的 Options 均是可选的。
class FutureHookOptions {
  /// 构建
  FutureHookOptions({
    this.manual = false,
    this.initialData,
    // this.refreshDeps = const [],
    this.onSuccess,
    this.onError,
    this.cacheKey,
    this.defaultParams,
    this.loadingDelay = 0,
    this.pollingInterval = 0,
    // this.pollingWhenHidden = true,
    // this.debounceInterval = 500,
  });

  /// 默认 false。 即在初始化时自动执行 service。
  /// 如果设置为 true，则需要手动调用 run 触发执行。
  bool? manual;

  /// 默认的 data
  dynamic? initialData;

  /// 在 manual = false 时，refreshDeps 变化，会触发 service 重新执行
  /// List<dynamic>? refreshDeps;
  /// future 成功 时触发，参数为 data 和 params
  Function(dynamic data, dynamic? params)? onSuccess;

  /// future 报错 时触发，参数为 data 和 params
  Function(dynamic error, dynamic? params)? onError;

  /// 请求唯一标识。如果设置了 cacheKey，我们会启用缓存机制
  /// 我们会缓存每次请求的 data , error , params , loading
  /// 在缓存机制下，同样的请求我们会先返回缓存中的数据，同时会在背后发送新的请求，待新数据返回后，重新触发数据更新
  String? cacheKey;

  /// 如果 manual=false ，自动执行 run 的时候，默认带上的参数
  dynamic? defaultParams;

  /// 设置显示 loading 的延迟时间，避免闪烁
  int? loadingDelay;

  /// 轮询间隔，单位为毫秒。设置后，将进入轮询模式，定时触发 run
  int? pollingInterval;

  /// 在页面隐藏时，是否继续轮询。默认为 true，即不会停止轮询
  /// 如果设置为 false , 在页面隐藏时会暂时停止轮询，页面重新显示时继续上次轮询
  /// bool? pollingWhenHidden;
  /// 防抖间隔, 单位为毫秒，设置后，请求进入防抖模式。
  /// int? debounceInterval;
}

/// use hook function
FutureHookResult useFutureState(
  Function future, {
  FutureHookOptions? options,
}) {
  return use(
    _FutureHook(
      future,
      options: FutureHookOptions(),
    ),
  );
}

class _FutureHook extends Hook<FutureHookResult> {
  /// init
  const _FutureHook(
    this.future, {
    this.options,
  });

  final Function future;
  final FutureHookOptions? options;

  @override
  _FutureHookState createState() => _FutureHookState();
}

class _FutureHookState extends HookState<FutureHookResult, _FutureHook> {
  /// 返回的结果
  final FutureHookResult _result = FutureHookResult();
  late final Map _cachedData;

  @override
  void initHook() {
    super.initHook();
    // 默认数据
    _result.data = hook.options?.initialData;
    // 执行函数
    _result.run = ([dynamic? params]) async {
      // 执行入参
      dynamic runParams = hook.options?.defaultParams;
      if (runParams is Map && params is Map) {
        // 合并手动入参
        runParams.addAll(params);
      }
      if (runParams is Map == false && params != null) {
        // 非map覆盖入参
        runParams = params;
      }

      // 避免并发执行
      if (_result.loading == true) {
        return;
      }

      // 默认数据
      if (hook.options?.cacheKey != null) {
        _result.data =
            _cachedData[hook.options!.cacheKey] ?? hook.options?.initialData;
      }

      setState(() {
        _result.loading = true;
      });

      try {
        final dynamic futureValue = await hook.future(runParams);
        _result.data = futureValue;
        // 缓存处理
        if (hook.options?.cacheKey != null) {
          _cachedData[hook.options!.cacheKey] = futureValue;
        }
        // 成功处理
        if (hook.options?.onSuccess != null) {
          hook.options!.onSuccess!(futureValue, runParams);
        }
        // 轮询
        if (hook.options!.pollingInterval! > 0) {
          await Future<void>.delayed(
            Duration(milliseconds: hook.options!.pollingInterval!),
          );
          _result.run!(runParams);
        }
        // print('useFutureState success: $futureValue');
        // print('useFutureState runParams: $runParams');
      } catch (err) {
        // 失败处理
        if (hook.options?.onError != null) {
          hook.options!.onError!(err, runParams);
          // print('useFutureState error: $err / $runParams');
        }
      } finally {
        // 延迟 loading 恢复
        await Future<void>.delayed(
          Duration(milliseconds: hook.options!.loadingDelay!),
        );
        setState(() {
          _result.loading = false;
        });
      }
    };
    // 非手动自动执行
    if (hook.options!.manual == false) {
      // print('auto run useFutureState');
      _result.run!();
    }
  }

  @override
  FutureHookResult build(BuildContext context) {
    return _result;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
