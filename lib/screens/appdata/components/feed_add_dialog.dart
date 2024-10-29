import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/services/database/database.dart';
import 'package:myapp/utils/custom_button.dart';
import 'package:myapp/utils/customdialog.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/debuglogs.dart';
import 'package:myapp/utils/touch_responsive_container.dart';

class AddFeedDialog extends StatefulWidget {
  const AddFeedDialog({super.key});

  @override
  State<AddFeedDialog> createState() => _AddFeedDialogState();
}

class _AddFeedDialogState extends State<AddFeedDialog> {
  final TextEditingController writeUpController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages;
  List<Uint8List> _imageBytes = [];
  bool _isPhotoSelected = false;
  bool _isAddingFeed = false;

  Future<void> _selectImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      List<Uint8List> imageBytes = [];
      for (XFile file in pickedImages) {
        Uint8List bytes = await file.readAsBytes();
        for (Uint8List image in _imageBytes) {
          imageBytes.add(image);
        }
        imageBytes.add(bytes);
      }
      setState(() {
        _selectedImages = _selectedImages == null
            ? pickedImages
            : _selectedImages! + pickedImages;
        _imageBytes = imageBytes;
        _isPhotoSelected = true;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageBytes.removeAt(index);
      _selectedImages!.removeAt(index);
      _isPhotoSelected = _selectedImages!.isNotEmpty;
    });
  }

  Map<String, String> image(List<String> imageUrls) {
    Map<String, String> images = {};
    for (int i = 0; i < imageUrls.length; i++) {
      images['$i'] = imageUrls[i];
    }
    return images;
  }

  Future<void> postFeed() async {
    setState(() {
      _isAddingFeed = true;
    });
    List<String> imageUrls = await FirestoreService().uploadFeedImages(
        selectedImages: _selectedImages!, title: titleController.text);
    Map<String, String> images = image(imageUrls);

    // Save the image URLs in Firestore
    if (imageUrls.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('AppData')
          .doc('feeds')
          .collection('feeds')
          .add({
        'title': titleController.text.trim(),
        'writeUp': writeUpController.text.trim(),
        'images': images,
        'time': Timestamp.now(),
      });
      
        debugLog(DebugLevel.info, 'images $images have been deleted sucessfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomActionDialog(
      title: Text(
        _isAddingFeed ? "Adding feed..." : "Add Feed",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: _isAddingFeed
          ? CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text('Title'),
                const SizedBox(height: 10),
                GlowingBorderTextField(
                  controller: titleController,
                ),
                const SizedBox(height: 10),
                const Text('Write Up'),
                const SizedBox(height: 10),
                GlowingBorderTextField(
                  controller: writeUpController,
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Text(_isPhotoSelected ? 'Upload photos' : 'Photo Preview'),
                const SizedBox(height: 10),
                !_isPhotoSelected
                    ? Center(
                        child: TouchResponsiveContainer(
                          height: 100,
                          width: 600,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(149, 42, 45, 62),
                              border: Border.all(
                                  color: const Color.fromARGB(81, 52, 73, 94))),
                          onPressed: _selectImages,
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Color.fromRGBO(52, 73, 94, 1),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 600,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0;
                                  i < _selectedImages!.length;
                                  i++) ...[
                                Stack(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      17, 0, 0, 0),
                                                  blurRadius: 3,
                                                  offset: Offset(2, 2))
                                            ]),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.memory(
                                            _imageBytes[i],
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 130,
                                          ),
                                        )),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: MouseRegion(
                                        onEnter: (_) {
                                          setState(() {});
                                        },
                                        child: GestureDetector(
                                          onTap: () => _removeImage(i),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54,
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 10),
                              ],
                              TouchResponsiveContainer(
                                height: 150,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(149, 42, 45, 62),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            81, 52, 73, 94))),
                                onPressed: _selectImages,
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Color.fromRGBO(52, 73, 94, 1),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
      actions: _isAddingFeed
          ? []
          : [
              const Spacer(),
              const Spacer(),
              MyCustomButtom(
                conerRadius: 8.0,
                backgroundColor: Colors.blue,
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      titleController.text == "") {
                    titleController.text = "Title can not be empty";
                    return;
                  }

                  if (writeUpController.text.isEmpty) {
                    writeUpController.text = "";
                  }

                  await postFeed();
                  Navigator.of(context).pop();
                },
                child: const Text("Add"),
              ),
            ],
    );
  }

  @override
  void dispose() {
    writeUpController.dispose();
    super.dispose();
  }
}

class GlowingBorderTextField extends StatefulWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final String? placeholder;
  final Widget? prefix;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;

  const GlowingBorderTextField(
      {super.key,
      this.controller,
      this.maxLines,
      this.placeholder,
      this.prefix,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted});
  @override
  GlowingBorderTextFieldState createState() => GlowingBorderTextFieldState();
}

class GlowingBorderTextFieldState extends State<GlowingBorderTextField> {
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color.fromARGB(85, 33, 149, 243)
                      .withOpacity(0.4), // Glowing color
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                ),
              ]
            : [],
      ),
      child: CupertinoTextField(
        controller: widget.controller,
        focusNode: _focusNode,
        style: const TextStyle(color: Colors.white),
        maxLines: widget.maxLines,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 42, 45, 62),
          border: Border.all(
            color: _isFocused
                ? Colors.blue // Border color when focused
                : const Color.fromRGBO(52, 73, 94, 1), // Default border color
          ),
        ),
        placeholder: widget.placeholder,
        prefix: widget.prefix,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
      ),
    );
  }
}
