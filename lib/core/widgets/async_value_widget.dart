import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_error_view.dart';
import 'shimmer/app_shimmer.dart';
import 'shimmer/skeleton_list.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.skeleton,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: false,
      data: data,
      loading: () => AppShimmer(child: skeleton ?? const SkeletonList()),
      error: (error, stackTrace) =>
          AppErrorView(error: error, onRetry: onRetry),
    );
  }
}
