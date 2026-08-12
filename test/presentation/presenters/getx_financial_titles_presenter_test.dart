import 'dart:async';

import 'package:celta_dash/domain/entities/entities.dart';
import 'package:celta_dash/presentation/presenters/presenters.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

enum FinancialTitleTestRequest implements FinancialTitleRequestKey {
  daily,
  monthly,
}

void main() {
  late GetxFinancialTitlesPresenter sut;
  late LoadFinancialTitleDataSpy loadFinancialTitleData;
  late SearchFinancialTitleDataParams params;
  late FinancialTitleDataResponseEntity response;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSearchFinancialTitleDataParams());
  });

  setUp(() {
    loadFinancialTitleData = LoadFinancialTitleDataSpy();
    params = EntityFactory.makeSearchFinancialTitleDataParams();
    response = EntityFactory.makeFinancialTitleDataResponseEntity(
      searchParameters: params,
    );
    loadFinancialTitleData.mockGet(response);
    sut = GetxFinancialTitlesPresenter(
      loadFinancialTitleData: loadFinancialTitleData,
    );
  });

  tearDown(() {
    sut.onClose();
  });

  test('Should emit loading and success for the requested key', () async {
    final states = <FinancialTitleState>[];
    final subscription =
        sut.streamOf(FinancialTitleTestRequest.daily).listen(states.add);

    await sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );

    expect(
      states.map((state) => state.status),
      [FinancialTitleStatus.loading, FinancialTitleStatus.success],
    );
    expect(
      sut.stateOf(FinancialTitleTestRequest.daily).data,
      response,
    );
    loadFinancialTitleData.verifyGet(params, 1);
    await subscription.cancel();
  });

  test('Should maintain independent states for different keys', () async {
    await sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );

    final monthlyParams = EntityFactory.makeSearchFinancialTitleDataParams();
    final monthlyResponse = EntityFactory.makeFinancialTitleDataResponseEntity(
      searchParameters: monthlyParams,
    );
    loadFinancialTitleData.mockGet(monthlyResponse);

    await sut.load(
      key: FinancialTitleTestRequest.monthly,
      params: monthlyParams,
    );

    expect(
      sut.stateOf(FinancialTitleTestRequest.daily).data,
      response,
    );
    expect(
      sut.stateOf(FinancialTitleTestRequest.monthly).data,
      monthlyResponse,
    );
  });

  test('Should reuse a cached result for the same key and params', () async {
    await sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );
    await sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );

    loadFinancialTitleData.verifyGet(params, 1);
  });

  test('Should emit failure and map the error', () async {
    loadFinancialTitleData.mockGetError();

    await sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );

    final state = sut.stateOf(FinancialTitleTestRequest.daily);
    expect(state.status, FinancialTitleStatus.failure);
    expect(state.params, params);
    expect(state.error, UIError.unexpected);
  });

  test('Should ignore an older response for the same key', () async {
    final firstCompleter = Completer<FinancialTitleDataResponseEntity>();
    final secondCompleter = Completer<FinancialTitleDataResponseEntity>();
    final secondParams = EntityFactory.makeSearchFinancialTitleDataParams();
    final secondResponse = EntityFactory.makeFinancialTitleDataResponseEntity(
      searchParameters: secondParams,
    );

    loadFinancialTitleData.mockGetWith(
      (requestParams) => requestParams == params
          ? firstCompleter.future
          : secondCompleter.future,
    );

    final firstRequest = sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );
    final secondRequest = sut.load(
      key: FinancialTitleTestRequest.daily,
      params: secondParams,
      forceRefresh: true,
    );

    secondCompleter.complete(secondResponse);
    await secondRequest;
    firstCompleter.complete(response);
    await firstRequest;

    expect(
      sut.stateOf(FinancialTitleTestRequest.daily).data,
      secondResponse,
    );
  });

  test('Should release the state owned by a key', () async {
    await sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );

    sut.release(FinancialTitleTestRequest.daily);

    final state = sut.stateOf(FinancialTitleTestRequest.daily);
    expect(state.status, FinancialTitleStatus.initial);
    expect(state.data, isNull);
  });

  test('Should ignore an in-flight response after releasing its key', () async {
    final completer = Completer<FinancialTitleDataResponseEntity>();
    loadFinancialTitleData.mockGetWith((_) => completer.future);

    final request = sut.load(
      key: FinancialTitleTestRequest.daily,
      params: params,
    );
    sut.release(FinancialTitleTestRequest.daily);
    completer.complete(response);
    await request;

    expect(
      sut.stateOf(FinancialTitleTestRequest.daily).status,
      FinancialTitleStatus.initial,
    );
  });
}
