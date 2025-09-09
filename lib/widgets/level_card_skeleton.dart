import 'package:flutter/material.dart';

class LevelCardSkeleton extends StatefulWidget {
  final int itemCount;

  const LevelCardSkeleton({
    Key? key,
    this.itemCount = 3,
  }) : super(key: key);

  @override
  State<LevelCardSkeleton> createState() => _LevelCardSkeletonState();
}

class _LevelCardSkeletonState extends State<LevelCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          _buildHeaderSkeleton(),
          const SizedBox(height: 16),

          // Level cards skeleton
          Column(
            children: List.generate(widget.itemCount, (index) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: 16,
                  left: (index % 2 == 0) ? 0 : 8,
                  right: (index % 2 == 0) ? 8 : 0,
                ),
                child: _buildLevelCardSkeleton(index),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerContainer(
                width: 150,
                height: 28,
                borderRadius: 8,
              ),
              const SizedBox(height: 8),
              _buildShimmerContainer(
                width: 180,
                height: 14,
                borderRadius: 4,
              ),
            ],
          ),
          _buildShimmerContainer(
            width: 40,
            height: 40,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCardSkeleton(int index) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[200]!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Base card content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildShimmerContainer(
                          width: 60,
                          height: 24,
                          borderRadius: 12,
                        ),
                        _buildShimmerContainer(
                          width: 36,
                          height: 36,
                          borderRadius: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    _buildShimmerContainer(
                      width: 140,
                      height: 20,
                      borderRadius: 6,
                    ),
                    const SizedBox(height: 6),

                    // Description lines
                    _buildShimmerContainer(
                      width: double.infinity,
                      height: 12,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(
                      width: 180,
                      height: 12,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 16),

                    // Progress section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildShimmerContainer(
                          width: 60,
                          height: 12,
                          borderRadius: 4,
                        ),
                        _buildShimmerContainer(
                          width: 30,
                          height: 14,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildShimmerContainer(
                      width: double.infinity,
                      height: 6,
                      borderRadius: 3,
                    ),
                  ],
                ),
              ),

              // Shimmer overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: AnimatedBuilder(
                    animation: _shimmerAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            stops: [
                              0.0,
                              0.5 + (_shimmerAnimation.value * 0.5),
                              1.0,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    required double borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
