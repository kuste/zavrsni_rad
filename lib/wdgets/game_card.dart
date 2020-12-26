import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String year;
  final String rank;
  final double height;

  const GameCard({
    this.imageUrl,
    this.title,
    this.year,
    this.rank,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Image.asset('assets/images/loader.gif'),
                    fit: BoxFit.fill,
                    alignment: Alignment.centerLeft,
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        'assets/images/no_image.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          title,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Text(
                          '($year)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
