import 'package:flutter/material.dart';
import 'package:univalle_app/config/themes/app_colors.dart';

class SeparatorTicket extends StatelessWidget {
  const SeparatorTicket({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 150),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            ' .' * 200,
                            style: const TextStyle(
                                height: 1,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryRed),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
