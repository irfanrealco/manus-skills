# Cross-Platform Error Handling for React Native

**Extracted from**: Make a Million app debugging session  
**Pattern**: Inconsistent error handling across web and native platforms  
**Category**: Error Handling / UX

---

## Overview

Create a centralized, platform-aware error handling system for React Native apps that works consistently across iOS, Android, and Web. Stop using `alert()` (web-only) and start using proper cross-platform error dialogs.

## The Problem

**Symptom**: Error dialogs work on web but silently fail on mobile, or vice versa.

**Example from Make a Million app**:
```typescript
// ❌ BAD: Scattered across codebase
// Some files use alert() (web-only)
alert('Failed to play card');

// Some files use Alert.alert() (native-only)
Alert.alert('Error', 'Failed to play card');

// Result: Inconsistent UX, some errors don't show on certain platforms
```

**Impact**:
- Errors invisible on mobile when using `alert()`
- Inconsistent user experience across platforms
- Scattered error handling logic throughout codebase
- Hard to add features like error logging or analytics

---

## The Solution: Centralized Error Handler

### Create `lib/error-handler.ts`

```typescript
import { Alert, Platform } from 'react-native';

/**
 * Show an error dialog that works on all platforms
 */
export function showError(title: string, message: string) {
  if (Platform.OS === 'web') {
    alert(`${title}: ${message}`);
  } else {
    Alert.alert(title, message);
  }
}

/**
 * Show a success dialog that works on all platforms
 */
export function showSuccess(title: string, message: string) {
  if (Platform.OS === 'web') {
    alert(`${title}: ${message}`);
  } else {
    Alert.alert(title, message);
  }
}

/**
 * Show a confirmation dialog with callbacks
 */
export function showConfirm(
  title: string,
  message: string,
  onConfirm: () => void,
  onCancel?: () => void
) {
  if (Platform.OS === 'web') {
    if (confirm(`${title}\n\n${message}`)) {
      onConfirm();
    } else if (onCancel) {
      onCancel();
    }
  } else {
    Alert.alert(title, message, [
      {
        text: 'Cancel',
        style: 'cancel',
        onPress: onCancel,
      },
      {
        text: 'OK',
        onPress: onConfirm,
      },
    ]);
  }
}

/**
 * Show an error with retry option
 */
export function showErrorWithRetry(
  title: string,
  message: string,
  onRetry: () => void,
  onCancel?: () => void
) {
  if (Platform.OS === 'web') {
    if (confirm(`${title}\n\n${message}\n\nRetry?`)) {
      onRetry();
    } else if (onCancel) {
      onCancel();
    }
  } else {
    Alert.alert(title, message, [
      {
        text: 'Cancel',
        style: 'cancel',
        onPress: onCancel,
      },
      {
        text: 'Retry',
        onPress: onRetry,
      },
    ]);
  }
}
```

---

## Usage Examples

### Basic Error

```typescript
import { showError } from '@/lib/error-handler';

try {
  await api.post('/games/123/play', { card });
} catch (err: any) {
  showError('Card Play Failed', err.message || 'Failed to play card');
}
```

### Success Message

```typescript
import { showSuccess } from '@/lib/error-handler';

await api.post('/games/123/bid', { amount: 5 });
showSuccess('Bid Placed', 'Your bid of 5 has been placed');
```

### Confirmation Dialog

```typescript
import { showConfirm } from '@/lib/error-handler';

showConfirm(
  'Leave Game',
  'Are you sure you want to leave this game?',
  () => {
    // User confirmed
    router.back();
  },
  () => {
    // User cancelled
    console.log('User cancelled');
  }
);
```

### Error with Retry

```typescript
import { showErrorWithRetry } from '@/lib/error-handler';

try {
  await api.post('/games/123/trump', { suit: 'hearts' });
} catch (err: any) {
  showErrorWithRetry(
    'Trump Selection Failed',
    err.message || 'Failed to select trump',
    () => {
      // Retry the action
      selectTrump('hearts');
    }
  );
}
```

---

## Migration Guide

### Step 1: Find All `alert()` Usage

```bash
# Search for alert() calls
grep -r "alert(" src/ --include="*.ts" --include="*.tsx"

# Search for Alert.alert() calls
grep -r "Alert.alert(" src/ --include="*.ts" --include="*.tsx"
```

### Step 2: Replace with Centralized Functions

**Before**:
```typescript
alert('You must follow suit if possible');
```

**After**:
```typescript
import { showError } from '@/lib/error-handler';

showError('Invalid Card', 'You must follow suit if possible');
```

**Before**:
```typescript
Alert.alert('Error', 'Failed to place bid');
```

**After**:
```typescript
import { showError } from '@/lib/error-handler';

showError('Bid Failed', 'Failed to place bid');
```

### Step 3: Add ESLint Rule

Prevent future direct `alert()` usage:

```javascript
// .eslintrc.js
module.exports = {
  rules: {
    'no-restricted-globals': [
      'error',
      {
        name: 'alert',
        message: 'Use showError() from @/lib/error-handler instead',
      },
      {
        name: 'confirm',
        message: 'Use showConfirm() from @/lib/error-handler instead',
      },
    ],
    'no-restricted-imports': [
      'error',
      {
        paths: [
          {
            name: 'react-native',
            importNames: ['Alert'],
            message: 'Use error-handler functions instead of Alert directly',
          },
        ],
      },
    ],
  },
};
```

---

## Advanced Features

### Add Error Logging

```typescript
import { Alert, Platform } from 'react-native';
import * as Sentry from '@sentry/react-native';

export function showError(title: string, message: string) {
  // Log to error tracking
  Sentry.captureMessage(`${title}: ${message}`, 'error');
  
  // Show to user
  if (Platform.OS === 'web') {
    alert(`${title}: ${message}`);
  } else {
    Alert.alert(title, message);
  }
}
```

### Add Analytics

```typescript
import { Analytics } from '@/lib/analytics';

export function showError(title: string, message: string) {
  // Track error shown
  Analytics.track('error_shown', {
    title,
    message,
    platform: Platform.OS,
  });
  
  // Show to user
  if (Platform.OS === 'web') {
    alert(`${title}: ${message}`);
  } else {
    Alert.alert(title, message);
  }
}
```

### Add Toast Notifications (Alternative)

For less critical errors, use toast notifications:

```typescript
import Toast from 'react-native-toast-message';

export function showToast(type: 'success' | 'error' | 'info', title: string, message: string) {
  Toast.show({
    type,
    text1: title,
    text2: message,
    position: 'bottom',
    visibilityTime: 3000,
  });
}

// Usage
showToast('error', 'Network Error', 'Please check your connection');
```

---

## Testing

### Unit Tests

```typescript
import { showError, showConfirm } from '@/lib/error-handler';
import { Alert, Platform } from 'react-native';

jest.mock('react-native', () => ({
  Alert: {
    alert: jest.fn(),
  },
  Platform: {
    OS: 'ios',
  },
}));

describe('error-handler', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('shows Alert.alert on native platforms', () => {
    showError('Test Error', 'Test message');
    
    expect(Alert.alert).toHaveBeenCalledWith('Test Error', 'Test message');
  });

  it('shows alert() on web', () => {
    Platform.OS = 'web';
    global.alert = jest.fn();
    
    showError('Test Error', 'Test message');
    
    expect(global.alert).toHaveBeenCalledWith('Test Error: Test message');
  });

  it('calls onConfirm when user confirms', () => {
    const onConfirm = jest.fn();
    const onCancel = jest.fn();
    
    showConfirm('Confirm', 'Are you sure?', onConfirm, onCancel);
    
    // Simulate user clicking OK
    const okButton = Alert.alert.mock.calls[0][2][1];
    okButton.onPress();
    
    expect(onConfirm).toHaveBeenCalled();
    expect(onCancel).not.toHaveBeenCalled();
  });
});
```

---

## Best Practices

### 1. Descriptive Titles

```typescript
// ❌ BAD: Generic title
showError('Error', 'Something went wrong');

// ✅ GOOD: Specific title
showError('Card Play Failed', 'You must follow suit if possible');
```

### 2. Actionable Messages

```typescript
// ❌ BAD: Vague message
showError('Error', 'Network error');

// ✅ GOOD: Actionable message
showError('Network Error', 'Please check your internet connection and try again');
```

### 3. User-Friendly Language

```typescript
// ❌ BAD: Technical jargon
showError('Error', 'HTTP 500: Internal Server Error');

// ✅ GOOD: User-friendly
showError('Server Error', 'Something went wrong on our end. Please try again later');
```

---

## Key Takeaways

1. **Centralize cross-cutting concerns** - Error handling, logging, analytics should be centralized utilities
2. **Platform-aware abstractions** - Abstract platform differences into reusable functions
3. **Consistent UX** - Users should have the same experience across all platforms
4. **Prevent regression** - Use ESLint rules to enforce usage of centralized functions
5. **Future-proof** - Centralized handlers make it easy to add logging, analytics, or change behavior

---

## Related Patterns

- **Centralized Logging**: Log all errors to a central service (Sentry, LogRocket)
- **Error Boundaries**: Catch React errors and show fallback UI
- **Retry Logic**: Automatically retry failed actions with exponential backoff

---

**Extracted from Make a Million app**: This pattern emerged from debugging inconsistent error handling where some errors showed on web but not mobile. Creating a centralized error handler fixed the issue and made future enhancements (like error logging) trivial to add.

**"The answer lies in the darkness"** - This gem was mined from scattered error handling! 💎
