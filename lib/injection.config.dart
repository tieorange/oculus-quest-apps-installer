// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:quest_game_manager/core/di/register_module.dart' as _i1054;
import 'package:quest_game_manager/core/services/rclone_service.dart' as _i574;
import 'package:quest_game_manager/features/catalog/data/datasources/catalog_local_datasource.dart'
    as _i418;
import 'package:quest_game_manager/features/catalog/data/datasources/catalog_remote_datasource.dart'
    as _i24;
import 'package:quest_game_manager/features/catalog/data/repositories/catalog_repository_impl.dart'
    as _i312;
import 'package:quest_game_manager/features/catalog/domain/repositories/catalog_repository.dart'
    as _i361;
import 'package:quest_game_manager/features/catalog/domain/usecases/get_game_catalog.dart'
    as _i751;
import 'package:quest_game_manager/features/catalog/domain/usecases/search_games.dart'
    as _i259;
import 'package:quest_game_manager/features/catalog/presentation/bloc/catalog_bloc.dart'
    as _i120;
import 'package:quest_game_manager/features/config/data/datasources/config_local_datasource.dart'
    as _i251;
import 'package:quest_game_manager/features/config/data/datasources/config_remote_datasource.dart'
    as _i803;
import 'package:quest_game_manager/features/config/data/repositories/config_repository_impl.dart'
    as _i1022;
import 'package:quest_game_manager/features/config/domain/repositories/config_repository.dart'
    as _i118;
import 'package:quest_game_manager/features/config/domain/usecases/fetch_config.dart'
    as _i155;
import 'package:quest_game_manager/features/downloads/data/datasources/download_remote_datasource.dart'
    as _i1009;
import 'package:quest_game_manager/features/downloads/data/repositories/download_repository_impl.dart'
    as _i244;
import 'package:quest_game_manager/features/downloads/domain/repositories/download_repository.dart'
    as _i269;
import 'package:quest_game_manager/features/downloads/presentation/bloc/downloads_bloc.dart'
    as _i505;
import 'package:quest_game_manager/features/settings/presentation/cubit/settings_cubit.dart'
    as _i261;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i259.SearchGames>(() => _i259.SearchGames());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i574.RcloneService>(() => _i574.RcloneService());
    gh.lazySingleton<_i251.ConfigLocalDatasource>(
        () => _i251.ConfigLocalDatasource());
    gh.lazySingleton<_i418.CatalogLocalDatasource>(
        () => _i418.CatalogLocalDatasource());
    gh.lazySingleton<_i803.ConfigRemoteDatasource>(
        () => _i803.ConfigRemoteDatasource(gh<_i361.Dio>()));
    gh.lazySingleton<_i24.CatalogRemoteDatasource>(
        () => _i24.CatalogRemoteDatasource(gh<_i361.Dio>()));
    gh.lazySingleton<_i1009.DownloadRemoteDatasource>(
        () => _i1009.DownloadRemoteDatasource(gh<_i361.Dio>()));
    gh.lazySingleton<_i269.DownloadRepository>(() =>
        _i244.DownloadRepositoryImpl(gh<_i1009.DownloadRemoteDatasource>()));
    gh.factory<_i361.CatalogRepository>(() => _i312.CatalogRepositoryImpl(
          gh<_i24.CatalogRemoteDatasource>(),
          gh<_i418.CatalogLocalDatasource>(),
        ));
    gh.factory<_i751.GetGameCatalog>(
        () => _i751.GetGameCatalog(gh<_i361.CatalogRepository>()));
    gh.factory<_i751.GetCachedCatalog>(
        () => _i751.GetCachedCatalog(gh<_i361.CatalogRepository>()));
    gh.factory<_i751.IsCacheStale>(
        () => _i751.IsCacheStale(gh<_i361.CatalogRepository>()));
    gh.lazySingleton<_i118.ConfigRepository>(() => _i1022.ConfigRepositoryImpl(
          gh<_i803.ConfigRemoteDatasource>(),
          gh<_i251.ConfigLocalDatasource>(),
        ));
    gh.factory<_i505.DownloadsBloc>(() => _i505.DownloadsBloc(
          gh<_i269.DownloadRepository>(),
          gh<_i118.ConfigRepository>(),
        ));
    gh.factory<_i155.FetchConfig>(
        () => _i155.FetchConfig(gh<_i118.ConfigRepository>()));
    gh.factory<_i261.SettingsCubit>(
        () => _i261.SettingsCubit(gh<_i118.ConfigRepository>()));
    gh.factory<_i120.CatalogBloc>(() => _i120.CatalogBloc(
          gh<_i155.FetchConfig>(),
          gh<_i751.GetGameCatalog>(),
          gh<_i751.GetCachedCatalog>(),
          gh<_i751.IsCacheStale>(),
          gh<_i259.SearchGames>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i1054.RegisterModule {}
