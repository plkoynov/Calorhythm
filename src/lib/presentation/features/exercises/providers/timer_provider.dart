import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_provider.g.dart';

enum TimerStatus { idle, running, paused, stopped }

class TimerState {
  const TimerState({
    this.elapsedSeconds = 0,
    this.status = TimerStatus.idle,
  });

  final int elapsedSeconds;
  final TimerStatus status;

  TimerState copyWith({int? elapsedSeconds, TimerStatus? status}) => TimerState(
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        status: status ?? this.status,
      );
}

@riverpod
class ExerciseTimer extends _$ExerciseTimer {
  Timer? _ticker;

  @override
  TimerState build() {
    ref.onDispose(() => _ticker?.cancel());
    return const TimerState();
  }

  void start() {
    if (state.status == TimerStatus.running) return;
    state = state.copyWith(status: TimerStatus.running);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  void pause() {
    if (state.status != TimerStatus.running) return;
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resume() {
    if (state.status != TimerStatus.paused) return;
    state = state.copyWith(status: TimerStatus.running);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  void stop() {
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.stopped);
  }

  void reset() {
    _ticker?.cancel();
    state = const TimerState();
  }
}
