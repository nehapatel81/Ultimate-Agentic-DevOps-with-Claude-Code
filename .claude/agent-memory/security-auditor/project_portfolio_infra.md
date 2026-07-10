---
name: project-portfolio-infra
description: Recurring security posture of the terraform/ static site infra (S3+CloudFront) for this portfolio project
metadata:
  type: project
---

The `terraform/` directory provisions a static portfolio site: one private S3 bucket
(`aws_s3_bucket.website`) fronted by CloudFront using OAC (not legacy OAI), with
`viewer_protocol_policy = "redirect-to-https"` and a public access block on the bucket.
State is currently local (`backend.tf` has the S3 backend block commented out).

**Why this matters:** the baseline (OAC, public access block, HTTPS redirect,
least-privilege bucket policy scoped with `AWS:SourceArn` condition) is consistently done
correctly here — do not re-flag these as findings in future audits unless the code changes.

**Recurring gaps found in the 2026-07-08 audit** (still open as of that date):
- No `aws_s3_bucket_server_side_encryption_configuration` on the website bucket (no
  encryption at rest configured).
- No `aws_cloudfront_response_headers_policy` attached to the distribution — no CSP,
  X-Frame-Options, HSTS, etc.
- No access logging on either the S3 bucket or the CloudFront distribution.
- `backend.tf` remote state backend is commented out — state is local, unencrypted, no
  locking.
- The IAM role used for GitHub Actions OIDC deploy (`github-actions-deploy`) is **not
  defined in Terraform at all** — it's only referenced by ARN in
  `.github/workflows/deploy.yml`. Its trust policy can't be audited from this repo.
- `.github/workflows/deploy.yml` hardcodes the AWS account ID, IAM role ARN, S3 bucket
  name, and CloudFront distribution ID directly in the workflow file rather than sourcing
  them from Terraform outputs or repo/environment variables.
- `variable "domain_name"` in `variables.tf` is declared but unused anywhere in `main.tf`
  — dead config suggesting an incomplete custom-domain/ACM setup. If it's wired up later,
  check that an ACM cert + `minimum_protocol_version = "TLSv1.2_2021"` replaces
  `cloudfront_default_certificate = true`.

**How to apply:** when re-auditing this repo, check whether these specific gaps have been
closed before re-reporting them, and check `.github/workflows/deploy.yml` alongside
`terraform/` since the OIDC role it assumes is invisible from Terraform alone. See
[[feedback-audit-scope]].
