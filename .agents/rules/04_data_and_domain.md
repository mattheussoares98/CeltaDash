---
trigger: model_decision
description: Activate when creating or modifying data models, domain entities, datasources, repositories, or handling API/JSON.
---

## Barrels & Imports
- Create barrels only in leaf folders (`entities/entities.dart`, `models/models.dart`, `datasource/datasource.dart`, `repository/repository.dart`).
- ❌ **FORBIDDEN**: Never create `data.dart`, `domain.dart`, `presentation.dart`, or `<feature_name>.dart`.
- Import the leaf barrel, never individual files or relative paths.

## Entities (Domain)
- Name: `*Entity` / `*_entity.dart` (ERP prefix `BSF`, e.g., `BSFCustomerEntity`).
- Must extend `Equatable`; list all properties in `props`.

## Models (Data)
- Name: `*Model` / `*_model.dart` (ERP prefix `BSF`, e.g., `BSFSaleRequestModel`).
- Implement `fromJson`, `toJson`, `fromEntity`, `toEntity`.
- **JSON Safety**: Use untyped `Map` (never `Map<String, dynamic>`: local storage returns `Map<dynamic, dynamic>`, causing runtime invariant cast crashes).
  - ✅ `factory MyModel.fromJson(Map json)`, `Map toJson()`, `MyNested.fromJson(json['x'] as Map)`
  - ❌ `factory MyModel.fromJson(Map<String, dynamic> json)`

## Datasources & Repositories
- Interfaces: `IMyDatasource`, `IMyRepository`.
- Implementations: Datasource = `MyDatasource`, Repository = `MyRepositoryImpl`.
- Inject datasources into repositories via constructor (never instantiate internally).

## Ec Datasource HTTP Pattern
Datasources prefixed `Ec` must follow in every method:
- Param: `EcRequestParams params`
- URL: `'${params.workingUrl}/api/Endpoint'`
- Headers: `params.toHeaders()`
- Body (POST/PUT): `{ ...params.toMap(), 'key': value }`
