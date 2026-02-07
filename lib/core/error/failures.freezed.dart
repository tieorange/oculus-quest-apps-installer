// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Failure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(_$NetworkFailureImpl value,
          $Res Function(_$NetworkFailureImpl) then) =
      __$$NetworkFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
      _$NetworkFailureImpl _value, $Res Function(_$NetworkFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$NetworkFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NetworkFailureImpl extends NetworkFailure {
  const _$NetworkFailureImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure extends Failure {
  const factory NetworkFailure({required final String message}) =
      _$NetworkFailureImpl;
  const NetworkFailure._() : super._();

  String get message;
  @JsonKey(ignore: true)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
          _$ServerFailureImpl value, $Res Function(_$ServerFailureImpl) then) =
      __$$ServerFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int statusCode, String message});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
      _$ServerFailureImpl _value, $Res Function(_$ServerFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = null,
  }) {
    return _then(_$ServerFailureImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ServerFailureImpl extends ServerFailure {
  const _$ServerFailureImpl({required this.statusCode, required this.message})
      : super._();

  @override
  final int statusCode;
  @override
  final String message;

  @override
  String toString() {
    return 'Failure.server(statusCode: $statusCode, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return server(statusCode, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return server?.call(statusCode, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(statusCode, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class ServerFailure extends Failure {
  const factory ServerFailure(
      {required final int statusCode,
      required final String message}) = _$ServerFailureImpl;
  const ServerFailure._() : super._();

  int get statusCode;
  String get message;
  @JsonKey(ignore: true)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageFailureImplCopyWith<$Res> {
  factory _$$StorageFailureImplCopyWith(_$StorageFailureImpl value,
          $Res Function(_$StorageFailureImpl) then) =
      __$$StorageFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StorageFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$StorageFailureImpl>
    implements _$$StorageFailureImplCopyWith<$Res> {
  __$$StorageFailureImplCopyWithImpl(
      _$StorageFailureImpl _value, $Res Function(_$StorageFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$StorageFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StorageFailureImpl extends StorageFailure {
  const _$StorageFailureImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.storage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      __$$StorageFailureImplCopyWithImpl<_$StorageFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return storage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return storage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class StorageFailure extends Failure {
  const factory StorageFailure({required final String message}) =
      _$StorageFailureImpl;
  const StorageFailure._() : super._();

  String get message;
  @JsonKey(ignore: true)
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExtractionFailureImplCopyWith<$Res> {
  factory _$$ExtractionFailureImplCopyWith(_$ExtractionFailureImpl value,
          $Res Function(_$ExtractionFailureImpl) then) =
      __$$ExtractionFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ExtractionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ExtractionFailureImpl>
    implements _$$ExtractionFailureImplCopyWith<$Res> {
  __$$ExtractionFailureImplCopyWithImpl(_$ExtractionFailureImpl _value,
      $Res Function(_$ExtractionFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ExtractionFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExtractionFailureImpl extends ExtractionFailure {
  const _$ExtractionFailureImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.extraction(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractionFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractionFailureImplCopyWith<_$ExtractionFailureImpl> get copyWith =>
      __$$ExtractionFailureImplCopyWithImpl<_$ExtractionFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return extraction(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return extraction?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (extraction != null) {
      return extraction(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return extraction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return extraction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (extraction != null) {
      return extraction(this);
    }
    return orElse();
  }
}

abstract class ExtractionFailure extends Failure {
  const factory ExtractionFailure({required final String message}) =
      _$ExtractionFailureImpl;
  const ExtractionFailure._() : super._();

  String get message;
  @JsonKey(ignore: true)
  _$$ExtractionFailureImplCopyWith<_$ExtractionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InstallationFailureImplCopyWith<$Res> {
  factory _$$InstallationFailureImplCopyWith(_$InstallationFailureImpl value,
          $Res Function(_$InstallationFailureImpl) then) =
      __$$InstallationFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$InstallationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$InstallationFailureImpl>
    implements _$$InstallationFailureImplCopyWith<$Res> {
  __$$InstallationFailureImplCopyWithImpl(_$InstallationFailureImpl _value,
      $Res Function(_$InstallationFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$InstallationFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InstallationFailureImpl extends InstallationFailure {
  const _$InstallationFailureImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.installation(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallationFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallationFailureImplCopyWith<_$InstallationFailureImpl> get copyWith =>
      __$$InstallationFailureImplCopyWithImpl<_$InstallationFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return installation(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return installation?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (installation != null) {
      return installation(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return installation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return installation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (installation != null) {
      return installation(this);
    }
    return orElse();
  }
}

abstract class InstallationFailure extends Failure {
  const factory InstallationFailure({required final String message}) =
      _$InstallationFailureImpl;
  const InstallationFailure._() : super._();

  String get message;
  @JsonKey(ignore: true)
  _$$InstallationFailureImplCopyWith<_$InstallationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermissionFailureImplCopyWith<$Res> {
  factory _$$PermissionFailureImplCopyWith(_$PermissionFailureImpl value,
          $Res Function(_$PermissionFailureImpl) then) =
      __$$PermissionFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String permission});
}

/// @nodoc
class __$$PermissionFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$PermissionFailureImpl>
    implements _$$PermissionFailureImplCopyWith<$Res> {
  __$$PermissionFailureImplCopyWithImpl(_$PermissionFailureImpl _value,
      $Res Function(_$PermissionFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permission = null,
  }) {
    return _then(_$PermissionFailureImpl(
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PermissionFailureImpl extends PermissionFailure {
  const _$PermissionFailureImpl({required this.permission}) : super._();

  @override
  final String permission;

  @override
  String toString() {
    return 'Failure.permission(permission: $permission)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionFailureImpl &&
            (identical(other.permission, permission) ||
                other.permission == permission));
  }

  @override
  int get hashCode => Object.hash(runtimeType, permission);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      __$$PermissionFailureImplCopyWithImpl<_$PermissionFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return permission(this.permission);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return permission?.call(this.permission);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this.permission);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionFailure extends Failure {
  const factory PermissionFailure({required final String permission}) =
      _$PermissionFailureImpl;
  const PermissionFailure._() : super._();

  String get permission;
  @JsonKey(ignore: true)
  _$$PermissionFailureImplCopyWith<_$PermissionFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InsufficientSpaceFailureImplCopyWith<$Res> {
  factory _$$InsufficientSpaceFailureImplCopyWith(
          _$InsufficientSpaceFailureImpl value,
          $Res Function(_$InsufficientSpaceFailureImpl) then) =
      __$$InsufficientSpaceFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int requiredMb, int availableMb});
}

/// @nodoc
class __$$InsufficientSpaceFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$InsufficientSpaceFailureImpl>
    implements _$$InsufficientSpaceFailureImplCopyWith<$Res> {
  __$$InsufficientSpaceFailureImplCopyWithImpl(
      _$InsufficientSpaceFailureImpl _value,
      $Res Function(_$InsufficientSpaceFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requiredMb = null,
    Object? availableMb = null,
  }) {
    return _then(_$InsufficientSpaceFailureImpl(
      requiredMb: null == requiredMb
          ? _value.requiredMb
          : requiredMb // ignore: cast_nullable_to_non_nullable
              as int,
      availableMb: null == availableMb
          ? _value.availableMb
          : availableMb // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$InsufficientSpaceFailureImpl extends InsufficientSpaceFailure {
  const _$InsufficientSpaceFailureImpl(
      {required this.requiredMb, required this.availableMb})
      : super._();

  @override
  final int requiredMb;
  @override
  final int availableMb;

  @override
  String toString() {
    return 'Failure.insufficientSpace(requiredMb: $requiredMb, availableMb: $availableMb)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsufficientSpaceFailureImpl &&
            (identical(other.requiredMb, requiredMb) ||
                other.requiredMb == requiredMb) &&
            (identical(other.availableMb, availableMb) ||
                other.availableMb == availableMb));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requiredMb, availableMb);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsufficientSpaceFailureImplCopyWith<_$InsufficientSpaceFailureImpl>
      get copyWith => __$$InsufficientSpaceFailureImplCopyWithImpl<
          _$InsufficientSpaceFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return insufficientSpace(requiredMb, availableMb);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return insufficientSpace?.call(requiredMb, availableMb);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (insufficientSpace != null) {
      return insufficientSpace(requiredMb, availableMb);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return insufficientSpace(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return insufficientSpace?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (insufficientSpace != null) {
      return insufficientSpace(this);
    }
    return orElse();
  }
}

abstract class InsufficientSpaceFailure extends Failure {
  const factory InsufficientSpaceFailure(
      {required final int requiredMb,
      required final int availableMb}) = _$InsufficientSpaceFailureImpl;
  const InsufficientSpaceFailure._() : super._();

  int get requiredMb;
  int get availableMb;
  @JsonKey(ignore: true)
  _$$InsufficientSpaceFailureImplCopyWith<_$InsufficientSpaceFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CancelledFailureImplCopyWith<$Res> {
  factory _$$CancelledFailureImplCopyWith(_$CancelledFailureImpl value,
          $Res Function(_$CancelledFailureImpl) then) =
      __$$CancelledFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CancelledFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CancelledFailureImpl>
    implements _$$CancelledFailureImplCopyWith<$Res> {
  __$$CancelledFailureImplCopyWithImpl(_$CancelledFailureImpl _value,
      $Res Function(_$CancelledFailureImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CancelledFailureImpl extends CancelledFailure {
  const _$CancelledFailureImpl() : super._();

  @override
  String toString() {
    return 'Failure.cancelled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CancelledFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class CancelledFailure extends Failure {
  const factory CancelledFailure() = _$CancelledFailureImpl;
  const CancelledFailure._() : super._();
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(_$UnknownFailureImpl value,
          $Res Function(_$UnknownFailureImpl) then) =
      __$$UnknownFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
      _$UnknownFailureImpl _value, $Res Function(_$UnknownFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UnknownFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnknownFailureImpl extends UnknownFailure {
  const _$UnknownFailureImpl({required this.message}) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) network,
    required TResult Function(int statusCode, String message) server,
    required TResult Function(String message) storage,
    required TResult Function(String message) extraction,
    required TResult Function(String message) installation,
    required TResult Function(String permission) permission,
    required TResult Function(int requiredMb, int availableMb)
        insufficientSpace,
    required TResult Function() cancelled,
    required TResult Function(String message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? network,
    TResult? Function(int statusCode, String message)? server,
    TResult? Function(String message)? storage,
    TResult? Function(String message)? extraction,
    TResult? Function(String message)? installation,
    TResult? Function(String permission)? permission,
    TResult? Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult? Function()? cancelled,
    TResult? Function(String message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? network,
    TResult Function(int statusCode, String message)? server,
    TResult Function(String message)? storage,
    TResult Function(String message)? extraction,
    TResult Function(String message)? installation,
    TResult Function(String permission)? permission,
    TResult Function(int requiredMb, int availableMb)? insufficientSpace,
    TResult Function()? cancelled,
    TResult Function(String message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ServerFailure value) server,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(ExtractionFailure value) extraction,
    required TResult Function(InstallationFailure value) installation,
    required TResult Function(PermissionFailure value) permission,
    required TResult Function(InsufficientSpaceFailure value) insufficientSpace,
    required TResult Function(CancelledFailure value) cancelled,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ServerFailure value)? server,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(ExtractionFailure value)? extraction,
    TResult? Function(InstallationFailure value)? installation,
    TResult? Function(PermissionFailure value)? permission,
    TResult? Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult? Function(CancelledFailure value)? cancelled,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(ServerFailure value)? server,
    TResult Function(StorageFailure value)? storage,
    TResult Function(ExtractionFailure value)? extraction,
    TResult Function(InstallationFailure value)? installation,
    TResult Function(PermissionFailure value)? permission,
    TResult Function(InsufficientSpaceFailure value)? insufficientSpace,
    TResult Function(CancelledFailure value)? cancelled,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure extends Failure {
  const factory UnknownFailure({required final String message}) =
      _$UnknownFailureImpl;
  const UnknownFailure._() : super._();

  String get message;
  @JsonKey(ignore: true)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
