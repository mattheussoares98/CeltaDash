import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/components.dart';

class PdfViewerPage extends StatefulWidget {
  final Uint8List pdfBytes;
  const PdfViewerPage({super.key, required this.pdfBytes});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late final PdfControllerPinch _pdfPinchController;
  late final PdfController _pdfController;

  // State variable to control the visibility of the AppBar.
  bool _showAppBar = true;
  // Stores the last vertical scroll offset to determine scroll direction.
  double _lastYOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openData(widget.pdfBytes),
      viewportFraction: 1,
    );
    _pdfController = PdfController(
      document: PdfDocument.openData(widget.pdfBytes),
    );

    _pdfPinchController.addListener(_handleScroll);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // IMPORTANT! When dispose the page, is enabled landscape mode
    _pdfPinchController.removeListener(_handleScroll);
    _pdfPinchController.dispose();
    _pdfController.dispose();

    super.dispose();
  }

  void _handleScroll() {
    // The Y-offset is obtained from the controller's transformation matrix.
    final currentYOffset = _pdfPinchController.value.row1[3];

    // A small threshold to prevent the AppBar from flickering on minor movements.
    if ((_lastYOffset - currentYOffset).abs() < 2.0) return;

    // When scrolling down, the Y-offset becomes more negative.
    if (currentYOffset < _lastYOffset && _showAppBar) {
      if (mounted) {
        setState(() {
          _showAppBar = false;
        });
        // Hide the system UI (status bar) for a full-screen immersive experience.
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
    // When scrolling up, the Y-offset becomes less negative (closer to 0).
    else if (currentYOffset > _lastYOffset && !_showAppBar) {
      if (mounted) {
        setState(() {
          _showAppBar = true;
        });
        // Restore the system UI when the AppBar becomes visible.
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
    _lastYOffset = currentYOffset;
  }

  /// Saves the PDF to the device using file_saver
  Future<void> _sharePdf() async {
    try {
      // Create an XFile object directly from the byte data in memory.
      // This is more efficient than saving to a temporary file first.

      final pdfFile = XFile.fromData(
        widget.pdfBytes,
        name: "pdfViewerProvider.fileName!", //TODO change
        mimeType: 'application/pdf',
      );

      // Use Share.shareXFiles to open the native share dialog.
      await SharePlus.instance.share(
        ShareParams(
          files: [pdfFile],
          text: "Compartilhar PDF",
          downloadFallbackEnabled: true,
          title: "pdfViewerProvider.fileName", //TODO change
          previewThumbnail: pdfFile,
          mailToFallbackEnabled: true,
          fileNameOverrides: ['name.pdf'], //TODO CHANGE
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
    final appBar = AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _sharePdf,
          tooltip: 'Compartilhar PDF',
        ),
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          // The PDF viewer takes up the entire screen.
          Positioned.fill(
            child: Platform.isWindows
                ? PdfView(
                    controller: _pdfController,
                    scrollDirection: Axis.vertical,
                  )
                : PdfViewPinch(
                    controller: _pdfPinchController,
                    maxScale: 1.5,
                    minScale: 1,
                  ),
          ),
          // This widget animates the position of the AppBar.
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // When _showAppBar is false, the 'top' property becomes negative,
            // moving the AppBar off the top of the screen.
            top: _showAppBar
                ? 0
                : -(appBar.preferredSize.height +
                    MediaQuery.of(context).padding.top),
            left: 0,
            right: 0,
            child: appBar,
          ),
        ],
      ),
    );
  }
}
