// lib/features/pdf_viewer/presentation/pages/pdf_viewer_page.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/routing/routing.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends HookWidget {
  final Uint8List pdfBytes;
  final String pdfFileName;

  const PdfViewerPage({
    super.key,
    required this.pdfBytes,
    required this.pdfFileName,
  });

  static Future<void> openPdf(
    Uint8List pdfBytes,
    String pdfFileName, [
    BuildContext? context,
  ]) async {
    final navState =
        (context != null ? Navigator.of(context, rootNavigator: true) : null) ??
        rootNavigatorKey.currentState;
    if (navState == null) {
      debugPrint(
        '❌ [PdfViewerPage] Cannot open PDF: No valid Navigator found.',
      );
      return;
    }
    await navState.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            PdfViewerPage(pdfBytes: pdfBytes, pdfFileName: pdfFileName),
      ),
    );
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final pdfFile = XFile.fromData(
        pdfBytes,
        name: pdfFileName,
        mimeType: 'application/pdf',
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [pdfFile],
          title: pdfFileName,
          previewThumbnail: pdfFile,
          fileNameOverrides: ['$pdfFileName.pdf'],
        ),
      );
    } catch (e) {
      debugPrint('❌ An error occurred while sharing the PDF: $e');
      if (context.mounted) {
        showToastMessage('Could not share file: $e', type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      return () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      };
    }, const []);

    return BaseScaffold(
      isScrollable: false,
      appBar: AppBar(
        title: BaseText.title(pdfFileName),
        actions: [
          if (PlatformUtil.isMobile)
            IconButton(
              icon: const PlatformIcon(
                materialIcon: Icons.share,
                cupertinoIcon: CupertinoIcons.share,
              ),
              onPressed: () => _sharePdf(context),
              tooltip: 'Compartilhar PDF'.hardcoded,
            ),
        ],
      ),
      body: SfPdfViewer.memory(pdfBytes),
    );
  }
}
