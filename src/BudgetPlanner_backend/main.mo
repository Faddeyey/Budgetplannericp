import Text "mo:base/Text";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Option "mo:base/Option";
import Iter "mo:base/Iter";

actor {
    type Budget = {
        id: Nat;
        category: Text;
        amount: Nat;
        spent: Nat;
    };

    private var nextId: Nat = 0;
    private var budgets = HashMap.HashMap<Nat, Budget>(0, Nat.equal, Hash.hash);

    public func createBudget(category: Text, amount: Nat, spent: ?Nat) : async Nat {
        let id = nextId;
        let newBudget: Budget = {
            id;
            category;
            amount;
            spent = Option.get(spent, 0); // Default spent value is 0
        };
        budgets.put(id, newBudget);
        nextId += 1;
        id
    };

    public func updateBudget(id: Nat, category: ?Text, amount: ?Nat, spent: ?Nat) : async Bool {
        switch (budgets.get(id)) {
            case (null) { false };
            case (?existingBudget) {
                let updatedBudget: Budget = {
                    id = existingBudget.id;
                    category = Option.get(category, existingBudget.category);
                    amount = Option.get(amount, existingBudget.amount);
                    spent = Option.get(spent, existingBudget.spent);
                };
                budgets.put(id, updatedBudget);
                true
            };
        }
    };

    public query func getBudget(id: Nat) : async ?Budget {
        budgets.get(id)
    };

    public query func getAllBudgets() : async [Budget] {
        Iter.toArray(budgets.vals())
    };

    public func deleteBudget(id: Nat) : async Bool {
        switch (budgets.remove(id)) {
            case (null) { false };
            case (?_) { true };
        }
    };
}
