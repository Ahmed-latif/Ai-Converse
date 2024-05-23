import 'dart:typed_data';

import 'package:ai_converse_chatbot_app/Image%20Generator/Views/art_screen.dart';
import 'package:ai_converse_chatbot_app/Image%20Generator/service/open_source_image.dart';
import 'package:ai_converse_chatbot_app/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  String? dropValue;
  var quality = ['Small', 'Medium', 'Large'];
  var values = ['256256x', '512x512', '1024x1024'];
  var textController = TextEditingController();
  bool isLoaded = false;
  String? image;

  ScreenshotController screenshotController = ScreenshotController();

  shareImage() async {
    await screenshotController
        .capture(delay: Duration(milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        final filename = "ai-converse-share.png";
        final imagepath = await File("${directory}/$filename").create();
        await imagepath.writeAsBytes(img);

        Share.shareFiles([imagepath.path],
            text: "Generated By AIConverse Chatbot App");
      } else {
        print('Failed');
      }
    });
  }

  downloadImg() async {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      const foldername = "AIConverse";
      final path = Directory("storage/emulated/0/DCIM/$foldername");
      final filename = "${DateTime.now().millisecondsSinceEpoch}.png";

      if (await path.exists()) {
        await screenshotController.captureAndSave(path.path,
            delay: const Duration(milliseconds: 100),
            fileName: filename,
            pixelRatio: 1.0);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The image is downloaded to ${path.path}')));
      } else {
        await path.create();
        await screenshotController.captureAndSave(path.path,
            delay: const Duration(milliseconds: 100),
            fileName: filename,
            pixelRatio: 1.0);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The image is downloaded to ${path.path}')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Permission Denied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        title: Text(
          "Image Generator",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 151, 54, .8),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArtScreen()));
                      },
                      child: Text(
                        'My Arts',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ))))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  Expanded(
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 214, 214, 214),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            style: GoogleFonts.poppins(
                                fontSize: 20, color: Colors.black),
                            controller: textController,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                                hintText: 'e.g.. Cat on Moon',
                                border: InputBorder.none),
                          ))),
                  SizedBox(
                    width: 12,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 214, 214),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Icon(
                          Icons.expand_more_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        value: dropValue,
                        hint: Text(
                          'Select Quality',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        items: List.generate(
                            quality.length,
                            (index) => DropdownMenuItem(
                                value: values[index],
                                child: Text(
                                  quality[index],
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ))),
                        onChanged: (value) {
                          setState(() {
                            dropValue = value.toString();
                          });
                        },
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 15,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 151, 54, .8),
                        borderRadius: BorderRadius.circular(12)),
                    child: TextButton(
                      onPressed: () async {
                        if (textController.text.isNotEmpty &&
                            dropValue!.isNotEmpty) {
                          setState(() {
                            isLoaded = false;
                          });
                          image = await OpenSourceImage.generateImage(
                              textController.text, dropValue!);
                          setState(() {
                            isLoaded = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Pass Query and Select Qulaity')));
                        }
                      },
                      child: Text(
                        'Generate',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                )
              ],
            )),
            Expanded(
              flex: 3,
              child: isLoaded
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 214, 214, 214),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Screenshot(
                                controller: screenshotController,
                                child: Image.network(
                                  image!,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MyButton(
                                  title: 'Download',
                                  onPressed: () async {
                                    await downloadImg();
                                  },
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(0, 151, 54, .8)),
                                  onPressed: () async {
                                    await shareImage();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Shared')));
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Share',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ))
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromARGB(255, 214, 214, 214)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/loading.gif',
                            height: 150,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Wait.. AIConverse is generating a image...',
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
