import 'package:celta_dash/features/buy_movement/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class HomeBuyMovementState extends Equatable {
  final List<BuyMovementDataRowEntity> rows;
  final num totalValue;

  const HomeBuyMovementState({required this.rows, required this.totalValue});

  factory HomeBuyMovementState.fromRows(List<BuyMovementDataRowEntity> rows) {
    return HomeBuyMovementState(
      rows: List.unmodifiable(rows),
      totalValue: rows.fold<num>(0, (total, row) => total + row.totalValue),
    );
  }

  @override
  List<Object> get props => [rows, totalValue];
}
