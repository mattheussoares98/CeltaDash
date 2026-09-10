import 'package:celta_dash/core/providers.dart';
import 'package:celta_dash/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_dash/features/buy_movement/data/repository/repository.dart';
import 'package:celta_dash/features/buy_movement/domain/repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IBuyMovementDatasource buyMovementDatasource(Ref ref) {
  return BuyMovementDatasource(ref.watch(httpClientProvider));
}

@riverpod
IBuyMovementRepository buyMovementRepository(Ref ref) {
  return BuyMovementRepositoryImpl(ref.watch(buyMovementDatasourceProvider));
}
