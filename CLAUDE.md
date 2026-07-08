# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**DMI Portfolio Website** — A professional static HTML/CSS portfolio site for Pravin Mishra (cloud/DevOps consultant). This repository serves as a teaching tool for DMI Week 1 students learning to deploy static sites on Linux/Nginx. It also includes production-grade CI/CD and infrastructure-as-code for AWS hosting.

**Key characteristics:**
- **No build process** — pure HTML/CSS with external CDN dependencies (Font Awesome)
- **Static site** — zero server-side logic
- **Dual deployment paths** — manual Nginx (DMI assignment) and automated AWS (production)
- **Custom Claude Code skills** — for Terraform and deployment automation

---

## Core Architecture

### File Structure
- **index.html** — Main portfolio page with sections: hero, about, services, courses, books, community, contact
- **privacy.html, terms.html** — Legal pages (minimal content)
- **style.css** — Single stylesheet handling all responsive design (mobile-first via hamburger menu)
- **images/** — Logo, hero banner, book/course covers, signature
- **.github/workflows/deploy.yml** — GitHub Actions: syncs to S3, invalidates CloudFront on main push
- **.claude/skills/** — Custom automation skills for infrastructure and deployment

### Responsiveness
The site uses CSS media queries and a hamburger menu for mobile; no JavaScript framework. Navigation links scroll to in-page anchors. External icon library: Font Awesome 6.5.0 via CDN.

### Deployment Paths

1. **DMI Assignment (Manual, Ubuntu VM)**
   - Students copy files to `/var/www/html` on an Ubuntu VM
   - Nginx serves static files on port 80
   - Requirement: edit footer (line 604, index.html) to add deployment proof with name/date/group
   - Must stay live for 24 hours

2. **Production (AWS, Automated CI/CD)**
   - GitHub Actions on `main` push syncs files to S3 bucket: `pravinmishradmi-site-production`
   - CloudFront distribution invalidates cache automatically
   - Uses OIDC for AWS authentication (no long-lived credentials stored)
   - Region: eu-north-1
   - Workflow excludes: terraform/, .git/, .github/, .claude/, .md files

---

## Key Files to Know

| File | Purpose |
|------|---------|
| `README.md` | DMI assignment brief and deployment proof requirements |
| `index.html` | Complete page structure; line 604 is the mandatory footer edit zone |
| `style.css` | Entire visual design; ~1500 lines, media queries at bottom for responsive layout |
| `.github/workflows/deploy.yml` | CI/CD pipeline: S3 sync + CloudFront invalidation |
| `.claude/skills/` | Custom Claude Code skills for Terraform and deployment tasks |

---

## Common Tasks & Commands

### No Build Step Required
This is pure static content. No `npm install`, `yarn build`, or compilation needed. Serve directly via HTTP.

### Local Testing
For quick testing before deployment, use any simple HTTP server in the root directory:
```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000

# Node (if installed)
npx http-server
```
Then visit `http://localhost:8000`.

### DMI Deployment (Manual)
1. Edit `index.html` line 604 footer to add: `<p><strong>Deployed by:</strong> Your Name | Group X | Date</p>`
2. Copy all files (except `.git`, `.github`, `terraform`, `.claude`, `*.md`) to Ubuntu VM `/var/www/html`
3. Verify in browser: `http://<vm-public-ip>`
4. Screenshot proof, keep live 24h

### Production Deployment (Automated)
No manual steps — push to `main` branch triggers GitHub Actions automatically:
```bash
git add .
git commit -m "Update site content"
git push origin main
```
Workflow runs: S3 sync → CloudFront invalidation. Live within 60 seconds.

### AWS Infrastructure Setup (One-Time)
If setting up AWS infrastructure from scratch:
1. **Scaffold Terraform:** Use `/scaffold-terraform` skill (generates S3, CloudFront, OIDC role)
2. **Plan:** Use `/tf-plan` skill to review resources before applying
3. **Deploy:** Use `/deploy` skill to sync files and invalidate cache (after `terraform apply`)

---

## Custom Claude Code Skills

These are pre-configured skills in `.claude/skills/`:

- **`/scaffold-terraform`** — Generate complete Terraform configuration for S3 + CloudFront. Args: `[region] [project-name]`
- **`/tf-plan`** — Run `terraform plan` and analyze for risks/blast radius. Use before infrastructure changes.
- **`/tf-apply`** — (implied by SKILL.md existence) Apply Terraform changes. Destructive; requires review.
- **`/deploy`** — Sync site to S3, invalidate CloudFront cache. Use after Terraform apply.

---

## Important Notes

### DMI Assignment Rule: Mandatory Footer Edit
**Before any DMI deployment**, students MUST edit the footer (`index.html`, around line 604):
- Find: `<p>Crafted with <span>cloud</span> excellence by Pravin Mishra</p>`
- Add below it: `<p><strong>Deployed by:</strong> [Your Name] | [Group] | [Date]</p>`
- This proof must appear in screenshots for submission

### CI/CD Exclusions
The GitHub Actions workflow explicitly excludes these from S3 sync:
- `.git/*`, `.github/*`, `.claude/*` — tooling
- `terraform/*` — infrastructure config (not web content)
- `*.md` — documentation
This keeps the S3 bucket clean and reduces costs.

### External Dependencies
- **Font Awesome 6.5.0** — loaded via CDN (`cdnjs.cloudflare.com`)
- If CDN is unavailable, icons render as missing; content remains readable
- No other JS libraries; all functionality is pure HTML + CSS

### Contact & Social Links
Social links in footer point to Pravin Mishra's actual accounts (LinkedIn, GitHub, YouTube, etc.). Do not change these unless explicitly requested; they are part of the portfolio branding.

---

## Troubleshooting

| Issue | Likely Cause | Fix |
|-------|--------------|-----|
| Site looks broken, icons missing | Font Awesome CDN unavailable | Check browser console for 403/404. Fallback: replace with emoji or simple text |
| Images don't load | Wrong image path | Images are in `./images/` relative to root; check for typos |
| Mobile menu stuck | CSS/hamburger logic | Check `style.css` media queries; JavaScript in HTML uses `toggleMenu()` function |
| Deployment fails on main push | AWS credentials or IAM misconfigured | Check GitHub repo secrets, OIDC role ARN, S3 bucket name in workflow |

---

## AWS Account Details (for Workflow Context)

- **AWS Account ID:** 533267262133
- **S3 Bucket:** pravinmishradmi-site-production
- **CloudFront Distribution ID:** E3V6O6MRE2E21P
- **Region:** eu-north-1
- **OIDC Role:** arn:aws:iam::533267262133:role/github-actions-deploy

Treat these as read-only reference; do not edit the workflow without understanding the implications.
