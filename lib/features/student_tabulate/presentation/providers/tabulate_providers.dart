import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/sira_dio_provider.dart';
import '../../data/datasources/sira_tabulate_remote_datasource.dart';
import '../../data/repositories/tabulate_repository_impl.dart';
import '../../domain/repositories/tabulate_repository.dart';
import '../../domain/usecases/get_tabulate_usecase.dart';

part 'tabulate_providers.g.dart';

@Riverpod(keepAlive: true)
SiraTabulateRemoteDataSource siraTabulateRemoteDataSource(Ref ref) {
  return SiraTabulateRemoteDataSource(ref.watch(siraDioProvider));
}

@Riverpod(keepAlive: true)
TabulateRepository tabulateRepository(Ref ref) {
  return TabulateRepositoryImpl(
    ref.watch(siraTabulateRemoteDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
GetTabulateUseCase getTabulateUseCase(Ref ref) {
  return GetTabulateUseCase(ref.watch(tabulateRepositoryProvider));
}
