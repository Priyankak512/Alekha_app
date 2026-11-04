// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:alekha/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MultiImageEditorScreen extends StatefulWidget {
  final List<File> initialFiles;

  const MultiImageEditorScreen({
    super.key,
    required this.initialFiles,
  });

  @override
  State<MultiImageEditorScreen> createState() => _MultiImageEditorScreenState();
}

class _MultiImageEditorScreenState extends State<MultiImageEditorScreen> {
  late List<File> _images;
  int _currentIndex = 0;
  late PageController _pageController;
  final ScrollController _thumbScrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _images = List<File>.from(widget.initialFiles);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbScrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentThumb(int index) {
    if (!_thumbScrollController.hasClients) return;
    final targetOffset = (index * 68.0) - 100.0;
    _thumbScrollController.animateTo(
      targetOffset.clamp(0.0, _thumbScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _editCurrentImage() async {
    if (_images.isEmpty || _currentIndex >= _images.length) return;

    final currentFile = _images[_currentIndex];
    try {
      final Uint8List originalBytes = await currentFile.readAsBytes();

      if (!mounted) return;

      final dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: originalBytes,
          ),
        ),
      );

      if (result != null && result is Uint8List) {
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'edited_${DateTime.now().millisecondsSinceEpoch}_$_currentIndex.jpg';
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(result);

        // Clear cached image so preview updates immediately
        imageCache.clear();
        imageCache.clearLiveImages();

        setState(() {
          _images[_currentIndex] = tempFile;
        });
      }
    } catch (e) {
      debugPrint("Error editing image: $e");
    }
  }

  Future<void> _addMoreImages() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text("Gallery",
                  style: TextStyle(color: Colors.white, fontFamily: "Open Sans")),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text("Camera",
                  style: TextStyle(color: Colors.white, fontFamily: "Open Sans")),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (source == ImageSource.gallery) {
      final List<XFile> moreFiles = await _picker.pickMultiImage();
      if (moreFiles.isNotEmpty) {
        setState(() {
          _images.addAll(moreFiles.map((x) => File(x.path)));
        });
      }
    } else {
      final XFile? cameraFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (cameraFile != null) {
        setState(() {
          _images.add(File(cameraFile.path));
        });
      }
    }
  }

  void _deleteCurrentImage() {
    if (_images.isEmpty) return;

    if (_images.length == 1) {
      Navigator.of(context).pop(<File>[]);
      return;
    }

    setState(() {
      _images.removeAt(_currentIndex);
      if (_currentIndex >= _images.length) {
        _currentIndex = _images.length - 1;
      }
    });

    _pageController.jumpToPage(_currentIndex);
    _scrollToCurrentThumb(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (_images.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("No images selected",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(<File>[]),
                child: const Text("Go Back"),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top WhatsApp style Action Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(<File>[]),
                  ),
                  Text(
                    "${_currentIndex + 1} of ${_images.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Open Sans",
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: "Crop & Rotate",
                    icon: const Icon(Icons.crop_rotate, color: Colors.white),
                    onPressed: _editCurrentImage,
                  ),
                  IconButton(
                    tooltip: "Edit Photo",
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: _editCurrentImage,
                  ),
                  IconButton(
                    tooltip: "Delete",
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    onPressed: _deleteCurrentImage,
                  ),
                ],
              ),
            ),

            // Main Preview Area (Swipeable PageView)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _scrollToCurrentThumb(index);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: _editCurrentImage,
                    child: Center(
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 3.5,
                        child: Image.file(
                          _images[index],
                          fit: BoxFit.contain,
                          key: ValueKey(_images[index].path),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Edit photo helper pill
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _editCurrentImage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.edit, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        "Tap to edit photo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Open Sans",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Carousel & Send/Done Button
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 12, 10),
              color: const Color(0xFF161616),
              child: Row(
                children: [
                  // Thumbnails list
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ListView.separated(
                        controller: _thumbScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          // Plus / Add more button at end
                          if (index == _images.length) {
                            return InkWell(
                              onTap: _addMoreImages,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.white38, width: 1.2),
                                  color: Colors.white10,
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            );
                          }

                          final isSelected = index == _currentIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                              );
                              _scrollToCurrentThumb(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? (PickColors.primaryColor)
                                      : Colors.transparent,
                                  width: isSelected ? 3.0 : 0.0,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                  key: ValueKey(_images[index].path),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // WhatsApp style Done / Send button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(_images);
                    },
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PickColors.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: PickColors.primaryColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

