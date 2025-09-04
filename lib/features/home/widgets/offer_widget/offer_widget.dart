import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OfferWidget extends StatelessWidget {
  final int totalOrders;
  final int stock;

  const OfferWidget({
    super.key,
    required this.totalOrders,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    int remaining = totalOrders - (totalOrders - stock);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // 🎁 Icon
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child:
            // Lottie.asset(
            //   'assets/deal.json',
            //   width: 10,
            //   height: 10,
            //   fit: BoxFit.contain,
            // )
            Icon(Icons.local_offer, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),

          // 📖 Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Limited Time Offer 🎉",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "First $totalOrders orders get special discount.\n"
                      "Remaining: $stock orders",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // 🔥 Remaining badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$stock left",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
