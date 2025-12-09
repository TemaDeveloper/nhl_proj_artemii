export class APIError extends Error {
  constructor(endpoint, statusCode, originalError = null) {
    super(`API Error calling ${endpoint}: HTTP ${statusCode}`);
    this.name = 'APIError';
    this.endpoint = endpoint;
    this.statusCode = statusCode;
    this.originalError = originalError;
  }
}

export class FirestoreError extends Error {
  constructor(operation, reason, originalError = null) {
    super(`Firestore Error (${operation}): ${reason}`);
    this.name = 'FirestoreError';
    this.operation = operation;
    this.reason = reason;
    this.originalError = originalError;
  }
}

export class ValidationError extends Error {
  constructor(field, message) {
    super(`Validation Error (${field}): ${message}`);
    this.name = 'ValidationError';
    this.field = field;
  }
}
