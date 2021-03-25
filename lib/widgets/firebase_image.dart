import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:bapp/config/config.dart';
import 'package:bapp/helpers/helper.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FirebaseStorageImage extends StatefulWidget {
  final String storagePathOrURL;
  final BoxFit fit;
  final double height;
  final double width;
  final Widget? ifEmpty;

  const FirebaseStorageImage({
    Key? key,
    required this.storagePathOrURL,
    this.fit = BoxFit.cover,
    this.height = 0,
    this.width = 0,
    this.ifEmpty,
  })  : assert((storagePathOrURL != null) || (ifEmpty != null)),
        super(key: key);

  @override
  _FirebaseStorageImageState createState() => _FirebaseStorageImageState();
}

class _FirebaseStorageImageState extends State<FirebaseStorageImage> {
  final _memoizer = AsyncMemoizer<Uint8List?>();

  @override
  void initState() {
    if (!isNullOrEmpty(widget.storagePathOrURL)) {
      _mem();
    }
    super.initState();
  }

  void _mem() {
    _memoizer.runOnce(() async {
      final file =
          await DefaultCacheManager().getFileFromCache(widget.storagePathOrURL);
      if (file != null) {
        return file.file.readAsBytes();
      } else if (widget.storagePathOrURL.startsWith("http")) {
        return (await DefaultCacheManager()
                .downloadFile(widget.storagePathOrURL))
            .file
            .readAsBytes();
      } else {
        return null;
        /* final i = FirebaseStorage.instance;
        final data = await i
            .ref()
            .child(
              widget.storagePathOrURL,
            )
            .getData(1024 * 1024 * 2);
        final newFile =
            await DefaultCacheManager().putFile(widget.storagePathOrURL, data);
        return newFile.readAsBytes(); */
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, cons) {
        if (isNullOrEmpty(widget.storagePathOrURL)) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: widget.ifEmpty,
          );
        }
        return FutureBuilder<Uint8List?>(
          future: _memoizer.future,
          builder: (_, snap) {
            final data = snap.data ?? Uint8List(0);
            if (snap.hasData) {
              return Image.memory(
                data,
                fit: widget.fit,
                width: widget.width,
                height: widget.height,
              );
            }
            return SizedBox(
              height: widget.height,
              width: widget.width,
              child: _getLoader(),
            );
          },
        );
      },
    );
  }

  Widget _getLoader() {
    return Center(
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class ListTileFirebaseImage extends StatelessWidget {
  final String? storagePathOrURL;
  final Widget? ifEmpty;

  const ListTileFirebaseImage({Key? key, this.storagePathOrURL, this.ifEmpty})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RRFirebaseStorageImage(
      height: 48,
      width: 48,
      storagePathOrURL: storagePathOrURL,
      ifEmpty: ifEmpty,
      fit: BoxFit.contain,
    );
  }
}

class RRFirebaseStorageImage extends StatelessWidget {
  final String? storagePathOrURL;
  final double width, height;
  final BoxFit fit;
  final Widget? ifEmpty;

  const RRFirebaseStorageImage({
    Key? key,
    this.storagePathOrURL,
    this.width = 0,
    this.height = 0,
    required this.fit,
    this.ifEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: FirebaseStorageImage(
        width: width,
        height: height,
        storagePathOrURL: storagePathOrURL ?? "",
        fit: fit,
        ifEmpty: ifEmpty,
      ),
    );
  }
}

class Initial extends StatelessWidget {
  final String forName;

  const Initial({Key? key, required this.forName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CardsColor.next(uid: forName),
      alignment: Alignment.center,
      child: Text(
        ((forName.length) > 2 ? forName.substring(0, 2) : ":)"),
        textAlign: TextAlign.center,
        style:
            Theme.of(context).textTheme.subtitle1?.apply(color: Colors.white),
      ),
    );
  }
}
