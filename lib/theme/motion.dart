import 'package:flutter/material.dart';

/// Shared motion rules: every animation plays once, eases out, and is
/// skipped entirely when the platform asks for reduced motion.
abstract final class Motion {
  static const Duration countUp = Duration(milliseconds: 1100);
  static const Duration draw = Duration(milliseconds: 1200);
  static const Duration press = Duration(milliseconds: 160);
  static const Duration theme = Duration(milliseconds: 450);
  static const Duration dialog = Duration(milliseconds: 380);

  static bool reduced(BuildContext context) =>
      MediaQuery.of(context).disableAnimations;

  /// [duration], or zero under reduced motion.
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}

/// Number that counts up from 0 to [value] once it scrolls into view,
/// e.g. "฿ 68.45M". Screen readers get only the final value.
class CountUpText extends StatelessWidget {
  final double value;
  final int decimals;
  final String prefix;
  final String suffix;
  final TextStyle style;

  const CountUpText(
    this.value, {
    super.key,
    this.decimals = 0,
    this.prefix = '',
    this.suffix = '',
    required this.style,
  });

  String _format(double v) => '$prefix${v.toStringAsFixed(decimals)}$suffix';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _format(value),
      child: ExcludeSemantics(
        child: PlayOnce(
          duration: Motion.countUp,
          builder: (context, t, _) => Text(_format(value * t), style: style),
        ),
      ),
    );
  }
}

/// Runs a 0 → 1 progress once and hands it to [builder]; [child] is built
/// once and passed through, so only what depends on progress rebuilds.
///
/// Inside a scroll view it waits until it is scrolled into view, so
/// content further down the page animates when the user reaches it rather
/// than unseen at page load.
class PlayOnce extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  final Widget? child;
  final Widget Function(BuildContext context, double t, Widget? child) builder;

  const PlayOnce({
    super.key,
    this.duration = Motion.draw,
    this.curve = Curves.easeOutCubic,
    this.child,
    required this.builder,
  });

  @override
  State<PlayOnce> createState() => _PlayOnceState();
}

class _PlayOnceState extends State<PlayOnce>
    with SingleTickerProviderStateMixin {
  /// How far into the viewport the top edge must be before playing.
  static const double _threshold = 48;

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final CurvedAnimation _curved =
      CurvedAnimation(parent: _controller, curve: widget.curve);
  ScrollPosition? _position;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    if (Motion.reduced(context)) {
      _started = true;
      _controller.value = 1;
      _detach();
      return;
    }
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _detach();
      _position = position?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (!mounted || _started) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final viewport =
        Scrollable.maybeOf(context)?.context.findRenderObject() as RenderBox?;
    if (viewport == null || !viewport.hasSize) {
      _start();
      return;
    }
    final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
    final bottom = top + box.size.height;
    if (top < viewport.size.height - _threshold && bottom > 0) _start();
  }

  void _start() {
    _started = true;
    _detach();
    _controller.forward();
  }

  void _detach() {
    _position?.removeListener(_check);
    _position = null;
  }

  @override
  void dispose() {
    _detach();
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      builder: (context, child) =>
          widget.builder(context, _curved.value, child),
      child: widget.child,
    );
  }
}

/// Reveals [child] from left to right once, e.g. a line being drawn.
class RevealLeftToRight extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const RevealLeftToRight({
    super.key,
    required this.child,
    this.duration = Motion.draw,
  });

  @override
  Widget build(BuildContext context) {
    return PlayOnce(
      duration: duration,
      curve: Curves.easeInOutCubic,
      child: child,
      builder: (context, t, child) =>
          ClipRect(clipper: _WidthClipper(t), child: child),
    );
  }
}

class _WidthClipper extends CustomClipper<Rect> {
  final double fraction;

  _WidthClipper(this.fraction);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(_WidthClipper old) => old.fraction != fraction;
}

/// Sub-range of a 0 → 1 progress, for staggering items in one animation:
/// item [index] of [count] starts a little after the previous one.
double stagger(double t, int index, int count, {double overlap = 0.6}) {
  final span = 1 / (1 + (count - 1) * (1 - overlap));
  final start = index * span * (1 - overlap);
  return ((t - start) / span).clamp(0.0, 1.0);
}
