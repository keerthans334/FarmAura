import { useNavigate } from 'react-router-dom';
import { useState } from 'react';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';
import FloatingIVR from './FloatingIVR';
import { Progress } from './ui/progress';
import { 
  TrendingUp, 
  TrendingDown, 
  DollarSign, 
  Calendar, 
  PieChart, 
  BarChart, 
  Plus, 
  ArrowLeft, 
  Download,
  ArrowUpRight,
  Banknote,
  Wallet,
  Target,
  Percent,
  AlertCircle,
  CheckCircle,
  ArrowDownRight,
  CreditCard,
  Receipt
} from 'lucide-react';

export default function PersonalFinance() {
  const navigate = useNavigate();
  const [selectedPeriod, setSelectedPeriod] = useState('year');
  const [showAddIncomeModal, setShowAddIncomeModal] = useState(false);
  const [showAddExpenseModal, setShowAddExpenseModal] = useState(false);

  const financialSummary = {
    totalRevenue: 445000,
    totalExpenses: 267000,
    netProfit: 178000,
    profitMargin: 40,
    growthRate: 23.5
  };

  const monthlyData = [
    { month: 'Apr', revenue: 35000, expenses: 21000, profit: 14000 },
    { month: 'May', revenue: 42000, expenses: 25000, profit: 17000 },
    { month: 'Jun', revenue: 38000, expenses: 23000, profit: 15000 },
    { month: 'Jul', revenue: 45000, expenses: 27000, profit: 18000 },
    { month: 'Aug', revenue: 52000, expenses: 31000, profit: 21000 },
    { month: 'Sep', revenue: 48000, expenses: 28000, profit: 20000 },
    { month: 'Oct', revenue: 55000, expenses: 33000, profit: 22000 },
    { month: 'Nov', revenue: 58000, expenses: 35000, profit: 23000 },
    { month: 'Dec', revenue: 72000, expenses: 44000, profit: 28000 }
  ];

  const cropWiseProfit = [
    { crop: 'Cotton', investment: 85000, revenue: 160000, profit: 75000, roi: 88.2, icon: '🌾' },
    { crop: 'Wheat', investment: 42000, revenue: 107000, profit: 65000, roi: 154.8, icon: '🌾' },
    { crop: 'Soybean', investment: 38000, revenue: 86000, profit: 48000, roi: 126.3, icon: '🫘' },
    { crop: 'Vegetables', investment: 32000, revenue: 92000, profit: 60000, roi: 187.5, icon: '🥬' }
  ];

  const expenses = [
    { category: 'Seeds & Fertilizers', amount: 95000, percentage: 35.6, color: '#43A047' },
    { category: 'Labor', amount: 78000, percentage: 29.2, color: '#FFC107' },
    { category: 'Irrigation', amount: 42000, percentage: 15.7, color: '#8D6E63' },
    { category: 'Equipment', amount: 35000, percentage: 13.1, color: '#FF9800' },
    { category: 'Others', amount: 17000, percentage: 6.4, color: '#757575' }
  ];

  const upcomingPayments = [
    { title: 'Fertilizer Payment', amount: 15000, date: 'Dec 25, 2024', status: 'pending' },
    { title: 'Labor Wages', amount: 8500, date: 'Dec 28, 2024', status: 'pending' },
    { title: 'Loan EMI', amount: 12000, date: 'Jan 1, 2025', status: 'upcoming' }
  ];

  const recentTransactions = [
    { id: 1, type: 'income', title: 'Cotton Harvest Sale', amount: 75000, date: 'Dec 18, 2024', status: 'completed', icon: '🌾' },
    { id: 2, type: 'expense', title: 'Fertilizer Purchase', amount: -12000, date: 'Dec 15, 2024', status: 'completed', icon: '🧪' },
    { id: 3, type: 'income', title: 'Wheat Sale', amount: 45000, date: 'Dec 12, 2024', status: 'completed', icon: '🌾' },
    { id: 4, type: 'expense', title: 'Labor Wages', amount: -8500, date: 'Dec 10, 2024', status: 'completed', icon: '👨‍🌾' },
    { id: 5, type: 'expense', title: 'Equipment Repair', amount: -5000, date: 'Dec 8, 2024', status: 'pending', icon: '🔧' }
  ];

  const savingsGoals = [
    { title: 'New Tractor', target: 500000, current: 285000, icon: '🚜' },
    { title: 'Drip Irrigation', target: 150000, current: 120000, icon: '💧' },
    { title: 'Emergency Fund', target: 100000, current: 75000, icon: '🏦' }
  ];

  const loanDetails = [
    { bank: 'Punjab National Bank', amount: 200000, paid: 120000, emi: 12000, dueDate: 'Jan 1, 2025' },
    { bank: 'SBI Kisan Credit', amount: 100000, paid: 65000, emi: 8000, dueDate: 'Jan 5, 2025' }
  ];

  return (
    <div className="min-h-screen bg-[#FAFAF5] pb-24 max-w-md mx-auto">
      <AppHeader title="Personal Finance" showBack={true} />
      
      <div className="pt-20 px-4">
        {/* Financial Summary Card */}
        <div className="bg-gradient-to-br from-[#43A047] to-[#1B5E20] rounded-3xl p-6 text-white shadow-xl mb-6 animate-fade-in">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-2xl">Financial Overview</h2>
            <button className="p-2 bg-white/20 rounded-full hover:bg-white/30 transition-colors">
              <Download className="w-5 h-5" />
            </button>
          </div>
          
          <div className="grid grid-cols-2 gap-4 mb-4">
            <div>
              <p className="text-sm opacity-90 mb-1">Total Revenue</p>
              <p className="text-2xl">₹{financialSummary.totalRevenue.toLocaleString()}</p>
            </div>
            <div>
              <p className="text-sm opacity-90 mb-1">Net Profit</p>
              <div className="flex items-center gap-2">
                <p className="text-2xl">₹{financialSummary.netProfit.toLocaleString()}</p>
                <ArrowUpRight className="w-5 h-5 text-[#FFC107]" />
              </div>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-3 pt-4 border-t border-white/30">
            <div>
              <p className="text-xs opacity-75 mb-1">Expenses</p>
              <p className="text-sm">₹{financialSummary.totalExpenses.toLocaleString()}</p>
            </div>
            <div>
              <p className="text-xs opacity-75 mb-1">Margin</p>
              <p className="text-sm">{financialSummary.profitMargin}%</p>
            </div>
            <div>
              <p className="text-xs opacity-75 mb-1">Growth</p>
              <div className="flex items-center gap-1">
                <TrendingUp className="w-3 h-3" />
                <p className="text-sm">{financialSummary.growthRate}%</p>
              </div>
            </div>
          </div>
        </div>

        {/* Quick Action Buttons */}
        <div className="grid grid-cols-2 gap-3 mb-6">
          <button 
            onClick={() => setShowAddIncomeModal(true)}
            className="bg-[#43A047] text-white rounded-2xl p-4 shadow-md hover:shadow-lg transition-all hover:scale-105 flex flex-col items-center gap-2"
          >
            <Plus className="w-6 h-6" />
            <span className="text-sm">Add Income</span>
          </button>
          <button 
            onClick={() => setShowAddExpenseModal(true)}
            className="bg-[#FFC107] text-white rounded-2xl p-4 shadow-md hover:shadow-lg transition-all hover:scale-105 flex flex-col items-center gap-2"
          >
            <Receipt className="w-6 h-6" />
            <span className="text-sm">Add Expense</span>
          </button>
        </div>

        {/* Savings Goals */}
        <h3 className="text-[#1B5E20] mb-3 flex items-center gap-2">
          <Target className="w-5 h-5" />
          Savings Goals
        </h3>
        <div className="space-y-3 mb-6">
          {savingsGoals.map((goal, idx) => {
            const percentage = (goal.current / goal.target) * 100;
            return (
              <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm animate-fade-in">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-2">
                    <span className="text-2xl">{goal.icon}</span>
                    <div>
                      <h4 className="text-[#1B5E20]">{goal.title}</h4>
                      <p className="text-xs text-[#757575]">
                        ₹{goal.current.toLocaleString()} / ₹{goal.target.toLocaleString()}
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-[#43A047]">{percentage.toFixed(0)}%</p>
                  </div>
                </div>
                <Progress value={percentage} className="h-2 bg-[#FAFAF5]" />
              </div>
            );
          })}
        </div>

        {/* Loan Details */}
        <h3 className="text-[#1B5E20] mb-3 flex items-center gap-2">
          <CreditCard className="w-5 h-5" />
          Active Loans
        </h3>
        <div className="space-y-3 mb-6">
          {loanDetails.map((loan, idx) => {
            const percentage = (loan.paid / loan.amount) * 100;
            return (
              <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm animate-fade-in">
                <div className="flex items-center justify-between mb-2">
                  <h4 className="text-[#1B5E20]">{loan.bank}</h4>
                  <span className="text-xs bg-yellow-100 text-yellow-700 px-2 py-1 rounded-full">
                    EMI: ₹{loan.emi.toLocaleString()}
                  </span>
                </div>
                <div className="grid grid-cols-2 gap-3 mb-3">
                  <div className="bg-[#FAFAF5] rounded-xl p-2">
                    <p className="text-xs text-[#757575]">Total Loan</p>
                    <p className="text-sm text-[#1B5E20]">₹{loan.amount.toLocaleString()}</p>
                  </div>
                  <div className="bg-[#FAFAF5] rounded-xl p-2">
                    <p className="text-xs text-[#757575]">Remaining</p>
                    <p className="text-sm text-[#1B5E20]">₹{(loan.amount - loan.paid).toLocaleString()}</p>
                  </div>
                </div>
                <Progress value={percentage} className="h-2 bg-[#FAFAF5] mb-2" />
                <p className="text-xs text-[#757575]">Next EMI: {loan.dueDate}</p>
              </div>
            );
          })}
        </div>

        {/* Recent Transactions */}
        <h3 className="text-[#1B5E20] mb-3 flex items-center gap-2">
          <Receipt className="w-5 h-5" />
          Recent Transactions
        </h3>
        <div className="space-y-3 mb-6">
          {recentTransactions.map((transaction) => (
            <div key={transaction.id} className="bg-white rounded-2xl p-4 shadow-sm flex items-center justify-between hover:shadow-md transition-shadow">
              <div className="flex items-center gap-3">
                <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                  transaction.type === 'income' ? 'bg-green-100' : 'bg-red-100'
                }`}>
                  <span className="text-2xl">{transaction.icon}</span>
                </div>
                <div>
                  <h4 className="text-[#1B5E20]">{transaction.title}</h4>
                  <p className="text-xs text-[#757575]">{transaction.date}</p>
                </div>
              </div>
              <div className="text-right">
                <p className={`${transaction.amount > 0 ? 'text-green-600' : 'text-red-600'}`}>
                  {transaction.amount > 0 ? '+' : ''}₹{Math.abs(transaction.amount).toLocaleString()}
                </p>
                <span className={`text-xs px-2 py-1 rounded-full ${
                  transaction.status === 'completed' 
                    ? 'bg-green-100 text-green-600' 
                    : 'bg-yellow-100 text-yellow-600'
                }`}>
                  {transaction.status}
                </span>
              </div>
            </div>
          ))}
        </div>

        {/* Period Selector */}
        <div className="flex gap-2 mb-4 overflow-x-auto pb-2">
          {['month', 'quarter', 'year'].map((period) => (
            <button
              key={period}
              onClick={() => setSelectedPeriod(period)}
              className={`px-4 py-2 rounded-full whitespace-nowrap transition-all ${
                selectedPeriod === period
                  ? 'bg-[#43A047] text-white shadow-md'
                  : 'bg-white text-[#1B5E20] hover:bg-[#FAFAF5]'
              }`}
            >
              {period.charAt(0).toUpperCase() + period.slice(1)}
            </button>
          ))}
        </div>

        {/* Monthly Trend Chart */}
        <div className="bg-white rounded-3xl p-5 shadow-sm mb-6">
          <h3 className="text-[#1B5E20] mb-4 flex items-center gap-2">
            <TrendingUp className="w-5 h-5 text-[#43A047]" />
            Monthly Profit Trend
          </h3>
          
          <div className="space-y-3">
            {monthlyData.slice(-6).map((data, idx) => {
              const maxProfit = Math.max(...monthlyData.map(d => d.profit));
              const percentage = (data.profit / maxProfit) * 100;
              
              return (
                <div key={idx}>
                  <div className="flex items-center justify-between text-sm mb-1">
                    <span className="text-[#757575]">{data.month}</span>
                    <span className="text-[#1B5E20]">₹{data.profit.toLocaleString()}</span>
                  </div>
                  <div className="h-2 bg-[#FAFAF5] rounded-full overflow-hidden">
                    <div 
                      className="h-full bg-gradient-to-r from-[#43A047] to-[#1B5E20] rounded-full transition-all duration-500"
                      style={{ width: `${percentage}%` }}
                    />
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Crop-wise Profit Analysis */}
        <h3 className="text-[#1B5E20] mb-3">Crop-wise Profit Analysis</h3>
        <div className="space-y-3 mb-6">
          {cropWiseProfit.map((crop, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm animate-fade-in" style={{ animationDelay: `${idx * 100}ms` }}>
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-3">
                  <div className="text-3xl">{crop.icon}</div>
                  <div>
                    <h4 className="text-[#1B5E20]">{crop.crop}</h4>
                    <p className="text-xs text-[#757575]">ROI: {crop.roi}%</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-green-600 flex items-center gap-1">
                    <ArrowUpRight className="w-4 h-4" />
                    ₹{crop.profit.toLocaleString()}
                  </p>
                  <p className="text-xs text-[#757575]">Profit</p>
                </div>
              </div>
              
              <div className="grid grid-cols-2 gap-3 text-sm">
                <div className="bg-[#FAFAF5] rounded-xl p-2">
                  <p className="text-xs text-[#757575] mb-1">Investment</p>
                  <p className="text-[#1B5E20]">₹{crop.investment.toLocaleString()}</p>
                </div>
                <div className="bg-[#FAFAF5] rounded-xl p-2">
                  <p className="text-xs text-[#757575] mb-1">Revenue</p>
                  <p className="text-[#1B5E20]">₹{crop.revenue.toLocaleString()}</p>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Expense Breakdown */}
        <h3 className="text-[#1B5E20] mb-3">Expense Breakdown</h3>
        <div className="bg-white rounded-3xl p-5 shadow-sm mb-6">
          <div className="space-y-4">
            {expenses.map((expense, idx) => (
              <div key={idx}>
                <div className="flex items-center justify-between text-sm mb-2">
                  <span className="text-[#1B5E20]">{expense.category}</span>
                  <div className="text-right">
                    <span className="text-[#1B5E20]">₹{expense.amount.toLocaleString()}</span>
                    <span className="text-xs text-[#757575] ml-2">({expense.percentage}%)</span>
                  </div>
                </div>
                <div className="h-2 bg-[#FAFAF5] rounded-full overflow-hidden">
                  <div 
                    className="h-full rounded-full transition-all duration-500"
                    style={{ 
                      width: `${expense.percentage}%`,
                      backgroundColor: expense.color 
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Upcoming Payments */}
        <h3 className="text-[#1B5E20] mb-3 flex items-center gap-2">
          <Calendar className="w-5 h-5" />
          Upcoming Payments
        </h3>
        <div className="space-y-3 mb-6">
          {upcomingPayments.map((payment, idx) => (
            <div key={idx} className="bg-white rounded-2xl p-4 shadow-sm flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                  payment.status === 'pending' ? 'bg-red-100' : 'bg-yellow-100'
                }`}>
                  <Banknote className={`w-6 h-6 ${
                    payment.status === 'pending' ? 'text-red-600' : 'text-yellow-600'
                  }`} />
                </div>
                <div>
                  <h4 className="text-[#1B5E20]">{payment.title}</h4>
                  <p className="text-xs text-[#757575]">{payment.date}</p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-[#1B5E20]">₹{payment.amount.toLocaleString()}</p>
                <span className={`text-xs px-2 py-1 rounded-full ${
                  payment.status === 'pending' 
                    ? 'bg-red-100 text-red-600' 
                    : 'bg-yellow-100 text-yellow-600'
                }`}>
                  {payment.status}
                </span>
              </div>
            </div>
          ))}
        </div>

        {/* Financial Tips */}
        <div className="bg-gradient-to-br from-[#FFC107] to-[#FF9800] rounded-3xl p-5 text-white mb-6">
          <h3 className="text-lg mb-2">💡 Financial Tip</h3>
          <p className="text-sm opacity-95">
            Your profit margin has increased by 23.5% this year! Consider investing in high-ROI crops like Vegetables (187.5% ROI) for next season.
          </p>
        </div>
      </div>

      <FloatingIVR />
      <AppFooter />
    </div>
  );
}