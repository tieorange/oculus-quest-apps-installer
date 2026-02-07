// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloads_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DownloadsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<DownloadTask> queue, DownloadTask? currentDownload)
        loaded,
    required TResult Function(Failure failure) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsInitial value) initial,
    required TResult Function(DownloadsLoading value) loading,
    required TResult Function(DownloadsLoaded value) loaded,
    required TResult Function(DownloadsError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsInitial value)? initial,
    TResult? Function(DownloadsLoading value)? loading,
    TResult? Function(DownloadsLoaded value)? loaded,
    TResult? Function(DownloadsError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsInitial value)? initial,
    TResult Function(DownloadsLoading value)? loading,
    TResult Function(DownloadsLoaded value)? loaded,
    TResult Function(DownloadsError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadsStateCopyWith<$Res> {
  factory $DownloadsStateCopyWith(
          DownloadsState value, $Res Function(DownloadsState) then) =
      _$DownloadsStateCopyWithImpl<$Res, DownloadsState>;
}

/// @nodoc
class _$DownloadsStateCopyWithImpl<$Res, $Val extends DownloadsState>
    implements $DownloadsStateCopyWith<$Res> {
  _$DownloadsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DownloadsInitialImplCopyWith<$Res> {
  factory _$$DownloadsInitialImplCopyWith(_$DownloadsInitialImpl value,
          $Res Function(_$DownloadsInitialImpl) then) =
      __$$DownloadsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DownloadsInitialImplCopyWithImpl<$Res>
    extends _$DownloadsStateCopyWithImpl<$Res, _$DownloadsInitialImpl>
    implements _$$DownloadsInitialImplCopyWith<$Res> {
  __$$DownloadsInitialImplCopyWithImpl(_$DownloadsInitialImpl _value,
      $Res Function(_$DownloadsInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DownloadsInitialImpl implements DownloadsInitial {
  const _$DownloadsInitialImpl();

  @override
  String toString() {
    return 'DownloadsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DownloadsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<DownloadTask> queue, DownloadTask? currentDownload)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsInitial value) initial,
    required TResult Function(DownloadsLoading value) loading,
    required TResult Function(DownloadsLoaded value) loaded,
    required TResult Function(DownloadsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsInitial value)? initial,
    TResult? Function(DownloadsLoading value)? loading,
    TResult? Function(DownloadsLoaded value)? loaded,
    TResult? Function(DownloadsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsInitial value)? initial,
    TResult Function(DownloadsLoading value)? loading,
    TResult Function(DownloadsLoaded value)? loaded,
    TResult Function(DownloadsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class DownloadsInitial implements DownloadsState {
  const factory DownloadsInitial() = _$DownloadsInitialImpl;
}

/// @nodoc
abstract class _$$DownloadsLoadingImplCopyWith<$Res> {
  factory _$$DownloadsLoadingImplCopyWith(_$DownloadsLoadingImpl value,
          $Res Function(_$DownloadsLoadingImpl) then) =
      __$$DownloadsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DownloadsLoadingImplCopyWithImpl<$Res>
    extends _$DownloadsStateCopyWithImpl<$Res, _$DownloadsLoadingImpl>
    implements _$$DownloadsLoadingImplCopyWith<$Res> {
  __$$DownloadsLoadingImplCopyWithImpl(_$DownloadsLoadingImpl _value,
      $Res Function(_$DownloadsLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DownloadsLoadingImpl implements DownloadsLoading {
  const _$DownloadsLoadingImpl();

  @override
  String toString() {
    return 'DownloadsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DownloadsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<DownloadTask> queue, DownloadTask? currentDownload)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsInitial value) initial,
    required TResult Function(DownloadsLoading value) loading,
    required TResult Function(DownloadsLoaded value) loaded,
    required TResult Function(DownloadsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsInitial value)? initial,
    TResult? Function(DownloadsLoading value)? loading,
    TResult? Function(DownloadsLoaded value)? loaded,
    TResult? Function(DownloadsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsInitial value)? initial,
    TResult Function(DownloadsLoading value)? loading,
    TResult Function(DownloadsLoaded value)? loaded,
    TResult Function(DownloadsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DownloadsLoading implements DownloadsState {
  const factory DownloadsLoading() = _$DownloadsLoadingImpl;
}

/// @nodoc
abstract class _$$DownloadsLoadedImplCopyWith<$Res> {
  factory _$$DownloadsLoadedImplCopyWith(_$DownloadsLoadedImpl value,
          $Res Function(_$DownloadsLoadedImpl) then) =
      __$$DownloadsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<DownloadTask> queue, DownloadTask? currentDownload});
}

/// @nodoc
class __$$DownloadsLoadedImplCopyWithImpl<$Res>
    extends _$DownloadsStateCopyWithImpl<$Res, _$DownloadsLoadedImpl>
    implements _$$DownloadsLoadedImplCopyWith<$Res> {
  __$$DownloadsLoadedImplCopyWithImpl(
      _$DownloadsLoadedImpl _value, $Res Function(_$DownloadsLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queue = null,
    Object? currentDownload = freezed,
  }) {
    return _then(_$DownloadsLoadedImpl(
      queue: null == queue
          ? _value._queue
          : queue // ignore: cast_nullable_to_non_nullable
              as List<DownloadTask>,
      currentDownload: freezed == currentDownload
          ? _value.currentDownload
          : currentDownload // ignore: cast_nullable_to_non_nullable
              as DownloadTask?,
    ));
  }
}

/// @nodoc

class _$DownloadsLoadedImpl implements DownloadsLoaded {
  const _$DownloadsLoadedImpl(
      {required final List<DownloadTask> queue, this.currentDownload})
      : _queue = queue;

  final List<DownloadTask> _queue;
  @override
  List<DownloadTask> get queue {
    if (_queue is EqualUnmodifiableListView) return _queue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queue);
  }

  @override
  final DownloadTask? currentDownload;

  @override
  String toString() {
    return 'DownloadsState.loaded(queue: $queue, currentDownload: $currentDownload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsLoadedImpl &&
            const DeepCollectionEquality().equals(other._queue, _queue) &&
            (identical(other.currentDownload, currentDownload) ||
                other.currentDownload == currentDownload));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_queue), currentDownload);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsLoadedImplCopyWith<_$DownloadsLoadedImpl> get copyWith =>
      __$$DownloadsLoadedImplCopyWithImpl<_$DownloadsLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<DownloadTask> queue, DownloadTask? currentDownload)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return loaded(queue, currentDownload);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return loaded?.call(queue, currentDownload);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(queue, currentDownload);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsInitial value) initial,
    required TResult Function(DownloadsLoading value) loading,
    required TResult Function(DownloadsLoaded value) loaded,
    required TResult Function(DownloadsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsInitial value)? initial,
    TResult? Function(DownloadsLoading value)? loading,
    TResult? Function(DownloadsLoaded value)? loaded,
    TResult? Function(DownloadsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsInitial value)? initial,
    TResult Function(DownloadsLoading value)? loading,
    TResult Function(DownloadsLoaded value)? loaded,
    TResult Function(DownloadsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class DownloadsLoaded implements DownloadsState {
  const factory DownloadsLoaded(
      {required final List<DownloadTask> queue,
      final DownloadTask? currentDownload}) = _$DownloadsLoadedImpl;

  List<DownloadTask> get queue;
  DownloadTask? get currentDownload;
  @JsonKey(ignore: true)
  _$$DownloadsLoadedImplCopyWith<_$DownloadsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DownloadsErrorImplCopyWith<$Res> {
  factory _$$DownloadsErrorImplCopyWith(_$DownloadsErrorImpl value,
          $Res Function(_$DownloadsErrorImpl) then) =
      __$$DownloadsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$DownloadsErrorImplCopyWithImpl<$Res>
    extends _$DownloadsStateCopyWithImpl<$Res, _$DownloadsErrorImpl>
    implements _$$DownloadsErrorImplCopyWith<$Res> {
  __$$DownloadsErrorImplCopyWithImpl(
      _$DownloadsErrorImpl _value, $Res Function(_$DownloadsErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$DownloadsErrorImpl(
      null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$DownloadsErrorImpl implements DownloadsError {
  const _$DownloadsErrorImpl(this.failure);

  @override
  final Failure failure;

  @override
  String toString() {
    return 'DownloadsState.error(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadsErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadsErrorImplCopyWith<_$DownloadsErrorImpl> get copyWith =>
      __$$DownloadsErrorImplCopyWithImpl<_$DownloadsErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<DownloadTask> queue, DownloadTask? currentDownload)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DownloadTask> queue, DownloadTask? currentDownload)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DownloadsInitial value) initial,
    required TResult Function(DownloadsLoading value) loading,
    required TResult Function(DownloadsLoaded value) loaded,
    required TResult Function(DownloadsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DownloadsInitial value)? initial,
    TResult? Function(DownloadsLoading value)? loading,
    TResult? Function(DownloadsLoaded value)? loaded,
    TResult? Function(DownloadsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DownloadsInitial value)? initial,
    TResult Function(DownloadsLoading value)? loading,
    TResult Function(DownloadsLoaded value)? loaded,
    TResult Function(DownloadsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DownloadsError implements DownloadsState {
  const factory DownloadsError(final Failure failure) = _$DownloadsErrorImpl;

  Failure get failure;
  @JsonKey(ignore: true)
  _$$DownloadsErrorImplCopyWith<_$DownloadsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
