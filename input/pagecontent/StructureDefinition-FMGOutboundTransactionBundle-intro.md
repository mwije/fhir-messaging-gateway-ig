### Scope and Usage

This profile constrains the Bundle resource for submitting multiple outbound message requests in a single transaction.

---

### Bundle Type

The bundle type is fixed to `transaction` - all entries are processed atomically.

---

### Entry Structure

The bundle defines two entry slices:

| Slice | Cardinality | Content |
|-------|-------------|---------|
| `message` | 1..* | [FMGOutboundCommunicationRequest](StructureDefinition-FMGOutboundCommunicationRequest.html) resources |
| `entity` | 0..* | Patient, Practitioner, or Group resources referenced by the messages |

---

### Use Cases

1. **Broadcast** - Submit multiple CommunicationRequest entries for different recipients in one transaction
2. **Patient Context** - Include Patient resources to provide recipient context without requiring them to already exist on the server

---

### Example

```json
{
  "resourceType": "Bundle",
  "type": "transaction",
  "entry": [
    {
      "fullUrl": "urn:uuid:msg-1",
      "resource": { "resourceType": "CommunicationRequest", ... },
      "request": { "method": "POST", "url": "CommunicationRequest" }
    },
    {
      "fullUrl": "urn:uuid:patient-1",
      "resource": { "resourceType": "Patient", ... },
      "request": { "method": "POST", "url": "Patient" }
    }
  ]
}
```
