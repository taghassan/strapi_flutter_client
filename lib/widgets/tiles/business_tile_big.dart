import 'package:bapp/classes/firebase_structures/business_branch.dart';
import 'package:bapp/config/constants.dart';
import 'package:flutter/material.dart';

import '../firebase_image.dart';

class BusinessTileBigWidget extends StatelessWidget {
  final BusinessBranch branch;
  final Widget tag;
  final Function onTap;

  const BusinessTileBigWidget(
      {Key key, this.branch, @required this.tag, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: cons.maxWidth,
              height: cons.maxWidth * (9 / 16),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    RRFirebaseStorageImage(
                      storagePathOrURL: branch.images.isNotEmpty
                          ? branch.images.keys.elementAt(0)
                          : null,
                      ifEmpty: Initial(forName: branch.name.value,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: tag,
                    )
                  ],
                ),
              ),
            ),
            BusinessTileWidget(
              branch: branch,
              onTap: () {},
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            ),
          ],
        ),
      );
    });
  }
}

class BusinessTileWidget extends StatelessWidget {
  final bool withImage;
  final BusinessBranch branch;
  final Function onTap;
  final EdgeInsets padding;
  final TextStyle titleStyle;
  final Function onTrailingTapped;

  const BusinessTileWidget(
      {Key key,
      @required this.branch,
      @required this.onTap,
      this.padding,
      this.titleStyle, this.withImage=false,
        this.onTrailingTapped
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: padding ?? EdgeInsets.zero,
      title: Text(
        branch.name.value,
        style: titleStyle,
        maxLines: 1,
      ),
      subtitle: Text(
        branch.address.value,
        maxLines: 1,
      ),
      leading: withImage? ListTileFirebaseImage(
        ifEmpty: Initial(forName: branch.name.value,),
        storagePathOrURL: branch.images.isNotEmpty?branch.images.keys.elementAt(0):null,
      ):null,
      trailing: GestureDetector(
        onTap: onTrailingTapped,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.star,
                color: Colors.amber
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              branch.rating.value.toString(),
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}
