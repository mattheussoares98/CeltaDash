---
trigger: model_decision
description: Activate this rule whenever the user asks to create or modify data models, domain entities, datasources, repositories, or when handling API requests and JSON serialization
---

## Barrel Files and Imports
- Every directory must have a barrel `.dart` file (same name as the directory) exporting all its files.
- Every import must target the barrel file, never a deep individual file.

## Entities (Domain Layer)
- Name: `*Entity` / file: `*_entity.dart`
- ERP-sourced entities: prefix `BSF` (e.g., `BSFCustomerEntity`)
- Must extend `Equatable`; all properties must be in `props`.

## Models (Data Layer)
- Name: `*Model` / file: `*_model.dart`
- ERP-sourced models: prefix `BSF` (e.g., `BSFSaleRequestModel`)
- Every model must implement: `fromJson`, `toJson`, `fromEntity`, `toEntity`
- **JSON Safety**: use untyped `Map` — never `Map<String, dynamic>`. Local storage (Hive, SharedPreferences) returns `Map<dynamic, dynamic>` at runtime, which is not a subtype of `Map<String, dynamic>` (Dart generics are invariant → runtime cast error).
  - ✅ `factory MyModel.fromJson(Map json)`
  - ✅ `Map toJson()`
  - ❌ `factory MyModel.fromJson(Map<String, dynamic> json)`
  - For nested maps: `MyNested.fromJson(json['x'] as Map)`

## Datasources and Repositories
- Interfaces prefix: `I` (e.g., `IMyDatasource`, `IMyRepository`)
- Datasource impl: strip `I` (e.g., `MyDatasource`)
- Repository impl: strip `I` + append `Impl` (e.g., `MyRepositoryImpl`)
- Repositories receive datasources via constructor — never instantiate them internally.

## Ec Datasource HTTP Pattern
Any datasource prefixed `Ec` must follow this pattern in every method:
- Param: `EcRequestParams params`
- URL: `'${params.workingUrl}/api/Endpoint'`
- Headers: `params.toHeaders()`
- Body (POST/PUT): `{ ...params.toMap(), 'key': value }`
