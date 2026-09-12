---
name: firecrawl-cli-installation
description: Install the official Firecrawl CLI and handle authentication.
---

# Firecrawl CLI Installation

Quick setup: `npx -y firecrawl-cli@latest init -y --browser`.

Manual install: `npm install -g firecrawl-cli@latest`.

Verify with `firecrawl --status`. Authenticate with `firecrawl login --browser` or `FIRECRAWL_API_KEY`. Search, scrape, and interact may use the rate-limited keyless tier; account-dependent commands require authentication.
