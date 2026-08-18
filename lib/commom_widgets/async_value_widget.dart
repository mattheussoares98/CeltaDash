import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/exceptions/exceptions.dart';
import 'package:celta_dash/ui/helpers/helpers.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.tryAgain,
    required this.data,
    this.isSliver,
    this.errorMaxLines,
    this.useLinearProgressIndicator,
    this.preserveValue = false,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final VoidCallback? tryAgain;
  final bool? isSliver;
  final bool? useLinearProgressIndicator;
  final int? errorMaxLines;
  final bool preserveValue;

  @override
  Widget build(BuildContext context) {
    final currentValue = value.value;
    if (preserveValue && value.isLoading && currentValue != null) {
      return data(currentValue);
    }

    if (value.isLoading) {
      return _Loading(
        isSliver: isSliver,
        useLinearProgressIndicator: useLinearProgressIndicator,
      );
    }

    return value.when(
      data: data,
      loading: () => _Loading(
        isSliver: isSliver,
        useLinearProgressIndicator: useLinearProgressIndicator,
      ),
      error: (e, st) => isSliver == true
          ? SliverToBoxAdapter(
              child: _Error(e: e, tryAgain: tryAgain, maxLines: errorMaxLines),
            )
          : _Error(e: e, tryAgain: tryAgain, maxLines: errorMaxLines),
    );
  }
}

class OptimazedAsyncValueWidget<T> extends ConsumerWidget {
  //!this widget was made for largest pages below to avoid rebuild unecessary
  const OptimazedAsyncValueWidget({
    super.key,
    required this.provider,
    required this.tryAgain,
    required this.child,
    this.isSliver,
    this.useLinearProgressIndicator,
    this.errorMaxLines,
  });
  final ProviderListenable<AsyncValue<T>> provider;
  final Widget child;
  final VoidCallback? tryAgain;
  final bool? isSliver;
  final bool? useLinearProgressIndicator;
  final int? errorMaxLines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(provider.select((s) => s.isLoading));
    final error = ref.watch(provider.select((s) => s.error));

    if (isLoading) {
      return _Loading(
        isSliver: isSliver,
        useLinearProgressIndicator: useLinearProgressIndicator,
      );
    } else if (error != null) {
      return isSliver == true
          ? SliverToBoxAdapter(
              child: _Error(
                e: error,
                tryAgain: tryAgain,
                maxLines: errorMaxLines,
              ),
            )
          : _Error(e: error, tryAgain: tryAgain, maxLines: errorMaxLines);
    }

    return child;
  }
}

class _Loading extends StatelessWidget {
  final bool? isSliver;
  final bool? useLinearProgressIndicator;
  const _Loading({
    required this.isSliver,
    required this.useLinearProgressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    if (useLinearProgressIndicator == true) {
      if (isSliver == true) {
        return const SliverToBoxAdapter(child: LinearProgressIndicator());
      }
      return const LinearProgressIndicator();
    }
    if (isSliver == true) {
      return const SliverToBoxAdapter(child: Center(child: LoadingWidget()));
    }
    return const Center(child: LoadingWidget());
  }
}

class _Error extends StatelessWidget {
  final Object e;
  final VoidCallback? tryAgain;
  final int? maxLines;
  const _Error({
    required this.e,
    required this.tryAgain,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseText.bodySmall(
              parseErrorMessage(e),
              textAlign: TextAlign.center,
              maxLines: maxLines,
              color: Colors.red,
            ),
            if (tryAgain != null)
              PrimaryTextButton(
                text: 'Tentar novamente'.hardcoded,
                onPressed: tryAgain,
                platformIcon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.refresh,
                  materialIcon: Icons.refresh,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
