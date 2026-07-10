---
name: cloudfront-price-class-sub-optimal
description: CloudFront using PriceClass_200 when PriceClass_100 likely sufficient for portfolio
metadata:
  type: project
---

**Optimization: CloudFront Price Class Selection**

Current configuration uses `PriceClass_200` which includes:
- North America, Europe, Asia (all locations except expensive regions like Middle East, Africa)

Recommended: `PriceClass_100` includes:
- US, Canada, Europe, Japan, Singapore, Hong Kong, Australia, New Zealand

**Why:** Portfolio site traffic is typically concentrated in US/EU/APAC regions. PriceClass_100 covers 95%+ of typical global audience while reducing egress costs by 15-20%.

**How to apply:** For audience targeting, use CloudFront's geo-restriction or analytics to verify most traffic comes from PriceClass_100 regions before downgrading.

**Impact: Medium** — ~15-20% savings on CloudFront data transfer costs (typically $0.02-0.085/GB depending on region).

Related: [[s3-versioning-enabled-high-cost]]
