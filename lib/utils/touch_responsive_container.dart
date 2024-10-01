import 'package:flutter/material.dart';

class TouchResponsiveContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final double? height;
  final double? width;

  const TouchResponsiveContainer(
      {super.key,
      required this.child,
      this.onPressed,
      this.borderRadius,
      this.color,
      this.padding,
      this.decoration,
      this.height,
      this.width})
      : assert(borderRadius == null || decoration == null);

  @override
  State<TouchResponsiveContainer> createState() =>
      _TouchResponsiveContainerState();
}

class _TouchResponsiveContainerState extends State<TouchResponsiveContainer>
    with SingleTickerProviderStateMixin {
  // Eyeballed values. Feel free to tweak.
  static const Duration kFadeOutDuration = Duration(milliseconds: 120);
  static const Duration kFadeInDuration = Duration(milliseconds: 180);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);
  final EdgeInsets _kButtonPadding = const EdgeInsets.all(4.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(TouchResponsiveContainer old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = 0.5;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) {
      return;
    }
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0,
            duration: kFadeOutDuration, curve: Curves.easeInOutCubicEmphasized)
        : _animationController.animateTo(0.0,
            duration: kFadeInDuration, curve: Curves.easeOutCubic);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) {
        _animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: Semantics(
          button: true,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: DecoratedBox(
              decoration: widget.decoration == null
                  ? BoxDecoration(
                      borderRadius: widget.borderRadius,
                      color: widget.color,
                    )
                  : widget.decoration!,
              child: (widget.height == null && widget.width == null)
                  ? Padding(
                      padding: (widget.padding == null)
                          ? _kButtonPadding
                          : widget.padding!,
                      child: widget.child,
                    )
                  : SizedBox(
                      height: widget.height,
                      width: widget.width,
                      child: Padding(
                        padding: (widget.padding == null)
                            ? _kButtonPadding
                            : widget.padding!,
                        child: widget.child,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
