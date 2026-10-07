import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';
import 'motion.dart';

// =====================================================================
//  SURFACES
// =====================================================================

/// A neumorphic surface on the page background.
///
/// * raised (default) — extruded: dark shadow bottom-right, light top-left.
/// * [inset] — pressed in: the same two shadows painted inside the edge.
///   Used for wells that hold content (tables, charts, progress tracks)
///   and for the selected state of controls.
class NeuBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool inset;

  /// Shadow offset; larger reads as deeper.
  final double distance;
  final double? width;
  final double? height;

  const NeuBox({
    super.key,
    this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.inset = false,
    this.distance = 9,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final content = Padding(padding: padding, child: child);
    if (inset) {
      return CustomPaint(
        painter: _InsetPainter(
          radius: radius,
          color: p.bg,
          dark: p.shadowDark,
          light: p.shadowLight,
          outline: p.outline,
          distance: distance,
        ),
        child: SizedBox(width: width, height: height, child: content),
      );
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(radius),
        border: p.outline.alpha == 0 ? null : Border.all(color: p.outline),
        boxShadow: p.raised(distance),
      ),
      child: content,
    );
  }
}

/// Flutter has no inset BoxShadow, so pressed-in surfaces paint their own:
/// a blurred frame around the shape, offset and clipped to the inside.
class _InsetPainter extends CustomPainter {
  final double radius;
  final Color color;
  final Color dark;
  final Color light;
  final Color outline;
  final double distance;

  _InsetPainter({
    required this.radius,
    required this.color,
    required this.dark,
    required this.light,
    required this.outline,
    required this.distance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rrect, Paint()..color = color);

    final sigma = Shadow.convertRadiusToSigma(distance * 2);
    void shadow(Color c, Offset offset) {
      final frame = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rect.inflate(distance * 4))
        ..addRRect(rrect.shift(offset));
      canvas.drawPath(
        frame,
        Paint()
          ..color = c
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma),
      );
    }

    canvas.save();
    canvas.clipRRect(rrect);
    shadow(dark, Offset(distance, distance));
    shadow(light, Offset(-distance, -distance));
    canvas.restore();

    if (outline.alpha != 0) {
      canvas.drawRRect(
        rrect.deflate(0.5),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = outline,
      );
    }
  }

  @override
  bool shouldRepaint(_InsetPainter old) =>
      old.radius != radius ||
      old.color != color ||
      old.dark != dark ||
      old.light != light ||
      old.outline != outline ||
      old.distance != distance;
}

/// A neumorphic control: raised at rest, pressed in while held or when
/// [selected]. Keyboard focusable, with an accent focus ring.
class NeuButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  final double radius;
  final double distance;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;
  final String? tooltip;
  final double? width;
  final double? height;

  const NeuButton({
    super.key,
    required this.child,
    required this.onTap,
    this.selected = false,
    this.radius = 18,
    this.distance = 5,
    this.padding = EdgeInsets.zero,
    this.semanticLabel,
    this.tooltip,
    this.width,
    this.height,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final inset = widget.selected || _pressed;
    // Depth runs smoothly from raised (+distance) through flat (0) to
    // pressed in (−), so the surface sinks instead of snapping.
    final depth = inset ? -widget.distance * 0.8 : widget.distance;
    Widget box = TweenAnimationBuilder<double>(
      tween: Tween(begin: depth, end: depth),
      duration: Motion.of(context, Motion.press),
      curve: Curves.easeOut,
      child: widget.child,
      builder: (context, d, child) => NeuBox(
        inset: d < 0,
        radius: widget.radius,
        distance: d.abs(),
        padding: widget.padding,
        width: widget.width,
        height: widget.height,
        child: child,
      ),
    );
    if (_focused) {
      box = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: p.accent, width: 2),
        ),
        child: box,
      );
    }

    Widget result = FocusableActionDetector(
      enabled: widget.onTap != null,
      mouseCursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) => widget.onTap?.call(),
        ),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: box,
      ),
    );
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.semanticLabel,
      child: result,
    );
  }
}

// =====================================================================
//  SMALL PIECES
// =====================================================================

/// Small raised pill with colored text. Always a text label, so meaning
/// never depends on color alone.
class NeuChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool dot;

  const NeuChip({
    super.key,
    required this.label,
    required this.color,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      radius: 999,
      distance: 3,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Text(dot ? '● $label' : label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: p.onAccent(color))),
    );
  }
}

/// Pressed-in well holding an accent-colored icon.
class NeuIconWell extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const NeuIconWell(this.icon, this.color, {super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return NeuBox(
      inset: true,
      radius: size * 0.33,
      distance: 4,
      width: size,
      height: size,
      child: Center(
        child: Icon(icon, size: size * 0.5, color: p.onAccent(color)),
      ),
    );
  }
}

/// Fades and slides its child in once, when it scrolls into view;
/// [index] staggers sections that appear together.
/// Shows the child immediately when the platform asks for reduced motion.
class FadeSlideIn extends StatelessWidget {
  final int index;
  final Widget child;

  const FadeSlideIn({super.key, required this.index, required this.child});

  static const _step = 70;
  static const _length = 420;

  @override
  Widget build(BuildContext context) {
    final total = _length + index * _step;
    final curve =
        Interval(index * _step / total, 1, curve: Curves.easeOutCubic);
    return PlayOnce(
      duration: Duration(milliseconds: total),
      curve: curve,
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: FractionalTranslation(
          translation: Offset(0, 0.04 * (1 - t)),
          child: child,
        ),
      ),
    );
  }
}

/// Shuttle shown while a Hero flies between a card and a dialog sheet:
/// a bare raised surface that morphs size and position, with the content
/// fading in only once it has landed.
Widget _neuHeroShuttle(BuildContext flightContext, Animation<double> animation,
    HeroFlightDirection direction, BuildContext from, BuildContext to) {
  return const NeuBox(radius: 24);
}

/// Hero wrapper that uses the neumorphic flight shuttle.
class NeuHero extends StatelessWidget {
  final Object tag;
  final Widget child;

  const NeuHero({super.key, required this.tag, required this.child});

  @override
  Widget build(BuildContext context) {
    return Hero(tag: tag, flightShuttleBuilder: _neuHeroShuttle, child: child);
  }
}

/// Modal dialog on a raised neumorphic sheet.
///
/// With [heroTag], the sheet grows out of the [NeuHero] with the same tag
/// (e.g. the card that was tapped) and shrinks back into it on close.
Future<void> showNeuDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  Object? heroTag,
}) {
  final p = AppPalette.of(context);
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: p.scrim,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: Motion.of(context, Motion.dialog),
      reverseTransitionDuration: Motion.of(context, Motion.dialog),
      transitionsBuilder: (context, animation, _, child) => heroTag != null
          ? child
          : FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween(begin: 0.96, end: 1.0).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              ),
            ),
      pageBuilder: (context, animation, _) {
        final p = AppPalette.of(context);
        // Content appears after the sheet has (mostly) finished growing.
        final contentOpacity = heroTag == null
            ? const AlwaysStoppedAnimation(1.0)
            : CurvedAnimation(
                parent: animation, curve: const Interval(0.55, 1));
        Widget sheet = NeuBox(
          radius: 28,
          padding: const EdgeInsets.fromLTRB(26, 22, 18, 24),
          child: FadeTransition(
            opacity: contentOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(title,
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: p.textStrong)),
                      ),
                    ),
                    NeuButton(
                      tooltip: 'Close',
                      semanticLabel: 'Close',
                      width: 44,
                      height: 44,
                      radius: 14,
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Icon(Icons.close_rounded,
                            size: 20, color: p.textMuted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: content,
                ),
              ],
            ),
          ),
        );
        if (heroTag != null) sheet = NeuHero(tag: heroTag, child: sheet);
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Material(type: MaterialType.transparency, child: sheet),
            ),
          ),
        );
      },
    ),
  );
}
