// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloads_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DownloadsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadsEventCopyWith<$Res> {
  factory $DownloadsEventCopyWith(
          DownloadsEvent value, $Res Function(DownloadsEvent) then) =
      _$DownloadsEventCopyWithImpl<$Res, DownloadsEvent>;
}

/// @nodoc
class _$DownloadsEventCopyWithImpl<$Res, $Val extends DownloadsEvent>
    implements $DownloadsEventCopyWith<$Res> {
  _$DownloadsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DownloadsLoadQueueImplCopyWith<$Res> {
  factory _$$DownloadsLoadQueueImplCopyWith(_$DownloadsLoadQueueImpl value,
          $Res Function(_$DownloadsLoadQueueImpl) then) =
      __$$DownloadsLoadQueueImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DownloadsLoadQueueImplCopyWithImpl<$Res>
    extends _$DownloadsEventCopyWithImpl<$Res, _$DownloadsLoadQueueImpl>
    implements _$$DownloadsLoadQueueImplCopyWith<$Res> {
  __$$DownloadsLoadQueueImplCopyWithImpl(_$DownloadsLoadQueueImpl _value,
      $Res Function(_$DownloadsLoadQueueImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DownloadsLoadQueueImpl implements DownloadsLoadQueue {
  const _$DownloadsLoadQueueImpl();

  @override
  String toString() {
    return 'DownloadsEvent.loadQueue()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DownloadsLoadQueueImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) {
    return loadQueue();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) {
    return loadQueue?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) {
    if (loadQueue != null) {
      return loadQueue();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) {
    return loadQueue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) {
    return loadQueue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) {
    if (loadQueue != null) {
      return loadQueue(this);
    }
    return orElse();
  }
}

abstract class DownloadsLoadQueue implements DownloadsEvent {
  const factory DownloadsLoadQueue() = _$DownloadsLoadQueueImpl;
}

/// @nodoc
abstract class _$$DownloadsDownloadImplCopyWith<$Res> {
  factory _$$DownloadsDownloadImplCopyWith(_$DownloadsDownloadImpl value,
          $Res Function(_$DownloadsDownloadImpl) then) =
      __$$DownloadsDownloadImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Game game});
}

/// @nodoc
class __$$DownloadsDownloadImplCopyWithImpl<$Res>
    extends _$DownloadsEventCopyWithImpl<$Res, _$DownloadsDownloadImpl>
    implements _$$DownloadsDownloadImplCopyWith<$Res> {
  __$$DownloadsDownloadImplCopyWithImpl(_$DownloadsDownloadImpl _value,
      $Res Function(_$DownloadsDownloadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? game = null,
  }) {
    return _then(_$DownloadsDownloadImpl(
      null == game
          ? _value.game
          : game // ignore: cast_nullable_to_non_nullable
              as Game,
    ));
  }
}

/// @nodoc

class _$DownloadsDownloadImpl implements DownloadsDownload {
  const _$DownloadsDownloadImpl(this.game);

  @override
  final Game game;

  @override
  String toString() {
    return 'DownloadsEvent.download(game: $game)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsDownloadImpl &&
            (identical(other.game, game) || other.game == game));
  }

  @override
  int get hashCode => Object.hash(runtimeType, game);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsDownloadImplCopyWith<_$DownloadsDownloadImpl> get copyWith =>
      __$$DownloadsDownloadImplCopyWithImpl<_$DownloadsDownloadImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) {
    return download(game);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) {
    return download?.call(game);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) {
    if (download != null) {
      return download(game);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) {
    return download(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) {
    return download?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) {
    if (download != null) {
      return download(this);
    }
    return orElse();
  }
}

abstract class DownloadsDownload implements DownloadsEvent {
  const factory DownloadsDownload(final Game game) = _$DownloadsDownloadImpl;

  Game get game;
  @JsonKey(ignore: true)
  _$$DownloadsDownloadImplCopyWith<_$DownloadsDownloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DownloadsCancelImplCopyWith<$Res> {
  factory _$$DownloadsCancelImplCopyWith(_$DownloadsCancelImpl value,
          $Res Function(_$DownloadsCancelImpl) then) =
      __$$DownloadsCancelImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gameId});
}

/// @nodoc
class __$$DownloadsCancelImplCopyWithImpl<$Res>
    extends _$DownloadsEventCopyWithImpl<$Res, _$DownloadsCancelImpl>
    implements _$$DownloadsCancelImplCopyWith<$Res> {
  __$$DownloadsCancelImplCopyWithImpl(
      _$DownloadsCancelImpl _value, $Res Function(_$DownloadsCancelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
  }) {
    return _then(_$DownloadsCancelImpl(
      null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DownloadsCancelImpl implements DownloadsCancel {
  const _$DownloadsCancelImpl(this.gameId);

  @override
  final String gameId;

  @override
  String toString() {
    return 'DownloadsEvent.cancel(gameId: $gameId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsCancelImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsCancelImplCopyWith<_$DownloadsCancelImpl> get copyWith =>
      __$$DownloadsCancelImplCopyWithImpl<_$DownloadsCancelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) {
    return cancel(gameId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) {
    return cancel?.call(gameId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) {
    if (cancel != null) {
      return cancel(gameId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) {
    return cancel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) {
    return cancel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) {
    if (cancel != null) {
      return cancel(this);
    }
    return orElse();
  }
}

abstract class DownloadsCancel implements DownloadsEvent {
  const factory DownloadsCancel(final String gameId) = _$DownloadsCancelImpl;

  String get gameId;
  @JsonKey(ignore: true)
  _$$DownloadsCancelImplCopyWith<_$DownloadsCancelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DownloadsRetryImplCopyWith<$Res> {
  factory _$$DownloadsRetryImplCopyWith(_$DownloadsRetryImpl value,
          $Res Function(_$DownloadsRetryImpl) then) =
      __$$DownloadsRetryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gameId});
}

/// @nodoc
class __$$DownloadsRetryImplCopyWithImpl<$Res>
    extends _$DownloadsEventCopyWithImpl<$Res, _$DownloadsRetryImpl>
    implements _$$DownloadsRetryImplCopyWith<$Res> {
  __$$DownloadsRetryImplCopyWithImpl(
      _$DownloadsRetryImpl _value, $Res Function(_$DownloadsRetryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
  }) {
    return _then(_$DownloadsRetryImpl(
      null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DownloadsRetryImpl implements DownloadsRetry {
  const _$DownloadsRetryImpl(this.gameId);

  @override
  final String gameId;

  @override
  String toString() {
    return 'DownloadsEvent.retry(gameId: $gameId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsRetryImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsRetryImplCopyWith<_$DownloadsRetryImpl> get copyWith =>
      __$$DownloadsRetryImplCopyWithImpl<_$DownloadsRetryImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) {
    return retry(gameId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) {
    return retry?.call(gameId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) {
    if (retry != null) {
      return retry(gameId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) {
    return retry(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) {
    return retry?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) {
    if (retry != null) {
      return retry(this);
    }
    return orElse();
  }
}

abstract class DownloadsRetry implements DownloadsEvent {
  const factory DownloadsRetry(final String gameId) = _$DownloadsRetryImpl;

  String get gameId;
  @JsonKey(ignore: true)
  _$$DownloadsRetryImplCopyWith<_$DownloadsRetryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DownloadsRemoveImplCopyWith<$Res> {
  factory _$$DownloadsRemoveImplCopyWith(_$DownloadsRemoveImpl value,
          $Res Function(_$DownloadsRemoveImpl) then) =
      __$$DownloadsRemoveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gameId});
}

/// @nodoc
class __$$DownloadsRemoveImplCopyWithImpl<$Res>
    extends _$DownloadsEventCopyWithImpl<$Res, _$DownloadsRemoveImpl>
    implements _$$DownloadsRemoveImplCopyWith<$Res> {
  __$$DownloadsRemoveImplCopyWithImpl(
      _$DownloadsRemoveImpl _value, $Res Function(_$DownloadsRemoveImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
  }) {
    return _then(_$DownloadsRemoveImpl(
      null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DownloadsRemoveImpl implements DownloadsRemove {
  const _$DownloadsRemoveImpl(this.gameId);

  @override
  final String gameId;

  @override
  String toString() {
    return 'DownloadsEvent.remove(gameId: $gameId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsRemoveImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsRemoveImplCopyWith<_$DownloadsRemoveImpl> get copyWith =>
      __$$DownloadsRemoveImplCopyWithImpl<_$DownloadsRemoveImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) {
    return remove(gameId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) {
    return remove?.call(gameId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) {
    if (remove != null) {
      return remove(gameId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) {
    return remove(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) {
    return remove?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) {
    if (remove != null) {
      return remove(this);
    }
    return orElse();
  }
}

abstract class DownloadsRemove implements DownloadsEvent {
  const factory DownloadsRemove(final String gameId) = _$DownloadsRemoveImpl;

  String get gameId;
  @JsonKey(ignore: true)
  _$$DownloadsRemoveImplCopyWith<_$DownloadsRemoveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DownloadsPauseAllImplCopyWith<$Res> {
  factory _$$DownloadsPauseAllImplCopyWith(_$DownloadsPauseAllImpl value,
          $Res Function(_$DownloadsPauseAllImpl) then) =
      __$$DownloadsPauseAllImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DownloadsPauseAllImplCopyWithImpl<$Res>
    extends _$DownloadsEventCopyWithImpl<$Res, _$DownloadsPauseAllImpl>
    implements _$$DownloadsPauseAllImplCopyWith<$Res> {
  __$$DownloadsPauseAllImplCopyWithImpl(_$DownloadsPauseAllImpl _value,
      $Res Function(_$DownloadsPauseAllImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DownloadsPauseAllImpl implements DownloadsPauseAll {
  const _$DownloadsPauseAllImpl();

  @override
  String toString() {
    return 'DownloadsEvent.pauseAll()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DownloadsPauseAllImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) {
    return pauseAll();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) {
    return pauseAll?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) {
    if (pauseAll != null) {
      return pauseAll();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) {
    return pauseAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) {
    return pauseAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) {
    if (pauseAll != null) {
      return pauseAll(this);
    }
    return orElse();
  }
}

abstract class DownloadsPauseAll implements DownloadsEvent {
  const factory DownloadsPauseAll() = _$DownloadsPauseAllImpl;
}

/// @nodoc
abstract class _$$DownloadsResumeAllImplCopyWith<$Res> {
  factory _$$DownloadsResumeAllImplCopyWith(_$DownloadsResumeAllImpl value,
          $Res Function(_$DownloadsResumeAllImpl) then) =
      __$$DownloadsResumeAllImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DownloadsResumeAllImplCopyWithImpl<$Res>
    extends _$DownloadsEventCopyWithImpl<$Res, _$DownloadsResumeAllImpl>
    implements _$$DownloadsResumeAllImplCopyWith<$Res> {
  __$$DownloadsResumeAllImplCopyWithImpl(_$DownloadsResumeAllImpl _value,
      $Res Function(_$DownloadsResumeAllImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DownloadsResumeAllImpl implements DownloadsResumeAll {
  const _$DownloadsResumeAllImpl();

  @override
  String toString() {
    return 'DownloadsEvent.resumeAll()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DownloadsResumeAllImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadQueue,
    required TResult Function(Game game) download,
    required TResult Function(String gameId) cancel,
    required TResult Function(String gameId) retry,
    required TResult Function(String gameId) remove,
    required TResult Function() pauseAll,
    required TResult Function() resumeAll,
  }) {
    return resumeAll();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadQueue,
    TResult? Function(Game game)? download,
    TResult? Function(String gameId)? cancel,
    TResult? Function(String gameId)? retry,
    TResult? Function(String gameId)? remove,
    TResult? Function()? pauseAll,
    TResult? Function()? resumeAll,
  }) {
    return resumeAll?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadQueue,
    TResult Function(Game game)? download,
    TResult Function(String gameId)? cancel,
    TResult Function(String gameId)? retry,
    TResult Function(String gameId)? remove,
    TResult Function()? pauseAll,
    TResult Function()? resumeAll,
    required TResult orElse(),
  }) {
    if (resumeAll != null) {
      return resumeAll();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsLoadQueue value) loadQueue,
    required TResult Function(DownloadsDownload value) download,
    required TResult Function(DownloadsCancel value) cancel,
    required TResult Function(DownloadsRetry value) retry,
    required TResult Function(DownloadsRemove value) remove,
    required TResult Function(DownloadsPauseAll value) pauseAll,
    required TResult Function(DownloadsResumeAll value) resumeAll,
  }) {
    return resumeAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsLoadQueue value)? loadQueue,
    TResult? Function(DownloadsDownload value)? download,
    TResult? Function(DownloadsCancel value)? cancel,
    TResult? Function(DownloadsRetry value)? retry,
    TResult? Function(DownloadsRemove value)? remove,
    TResult? Function(DownloadsPauseAll value)? pauseAll,
    TResult? Function(DownloadsResumeAll value)? resumeAll,
  }) {
    return resumeAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsLoadQueue value)? loadQueue,
    TResult Function(DownloadsDownload value)? download,
    TResult Function(DownloadsCancel value)? cancel,
    TResult Function(DownloadsRetry value)? retry,
    TResult Function(DownloadsRemove value)? remove,
    TResult Function(DownloadsPauseAll value)? pauseAll,
    TResult Function(DownloadsResumeAll value)? resumeAll,
    required TResult orElse(),
  }) {
    if (resumeAll != null) {
      return resumeAll(this);
    }
    return orElse();
  }
}

abstract class DownloadsResumeAll implements DownloadsEvent {
  const factory DownloadsResumeAll() = _$DownloadsResumeAllImpl;
}
