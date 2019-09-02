import 'package:flutter_web/gestures.dart';
import 'package:flutter_web/material.dart';
import 'package:linkify/linkify.dart';

export 'package:linkify/linkify.dart'
    show
        LinkifyElement,
        LinkableElement,
        LinkElement,
        EmailElement,
        TextElement,
        LinkType;

/// Callback clicked link
typedef LinkCallback(LinkableElement link);

/// Turns URLs into links
class Linkify extends StatelessWidget {
  /// Text to be linkified
  final String text;

  /// Enables some types of links (URL, email).
  /// Will default to all (if `null`).
  final List<LinkType> linkTypes;

  /// Callback for tapping a link
  final LinkCallback onOpen;

  /// Removes http/https from shown URLS.
  /// Will default to `false` (if `null`)
  final bool humanize;

  // TextSpan

  /// Style for non-link text
  final TextStyle style;

  /// Style of link text
  final TextStyle linkStyle;

  // RichText

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Text direction of the text
  final TextDirection textDirection;

  final int maxLines;
  final TextOverflow overflow;

  /// Text scale factor
  final double textScaleFactor;

  const Linkify({
    Key key,
    this.text,
    this.linkTypes,
    this.onOpen,
    this.humanize,
    // TextSpawn
    this.style,
    this.linkStyle,
    // RichText
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textScaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final elements = linkify(
      text,
      humanize: humanize,
      linkTypes: linkTypes,
    );

    return RichText(
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      textScaleFactor:
          textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
      text: buildTextSpan(
        elements,
        style: Theme.of(context).textTheme.body1.merge(style),
        onOpen: onOpen,
        linkStyle: Theme.of(context)
            .textTheme
            .body1
            .merge(style)
            .copyWith(
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
            )
            .merge(linkStyle),
      ),
    );
  }
}

/// Raw TextSpan builder for more control on the RichText
TextSpan buildTextSpan(
  List<LinkifyElement> elements, {
  TextStyle style,
  TextStyle linkStyle,
  LinkCallback onOpen,
}) {
  return TextSpan(
    children: elements.map<TextSpan>(
      (element) {
        if (element is LinkableElement) {
          return TextSpan(
            text: element.text,
            style: linkStyle,
            recognizer: onOpen != null
                ? (TapGestureRecognizer()..onTap = () => onOpen(element))
                : null,
          );
        } else {
          return TextSpan(
            text: element.text,
            style: style,
          );
        }
      },
    ).toList(),
  );
}
