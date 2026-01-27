# Auth Module - Cognito with Google Identity Provider

This module sets up an AWS Cognito User Pool with Google as a federated identity provider. It uses SSM Parameter Store to export configuration values.

## Prerequisites: Google OAuth 2.0 Credentials

To deploy this module, you need a Google Client ID and Client Secret. Follow these steps:

### 1. Create a Google Cloud Project
1.  Go to the [Google Cloud Console](https://console.cloud.google.com/).
2.  Create a new project (or select an existing one).

### 2. Configure OAuth Consent Screen
1.  Navigate to **APIs & Services > OAuth consent screen**.
2.  Select **External** (for testing/public) or **Internal** (if organization-only) and click **Create**.
3.  Fill in the **App Information** (App name, User support email) and **Developer contact information**.
4.  Click **Save and Continue**.
5.  (Optional) Add scopes if needed (default `email`, `profile`, `openid` are usually sufficient).
6.  (Optional) Add test users if the app is in "Testing" mode.

### 3. Create OAuth Client ID & Secret
1.  Navigate to **APIs & Services > Credentials**.
2.  Click **+ CREATE CREDENTIALS** and select **OAuth client ID**.
3.  **Application type**: Select **Web application**.
4.  **Name**: Enter a name (e.g., `Cognito Auth`).
5.  **Authorized JavaScript origins**:
    *   Add `http://localhost:3000` (for local development).
    *   Add your production domain if you have one.
6.  **Authorized redirect URIs**:
    *   *Note: You will need the Cognito Domain URL which is generated **after** this Terraform runs.*
    *   For now, you can leave it blank or add a placeholder.
    *   **AFTER Terraform apply**, you must come back here and add:
        `https://<your-cognito-domain>.auth.<region>.amazoncognito.com/oauth2/idpresponse`
7.  Click **Create**.
8.  Copy the **Client ID** and **Client Secret**.

## Usage

### 1. Initialize and Apply
Run terraform, providing the IDs you just created.

```bash
terraform init
terraform apply \
  -var="project_name=my-app" \
  -var="region=us-east-1" \
  -var="google_client_id=YOUR_GOOGLE_CLIENT_ID" \
  -var="google_client_secret=YOUR_GOOGLE_CLIENT_SECRET"
```

### 2. Post-Deployment Step (IMPORTANT)
1.  Terraform will output a `domain_url`.
2.  Go back to the [Google Cloud Console > Credentials](https://console.cloud.google.com/apis/credentials).
3.  Edit your OAuth Client.
4.  Add the following to **Authorized redirect URIs**:
    `<domain_url>/oauth2/idpresponse`
    *Example:* `https://my-app-dev-1234.auth.us-east-1.amazoncognito.com/oauth2/idpresponse`

## Inputs

| Name | Description | Required |
|------|-------------|:--------:|
| `region` | AWS Region (e.g., us-east-1) | Yes |
| `project_name` | Name of the project (used for naming resources) | Yes |
| `google_client_id` | OAuth 2.0 Client ID from Google | Yes |
| `google_client_secret` | OAuth 2.0 Client Secret from Google | Yes |
| `environment` | Deployment environment (default: dev) | No |

## Outputs (SSM Parameters)

This module creates the following SSM parameters for use in your application:
*   `/{project_name}/{environment}/cognito/user_pool_id`
*   `/{project_name}/{environment}/cognito/client_id`
*   `/{project_name}/{environment}/cognito/client_secret`
*   `/{project_name}/{environment}/cognito/domain`
