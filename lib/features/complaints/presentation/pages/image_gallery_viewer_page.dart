import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/loading_widget.dart';

class ImageGalleryViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageGalleryViewerPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<ImageGalleryViewerPage> createState() => _ImageGalleryViewerPageState();
}
class _ImageGalleryViewerPageState extends State<ImageGalleryViewerPage> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for image viewing
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'صورة ${_currentPage + 1} من ${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer( // Allows zooming and panning
                  panEnabled: true, // Set to false to disable pan
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.contain, // Ensure image fits within bounds
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: LoadingWidget(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
