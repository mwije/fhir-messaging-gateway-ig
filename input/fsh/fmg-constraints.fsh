
// Enforce resource identification : business or reference
Invariant: ref-identifier-or-literal
Description: "Either identifier or reference must be present"
Expression: "identifier.exists() or reference.exists()"
Severity: #error
