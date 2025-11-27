
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class SavingsGoal {
  const SavingsGoal({required this.title, required this.current, required this.target, required this.progress, required this.icon});
  final String title;
  final String current;
  final String target;
  final double progress;
  final IconData icon;
}

class Loan {
  const Loan({required this.bank, required this.total, required this.remaining, required this.nextEmiDate, required this.emi, required this.progress});
  final String bank;
  final String total;
  final String remaining;
  final String nextEmiDate;
  final String emi;
  final double progress;
}

class TransactionEntry {
  const TransactionEntry({required this.title, required this.amount, required this.date, required this.isIncome, required this.status, required this.icon, required this.color});
  final String title;
  final num amount;
  final String date;
  final bool isIncome;
  final String status;
  final IconData icon;
  final Color color;
}

class ProfitPoint {
  const ProfitPoint({required this.label, required this.value});
  final String label;
  final double value;
}

class CropProfit {
  const CropProfit({required this.icon, required this.name, required this.roi, required this.investment, required this.revenue, required this.profit});
  final IconData icon;
  final String name;
  final String roi;
  final String investment;
  final String revenue;
  final String profit;
}

class ExpenseCategory {
  const ExpenseCategory({required this.label, required this.amount, required this.percent, required this.color});
  final String label;
  final String amount;
  final double percent;
  final Color color;
}

class UpcomingPayment {
  const UpcomingPayment({required this.title, required this.date, required this.amount, required this.status, required this.icon, required this.color});
  final String title;
  final String date;
  final String amount;
  final String status;
  final IconData icon;
  final Color color;
}

enum _Range { month, quarter, year }
class PersonalFinanceScreen extends StatefulWidget {
  const PersonalFinanceScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<PersonalFinanceScreen> createState() => _PersonalFinanceScreenState();
}

class _PersonalFinanceScreenState extends State<PersonalFinanceScreen> {
  final List<SavingsGoal> goals = const [
    SavingsGoal(title: 'New Tractor', current: '₹2,85,000', target: '₹5,00,000', progress: 0.57, icon: Icons.agriculture),
    SavingsGoal(title: 'Drip Irrigation', current: '₹1,20,000', target: '₹1,50,000', progress: 0.8, icon: Icons.water_drop),
    SavingsGoal(title: 'Emergency Fund', current: '₹75,000', target: '₹1,00,000', progress: 0.75, icon: Icons.shield_outlined),
  ];

  final List<Loan> loans = const [
    Loan(bank: 'Punjab National Bank', total: '₹2,00,000', remaining: '₹80,000', nextEmiDate: 'Jan 1, 2025', emi: '₹12,000', progress: 0.6),
    Loan(bank: 'SBI Kisan Credit', total: '₹1,00,000', remaining: '₹35,000', nextEmiDate: 'Jan 5, 2025', emi: '₹8,000', progress: 0.65),
  ];

  final List<TransactionEntry> transactions = const [
    TransactionEntry(title: 'Cotton Harvest Sale', amount: 75000, date: 'Dec 18, 2024', isIncome: true, status: 'Completed', icon: LucideIcons.sprout, color: Colors.green),
    TransactionEntry(title: 'Fertilizer Purchase', amount: -12000, date: 'Dec 15, 2024', isIncome: false, status: 'Completed', icon: Icons.shopping_bag, color: Colors.orange),
    TransactionEntry(title: 'Wheat Sale', amount: 45000, date: 'Dec 12, 2024', isIncome: true, status: 'Completed', icon: LucideIcons.wheat, color: Colors.green),
    TransactionEntry(title: 'Labor Wages', amount: -8500, date: 'Dec 10, 2024', isIncome: false, status: 'Completed', icon: Icons.work, color: Colors.orange),
    TransactionEntry(title: 'Equipment Repair', amount: -5000, date: 'Dec 8, 2024', isIncome: false, status: 'Pending', icon: Icons.build, color: Colors.red),
  ];

  final List<ProfitPoint> yearlyProfit = const [
    ProfitPoint(label: 'Jul', value: 18000),
    ProfitPoint(label: 'Aug', value: 21000),
    ProfitPoint(label: 'Sep', value: 23000),
    ProfitPoint(label: 'Oct', value: 25000),
    ProfitPoint(label: 'Nov', value: 26000),
    ProfitPoint(label: 'Dec', value: 28000),
  ];

  final List<CropProfit> cropProfits = const [
    CropProfit(icon: LucideIcons.sprout, name: 'Cotton', roi: '62.5%', investment: '₹85,000', revenue: '₹1,60,000', profit: '₹75,000'),
    CropProfit(icon: LucideIcons.wheat, name: 'Wheat', roi: '53.3%', investment: '₹75,000', revenue: '₹1,15,000', profit: '₹40,000'),
    CropProfit(icon: LucideIcons.bean, name: 'Soybean', roi: '35.6%', investment: '₹62,000', revenue: '₹1,05,000', profit: '₹43,000'),
    CropProfit(icon: LucideIcons.carrot, name: 'Vegetables', roi: '187.5%', investment: '₹32,000', revenue: '₹92,000', profit: '₹60,000'),
  ];

  final List<ExpenseCategory> expenses = const [
    ExpenseCategory(label: 'Seeds & Fertilizers', amount: '₹95,000', percent: 35.6, color: Colors.orange),
    ExpenseCategory(label: 'Labor', amount: '₹78,000', percent: 29.2, color: Colors.blue),
    ExpenseCategory(label: 'Irrigation', amount: '₹42,000', percent: 15.7, color: Colors.green),
    ExpenseCategory(label: 'Equipment', amount: '₹35,000', percent: 13.1, color: Colors.red),
    ExpenseCategory(label: 'Others', amount: '₹17,000', percent: 6.4, color: Colors.purple),
  ];

  final List<UpcomingPayment> upcomingPayments = const [
    UpcomingPayment(title: 'Fertilizer Payment', date: 'Dec 25, 2024', amount: '₹15,000', status: 'Pending', icon: Icons.shopping_bag, color: Colors.orange),
    UpcomingPayment(title: 'Labor Wages', date: 'Dec 28, 2024', amount: '₹8,500', status: 'Pending', icon: Icons.work, color: Colors.orange),
    UpcomingPayment(title: 'Loan EMI', date: 'Jan 1, 2025', amount: '₹12,000', status: 'Upcoming', icon: Icons.account_balance, color: Colors.blue),
  ];

  final String tipText =
      'Your profit margin has increased by 23.5% this year! Consider investing in high-ROI crops like Vegetables (187.5% ROI) for next season.';

  _Range _selectedRange = _Range.year;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go('/profile');
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: const AppFooter(),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeader(
                      title: 'Personal Finance',
                      showBack: true,
                      showProfile: false,
                      appState: widget.appState,
                      onBack: () => context.go('/profile'),
                    ),
                    const SizedBox(height: 16),
                    _buildOverviewCard(),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                    const SizedBox(height: 20),
                    _buildSavingsGoals(),
                    const SizedBox(height: 20),
                    _buildActiveLoans(),
                    const SizedBox(height: 20),
                    _buildRecentTransactions(),
                    const SizedBox(height: 20),
                    _buildTrend(),
                    const SizedBox(height: 20),
                    _buildCropAnalysis(),
                    const SizedBox(height: 20),
                    _buildExpenseBreakdown(),
                    const SizedBox(height: 20),
                    _buildUpcomingPayments(),
                    const SizedBox(height: 20),
                    _buildFinancialTip(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const FloatingIVR(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primaryDark.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Financial Overview', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: _OverviewStat(label: 'Total Revenue', value: '₹4,45,000')),
              SizedBox(width: 12),
              Expanded(child: _OverviewStat(label: 'Net Profit', value: '₹1,78,000')),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: const Text('Profit Margin: 40%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            label: const Text('Add Income', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.receipt_long, color: AppColors.primaryDark),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF4D5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            label: const Text('Add Expense', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
  Widget _buildSavingsGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.savings, color: AppColors.primaryDark, size: 18),
            SizedBox(width: 8),
            Text('Savings Goals', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        ...goals.map(
          (g) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                  child: Icon(g.icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${g.current} / ${g.target}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          Text('${(g.progress * 100).toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: g.progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveLoans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.account_balance_wallet, color: AppColors.primaryDark, size: 18),
            SizedBox(width: 8),
            Text('Active Loans', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        ...loans.map(
          (loan) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.account_balance, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(loan.bank, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.yellow.shade100, borderRadius: BorderRadius.circular(20)),
                      child: Text('EMI: ${loan.emi}', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Total Loan', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('₹2,00,000', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Remaining', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('₹80,000', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: loan.progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primaryDark),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Next EMI: ${loan.nextEmiDate}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.list_alt, color: AppColors.primaryDark, size: 18),
            SizedBox(width: 8),
            Text('Recent Transactions', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        ...transactions.map((tx) => _TransactionTile(entry: tx)),
      ],
    );
  }
  Widget _buildTrend() {
    final maxValue = yearlyProfit.map((e) => e.value).fold<double>(0, (prev, v) => v > prev ? v : prev);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.show_chart, color: AppColors.primaryDark, size: 18),
            SizedBox(width: 8),
            Text('Monthly Profit Trend', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: _Range.values.map((r) {
            final isActive = r == _selectedRange;
            final label = r == _Range.month
                ? 'Month'
                : r == _Range.quarter
                    ? 'Quarter'
                    : 'Year';
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRange = r),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(right: r == _Range.year ? 0 : 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: yearlyProfit
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(width: 40, child: Text(p.label, style: const TextStyle(color: AppColors.muted, fontSize: 12))),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                              ),
                              FractionallySizedBox(
                                widthFactor: maxValue == 0 ? 0 : (p.value / maxValue).clamp(0, 1),
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('?${p.value.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCropAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Crop-wise Profit Analysis', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 12),
        ...cropProfits.map(
          (c) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                  child: Icon(c.icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('ROI: ${c.roi}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _miniStat('Investment', c.investment),
                          const SizedBox(width: 10),
                          _miniStat('Revenue', c.revenue),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.arrowUpRight, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(c.profit, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }

  Widget _buildExpenseBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.pie_chart, color: AppColors.primaryDark, size: 18),
            SizedBox(width: 8),
            Text('Expense Breakdown', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: expenses
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.label, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                            Text('${e.amount} (${e.percent.toStringAsFixed(1)}%)', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: e.percent / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(e.color),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingPayments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.calendar_today_outlined, color: AppColors.primaryDark, size: 18),
            SizedBox(width: 8),
            Text('Upcoming Payments', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 12),
        ...upcomingPayments.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: p.color.withOpacity(0.08), shape: BoxShape.circle),
                  child: Icon(p.icon, color: p.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(p.date, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(p.amount, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: p.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: Text(p.status, style: TextStyle(color: p.color, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.15), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(tipText, style: const TextStyle(color: AppColors.primaryDark, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
class _OverviewStat extends StatelessWidget {
  const _OverviewStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.entry});
  final TransactionEntry entry;

  @override
  Widget build(BuildContext context) {
    final amountPrefix = entry.amount > 0 ? '+' : '';
    final amountText = '$amountPrefix?${entry.amount.abs().toStringAsFixed(0)}';
    final chipColor = entry.status.toLowerCase() == 'completed'
        ? Colors.green
        : entry.status.toLowerCase() == 'pending'
            ? Colors.orange
            : Colors.blue;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: entry.color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(entry.icon, color: entry.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 15)),
                Text(entry.date, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amountText, style: TextStyle(color: entry.isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: chipColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(entry.status, style: TextStyle(color: chipColor, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
