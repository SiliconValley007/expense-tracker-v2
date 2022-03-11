import 'package:final_year_project_v2/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:extensions/extensions.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key? key,
    required this.transactionTitle,
    required this.transactionDate,
    required this.transactionAmount,
    required this.onPressed,
    required this.transactionCategoryColor,
    required this.transactionCategory,
  }) : super(key: key);

  final String transactionTitle;
  final DateTime transactionDate;
  final double transactionAmount;
  final VoidCallback onPressed;
  final int transactionCategoryColor;
  final String transactionCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 15.0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).cardColor,
              border: (transactionCategoryColor != 0 &&
                      transactionCategory.isNotEmpty)
                  ? Border.all(
                      color: Color(transactionCategoryColor),
                      width: 2,
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactionTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        dateTimeToString(transactionDate),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  MoneyFormat(transactionAmount).toMoney(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            left: 15.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(transactionCategoryColor),
              ),
              child: Text(transactionCategory),
            ),
          ),
        ],
      ),
    );
  }
}
