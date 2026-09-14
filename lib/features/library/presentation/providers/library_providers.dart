import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/library_dio_provider.dart';
import '../../../../core/storage/local_storage_providers.dart';
import '../../data/datasources/library_remote_datasource.dart';
import '../../data/repositories/library_repository_impl.dart';
import '../../domain/repositories/library_repository.dart';
import '../../domain/usecases/get_library_account_usecase.dart';

part 'library_providers.g.dart';

@Riverpod(keepAlive: true)
LibraryRemoteDataSource libraryRemoteDataSource(Ref ref) {
  return LibraryRemoteDataSource(
    ref.watch(libraryDioProvider),
    ref.watch(libraryCookieJarProvider),
  );
}

@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) {
  return LibraryRepositoryImpl(
    ref.watch(libraryRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
GetLibraryAccountUseCase getLibraryAccountUseCase(Ref ref) {
  return GetLibraryAccountUseCase(ref.watch(libraryRepositoryProvider));
}
