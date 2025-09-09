import 'package:flutter/material.dart';

class StaggeredAnimationWrapper extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double slideDistance;
  final bool slideFromBottom;
  final bool fadeIn;
  final bool scaleIn;

  const StaggeredAnimationWrapper({
    Key? key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.slideDistance = 50.0,
    this.slideFromBottom = true,
    this.fadeIn = true,
    this.scaleIn = false,
  }) : super(key: key);

  @override
  State<StaggeredAnimationWrapper> createState() =>
      _StaggeredAnimationWrapperState();
}

class _StaggeredAnimationWrapperState extends State<StaggeredAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Create slide animation
    _slideAnimation = Tween<double>(
      begin:
          widget.slideFromBottom ? widget.slideDistance : -widget.slideDistance,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    ));

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: widget.fadeIn ? 0.0 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    ));

    // Create scale animation
    _scaleAnimation = Tween<double>(
      begin: widget.scaleIn ? 0.8 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    ));

    // Start animation with delay based on index
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(widget.delay * widget.index);
    if (mounted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class StaggeredGridAnimationWrapper extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Duration animationDelay;
  final Duration animationDuration;
  final Curve animationCurve;

  const StaggeredGridAnimationWrapper({
    Key? key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16.0,
    this.crossAxisSpacing = 16.0,
    this.animationDelay = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  State<StaggeredGridAnimationWrapper> createState() =>
      _StaggeredGridAnimationWrapperState();
}

class _StaggeredGridAnimationWrapperState
    extends State<StaggeredGridAnimationWrapper> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildRows(),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];
    for (int i = 0; i < widget.children.length; i += widget.crossAxisCount) {
      List<Widget> rowChildren = [];
      for (int j = 0;
          j < widget.crossAxisCount && (i + j) < widget.children.length;
          j++) {
        rowChildren.add(
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right:
                    j < widget.crossAxisCount - 1 ? widget.crossAxisSpacing : 0,
              ),
              child: StaggeredAnimationWrapper(
                index: i + j,
                delay: widget.animationDelay,
                duration: widget.animationDuration,
                curve: widget.animationCurve,
                fadeIn: true,
                scaleIn: true,
                slideFromBottom: true,
                child: widget.children[i + j],
              ),
            ),
          ),
        );
      }

      // Add empty expanded widgets to fill the row if needed
      while (rowChildren.length < widget.crossAxisCount) {
        rowChildren.add(const Expanded(child: SizedBox()));
      }

      rows.add(
        Container(
          margin: EdgeInsets.only(
            bottom: i + widget.crossAxisCount < widget.children.length
                ? widget.mainAxisSpacing
                : 0,
          ),
          child: Row(
            children: rowChildren,
          ),
        ),
      );
    }
    return rows;
  }
}

class StaggeredListAnimationWrapper extends StatefulWidget {
  final List<Widget> children;
  final Duration animationDelay;
  final Duration animationDuration;
  final Curve animationCurve;
  final double spacing;
  final bool alternateDirection;

  const StaggeredListAnimationWrapper({
    Key? key,
    required this.children,
    this.animationDelay = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutCubic,
    this.spacing = 16.0,
    this.alternateDirection = false,
  }) : super(key: key);

  @override
  State<StaggeredListAnimationWrapper> createState() =>
      _StaggeredListAnimationWrapperState();
}

class _StaggeredListAnimationWrapperState
    extends State<StaggeredListAnimationWrapper> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildAnimatedChildren(),
    );
  }

  List<Widget> _buildAnimatedChildren() {
    List<Widget> animatedChildren = [];

    for (int i = 0; i < widget.children.length; i++) {
      animatedChildren.add(
        StaggeredAnimationWrapper(
          index: i,
          delay: widget.animationDelay,
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          fadeIn: true,
          scaleIn: false,
          slideFromBottom: widget.alternateDirection ? (i % 2 == 0) : true,
          slideDistance: 30.0,
          child: widget.children[i],
        ),
      );

      // Add spacing between items (except after the last item)
      if (i < widget.children.length - 1) {
        animatedChildren.add(SizedBox(height: widget.spacing));
      }
    }

    return animatedChildren;
  }
}
