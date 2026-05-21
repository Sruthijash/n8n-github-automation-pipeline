# GitHub Top Repositories Automation Pipeline

An automated backend data pipeline built using **n8n** that fetches, processes, and verifies trending GitHub repository data.

## 🚀 Workflow Architecture
1. **Schedule Trigger**: Fires the pipeline automatically.
2. **Fetch Top Repositories**: Queries the GitHub API for repositories with >25k stars.
3. **Filter Top 5**: Extracts the top 5 records using custom JavaScript logic.
4. **Enrich Languages Data**: Dynamically extracts primary development language payloads.
5. **Check Valid Payload**: Conditional routing router ensuring payload integrity.
6. **Data Output**: Transmits structured tech digests to a live verification webhook endpoint.

## 🛠️ Technical Implementation Details
* **Automation Platform:** n8n (Self-hosted via npm)
* **Data Format:** JSON / REST API Integration
* **Data Output Verification:** Webhook.site target delivery
