abstract class ExpenseEvent {}

class CreateExpenseEvent extends ExpenseEvent {
  final int userId;
  final Map<String, dynamic> expenseData;

  CreateExpenseEvent({
    required this.userId,
    required this.expenseData,
  });
}

class CreateExpenseForOwnerEvent extends ExpenseEvent {
  final int ownerId;
  final Map<String, dynamic> expenseData;

  CreateExpenseForOwnerEvent({
    required this.ownerId,
    required this.expenseData,
  });
}

class FetchAllExpensesEvent extends ExpenseEvent {}

class FetchExpenseByIdEvent extends ExpenseEvent {
  final int expenseId;

  FetchExpenseByIdEvent(this.expenseId);
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int expenseId;

  DeleteExpenseEvent(this.expenseId);
}

