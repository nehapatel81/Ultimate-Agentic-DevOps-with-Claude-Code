---
name: feedback-audit-scope
description: When auditing terraform/ for this repo, also glance at the GitHub Actions deploy workflow for hardcoded ARNs/IDs and unmanaged IAM roles
metadata:
  type: feedback
---

Even though the task is scoped to reviewing `terraform/`, the checklist item "no hardcoded
credentials, ARNs, or account IDs in code" and "OIDC trust policies must be scoped to
specific repo/branch" cannot be fully evaluated from `terraform/` alone in this repo,
because the GitHub Actions OIDC IAM role is never defined in Terraform — it's only
referenced by ARN in `.github/workflows/deploy.yml`.

**Why:** in the 2026-07-08 audit, `terraform/` itself had no IAM resources to check, but
the deploy workflow hardcoded the AWS account ID, role ARN, S3 bucket name, and CloudFront
distribution ID. Missing this would mean under-reporting real findings just because they
live one directory over.

**How to apply:** when asked to audit `terraform/` security in this repo, also read
`.github/workflows/*.yml` briefly to check for hardcoded account IDs/ARNs and to flag that
the OIDC role's trust policy is unmanaged/unauditable from Terraform. Report these as
findings but note they are outside the `terraform/` directory strictly. See
[[project-portfolio-infra]].
