import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_clock_provider.g.dart';

@Riverpod(keepAlive: true)
class SessionClock extends _$SessionClock {
  Timer? _ticker;

  @override
  int build(DateTime startTime) {
    final elapsed =
        DateTime.now().difference(startTime).inSeconds.clamp(0, 86400 * 7);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      state++;
    });
    ref.onDispose(() => _ticker?.cancel());
    return elapsed;
  }
}
