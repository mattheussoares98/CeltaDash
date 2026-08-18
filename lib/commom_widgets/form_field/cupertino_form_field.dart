import 'package:celta_dash/commom_widgets/form_field/form_field.dart';
import 'package:celta_dash/core/domain/entities/entities.dart';
import 'package:celta_dash/core/infrastructure/infrastructure.dart';
import 'package:celta_dash/core/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CupertinoFormField extends ConsumerStatefulWidget {
  final BaseTextFormField baseTextFormField;

  const CupertinoFormField({super.key, required this.baseTextFormField});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CupertinoFormFieldState();
}

class _CupertinoFormFieldState extends ConsumerState<CupertinoFormField> {
  FormFieldState<String>? _formFieldState;
  final overlayManager = OverlayManager();

  @override
  void initState() {
    super.initState();

    widget.baseTextFormField.focusNode?.addListener(_updateOverlayState);
    widget.baseTextFormField.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.baseTextFormField.focusNode?.removeListener(_updateOverlayState);
    widget.baseTextFormField.controller?.removeListener(_onControllerChanged);
    overlayManager.hide();
    try {
      ref
          .read(activeNumericFocusNodeProvider.notifier)
          .clearIfActive(widget.baseTextFormField.focusNode);
    } catch (_) {
      // Safely ignore if the ref or provider container is already inactive/disposed.
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (_formFieldState?.value != widget.baseTextFormField.controller?.text) {
      _formFieldState?.didChange(widget.baseTextFormField.controller?.text);
    }
  }

  void _updateOverlayState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      final dtf = widget.baseTextFormField;
      final hasFocus = dtf.focusNode?.hasFocus ?? false;
      final isKeyboardOpen = ref.read(
        keyboardVisibilityStateControllerProvider,
      );

      if (hasFocus && isKeyboardOpen && isNumeric) {
        debugPrint('show');
        _showOverlay();
      } else {
        debugPrint('Hide');
        overlayManager.hide();
        ref
            .read(activeNumericFocusNodeProvider.notifier)
            .clearIfActive(dtf.focusNode);
      }
    });
  }

  void _showOverlay() {
    final dtf = widget.baseTextFormField;
    overlayManager.showDoneBar(
      context: context,
      focusNode: dtf.focusNode,
      onDone: () {
        if (dtf.onFieldSubmitted != null) {
          dtf.onFieldSubmitted?.call(dtf.controller?.text ?? '');
        } else if (dtf.onEditingComplete != null) {
          dtf.onEditingComplete?.call();
        } else {
          dtf.focusNode?.unfocus();
        }
      },
    );
    ref
        .read(activeNumericFocusNodeProvider.notifier)
        .setActiveNode(dtf.focusNode);
  }

  bool get isNumeric =>
      widget.baseTextFormField.keyboardType == TextInputType.number ||
      widget.baseTextFormField.keyboardType ==
          const TextInputType.numberWithOptions(decimal: true) ||
      widget.baseTextFormField.keyboardType ==
          const TextInputType.numberWithOptions();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final dtf = widget.baseTextFormField;
    final isEnabled = dtf.enabled ?? true;

    if (dtf.focusNode == null &&
        (dtf.keyboardType == TextInputType.number ||
            dtf.keyboardType ==
                const TextInputType.numberWithOptions(decimal: true))) {
      ref.read(crashlyticsServiceProvider).setCustomKeys([
        const CrashlyticsCustomKeyEntity(
          key: 'iOS numeric keyboard without focus node',
          value:
              'iOS device with numeric keyboard and no focus node. This is a problem to manage the overlay with the done button. Please, add a focus node to this text field.',
        ),
      ]);
    }

    return FormField<String>(
      key: dtf.key,
      validator: dtf.validator,
      enabled: isEnabled,
      initialValue: dtf.controller?.text,
      autovalidateMode: dtf.autovalidateMode,
      builder: (state) {
        _formFieldState = state;

        final fillColor = isEnabled
            ? CupertinoColors.tertiarySystemFill.resolveFrom(context)
            : colorScheme.onSurface.withAlpha(25);

        final Border? border = state.hasError
            ? Border.all(color: CupertinoColors.destructiveRed)
            : !isEnabled
            ? Border.all(color: colorScheme.onSurface.withAlpha(20))
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dtf.labelText != null)
              Padding(
                padding: const EdgeInsets.only(left: Sizes.p8),
                child: Text(
                  dtf.labelText!,
                  style: TextStyle(
                    color: isEnabled
                        ? colorScheme.onSurface.withAlpha(200)
                        : colorScheme.onSurface.withAlpha(100),
                    fontSize: 12,
                  ),
                ),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: Sizes.p48),
              child: CupertinoTextField(
                scrollPadding: EdgeInsets.all(
                  OverlayManager.totalAccessoryHeight,
                ),
                onTap: dtf.onTap,
                onEditingComplete: dtf.onEditingComplete,
                inputFormatters: dtf.inputFormatters,
                controller: dtf.controller,
                textInputAction: dtf.textInputAction,
                minLines: 1,
                maxLines: dtf.maxLines ?? 1,
                placeholder: dtf.hintText,
                autofocus: dtf.autofocus == true,
                style: TextStyle(
                  color: isEnabled
                      ? null
                      : colorScheme.onSurface.withAlpha(100),
                ),
                placeholderStyle: context.theme.textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? colorScheme.onSurface.withAlpha(125)
                      : colorScheme.onSurface.withAlpha(100),
                  fontSize: 12,
                ),
                textAlignVertical: TextAlignVertical.center,
                obscureText: dtf.obscureText,
                onSubmitted: dtf.onFieldSubmitted,
                enabled: isEnabled,
                focusNode: dtf.focusNode,
                maxLength: dtf.maxLength,
                autofillHints: dtf.autofillHints,
                onChanged: (value) {
                  dtf.onChanged?.call(value);
                  state.didChange(value);
                },
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(Sizes.p8),
                  border: border,
                ),
                keyboardType: dtf.keyboardType,
                prefix: dtf.prefixIcon == null
                    ? null
                    : _BuildIcon(widget: dtf.prefixIcon!),
                suffix: dtf.suffixIcon == null
                    ? null
                    : _BuildIcon(widget: dtf.suffixIcon!),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: Sizes.p8, top: Sizes.p4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontSize: Sizes.p12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BuildIcon extends StatelessWidget {
  final Widget widget;
  const _BuildIcon({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: Sizes.p48,
        minHeight: Sizes.p48,
      ),
      child: Center(child: widget),
    );
  }
}
