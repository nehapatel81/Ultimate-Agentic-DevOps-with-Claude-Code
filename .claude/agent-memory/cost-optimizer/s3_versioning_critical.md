---
name: s3-versioning-enabled-high-cost
description: S3 bucket has versioning enabled without lifecycle rules, creating unbounded storage costs
metadata:
  type: project
---

**Critical Cost Issue: S3 Versioning Without Lifecycle Rules**

The portfolio site S3 bucket (`portfolio-site-production-{account-id}`) has versioning enabled but no lifecycle rules configured to delete old versions. This causes:

- Every object update creates a new version stored indefinitely
- Storage costs multiply based on number of versions retained
- Potential savings: 50-90% of S3 storage costs if versioning is disabled

**Why:** Versioning is useful for production databases and critical infrastructure, but for a static HTML/CSS portfolio site with infrequent changes, it's unnecessary overhead.

**How to apply:** For this portfolio site project, disable S3 versioning entirely. If version control is needed later, use git or implement minimal lifecycle rules (retain only last 3-5 versions).

**Impact: Very High** — This is the single largest cost optimization opportunity.

Related: [[cloudfront-price-class-optimization]], [[s3-lifecycle-policy-recommendation]]
