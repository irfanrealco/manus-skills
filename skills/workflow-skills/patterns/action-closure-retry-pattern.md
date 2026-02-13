# Action Closure Retry Pattern

**Extracted from**: Make a Million app debugging session  
**Pattern**: Retry button not retrying the actual failed action  
**Category**: Error Recovery / State Management

---

## The Problem

You have a retry button in your error UI, but when users click it, it doesn't retry the failed action - it just refetches data or does something generic.

**Symptom**:
```
User tries to place bid → Network fails → Error shown with Retry button → 
User clicks Retry → Expected: Retry the bid → Actual: Just refetch game state
```

**Why this happens**:
- No reference to what action failed
- Retry handler doesn't know what to retry
- Generic "retry" just refetches or refreshes

---

## The Solution: Action Closure Pattern

**Store the action closure BEFORE executing it**, so retry can re-execute the exact same action with the same parameters.

### The Pattern

```typescript
const [lastAction, setLastAction] = useState<(() => Promise<void>) | null>(null);

const actionMethod = useCallback(async (params) => {
  // 1. Create action closure
  const action = async () => {
    await api.post(`/endpoint`, { params });
    await refreshData();
  };
  
  // 2. Store action for retry
  setLastAction(() => action);
  
  // 3. Execute action
  try {
    setError(null);
    await action();
  } catch (err: any) {
    setError(err.response?.data?.message || 'Failed');
    throw err;
  }
}, [dependencies]);

const retryLastAction = useCallback(async () => {
  if (lastAction) {
    await lastAction(); // Retries exact same action!
  } else {
    await refreshData(); // Fallback to refresh
  }
}, [lastAction, refreshData]);
```

---

## Real-World Example: Game Actions

### Before (Broken Retry)

```typescript
// lib/game-context.tsx
const [error, setError] = useState<string | null>(null);

const placeBid = useCallback(async (amount: number | 'pass') => {
  try {
    setError(null);
    await api.post(`/games/${gameId}/bid`, { amount });
    await fetchGame();
  } catch (err: any) {
    setError(err.response?.data?.message || 'Failed to place bid');
    throw err;
  }
}, [gameId, fetchGame]);

const retryLastAction = useCallback(async () => {
  // ❌ Problem: No reference to what action failed!
  // Can only refetch game, can't retry the bid
  await fetchGame();
}, [fetchGame]);
```

**Result**: Retry button just refetches game, doesn't retry the bid.

---

### After (Working Retry)

```typescript
// lib/game-context.tsx
const [error, setError] = useState<string | null>(null);
const [lastAction, setLastAction] = useState<(() => Promise<void>) | null>(null);

const placeBid = useCallback(async (amount: number | 'pass') => {
  // 1. Create action closure that captures the bid amount
  const action = async () => {
    await api.post(`/games/${gameId}/bid`, { amount });
    await fetchGame();
  };
  
  // 2. Store action for retry
  setLastAction(() => action);
  
  // 3. Execute action
  try {
    setError(null);
    await action();
  } catch (err: any) {
    setError(err.response?.data?.message || 'Failed to place bid');
    throw err;
  }
}, [gameId, fetchGame]);

const retryLastAction = useCallback(async () => {
  if (lastAction) {
    // ✅ Retries the exact action that failed!
    await lastAction();
  } else {
    // Fallback to refresh if no action stored
    await fetchGame();
  }
}, [lastAction, fetchGame]);
```

**Result**: Retry button retries the exact bid with the exact amount!

---

## How It Works

### Flow Diagram

```
User Action (e.g., place bid with amount=5)
  ↓
Create action closure: async () => { await api.post('/bid', { amount: 5 }); }
  ↓
Store in lastAction state
  ↓
Execute action
  ↓
Success? → Clear error, update state
  ↓
Failure? → Set error, show retry button
  ↓
User clicks "Retry"
  ↓
retryLastAction() executes stored closure
  ↓
Retries EXACT SAME action (amount=5) ✅
```

### Key Insight

**The closure captures the parameters at creation time**, so when you retry, you're retrying with the exact same parameters that failed.

```typescript
const amount = 5;

// Closure captures amount=5
const action = async () => {
  await api.post('/bid', { amount }); // amount is captured!
};

// Later, even if amount changes to 10...
const amount = 10;

// ...the closure still has amount=5
await action(); // Still bids 5, not 10!
```

---

## Multiple Actions Example

```typescript
const [lastAction, setLastAction] = useState<(() => Promise<void>) | null>(null);

// Bid action
const placeBid = useCallback(async (amount: number | 'pass') => {
  const action = async () => {
    await api.post(`/games/${gameId}/bid`, { amount });
    await fetchGame();
  };
  setLastAction(() => action);
  try {
    setError(null);
    await action();
  } catch (err: any) {
    setError(err.response?.data?.message || 'Failed to place bid');
    throw err;
  }
}, [gameId, fetchGame]);

// Trump selection action
const selectTrump = useCallback(async (suit: Suit) => {
  const action = async () => {
    await api.post(`/games/${gameId}/trump`, { suit });
    await fetchGame();
  };
  setLastAction(() => action);
  try {
    setError(null);
    await action();
  } catch (err: any) {
    setError(err.response?.data?.message || 'Failed to select trump');
    throw err;
  }
}, [gameId, fetchGame]);

// Play card action
const playCard = useCallback(async (card: Card) => {
  const action = async () => {
    await api.post(`/games/${gameId}/play`, { card });
    await fetchGame();
  };
  setLastAction(() => action);
  try {
    setError(null);
    await action();
  } catch (err: any) {
    setError(err.response?.data?.message || 'Failed to play card');
    throw err;
  }
}, [gameId, fetchGame]);

// Single retry handler for all actions!
const retryLastAction = useCallback(async () => {
  if (lastAction) {
    await lastAction(); // Retries whichever action failed
  } else {
    await fetchGame();
  }
}, [lastAction, fetchGame]);
```

---

## Error Recovery UI

```typescript
// components/ErrorRecovery.tsx
export function ErrorRecovery({ 
  error, 
  onRetry, 
  onDismiss 
}: {
  error: string;
  onRetry: () => Promise<void>;
  onDismiss?: () => void;
}) {
  const [retrying, setRetrying] = useState(false);

  const handleRetry = async () => {
    setRetrying(true);
    try {
      await onRetry();
    } catch (err) {
      // Error will be handled by parent
    } finally {
      setRetrying(false);
    }
  };

  return (
    <View className="bg-error/10 border border-error rounded-lg p-4 m-4">
      <Text className="text-error font-semibold mb-2">⚠️ Error</Text>
      <Text className="text-foreground mb-4">{error}</Text>
      
      <View className="flex-row gap-2">
        <TouchableOpacity 
          onPress={handleRetry} 
          disabled={retrying}
          className="bg-primary px-4 py-2 rounded"
        >
          {retrying ? (
            <ActivityIndicator color="white" />
          ) : (
            <Text className="text-white font-semibold">Retry</Text>
          )}
        </TouchableOpacity>
        
        {onDismiss && (
          <TouchableOpacity 
            onPress={onDismiss} 
            disabled={retrying}
            className="bg-gray-200 px-4 py-2 rounded"
          >
            <Text className="text-gray-700 font-semibold">Dismiss</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

// Usage in game screen
function GameScreen() {
  const { error, retryLastAction, clearError } = useGame();
  
  return (
    <View>
      {error && (
        <ErrorRecovery
          error={error}
          onRetry={retryLastAction}
          onDismiss={clearError}
        />
      )}
      {/* Rest of game UI */}
    </View>
  );
}
```

---

## Gotchas & Considerations

### 1. Stale Parameters ⚠️

**Problem**: If state changes between failure and retry, retried action uses original parameters.

**Example**:
```typescript
// User tries to play card A
playCard(cardA); // Fails

// Meanwhile, another player plays, trick completes
// Card A is no longer valid

// User retries
retryLastAction(); // Still tries to play card A (might be invalid now!)
```

**Mitigation**:
- Backend should validate all actions
- Frontend can disable retry if state changes significantly
- Add staleness check in retry handler

```typescript
const retryLastAction = useCallback(async () => {
  // Check if game phase changed
  if (game?.phase !== phaseWhenActionFailed) {
    setError('Game state changed. Please try your action again.');
    return;
  }
  
  if (lastAction) {
    await lastAction();
  }
}, [lastAction, game?.phase, phaseWhenActionFailed]);
```

### 2. Multiple Failures

**Problem**: If user tries multiple actions and all fail, only last action is stored.

**Example**:
```typescript
placeBid(5); // Fails
placeBid(6); // Fails
retryLastAction(); // Only retries bid 6, not bid 5
```

**Mitigation**: This is acceptable behavior - retry last action only. User can manually retry earlier actions if needed.

### 3. Memory Leaks

**Problem**: Action closures capture dependencies, could prevent garbage collection.

**Mitigation**:
- Closures are small and short-lived
- `lastAction` is overwritten on each new action
- Component unmount clears all state
- No significant memory leak risk

---

## Testing

```typescript
describe('Action Closure Retry Pattern', () => {
  it('retries the exact action that failed', async () => {
    const mockApi = jest.fn().mockRejectedValueOnce(new Error('Network error'));
    
    // First attempt fails
    await expect(placeBid(5)).rejects.toThrow();
    
    // Mock succeeds on retry
    mockApi.mockResolvedValueOnce({ data: { success: true } });
    
    // Retry should call with same parameters
    await retryLastAction();
    
    expect(mockApi).toHaveBeenCalledTimes(2);
    expect(mockApi).toHaveBeenNthCalledWith(1, '/games/123/bid', { amount: 5 });
    expect(mockApi).toHaveBeenNthCalledWith(2, '/games/123/bid', { amount: 5 });
  });
});
```

---

## Key Takeaways

1. **Store action closure BEFORE executing** - Not after failure
2. **Closures capture parameters** - Retry uses exact same parameters
3. **Single retry handler** - Works for all actions
4. **Validate on retry** - Check if action is still valid
5. **Better UX** - One-click retry without re-entering data

---

## Related Patterns

- **Exponential Backoff**: Automatically retry with increasing delays
- **Optimistic Updates**: Update UI immediately, rollback on failure
- **Command Pattern**: Encapsulate actions as objects for undo/redo

---

**Extracted from Make a Million app**: This pattern emerged from debugging a retry button that didn't actually retry the failed action. The solution improved UX significantly - users can now retry failed actions with one click instead of manually re-entering data.

**Impact**:
- Before: Retry button just refetched data (didn't retry action)
- After: Retry button retries exact failed action
- Result: Better UX, reduced user frustration, one-click recovery

**"The answer lies in the darkness"** - This gem was mined from a broken retry button! 💎
