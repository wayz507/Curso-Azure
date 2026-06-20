Azure service principal and GitHub secrets required for workflow-runner auth

Required GitHub repository secrets
- AZURE_CLIENT_ID : the application (client) id of the service principal
- AZURE_CLIENT_SECRET : the service principal client secret
- AZURE_TENANT_ID : the Entra/Microsoft Entra (tenant) id
- AZURE_SUBSCRIPTION_ID : target Azure subscription id
- GH_ACCESS_TOKEN : a GitHub personal access token used by workflows when referenced (if used)

Notes
- The workflows also mirror values into ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID and ARM_SUBSCRIPTION_ID so Terraform picks them up.
- Never commit secrets to source control. Add them through GitHub repository Settings → Secrets → Actions or via `gh secret`.

Create a service principal (examples)
1) Login as an interactive user in your environment:

```bash
az login
az account set --subscription "$SUBSCRIPTION_ID"
```

2) Create a service principal scoped to the subscription (least-privilege: consider scoping to a resource group instead of the full subscription):

```bash
az ad sp create-for-rbac \
  --name "github-actions-sp-<repo>" \
  --role "Contributor" \
  --scopes "/subscriptions/$SUBSCRIPTION_ID" \
  --sdk-auth > sp.json
```

- `sp.json` contains `clientId`, `clientSecret`, `tenantId`, and `subscriptionId` (the JSON form can be used for some automation). If you prefer a one-liner output:

```bash
az ad sp create-for-rbac --name "github-actions-sp-<repo>" --role "Contributor" --scopes "/subscriptions/$SUBSCRIPTION_ID"
```

Capture the values:
```bash
CLIENT_ID=$(jq -r .clientId sp.json)
CLIENT_SECRET=$(jq -r .clientSecret sp.json)
TENANT_ID=$(jq -r .tenantId sp.json)
SUBSCRIPTION_ID=$(jq -r .subscriptionId sp.json)
```

Add secrets to GitHub (examples)
- Using the GitHub web UI: Repository → Settings → Secrets and variables → Actions → New repository secret. Add `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, and `GH_ACCESS_TOKEN` (if needed by your workflows).

- Using `gh` CLI (recommended for automation):

```bash
# set secrets for repo owner/repo
gh secret set AZURE_CLIENT_ID --body "$CLIENT_ID" --repo OWNER/REPO
gh secret set AZURE_CLIENT_SECRET --body "$CLIENT_SECRET" --repo OWNER/REPO
gh secret set AZURE_TENANT_ID --body "$TENANT_ID" --repo OWNER/REPO
gh secret set AZURE_SUBSCRIPTION_ID --body "$SUBSCRIPTION_ID" --repo OWNER/REPO
```

Test the service principal locally

```bash
az login --service-principal -u "$CLIENT_ID" -p "$CLIENT_SECRET" --tenant "$TENANT_ID"
az account show --subscription "$SUBSCRIPTION_ID"
```

Triggering the deployment workflow from the GitHub UI
- Go to the repository Actions tab → select "Infrastructure Deployment" workflow → Run workflow → choose branch `main` and any inputs, then Run workflow.

Security recommendations
- Prefer scoping the service principal to the minimal resource group, not the whole subscription.
- Rotate client secrets periodically and store them securely.
- Grant only the permissions your Terraform needs (for example `Contributor` on a resource group instead of subscription-wide).

If you want, I can:
- Provide a script to create the SP with least-privilege for a specific resource group.
- Add a short check-action to the repository to verify the required secrets are present before allowing a run.
