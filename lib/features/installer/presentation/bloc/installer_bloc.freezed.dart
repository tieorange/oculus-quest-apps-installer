// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'installer_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InstallerEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Game game, String extractedDir) install,
    required TResult Function() refreshInstalled,
    required TResult Function(String packageName) uninstall,
    required TResult Function(String packageName) launch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Game game, String extractedDir)? install,
    TResult? Function()? refreshInstalled,
    TResult? Function(String packageName)? uninstall,
    TResult? Function(String packageName)? launch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Game game, String extractedDir)? install,
    TResult Function()? refreshInstalled,
    TResult Function(String packageName)? uninstall,
    TResult Function(String packageName)? launch,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerInstall value) install,
    required TResult Function(InstallerRefreshInstalled value) refreshInstalled,
    required TResult Function(InstallerUninstall value) uninstall,
    required TResult Function(InstallerLaunch value) launch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerInstall value)? install,
    TResult? Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult? Function(InstallerUninstall value)? uninstall,
    TResult? Function(InstallerLaunch value)? launch,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerInstall value)? install,
    TResult Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult Function(InstallerUninstall value)? uninstall,
    TResult Function(InstallerLaunch value)? launch,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstallerEventCopyWith<$Res> {
  factory $InstallerEventCopyWith(
          InstallerEvent value, $Res Function(InstallerEvent) then) =
      _$InstallerEventCopyWithImpl<$Res, InstallerEvent>;
}

/// @nodoc
class _$InstallerEventCopyWithImpl<$Res, $Val extends InstallerEvent>
    implements $InstallerEventCopyWith<$Res> {
  _$InstallerEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InstallerInstallImplCopyWith<$Res> {
  factory _$$InstallerInstallImplCopyWith(_$InstallerInstallImpl value,
          $Res Function(_$InstallerInstallImpl) then) =
      __$$InstallerInstallImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Game game, String extractedDir});
}

/// @nodoc
class __$$InstallerInstallImplCopyWithImpl<$Res>
    extends _$InstallerEventCopyWithImpl<$Res, _$InstallerInstallImpl>
    implements _$$InstallerInstallImplCopyWith<$Res> {
  __$$InstallerInstallImplCopyWithImpl(_$InstallerInstallImpl _value,
      $Res Function(_$InstallerInstallImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? game = null,
    Object? extractedDir = null,
  }) {
    return _then(_$InstallerInstallImpl(
      game: null == game
          ? _value.game
          : game // ignore: cast_nullable_to_non_nullable
              as Game,
      extractedDir: null == extractedDir
          ? _value.extractedDir
          : extractedDir // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InstallerInstallImpl implements InstallerInstall {
  const _$InstallerInstallImpl(
      {required this.game, required this.extractedDir});

  @override
  final Game game;
  @override
  final String extractedDir;

  @override
  String toString() {
    return 'InstallerEvent.install(game: $game, extractedDir: $extractedDir)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerInstallImpl &&
            (identical(other.game, game) || other.game == game) &&
            (identical(other.extractedDir, extractedDir) ||
                other.extractedDir == extractedDir));
  }

  @override
  int get hashCode => Object.hash(runtimeType, game, extractedDir);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallerInstallImplCopyWith<_$InstallerInstallImpl> get copyWith =>
      __$$InstallerInstallImplCopyWithImpl<_$InstallerInstallImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Game game, String extractedDir) install,
    required TResult Function() refreshInstalled,
    required TResult Function(String packageName) uninstall,
    required TResult Function(String packageName) launch,
  }) {
    return install(game, extractedDir);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Game game, String extractedDir)? install,
    TResult? Function()? refreshInstalled,
    TResult? Function(String packageName)? uninstall,
    TResult? Function(String packageName)? launch,
  }) {
    return install?.call(game, extractedDir);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Game game, String extractedDir)? install,
    TResult Function()? refreshInstalled,
    TResult Function(String packageName)? uninstall,
    TResult Function(String packageName)? launch,
    required TResult orElse(),
  }) {
    if (install != null) {
      return install(game, extractedDir);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerInstall value) install,
    required TResult Function(InstallerRefreshInstalled value) refreshInstalled,
    required TResult Function(InstallerUninstall value) uninstall,
    required TResult Function(InstallerLaunch value) launch,
  }) {
    return install(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerInstall value)? install,
    TResult? Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult? Function(InstallerUninstall value)? uninstall,
    TResult? Function(InstallerLaunch value)? launch,
  }) {
    return install?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerInstall value)? install,
    TResult Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult Function(InstallerUninstall value)? uninstall,
    TResult Function(InstallerLaunch value)? launch,
    required TResult orElse(),
  }) {
    if (install != null) {
      return install(this);
    }
    return orElse();
  }
}

abstract class InstallerInstall implements InstallerEvent {
  const factory InstallerInstall(
      {required final Game game,
      required final String extractedDir}) = _$InstallerInstallImpl;

  Game get game;
  String get extractedDir;
  @JsonKey(ignore: true)
  _$$InstallerInstallImplCopyWith<_$InstallerInstallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InstallerRefreshInstalledImplCopyWith<$Res> {
  factory _$$InstallerRefreshInstalledImplCopyWith(
          _$InstallerRefreshInstalledImpl value,
          $Res Function(_$InstallerRefreshInstalledImpl) then) =
      __$$InstallerRefreshInstalledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InstallerRefreshInstalledImplCopyWithImpl<$Res>
    extends _$InstallerEventCopyWithImpl<$Res, _$InstallerRefreshInstalledImpl>
    implements _$$InstallerRefreshInstalledImplCopyWith<$Res> {
  __$$InstallerRefreshInstalledImplCopyWithImpl(
      _$InstallerRefreshInstalledImpl _value,
      $Res Function(_$InstallerRefreshInstalledImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InstallerRefreshInstalledImpl implements InstallerRefreshInstalled {
  const _$InstallerRefreshInstalledImpl();

  @override
  String toString() {
    return 'InstallerEvent.refreshInstalled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerRefreshInstalledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Game game, String extractedDir) install,
    required TResult Function() refreshInstalled,
    required TResult Function(String packageName) uninstall,
    required TResult Function(String packageName) launch,
  }) {
    return refreshInstalled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Game game, String extractedDir)? install,
    TResult? Function()? refreshInstalled,
    TResult? Function(String packageName)? uninstall,
    TResult? Function(String packageName)? launch,
  }) {
    return refreshInstalled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Game game, String extractedDir)? install,
    TResult Function()? refreshInstalled,
    TResult Function(String packageName)? uninstall,
    TResult Function(String packageName)? launch,
    required TResult orElse(),
  }) {
    if (refreshInstalled != null) {
      return refreshInstalled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerInstall value) install,
    required TResult Function(InstallerRefreshInstalled value) refreshInstalled,
    required TResult Function(InstallerUninstall value) uninstall,
    required TResult Function(InstallerLaunch value) launch,
  }) {
    return refreshInstalled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerInstall value)? install,
    TResult? Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult? Function(InstallerUninstall value)? uninstall,
    TResult? Function(InstallerLaunch value)? launch,
  }) {
    return refreshInstalled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerInstall value)? install,
    TResult Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult Function(InstallerUninstall value)? uninstall,
    TResult Function(InstallerLaunch value)? launch,
    required TResult orElse(),
  }) {
    if (refreshInstalled != null) {
      return refreshInstalled(this);
    }
    return orElse();
  }
}

abstract class InstallerRefreshInstalled implements InstallerEvent {
  const factory InstallerRefreshInstalled() = _$InstallerRefreshInstalledImpl;
}

/// @nodoc
abstract class _$$InstallerUninstallImplCopyWith<$Res> {
  factory _$$InstallerUninstallImplCopyWith(_$InstallerUninstallImpl value,
          $Res Function(_$InstallerUninstallImpl) then) =
      __$$InstallerUninstallImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String packageName});
}

/// @nodoc
class __$$InstallerUninstallImplCopyWithImpl<$Res>
    extends _$InstallerEventCopyWithImpl<$Res, _$InstallerUninstallImpl>
    implements _$$InstallerUninstallImplCopyWith<$Res> {
  __$$InstallerUninstallImplCopyWithImpl(_$InstallerUninstallImpl _value,
      $Res Function(_$InstallerUninstallImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
  }) {
    return _then(_$InstallerUninstallImpl(
      null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InstallerUninstallImpl implements InstallerUninstall {
  const _$InstallerUninstallImpl(this.packageName);

  @override
  final String packageName;

  @override
  String toString() {
    return 'InstallerEvent.uninstall(packageName: $packageName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerUninstallImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallerUninstallImplCopyWith<_$InstallerUninstallImpl> get copyWith =>
      __$$InstallerUninstallImplCopyWithImpl<_$InstallerUninstallImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Game game, String extractedDir) install,
    required TResult Function() refreshInstalled,
    required TResult Function(String packageName) uninstall,
    required TResult Function(String packageName) launch,
  }) {
    return uninstall(packageName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Game game, String extractedDir)? install,
    TResult? Function()? refreshInstalled,
    TResult? Function(String packageName)? uninstall,
    TResult? Function(String packageName)? launch,
  }) {
    return uninstall?.call(packageName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Game game, String extractedDir)? install,
    TResult Function()? refreshInstalled,
    TResult Function(String packageName)? uninstall,
    TResult Function(String packageName)? launch,
    required TResult orElse(),
  }) {
    if (uninstall != null) {
      return uninstall(packageName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerInstall value) install,
    required TResult Function(InstallerRefreshInstalled value) refreshInstalled,
    required TResult Function(InstallerUninstall value) uninstall,
    required TResult Function(InstallerLaunch value) launch,
  }) {
    return uninstall(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerInstall value)? install,
    TResult? Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult? Function(InstallerUninstall value)? uninstall,
    TResult? Function(InstallerLaunch value)? launch,
  }) {
    return uninstall?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerInstall value)? install,
    TResult Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult Function(InstallerUninstall value)? uninstall,
    TResult Function(InstallerLaunch value)? launch,
    required TResult orElse(),
  }) {
    if (uninstall != null) {
      return uninstall(this);
    }
    return orElse();
  }
}

abstract class InstallerUninstall implements InstallerEvent {
  const factory InstallerUninstall(final String packageName) =
      _$InstallerUninstallImpl;

  String get packageName;
  @JsonKey(ignore: true)
  _$$InstallerUninstallImplCopyWith<_$InstallerUninstallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InstallerLaunchImplCopyWith<$Res> {
  factory _$$InstallerLaunchImplCopyWith(_$InstallerLaunchImpl value,
          $Res Function(_$InstallerLaunchImpl) then) =
      __$$InstallerLaunchImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String packageName});
}

/// @nodoc
class __$$InstallerLaunchImplCopyWithImpl<$Res>
    extends _$InstallerEventCopyWithImpl<$Res, _$InstallerLaunchImpl>
    implements _$$InstallerLaunchImplCopyWith<$Res> {
  __$$InstallerLaunchImplCopyWithImpl(
      _$InstallerLaunchImpl _value, $Res Function(_$InstallerLaunchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
  }) {
    return _then(_$InstallerLaunchImpl(
      null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InstallerLaunchImpl implements InstallerLaunch {
  const _$InstallerLaunchImpl(this.packageName);

  @override
  final String packageName;

  @override
  String toString() {
    return 'InstallerEvent.launch(packageName: $packageName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerLaunchImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, packageName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallerLaunchImplCopyWith<_$InstallerLaunchImpl> get copyWith =>
      __$$InstallerLaunchImplCopyWithImpl<_$InstallerLaunchImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Game game, String extractedDir) install,
    required TResult Function() refreshInstalled,
    required TResult Function(String packageName) uninstall,
    required TResult Function(String packageName) launch,
  }) {
    return launch(packageName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Game game, String extractedDir)? install,
    TResult? Function()? refreshInstalled,
    TResult? Function(String packageName)? uninstall,
    TResult? Function(String packageName)? launch,
  }) {
    return launch?.call(packageName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Game game, String extractedDir)? install,
    TResult Function()? refreshInstalled,
    TResult Function(String packageName)? uninstall,
    TResult Function(String packageName)? launch,
    required TResult orElse(),
  }) {
    if (launch != null) {
      return launch(packageName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerInstall value) install,
    required TResult Function(InstallerRefreshInstalled value) refreshInstalled,
    required TResult Function(InstallerUninstall value) uninstall,
    required TResult Function(InstallerLaunch value) launch,
  }) {
    return launch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerInstall value)? install,
    TResult? Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult? Function(InstallerUninstall value)? uninstall,
    TResult? Function(InstallerLaunch value)? launch,
  }) {
    return launch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerInstall value)? install,
    TResult Function(InstallerRefreshInstalled value)? refreshInstalled,
    TResult Function(InstallerUninstall value)? uninstall,
    TResult Function(InstallerLaunch value)? launch,
    required TResult orElse(),
  }) {
    if (launch != null) {
      return launch(this);
    }
    return orElse();
  }
}

abstract class InstallerLaunch implements InstallerEvent {
  const factory InstallerLaunch(final String packageName) =
      _$InstallerLaunchImpl;

  String get packageName;
  @JsonKey(ignore: true)
  _$$InstallerLaunchImplCopyWith<_$InstallerLaunchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InstallerState {
  Set<String> get installedPackages => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Set<String> installedPackages) idle,
    required TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)
        installing,
    required TResult Function(String gameName, Set<String> installedPackages)
        success,
    required TResult Function(String message, Set<String> installedPackages)
        failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Set<String> installedPackages)? idle,
    TResult? Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult? Function(String gameName, Set<String> installedPackages)? success,
    TResult? Function(String message, Set<String> installedPackages)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Set<String> installedPackages)? idle,
    TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult Function(String gameName, Set<String> installedPackages)? success,
    TResult Function(String message, Set<String> installedPackages)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerIdle value) idle,
    required TResult Function(InstallerInstalling value) installing,
    required TResult Function(InstallerSuccess value) success,
    required TResult Function(InstallerFailed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerIdle value)? idle,
    TResult? Function(InstallerInstalling value)? installing,
    TResult? Function(InstallerSuccess value)? success,
    TResult? Function(InstallerFailed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerIdle value)? idle,
    TResult Function(InstallerInstalling value)? installing,
    TResult Function(InstallerSuccess value)? success,
    TResult Function(InstallerFailed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InstallerStateCopyWith<InstallerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstallerStateCopyWith<$Res> {
  factory $InstallerStateCopyWith(
          InstallerState value, $Res Function(InstallerState) then) =
      _$InstallerStateCopyWithImpl<$Res, InstallerState>;
  @useResult
  $Res call({Set<String> installedPackages});
}

/// @nodoc
class _$InstallerStateCopyWithImpl<$Res, $Val extends InstallerState>
    implements $InstallerStateCopyWith<$Res> {
  _$InstallerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? installedPackages = null,
  }) {
    return _then(_value.copyWith(
      installedPackages: null == installedPackages
          ? _value.installedPackages
          : installedPackages // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstallerIdleImplCopyWith<$Res>
    implements $InstallerStateCopyWith<$Res> {
  factory _$$InstallerIdleImplCopyWith(
          _$InstallerIdleImpl value, $Res Function(_$InstallerIdleImpl) then) =
      __$$InstallerIdleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<String> installedPackages});
}

/// @nodoc
class __$$InstallerIdleImplCopyWithImpl<$Res>
    extends _$InstallerStateCopyWithImpl<$Res, _$InstallerIdleImpl>
    implements _$$InstallerIdleImplCopyWith<$Res> {
  __$$InstallerIdleImplCopyWithImpl(
      _$InstallerIdleImpl _value, $Res Function(_$InstallerIdleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? installedPackages = null,
  }) {
    return _then(_$InstallerIdleImpl(
      installedPackages: null == installedPackages
          ? _value._installedPackages
          : installedPackages // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$InstallerIdleImpl implements InstallerIdle {
  const _$InstallerIdleImpl({final Set<String> installedPackages = const {}})
      : _installedPackages = installedPackages;

  final Set<String> _installedPackages;
  @override
  @JsonKey()
  Set<String> get installedPackages {
    if (_installedPackages is EqualUnmodifiableSetView)
      return _installedPackages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_installedPackages);
  }

  @override
  String toString() {
    return 'InstallerState.idle(installedPackages: $installedPackages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerIdleImpl &&
            const DeepCollectionEquality()
                .equals(other._installedPackages, _installedPackages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_installedPackages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallerIdleImplCopyWith<_$InstallerIdleImpl> get copyWith =>
      __$$InstallerIdleImplCopyWithImpl<_$InstallerIdleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Set<String> installedPackages) idle,
    required TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)
        installing,
    required TResult Function(String gameName, Set<String> installedPackages)
        success,
    required TResult Function(String message, Set<String> installedPackages)
        failed,
  }) {
    return idle(installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Set<String> installedPackages)? idle,
    TResult? Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult? Function(String gameName, Set<String> installedPackages)? success,
    TResult? Function(String message, Set<String> installedPackages)? failed,
  }) {
    return idle?.call(installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Set<String> installedPackages)? idle,
    TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult Function(String gameName, Set<String> installedPackages)? success,
    TResult Function(String message, Set<String> installedPackages)? failed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(installedPackages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerIdle value) idle,
    required TResult Function(InstallerInstalling value) installing,
    required TResult Function(InstallerSuccess value) success,
    required TResult Function(InstallerFailed value) failed,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerIdle value)? idle,
    TResult? Function(InstallerInstalling value)? installing,
    TResult? Function(InstallerSuccess value)? success,
    TResult? Function(InstallerFailed value)? failed,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerIdle value)? idle,
    TResult Function(InstallerInstalling value)? installing,
    TResult Function(InstallerSuccess value)? success,
    TResult Function(InstallerFailed value)? failed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class InstallerIdle implements InstallerState {
  const factory InstallerIdle({final Set<String> installedPackages}) =
      _$InstallerIdleImpl;

  @override
  Set<String> get installedPackages;
  @override
  @JsonKey(ignore: true)
  _$$InstallerIdleImplCopyWith<_$InstallerIdleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InstallerInstallingImplCopyWith<$Res>
    implements $InstallerStateCopyWith<$Res> {
  factory _$$InstallerInstallingImplCopyWith(_$InstallerInstallingImpl value,
          $Res Function(_$InstallerInstallingImpl) then) =
      __$$InstallerInstallingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gameName, InstallStage stage, Set<String> installedPackages});
}

/// @nodoc
class __$$InstallerInstallingImplCopyWithImpl<$Res>
    extends _$InstallerStateCopyWithImpl<$Res, _$InstallerInstallingImpl>
    implements _$$InstallerInstallingImplCopyWith<$Res> {
  __$$InstallerInstallingImplCopyWithImpl(_$InstallerInstallingImpl _value,
      $Res Function(_$InstallerInstallingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameName = null,
    Object? stage = null,
    Object? installedPackages = null,
  }) {
    return _then(_$InstallerInstallingImpl(
      gameName: null == gameName
          ? _value.gameName
          : gameName // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as InstallStage,
      installedPackages: null == installedPackages
          ? _value._installedPackages
          : installedPackages // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$InstallerInstallingImpl implements InstallerInstalling {
  const _$InstallerInstallingImpl(
      {required this.gameName,
      required this.stage,
      required final Set<String> installedPackages})
      : _installedPackages = installedPackages;

  @override
  final String gameName;
  @override
  final InstallStage stage;
  final Set<String> _installedPackages;
  @override
  Set<String> get installedPackages {
    if (_installedPackages is EqualUnmodifiableSetView)
      return _installedPackages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_installedPackages);
  }

  @override
  String toString() {
    return 'InstallerState.installing(gameName: $gameName, stage: $stage, installedPackages: $installedPackages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerInstallingImpl &&
            (identical(other.gameName, gameName) ||
                other.gameName == gameName) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            const DeepCollectionEquality()
                .equals(other._installedPackages, _installedPackages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameName, stage,
      const DeepCollectionEquality().hash(_installedPackages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallerInstallingImplCopyWith<_$InstallerInstallingImpl> get copyWith =>
      __$$InstallerInstallingImplCopyWithImpl<_$InstallerInstallingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Set<String> installedPackages) idle,
    required TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)
        installing,
    required TResult Function(String gameName, Set<String> installedPackages)
        success,
    required TResult Function(String message, Set<String> installedPackages)
        failed,
  }) {
    return installing(gameName, stage, installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Set<String> installedPackages)? idle,
    TResult? Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult? Function(String gameName, Set<String> installedPackages)? success,
    TResult? Function(String message, Set<String> installedPackages)? failed,
  }) {
    return installing?.call(gameName, stage, installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Set<String> installedPackages)? idle,
    TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult Function(String gameName, Set<String> installedPackages)? success,
    TResult Function(String message, Set<String> installedPackages)? failed,
    required TResult orElse(),
  }) {
    if (installing != null) {
      return installing(gameName, stage, installedPackages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerIdle value) idle,
    required TResult Function(InstallerInstalling value) installing,
    required TResult Function(InstallerSuccess value) success,
    required TResult Function(InstallerFailed value) failed,
  }) {
    return installing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerIdle value)? idle,
    TResult? Function(InstallerInstalling value)? installing,
    TResult? Function(InstallerSuccess value)? success,
    TResult? Function(InstallerFailed value)? failed,
  }) {
    return installing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerIdle value)? idle,
    TResult Function(InstallerInstalling value)? installing,
    TResult Function(InstallerSuccess value)? success,
    TResult Function(InstallerFailed value)? failed,
    required TResult orElse(),
  }) {
    if (installing != null) {
      return installing(this);
    }
    return orElse();
  }
}

abstract class InstallerInstalling implements InstallerState {
  const factory InstallerInstalling(
          {required final String gameName,
          required final InstallStage stage,
          required final Set<String> installedPackages}) =
      _$InstallerInstallingImpl;

  String get gameName;
  InstallStage get stage;
  @override
  Set<String> get installedPackages;
  @override
  @JsonKey(ignore: true)
  _$$InstallerInstallingImplCopyWith<_$InstallerInstallingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InstallerSuccessImplCopyWith<$Res>
    implements $InstallerStateCopyWith<$Res> {
  factory _$$InstallerSuccessImplCopyWith(_$InstallerSuccessImpl value,
          $Res Function(_$InstallerSuccessImpl) then) =
      __$$InstallerSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gameName, Set<String> installedPackages});
}

/// @nodoc
class __$$InstallerSuccessImplCopyWithImpl<$Res>
    extends _$InstallerStateCopyWithImpl<$Res, _$InstallerSuccessImpl>
    implements _$$InstallerSuccessImplCopyWith<$Res> {
  __$$InstallerSuccessImplCopyWithImpl(_$InstallerSuccessImpl _value,
      $Res Function(_$InstallerSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameName = null,
    Object? installedPackages = null,
  }) {
    return _then(_$InstallerSuccessImpl(
      gameName: null == gameName
          ? _value.gameName
          : gameName // ignore: cast_nullable_to_non_nullable
              as String,
      installedPackages: null == installedPackages
          ? _value._installedPackages
          : installedPackages // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$InstallerSuccessImpl implements InstallerSuccess {
  const _$InstallerSuccessImpl(
      {required this.gameName, required final Set<String> installedPackages})
      : _installedPackages = installedPackages;

  @override
  final String gameName;
  final Set<String> _installedPackages;
  @override
  Set<String> get installedPackages {
    if (_installedPackages is EqualUnmodifiableSetView)
      return _installedPackages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_installedPackages);
  }

  @override
  String toString() {
    return 'InstallerState.success(gameName: $gameName, installedPackages: $installedPackages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerSuccessImpl &&
            (identical(other.gameName, gameName) ||
                other.gameName == gameName) &&
            const DeepCollectionEquality()
                .equals(other._installedPackages, _installedPackages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameName,
      const DeepCollectionEquality().hash(_installedPackages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallerSuccessImplCopyWith<_$InstallerSuccessImpl> get copyWith =>
      __$$InstallerSuccessImplCopyWithImpl<_$InstallerSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Set<String> installedPackages) idle,
    required TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)
        installing,
    required TResult Function(String gameName, Set<String> installedPackages)
        success,
    required TResult Function(String message, Set<String> installedPackages)
        failed,
  }) {
    return success(gameName, installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Set<String> installedPackages)? idle,
    TResult? Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult? Function(String gameName, Set<String> installedPackages)? success,
    TResult? Function(String message, Set<String> installedPackages)? failed,
  }) {
    return success?.call(gameName, installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Set<String> installedPackages)? idle,
    TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult Function(String gameName, Set<String> installedPackages)? success,
    TResult Function(String message, Set<String> installedPackages)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(gameName, installedPackages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerIdle value) idle,
    required TResult Function(InstallerInstalling value) installing,
    required TResult Function(InstallerSuccess value) success,
    required TResult Function(InstallerFailed value) failed,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerIdle value)? idle,
    TResult? Function(InstallerInstalling value)? installing,
    TResult? Function(InstallerSuccess value)? success,
    TResult? Function(InstallerFailed value)? failed,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerIdle value)? idle,
    TResult Function(InstallerInstalling value)? installing,
    TResult Function(InstallerSuccess value)? success,
    TResult Function(InstallerFailed value)? failed,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class InstallerSuccess implements InstallerState {
  const factory InstallerSuccess(
      {required final String gameName,
      required final Set<String> installedPackages}) = _$InstallerSuccessImpl;

  String get gameName;
  @override
  Set<String> get installedPackages;
  @override
  @JsonKey(ignore: true)
  _$$InstallerSuccessImplCopyWith<_$InstallerSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InstallerFailedImplCopyWith<$Res>
    implements $InstallerStateCopyWith<$Res> {
  factory _$$InstallerFailedImplCopyWith(_$InstallerFailedImpl value,
          $Res Function(_$InstallerFailedImpl) then) =
      __$$InstallerFailedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Set<String> installedPackages});
}

/// @nodoc
class __$$InstallerFailedImplCopyWithImpl<$Res>
    extends _$InstallerStateCopyWithImpl<$Res, _$InstallerFailedImpl>
    implements _$$InstallerFailedImplCopyWith<$Res> {
  __$$InstallerFailedImplCopyWithImpl(
      _$InstallerFailedImpl _value, $Res Function(_$InstallerFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? installedPackages = null,
  }) {
    return _then(_$InstallerFailedImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      installedPackages: null == installedPackages
          ? _value._installedPackages
          : installedPackages // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$InstallerFailedImpl implements InstallerFailed {
  const _$InstallerFailedImpl(
      {required this.message, required final Set<String> installedPackages})
      : _installedPackages = installedPackages;

  @override
  final String message;
  final Set<String> _installedPackages;
  @override
  Set<String> get installedPackages {
    if (_installedPackages is EqualUnmodifiableSetView)
      return _installedPackages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_installedPackages);
  }

  @override
  String toString() {
    return 'InstallerState.failed(message: $message, installedPackages: $installedPackages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallerFailedImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._installedPackages, _installedPackages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(_installedPackages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallerFailedImplCopyWith<_$InstallerFailedImpl> get copyWith =>
      __$$InstallerFailedImplCopyWithImpl<_$InstallerFailedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Set<String> installedPackages) idle,
    required TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)
        installing,
    required TResult Function(String gameName, Set<String> installedPackages)
        success,
    required TResult Function(String message, Set<String> installedPackages)
        failed,
  }) {
    return failed(message, installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Set<String> installedPackages)? idle,
    TResult? Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult? Function(String gameName, Set<String> installedPackages)? success,
    TResult? Function(String message, Set<String> installedPackages)? failed,
  }) {
    return failed?.call(message, installedPackages);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Set<String> installedPackages)? idle,
    TResult Function(
            String gameName, InstallStage stage, Set<String> installedPackages)?
        installing,
    TResult Function(String gameName, Set<String> installedPackages)? success,
    TResult Function(String message, Set<String> installedPackages)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(message, installedPackages);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InstallerIdle value) idle,
    required TResult Function(InstallerInstalling value) installing,
    required TResult Function(InstallerSuccess value) success,
    required TResult Function(InstallerFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InstallerIdle value)? idle,
    TResult? Function(InstallerInstalling value)? installing,
    TResult? Function(InstallerSuccess value)? success,
    TResult? Function(InstallerFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InstallerIdle value)? idle,
    TResult Function(InstallerInstalling value)? installing,
    TResult Function(InstallerSuccess value)? success,
    TResult Function(InstallerFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class InstallerFailed implements InstallerState {
  const factory InstallerFailed(
      {required final String message,
      required final Set<String> installedPackages}) = _$InstallerFailedImpl;

  String get message;
  @override
  Set<String> get installedPackages;
  @override
  @JsonKey(ignore: true)
  _$$InstallerFailedImplCopyWith<_$InstallerFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
