// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract ExpenseTracker {
    struct Expense {
        uint256 id;
        uint256 amount;
        uint256 date;
        string category;
        string description;
        bool isCanceled;
    }

    Expense[] private expenses;
    uint256 private nextId = 1;
    mapping(string => uint256) private totalExpensesByCategory;

    event ExpenseAdded(
        uint256 id,
        uint256 amount,
        string category,
        string description
    );
    event ExpenseModified(
        uint256 id,
        uint256 amount,
        string category,
        string description
    );
    event ExpenseCanceled(uint256 id);

    function addExpense(
        uint256 _amount,
        uint256 _date,
        string memory _category,
        string memory _description
    ) public {
        expenses.push(
            Expense(nextId, _amount, _date, _category, _description, false)
        );
        totalExpensesByCategory[_category] += _amount;
        emit ExpenseAdded(nextId, _amount, _category, _description);
        nextId++;
    }

    function modifyExpense(
        uint256 _id,
        uint256 _newAmount,
        string memory _newCategory,
        string memory _newDescription
    ) public {
        for (uint256 i = 0; i < expenses.length; i++) {
            if (expenses[i].id == _id && !expenses[i].isCanceled) {
                totalExpensesByCategory[expenses[i].category] -= expenses[i]
                    .amount;
                expenses[i].amount = _newAmount;
                expenses[i].category = _newCategory;
                expenses[i].description = _newDescription;
                totalExpensesByCategory[_newCategory] += _newAmount;
                emit ExpenseModified(
                    _id,
                    _newAmount,
                    _newCategory,
                    _newDescription
                );
                break;
            }
        }
    }

    function cancelExpense(uint256 _id) public {
        for (uint256 i = 0; i < expenses.length; i++) {
            if (expenses[i].id == _id && !expenses[i].isCanceled) {
                expenses[i].isCanceled = true;
                totalExpensesByCategory[expenses[i].category] -= expenses[i]
                    .amount;
                emit ExpenseCanceled(_id);
                break;
            }
        }
    }

    function getExpenses() public view returns (Expense[] memory) {
        return expenses;
    }

    function getTotalExpensesByCategory(string memory _category)
        public
        view
        returns (uint256)
    {
        return totalExpensesByCategory[_category];
    }

    
}
