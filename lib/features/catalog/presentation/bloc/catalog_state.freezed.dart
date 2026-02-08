// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CatalogState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double progress, String message) loading,
    required TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)
        loaded,
    required TResult Function(Failure failure) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double progress, String message)? loading,
    TResult? Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double progress, String message)? loading,
    TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogInitial value) initial,
    required TResult Function(CatalogLoading value) loading,
    required TResult Function(CatalogLoaded value) loaded,
    required TResult Function(CatalogError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogInitial value)? initial,
    TResult? Function(CatalogLoading value)? loading,
    TResult? Function(CatalogLoaded value)? loaded,
    TResult? Function(CatalogError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogInitial value)? initial,
    TResult Function(CatalogLoading value)? loading,
    TResult Function(CatalogLoaded value)? loaded,
    TResult Function(CatalogError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogStateCopyWith<$Res> {
  factory $CatalogStateCopyWith(
          CatalogState value, $Res Function(CatalogState) then) =
      _$CatalogStateCopyWithImpl<$Res, CatalogState>;
}

/// @nodoc
class _$CatalogStateCopyWithImpl<$Res, $Val extends CatalogState>
    implements $CatalogStateCopyWith<$Res> {
  _$CatalogStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CatalogInitialImplCopyWith<$Res> {
  factory _$$CatalogInitialImplCopyWith(_$CatalogInitialImpl value,
          $Res Function(_$CatalogInitialImpl) then) =
      __$$CatalogInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CatalogInitialImplCopyWithImpl<$Res>
    extends _$CatalogStateCopyWithImpl<$Res, _$CatalogInitialImpl>
    implements _$$CatalogInitialImplCopyWith<$Res> {
  __$$CatalogInitialImplCopyWithImpl(
      _$CatalogInitialImpl _value, $Res Function(_$CatalogInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CatalogInitialImpl implements CatalogInitial {
  const _$CatalogInitialImpl();

  @override
  String toString() {
    return 'CatalogState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CatalogInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double progress, String message) loading,
    required TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double progress, String message)? loading,
    TResult? Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double progress, String message)? loading,
    TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
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
    required TResult Function(CatalogInitial value) initial,
    required TResult Function(CatalogLoading value) loading,
    required TResult Function(CatalogLoaded value) loaded,
    required TResult Function(CatalogError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogInitial value)? initial,
    TResult? Function(CatalogLoading value)? loading,
    TResult? Function(CatalogLoaded value)? loaded,
    TResult? Function(CatalogError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogInitial value)? initial,
    TResult Function(CatalogLoading value)? loading,
    TResult Function(CatalogLoaded value)? loaded,
    TResult Function(CatalogError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CatalogInitial implements CatalogState {
  const factory CatalogInitial() = _$CatalogInitialImpl;
}

/// @nodoc
abstract class _$$CatalogLoadingImplCopyWith<$Res> {
  factory _$$CatalogLoadingImplCopyWith(_$CatalogLoadingImpl value,
          $Res Function(_$CatalogLoadingImpl) then) =
      __$$CatalogLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double progress, String message});
}

/// @nodoc
class __$$CatalogLoadingImplCopyWithImpl<$Res>
    extends _$CatalogStateCopyWithImpl<$Res, _$CatalogLoadingImpl>
    implements _$$CatalogLoadingImplCopyWith<$Res> {
  __$$CatalogLoadingImplCopyWithImpl(
      _$CatalogLoadingImpl _value, $Res Function(_$CatalogLoadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? message = null,
  }) {
    return _then(_$CatalogLoadingImpl(
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CatalogLoadingImpl implements CatalogLoading {
  const _$CatalogLoadingImpl(
      {this.progress = 0.0, this.message = 'Loading...'});

  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'CatalogState.loading(progress: $progress, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogLoadingImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogLoadingImplCopyWith<_$CatalogLoadingImpl> get copyWith =>
      __$$CatalogLoadingImplCopyWithImpl<_$CatalogLoadingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double progress, String message) loading,
    required TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return loading(progress, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double progress, String message)? loading,
    TResult? Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return loading?.call(progress, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double progress, String message)? loading,
    TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(progress, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogInitial value) initial,
    required TResult Function(CatalogLoading value) loading,
    required TResult Function(CatalogLoaded value) loaded,
    required TResult Function(CatalogError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogInitial value)? initial,
    TResult? Function(CatalogLoading value)? loading,
    TResult? Function(CatalogLoaded value)? loaded,
    TResult? Function(CatalogError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogInitial value)? initial,
    TResult Function(CatalogLoading value)? loading,
    TResult Function(CatalogLoaded value)? loaded,
    TResult Function(CatalogError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CatalogLoading implements CatalogState {
  const factory CatalogLoading({final double progress, final String message}) =
      _$CatalogLoadingImpl;

  double get progress;
  String get message;
  @JsonKey(ignore: true)
  _$$CatalogLoadingImplCopyWith<_$CatalogLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CatalogLoadedImplCopyWith<$Res> {
  factory _$$CatalogLoadedImplCopyWith(
          _$CatalogLoadedImpl value, $Res Function(_$CatalogLoadedImpl) then) =
      __$$CatalogLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Game> games,
      List<Game> filteredGames,
      String searchQuery,
      SortType sortType,
      GameStatusFilter filter,
      Set<String> installedPackages,
      int freeSpaceMb});
}

/// @nodoc
class __$$CatalogLoadedImplCopyWithImpl<$Res>
    extends _$CatalogStateCopyWithImpl<$Res, _$CatalogLoadedImpl>
    implements _$$CatalogLoadedImplCopyWith<$Res> {
  __$$CatalogLoadedImplCopyWithImpl(
      _$CatalogLoadedImpl _value, $Res Function(_$CatalogLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? games = null,
    Object? filteredGames = null,
    Object? searchQuery = null,
    Object? sortType = null,
    Object? filter = null,
    Object? installedPackages = null,
    Object? freeSpaceMb = null,
  }) {
    return _then(_$CatalogLoadedImpl(
      games: null == games
          ? _value._games
          : games // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      filteredGames: null == filteredGames
          ? _value._filteredGames
          : filteredGames // ignore: cast_nullable_to_non_nullable
              as List<Game>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      sortType: null == sortType
          ? _value.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortType,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as GameStatusFilter,
      installedPackages: null == installedPackages
          ? _value._installedPackages
          : installedPackages // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      freeSpaceMb: null == freeSpaceMb
          ? _value.freeSpaceMb
          : freeSpaceMb // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CatalogLoadedImpl implements CatalogLoaded {
  const _$CatalogLoadedImpl(
      {required final List<Game> games,
      required final List<Game> filteredGames,
      required this.searchQuery,
      required this.sortType,
      required this.filter,
      required final Set<String> installedPackages,
      this.freeSpaceMb = 0})
      : _games = games,
        _filteredGames = filteredGames,
        _installedPackages = installedPackages;

  final List<Game> _games;
  @override
  List<Game> get games {
    if (_games is EqualUnmodifiableListView) return _games;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_games);
  }

  final List<Game> _filteredGames;
  @override
  List<Game> get filteredGames {
    if (_filteredGames is EqualUnmodifiableListView) return _filteredGames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredGames);
  }

  @override
  final String searchQuery;
  @override
  final SortType sortType;
  @override
  final GameStatusFilter filter;
  final Set<String> _installedPackages;
  @override
  Set<String> get installedPackages {
    if (_installedPackages is EqualUnmodifiableSetView)
      return _installedPackages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_installedPackages);
  }

  @override
  @JsonKey()
  final int freeSpaceMb;

  @override
  String toString() {
    return 'CatalogState.loaded(games: $games, filteredGames: $filteredGames, searchQuery: $searchQuery, sortType: $sortType, filter: $filter, installedPackages: $installedPackages, freeSpaceMb: $freeSpaceMb)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogLoadedImpl &&
            const DeepCollectionEquality().equals(other._games, _games) &&
            const DeepCollectionEquality()
                .equals(other._filteredGames, _filteredGames) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality()
                .equals(other._installedPackages, _installedPackages) &&
            (identical(other.freeSpaceMb, freeSpaceMb) ||
                other.freeSpaceMb == freeSpaceMb));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_games),
      const DeepCollectionEquality().hash(_filteredGames),
      searchQuery,
      sortType,
      filter,
      const DeepCollectionEquality().hash(_installedPackages),
      freeSpaceMb);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogLoadedImplCopyWith<_$CatalogLoadedImpl> get copyWith =>
      __$$CatalogLoadedImplCopyWithImpl<_$CatalogLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double progress, String message) loading,
    required TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return loaded(games, filteredGames, searchQuery, sortType, filter,
        installedPackages, freeSpaceMb);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double progress, String message)? loading,
    TResult? Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return loaded?.call(games, filteredGames, searchQuery, sortType, filter,
        installedPackages, freeSpaceMb);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double progress, String message)? loading,
    TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult Function(Failure failure)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(games, filteredGames, searchQuery, sortType, filter,
          installedPackages, freeSpaceMb);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogInitial value) initial,
    required TResult Function(CatalogLoading value) loading,
    required TResult Function(CatalogLoaded value) loaded,
    required TResult Function(CatalogError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogInitial value)? initial,
    TResult? Function(CatalogLoading value)? loading,
    TResult? Function(CatalogLoaded value)? loaded,
    TResult? Function(CatalogError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogInitial value)? initial,
    TResult Function(CatalogLoading value)? loading,
    TResult Function(CatalogLoaded value)? loaded,
    TResult Function(CatalogError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CatalogLoaded implements CatalogState {
  const factory CatalogLoaded(
      {required final List<Game> games,
      required final List<Game> filteredGames,
      required final String searchQuery,
      required final SortType sortType,
      required final GameStatusFilter filter,
      required final Set<String> installedPackages,
      final int freeSpaceMb}) = _$CatalogLoadedImpl;

  List<Game> get games;
  List<Game> get filteredGames;
  String get searchQuery;
  SortType get sortType;
  GameStatusFilter get filter;
  Set<String> get installedPackages;
  int get freeSpaceMb;
  @JsonKey(ignore: true)
  _$$CatalogLoadedImplCopyWith<_$CatalogLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CatalogErrorImplCopyWith<$Res> {
  factory _$$CatalogErrorImplCopyWith(
          _$CatalogErrorImpl value, $Res Function(_$CatalogErrorImpl) then) =
      __$$CatalogErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$CatalogErrorImplCopyWithImpl<$Res>
    extends _$CatalogStateCopyWithImpl<$Res, _$CatalogErrorImpl>
    implements _$$CatalogErrorImplCopyWith<$Res> {
  __$$CatalogErrorImplCopyWithImpl(
      _$CatalogErrorImpl _value, $Res Function(_$CatalogErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$CatalogErrorImpl(
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

class _$CatalogErrorImpl implements CatalogError {
  const _$CatalogErrorImpl(this.failure);

  @override
  final Failure failure;

  @override
  String toString() {
    return 'CatalogState.error(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogErrorImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogErrorImplCopyWith<_$CatalogErrorImpl> get copyWith =>
      __$$CatalogErrorImplCopyWithImpl<_$CatalogErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double progress, String message) loading,
    required TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)
        loaded,
    required TResult Function(Failure failure) error,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double progress, String message)? loading,
    TResult? Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
        loaded,
    TResult? Function(Failure failure)? error,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double progress, String message)? loading,
    TResult Function(
            List<Game> games,
            List<Game> filteredGames,
            String searchQuery,
            SortType sortType,
            GameStatusFilter filter,
            Set<String> installedPackages,
            int freeSpaceMb)?
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
    required TResult Function(CatalogInitial value) initial,
    required TResult Function(CatalogLoading value) loading,
    required TResult Function(CatalogLoaded value) loaded,
    required TResult Function(CatalogError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogInitial value)? initial,
    TResult? Function(CatalogLoading value)? loading,
    TResult? Function(CatalogLoaded value)? loaded,
    TResult? Function(CatalogError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogInitial value)? initial,
    TResult Function(CatalogLoading value)? loading,
    TResult Function(CatalogLoaded value)? loaded,
    TResult Function(CatalogError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CatalogError implements CatalogState {
  const factory CatalogError(final Failure failure) = _$CatalogErrorImpl;

  Failure get failure;
  @JsonKey(ignore: true)
  _$$CatalogErrorImplCopyWith<_$CatalogErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
