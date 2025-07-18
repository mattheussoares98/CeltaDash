import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../main/utils/utils.dart';
import '../../components/components.dart';

class PdfViewer {
  PdfViewer._();

  static Future<void> openPdf(Uint8List pdfBytes, String pdfFileName) async {
    await Navigator.push(
      NavigatorKey.key.currentContext!,
      MaterialPageRoute(
        builder: (context) => _PdfViewerPage(
          pdfBytes: pdfBytes,
          pdfFileName: pdfFileName,
        ),
      ),
    );
  }
}

class _PdfViewerPage extends StatefulWidget {
  final Uint8List pdfBytes;
  final String pdfFileName;
  const _PdfViewerPage({
    required this.pdfBytes,
    required this.pdfFileName,
  });

  @override
  State<_PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<_PdfViewerPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _sharePdf() async {
    try {
      final pdfFile = XFile.fromData(
        widget.pdfBytes,
        name: widget.pdfFileName,
        mimeType: 'application/pdf',
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [pdfFile],
          text: "Compartilhar PDF",
          downloadFallbackEnabled: true,
          title: widget.pdfFileName,
          previewThumbnail: pdfFile,
          mailToFallbackEnabled: true,
          fileNameOverrides: ['${widget.pdfFileName}.pdf'],
        ),
      );
    } catch (e) {
      debugPrint("❌ An error occurred while sharing the PDF: $e");
      if (context.mounted) {
        snackBarMessage(
          context,
          'Could not share file: $e',
          Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfFileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePdf,
            tooltip: 'Compartilhar PDF',
          ),
        ],
      ),
      body: SfPdfViewer.memory(
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        enableDocumentLinkAnnotation: true,
        enableHyperlinkNavigation: true,
        interactionMode: PdfInteractionMode.selection,
        canShowScrollStatus: true,
        canShowScrollHead: true,
        widget.pdfBytes,
        canShowTextSelectionMenu: true,
      ),
    );
  }
}
