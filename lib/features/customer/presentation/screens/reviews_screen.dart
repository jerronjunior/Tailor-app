import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_theme.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _rating = 4;
  final _feedbackCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Reviews & Ratings'), backgroundColor: AppColors.thread),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Rate new order ─────────────────────────────────────
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const AvatarCircle(initials: 'RK', size: 44),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('Ravi Kumar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.thread)),
                  Text('Order: Custom Suit — Navy Blue', style: TextStyle(fontSize: 12, color: AppColors.taupe)),
                ]),
              ]),
              const SizedBox(height: 16),
              const SectionLabel('Your Rating'),
              Row(
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 32,
                      color: i < _rating ? AppColors.gold : Colors.black20,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 16),
              const Text('Write your feedback', style: TextStyle(fontSize: 12, color: AppColors.taupe, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(
                controller: _feedbackCtrl,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Share your experience — fit, quality, communication…'),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _submitReview(context),
                icon: const Icon(Icons.send_outlined, size: 16),
                label: const Text('Submit Review'),
              ),
            ]),
          ),

          // ── Past reviews ───────────────────────────────────────
          const SectionLabel('Past Reviews'),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Ravi Kumar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.thread)),
                _StarRow(rating: 5),
              ]),
              const SizedBox(height: 8),
              const Text('"Perfect fit, excellent stitching quality. Will order again for the wedding suits!"', style: TextStyle(fontSize: 13, color: AppColors.taupe, height: 1.5, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              const Text('Apr 8 · Slim Fit Trousers', style: TextStyle(fontSize: 11, color: AppColors.taupe)),
            ]),
          ),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Priya Sharma', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.thread)),
                _StarRow(rating: 5),
              ]),
              const SizedBox(height: 8),
              const Text('"Beautiful saree blouse, exactly as I described. The fit was flawless and delivery was on time."', style: TextStyle(fontSize: 13, color: AppColors.taupe, height: 1.5, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              const Text('Mar 22 · Saree Blouse', style: TextStyle(fontSize: 11, color: AppColors.taupe)),
            ]),
          ),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Ravi Kumar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.thread)),
                _StarRow(rating: 4),
              ]),
              const SizedBox(height: 8),
              const Text('"Good quality work but delivery was one day late. Will still order again."', style: TextStyle(fontSize: 13, color: AppColors.taupe, height: 1.5, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              const Text('Feb 14 · Kurta Pyjama', style: TextStyle(fontSize: 11, color: AppColors.taupe)),
            ]),
          ),
        ]),
      ),
    );
  }

  void _submitReview(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Review submitted! Thank you.'),
        backgroundColor: AppColors.badgeGreenText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
    setState(() { _rating = 0; _feedbackCtrl.clear(); });
  }
}

class _StarRow extends StatelessWidget {
  final int rating;
  const _StarRow({required this.rating});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Icon(i < rating ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: i < rating ? AppColors.gold : Colors.black20)),
    );
  }
}
