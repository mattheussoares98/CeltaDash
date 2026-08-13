# 01. Entity & Model Migration Guide

## Objective
Migrate business entities to pure Dart domain objects and API Data Transfer Objects (DTOs / Models) to the data layer with explicit conversion methods (`toEntity`, `fromEntity`, `fromJson`, `toJson`).

---

## 1. Domain Entities (`domain/entities/`)
- **Location**: `lib/features/[feature]/domain/entities/[entity_name]_entity.dart`
- **Rules**:
  - Pure Dart only: No Flutter imports (`package:flutter/...`), No HTTP dependencies, No serialization logic (`fromJson`/`toJson`).
  - Immutable fields (`final`).
  - Implement `copyWith`, `==`, `hashCode`, and `toString` (or use `Equatable` if preferred).
  - One class per file.
  - Export all entities in `entities.dart`.

### Example
```dart
// lib/features/seller/domain/entities/seller_entity.dart
class SellerEntity {
  final int id;
  final String name;
  final double totalSales;

  const SellerEntity({
    required this.id,
    required this.name,
    required this.totalSales,
  });

  SellerEntity copyWith({
    int? id,
    String? name,
    double? totalSales,
  }) {
    return SellerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      totalSales: totalSales ?? this.totalSales,
    );
  }
}
```

---

## 2. Domain Parameter Objects (`domain/entities/` or `domain/models/`)
- **Location**: `lib/features/[feature]/domain/entities/[feature]_params.dart`
- **Rules**:
  - Used for passing query filters and arguments to repository methods and parameterized controllers.
  - **Must extend `Equatable`** and declare all fields in `props`.
  - Immutable (`final` fields) with `copyWith`.

### Example
```dart
// lib/features/sale_statistics/domain/entities/get_sale_statistics_params.dart
import 'package:equatable/equatable.dart';

class GetSaleStatisticsParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final List<int>? enterpriseIds;
  final bool? groupByProductDepartment;
  final bool? groupBySeller;

  const GetSaleStatisticsParams({
    required this.startDate,
    required this.endDate,
    this.enterpriseIds,
    this.groupByProductDepartment,
    this.groupBySeller,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        enterpriseIds,
        groupByProductDepartment,
        groupBySeller,
      ];
}
```

---

## 3. Data Models / DTOs (`data/models/`)
- **Location**: `lib/features/[feature]/data/models/[model_name]_model.dart`
- **Rules**:
  - Handles API JSON serialization (`fromJson`, `toJson`).
  - Handles data parsing edge cases (null safety defaults, type conversions).
  - Provide `toEntity()` to convert the DTO to a pure Domain Entity.
  - Provide `factory Model.fromEntity(Entity entity)` if mutations are pushed back to the backend.
  - Export all models in `models.dart`.

### Example
```dart
// lib/features/seller/data/models/seller_model.dart
import 'package:celta_dash/features/seller/domain/entities/entities.dart';

class SellerModel {
  final int? id;
  final String? name;
  final num? totalSales;

  const SellerModel({
    this.id,
    this.name,
    this.totalSales,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      totalSales: json['total_sales'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'total_sales': totalSales,
  };

  SellerEntity toEntity() {
    return SellerEntity(
      id: id ?? 0,
      name: name ?? '',
      totalSales: totalSales?.toDouble() ?? 0.0,
    );
  }
}
```

---

## Checklist for Entities & Models
- [ ] Create `domain/entities/[entity]_entity.dart` with pure Dart class and `const` constructor.
- [ ] Ensure NO Flutter / HTTP / JSON imports exist in `domain/entities/`.
- [ ] Create `domain/entities/entities.dart` barrel file exporting the entity.
- [ ] Create `data/models/[model]_model.dart` with `fromJson`, `toJson`, and `toEntity()`.
- [ ] Create `data/models/models.dart` barrel file exporting the model.
- [ ] Verify barrel files use package imports (`package:celta_dash/...`).
