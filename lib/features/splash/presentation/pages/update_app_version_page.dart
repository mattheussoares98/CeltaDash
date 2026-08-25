import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

const _appStoreUrl = 'https://apps.apple.com/app/id6745738261';
const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=br.com.celtaware.dash';

class UpdateAppVersionPage extends HookWidget {
  const UpdateAppVersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    final scale = useAnimation(
      Tween<double>(begin: 1, end: 1.05).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ResponsiveCenter(
            maxContentWidth: 560,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.system_update_rounded,
                    size: Sizes.p120,
                    color: context.theme.primaryColor,
                  ),
                  gapH32,
                  BaseText.headline(
                    'Nova atualização necessária'.hardcoded,
                    textAlign: TextAlign.center,
                  ),
                  gapH16,
                  BaseText.bodyLarge(
                    'Por favor, atualize a versão do aplicativo para continuar usando. Obrigado!'
                        .hardcoded,
                    textAlign: TextAlign.center,
                  ),
                  gapH32,
                  Transform.scale(
                    scale: scale,
                    child: PrimaryButton(
                      text: 'Atualizar'.hardcoded,
                      icon: const Icon(Icons.download_rounded),
                      onPressed: () => _launchStore(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchStore(BuildContext context) async {
    final url = Uri.parse(
      Theme.of(context).platform == TargetPlatform.android
          ? _playStoreUrl
          : _appStoreUrl,
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
