// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CatalogEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() refresh,
    required TResult Function(String query) search,
    required TResult Function(GameStatusFilter filter) filterByStatus,
    required TResult Function(SortType sortType) sortBy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? refresh,
    TResult? Function(String query)? search,
    TResult? Function(GameStatusFilter filter)? filterByStatus,
    TResult? Function(SortType sortType)? sortBy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? refresh,
    TResult Function(String query)? search,
    TResult Function(GameStatusFilter filter)? filterByStatus,
    TResult Function(SortType sortType)? sortBy,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogLoad value) load,
    required TResult Function(CatalogRefresh value) refresh,
    required TResult Function(CatalogSearch value) search,
    required TResult Function(CatalogFilterByStatus value) filterByStatus,
    required TResult Function(CatalogSortBy value) sortBy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogLoad value)? load,
    TResult? Function(CatalogRefresh value)? refresh,
    TResult? Function(CatalogSearch value)? search,
    TResult? Function(CatalogFilterByStatus value)? filterByStatus,
    TResult? Function(CatalogSortBy value)? sortBy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogLoad value)? load,
    TResult Function(CatalogRefresh value)? refresh,
    TResult Function(CatalogSearch value)? search,
    TResult Function(CatalogFilterByStatus value)? filterByStatus,
    TResult Function(CatalogSortBy value)? sortBy,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogEventCopyWith<$Res> {
  factory $CatalogEventCopyWith(
          CatalogEvent value, $Res Function(CatalogEvent) then) =
      _$CatalogEventCopyWithImpl<$Res, CatalogEvent>;
}

/// @nodoc
class _$CatalogEventCopyWithImpl<$Res, $Val extends CatalogEvent>
    implements $CatalogEventCopyWith<$Res> {
  _$CatalogEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CatalogLoadImplCopyWith<$Res> {
  factory _$$CatalogLoadImplCopyWith(
          _$CatalogLoadImpl value, $Res Function(_$CatalogLoadImpl) then) =
      __$$CatalogLoadImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CatalogLoadImplCopyWithImpl<$Res>
    extends _$CatalogEventCopyWithImpl<$Res, _$CatalogLoadImpl>
    implements _$$CatalogLoadImplCopyWith<$Res> {
  __$$CatalogLoadImplCopyWithImpl(
      _$CatalogLoadImpl _value, $Res Function(_$CatalogLoadImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CatalogLoadImpl implements CatalogLoad {
  const _$CatalogLoadImpl();

  @override
  String toString() {
    return 'CatalogEvent.load()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CatalogLoadImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() refresh,
    required TResult Function(String query) search,
    required TResult Function(GameStatusFilter filter) filterByStatus,
    required TResult Function(SortType sortType) sortBy,
  }) {
    return load();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? refresh,
    TResult? Function(String query)? search,
    TResult? Function(GameStatusFilter filter)? filterByStatus,
    TResult? Function(SortType sortType)? sortBy,
  }) {
    return load?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? refresh,
    TResult Function(String query)? search,
    TResult Function(GameStatusFilter filter)? filterByStatus,
    TResult Function(SortType sortType)? sortBy,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogLoad value) load,
    required TResult Function(CatalogRefresh value) refresh,
    required TResult Function(CatalogSearch value) search,
    required TResult Function(CatalogFilterByStatus value) filterByStatus,
    required TResult Function(CatalogSortBy value) sortBy,
  }) {
    return load(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogLoad value)? load,
    TResult? Function(CatalogRefresh value)? refresh,
    TResult? Function(CatalogSearch value)? search,
    TResult? Function(CatalogFilterByStatus value)? filterByStatus,
    TResult? Function(CatalogSortBy value)? sortBy,
  }) {
    return load?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogLoad value)? load,
    TResult Function(CatalogRefresh value)? refresh,
    TResult Function(CatalogSearch value)? search,
    TResult Function(CatalogFilterByStatus value)? filterByStatus,
    TResult Function(CatalogSortBy value)? sortBy,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load(this);
    }
    return orElse();
  }
}

abstract class CatalogLoad implements CatalogEvent {
  const factory CatalogLoad() = _$CatalogLoadImpl;
}

/// @nodoc
abstract class _$$CatalogRefreshImplCopyWith<$Res> {
  factory _$$CatalogRefreshImplCopyWith(_$CatalogRefreshImpl value,
          $Res Function(_$CatalogRefreshImpl) then) =
      __$$CatalogRefreshImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CatalogRefreshImplCopyWithImpl<$Res>
    extends _$CatalogEventCopyWithImpl<$Res, _$CatalogRefreshImpl>
    implements _$$CatalogRefreshImplCopyWith<$Res> {
  __$$CatalogRefreshImplCopyWithImpl(
      _$CatalogRefreshImpl _value, $Res Function(_$CatalogRefreshImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CatalogRefreshImpl implements CatalogRefresh {
  const _$CatalogRefreshImpl();

  @override
  String toString() {
    return 'CatalogEvent.refresh()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CatalogRefreshImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() refresh,
    required TResult Function(String query) search,
    required TResult Function(GameStatusFilter filter) filterByStatus,
    required TResult Function(SortType sortType) sortBy,
  }) {
    return refresh();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? refresh,
    TResult? Function(String query)? search,
    TResult? Function(GameStatusFilter filter)? filterByStatus,
    TResult? Function(SortType sortType)? sortBy,
  }) {
    return refresh?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? refresh,
    TResult Function(String query)? search,
    TResult Function(GameStatusFilter filter)? filterByStatus,
    TResult Function(SortType sortType)? sortBy,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogLoad value) load,
    required TResult Function(CatalogRefresh value) refresh,
    required TResult Function(CatalogSearch value) search,
    required TResult Function(CatalogFilterByStatus value) filterByStatus,
    required TResult Function(CatalogSortBy value) sortBy,
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogLoad value)? load,
    TResult? Function(CatalogRefresh value)? refresh,
    TResult? Function(CatalogSearch value)? search,
    TResult? Function(CatalogFilterByStatus value)? filterByStatus,
    TResult? Function(CatalogSortBy value)? sortBy,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogLoad value)? load,
    TResult Function(CatalogRefresh value)? refresh,
    TResult Function(CatalogSearch value)? search,
    TResult Function(CatalogFilterByStatus value)? filterByStatus,
    TResult Function(CatalogSortBy value)? sortBy,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh(this);
    }
    return orElse();
  }
}

abstract class CatalogRefresh implements CatalogEvent {
  const factory CatalogRefresh() = _$CatalogRefreshImpl;
}

/// @nodoc
abstract class _$$CatalogSearchImplCopyWith<$Res> {
  factory _$$CatalogSearchImplCopyWith(
          _$CatalogSearchImpl value, $Res Function(_$CatalogSearchImpl) then) =
      __$$CatalogSearchImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$CatalogSearchImplCopyWithImpl<$Res>
    extends _$CatalogEventCopyWithImpl<$Res, _$CatalogSearchImpl>
    implements _$$CatalogSearchImplCopyWith<$Res> {
  __$$CatalogSearchImplCopyWithImpl(
      _$CatalogSearchImpl _value, $Res Function(_$CatalogSearchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
  }) {
    return _then(_$CatalogSearchImpl(
      null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CatalogSearchImpl implements CatalogSearch {
  const _$CatalogSearchImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'CatalogEvent.search(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogSearchImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogSearchImplCopyWith<_$CatalogSearchImpl> get copyWith =>
      __$$CatalogSearchImplCopyWithImpl<_$CatalogSearchImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() refresh,
    required TResult Function(String query) search,
    required TResult Function(GameStatusFilter filter) filterByStatus,
    required TResult Function(SortType sortType) sortBy,
  }) {
    return search(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? refresh,
    TResult? Function(String query)? search,
    TResult? Function(GameStatusFilter filter)? filterByStatus,
    TResult? Function(SortType sortType)? sortBy,
  }) {
    return search?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? refresh,
    TResult Function(String query)? search,
    TResult Function(GameStatusFilter filter)? filterByStatus,
    TResult Function(SortType sortType)? sortBy,
    required TResult orElse(),
  }) {
    if (search != null) {
      return search(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogLoad value) load,
    required TResult Function(CatalogRefresh value) refresh,
    required TResult Function(CatalogSearch value) search,
    required TResult Function(CatalogFilterByStatus value) filterByStatus,
    required TResult Function(CatalogSortBy value) sortBy,
  }) {
    return search(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogLoad value)? load,
    TResult? Function(CatalogRefresh value)? refresh,
    TResult? Function(CatalogSearch value)? search,
    TResult? Function(CatalogFilterByStatus value)? filterByStatus,
    TResult? Function(CatalogSortBy value)? sortBy,
  }) {
    return search?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogLoad value)? load,
    TResult Function(CatalogRefresh value)? refresh,
    TResult Function(CatalogSearch value)? search,
    TResult Function(CatalogFilterByStatus value)? filterByStatus,
    TResult Function(CatalogSortBy value)? sortBy,
    required TResult orElse(),
  }) {
    if (search != null) {
      return search(this);
    }
    return orElse();
  }
}

abstract class CatalogSearch implements CatalogEvent {
  const factory CatalogSearch(final String query) = _$CatalogSearchImpl;

  String get query;
  @JsonKey(ignore: true)
  _$$CatalogSearchImplCopyWith<_$CatalogSearchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CatalogFilterByStatusImplCopyWith<$Res> {
  factory _$$CatalogFilterByStatusImplCopyWith(
          _$CatalogFilterByStatusImpl value,
          $Res Function(_$CatalogFilterByStatusImpl) then) =
      __$$CatalogFilterByStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GameStatusFilter filter});
}

/// @nodoc
class __$$CatalogFilterByStatusImplCopyWithImpl<$Res>
    extends _$CatalogEventCopyWithImpl<$Res, _$CatalogFilterByStatusImpl>
    implements _$$CatalogFilterByStatusImplCopyWith<$Res> {
  __$$CatalogFilterByStatusImplCopyWithImpl(_$CatalogFilterByStatusImpl _value,
      $Res Function(_$CatalogFilterByStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
  }) {
    return _then(_$CatalogFilterByStatusImpl(
      null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as GameStatusFilter,
    ));
  }
}

/// @nodoc

class _$CatalogFilterByStatusImpl implements CatalogFilterByStatus {
  const _$CatalogFilterByStatusImpl(this.filter);

  @override
  final GameStatusFilter filter;

  @override
  String toString() {
    return 'CatalogEvent.filterByStatus(filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogFilterByStatusImpl &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogFilterByStatusImplCopyWith<_$CatalogFilterByStatusImpl>
      get copyWith => __$$CatalogFilterByStatusImplCopyWithImpl<
          _$CatalogFilterByStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() refresh,
    required TResult Function(String query) search,
    required TResult Function(GameStatusFilter filter) filterByStatus,
    required TResult Function(SortType sortType) sortBy,
  }) {
    return filterByStatus(filter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? refresh,
    TResult? Function(String query)? search,
    TResult? Function(GameStatusFilter filter)? filterByStatus,
    TResult? Function(SortType sortType)? sortBy,
  }) {
    return filterByStatus?.call(filter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? refresh,
    TResult Function(String query)? search,
    TResult Function(GameStatusFilter filter)? filterByStatus,
    TResult Function(SortType sortType)? sortBy,
    required TResult orElse(),
  }) {
    if (filterByStatus != null) {
      return filterByStatus(filter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogLoad value) load,
    required TResult Function(CatalogRefresh value) refresh,
    required TResult Function(CatalogSearch value) search,
    required TResult Function(CatalogFilterByStatus value) filterByStatus,
    required TResult Function(CatalogSortBy value) sortBy,
  }) {
    return filterByStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogLoad value)? load,
    TResult? Function(CatalogRefresh value)? refresh,
    TResult? Function(CatalogSearch value)? search,
    TResult? Function(CatalogFilterByStatus value)? filterByStatus,
    TResult? Function(CatalogSortBy value)? sortBy,
  }) {
    return filterByStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogLoad value)? load,
    TResult Function(CatalogRefresh value)? refresh,
    TResult Function(CatalogSearch value)? search,
    TResult Function(CatalogFilterByStatus value)? filterByStatus,
    TResult Function(CatalogSortBy value)? sortBy,
    required TResult orElse(),
  }) {
    if (filterByStatus != null) {
      return filterByStatus(this);
    }
    return orElse();
  }
}

abstract class CatalogFilterByStatus implements CatalogEvent {
  const factory CatalogFilterByStatus(final GameStatusFilter filter) =
      _$CatalogFilterByStatusImpl;

  GameStatusFilter get filter;
  @JsonKey(ignore: true)
  _$$CatalogFilterByStatusImplCopyWith<_$CatalogFilterByStatusImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CatalogSortByImplCopyWith<$Res> {
  factory _$$CatalogSortByImplCopyWith(
          _$CatalogSortByImpl value, $Res Function(_$CatalogSortByImpl) then) =
      __$$CatalogSortByImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SortType sortType});
}

/// @nodoc
class __$$CatalogSortByImplCopyWithImpl<$Res>
    extends _$CatalogEventCopyWithImpl<$Res, _$CatalogSortByImpl>
    implements _$$CatalogSortByImplCopyWith<$Res> {
  __$$CatalogSortByImplCopyWithImpl(
      _$CatalogSortByImpl _value, $Res Function(_$CatalogSortByImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortType = null,
  }) {
    return _then(_$CatalogSortByImpl(
      null == sortType
          ? _value.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortType,
    ));
  }
}

/// @nodoc

class _$CatalogSortByImpl implements CatalogSortBy {
  const _$CatalogSortByImpl(this.sortType);

  @override
  final SortType sortType;

  @override
  String toString() {
    return 'CatalogEvent.sortBy(sortType: $sortType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogSortByImpl &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sortType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogSortByImplCopyWith<_$CatalogSortByImpl> get copyWith =>
      __$$CatalogSortByImplCopyWithImpl<_$CatalogSortByImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() refresh,
    required TResult Function(String query) search,
    required TResult Function(GameStatusFilter filter) filterByStatus,
    required TResult Function(SortType sortType) sortBy,
  }) {
    return sortBy(sortType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? refresh,
    TResult? Function(String query)? search,
    TResult? Function(GameStatusFilter filter)? filterByStatus,
    TResult? Function(SortType sortType)? sortBy,
  }) {
    return sortBy?.call(sortType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? refresh,
    TResult Function(String query)? search,
    TResult Function(GameStatusFilter filter)? filterByStatus,
    TResult Function(SortType sortType)? sortBy,
    required TResult orElse(),
  }) {
    if (sortBy != null) {
      return sortBy(sortType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CatalogLoad value) load,
    required TResult Function(CatalogRefresh value) refresh,
    required TResult Function(CatalogSearch value) search,
    required TResult Function(CatalogFilterByStatus value) filterByStatus,
    required TResult Function(CatalogSortBy value) sortBy,
  }) {
    return sortBy(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CatalogLoad value)? load,
    TResult? Function(CatalogRefresh value)? refresh,
    TResult? Function(CatalogSearch value)? search,
    TResult? Function(CatalogFilterByStatus value)? filterByStatus,
    TResult? Function(CatalogSortBy value)? sortBy,
  }) {
    return sortBy?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CatalogLoad value)? load,
    TResult Function(CatalogRefresh value)? refresh,
    TResult Function(CatalogSearch value)? search,
    TResult Function(CatalogFilterByStatus value)? filterByStatus,
    TResult Function(CatalogSortBy value)? sortBy,
    required TResult orElse(),
  }) {
    if (sortBy != null) {
      return sortBy(this);
    }
    return orElse();
  }
}

abstract class CatalogSortBy implements CatalogEvent {
  const factory CatalogSortBy(final SortType sortType) = _$CatalogSortByImpl;

  SortType get sortType;
  @JsonKey(ignore: true)
  _$$CatalogSortByImplCopyWith<_$CatalogSortByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
