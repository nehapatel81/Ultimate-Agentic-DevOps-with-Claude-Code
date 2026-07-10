---
name: s3-lifecycle-policy-recommendation
description: S3 bucket missing lifecycle rules to manage object versions and old objects
metadata:
  type: project
---

**Recommendation: Implement S3 Lifecycle Rules**

Current state: S3 bucket with versioning enabled but no lifecycle configuration.

**Two scenarios:**

1. **If keeping versioning (not recommended):** Add lifecycle rule to delete old versions after 30 days or retain only last 3 versions
2. **If disabling versioning (recommended for static site):** Implement lifecycle rule to transition infrequent objects to Intelligent-Tiering or Glacier

**Why:** Lifecycle rules prevent unbounded storage growth and automatically move cold data to cheaper storage classes.

**How to apply:** For this portfolio site, implement option 1 temporarily while testing, then move to option 2 (disable versioning entirely).

**Impact: High** — Cost savings depend on update frequency. For static site with versioning: 60-70% storage reduction.

Related: [[s3-versioning-enabled-high-cost]]
