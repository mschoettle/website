---
date:
  created: 2025-07-23
categories:
  - Digital Healthcare
---

# Authenticating as a system user with OpenEMR's FHIR API using OAuth2

At [Opal](../../../projects/index.md#opal) we want to support the current industry standard in healthcare integration which is [SMART on FHIR](https://infoscribe.infoway-inforoute.ca/display/HL7/SMART+on+FHIR).
This also makes sense given that Opal has a [partnership with OpenEMR](https://www.opalmedapps.com/en/nouvelles-openemr) which supports this standard.

In this article I describe how to authenticate a backend service using the `client_credentials` grant in Python in two different ways (i.e., with two different packages).
For example, this is required when making use of the [Bulk Export API](https://github.com/openemr/openemr/blob/master/API_README.md#client-credentials-grant).

<!-- more -->

## Creating a JSON Web Key

System clients require a JSON Web Key (JWK) to do asymmetric authentication when fetching a token.
You can generate a JWK at https://mkjwk.org/.
Select algorithm *RS384*, provide a key ID, and select to show the *X.509* certificates.

The public key needs to be provided to OpenEMR when registering the API client in the next step.
I recommend to upload the JWK somewhere and provide the URL to your public key to OpenEMR.
This way, the key can be rotated later without having to re-register a new API client.

The format of the JSON file that is expected is as follows:

```json
{
    "keys": [
        // the public key from the generator goes here
    ]
}
```

!!! warning

    Do **not** add your private key to this file.

## Registering an API client

The first step is to register the API client in OpenEMR.

This can be done via an API call or in the UI.
For the purpose of this article I describe how to register the client in OpenEMR's UI.
You can find details about the registration endpoint, scopes etc. in the [OpenEMR API documentation](https://github.com/openemr/openemr/blob/master/API_README.md#authorization).

The interface to register a new app can be found at `<host>/interface/smart/register-app.php`.
You can also find it from within OpenEMR under *Admin > System > API Clients*.

Make the follow selections:

- **Application Type:** Confidential
- **Application Context:** System Client Application
- **App Name:** Provide a meaningful name that identifies this application
- **Scopes Requested:** Selecting the *System Client* context limits the scopes to system scopes.
    Leave the full selection for testing purposes.
    For production, limit this to only the scopes that are actually needed.
- **JSON Web Key Set URI:** Provide the URL to your **public** JSON Web Key in the format described above.

Once registered, you get a client ID and client secret.
Keep note of those.
While we only need the client ID, it doesn't hurt to save both of those somewhere.

By default, new clients are disabled and need to be enabled by an administrator.
Go to *API Clients* in the system settings and enable the client you just created.

## Fetching an access token

At the time of writing, OpenEMR (current version `7.0.3`) supports *SMART on FHIR v1*.
There is an [authorization guide](https://hl7.org/fhir/uv/bulkdata/STU1/authorization/index.html) for this version.
However, I found the [client authentication guide for v2](https://build.fhir.org/ig/HL7/smart-app-launch/client-confidential-asymmetric.html) easier to follow.
I came across it via the information on [backend services](https://build.fhir.org/ig/HL7/smart-app-launch/backend-services.html).

Basically, the client needs to use the [asymmetric authentication process](https://build.fhir.org/ig/HL7/smart-app-launch/client-confidential-asymmetric.html#authenticating-to-the-token-endpoint) using the private key generated earlier.

The client generates a JSON Web Token (JWT) signed with their private key which the server can validate using the public key.
If successful, the server responds with the access token that the client can use to make requests.

Fortunately, there are Python packages that can help us with all this.
I will show two of those below.
All scripts contain *PEP 723 inline metadata* so you can run them using `uv` without installing dependencies yourself.

!!! note

    After going through the whole process I found the [Python SMART on FHIR client](https://github.com/smart-on-fhir/client-py) which I have not tested out yet.
    I intend to use the [`fhir.resources`](https://github.com/nazrulworld/fhir.resources/) package which defines FHIR resources as [Pydantic](https://) models.

### Using `requests-oauthlib` and `PyJWT`

[`requests-oauthlib`](https://requests-oauthlib.readthedocs.io/en/latest/index.html) adds OAuth2 support to the popular `requests` package.
It supports the [backend application flow](https://requests-oauthlib.readthedocs.io/en/latest/oauth2_workflow.html#backend-application-flow) which corresponds to the `client_credentials` grant we need to use.

To sign the JWT I used `PyJWT` although it might also be possible to accomplish this with the functionality provided in [`oauthlib`](https://oauthlib.readthedocs.io/en/latest/) which `requests-oauthlib` uses behind the scene.

The script below shows you how to fetch the token as a backend application.

```python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "cryptography==45.0.5",
#     "pyjwt==2.10.1",
#     "requests==2.32.3",
#     "requests-oauthlib==2.0.0",
# ]
# ///

import uuid
from datetime import datetime

import jwt
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

BASE_URL = 'https://...'
OAUTH_URL = BASE_URL + '/oauth2/default'
FHIR_URL = BASE_URL + '/apis/default/fhir'
TOKEN_ENDPOINT = f'{OAUTH_URL}/token'

CLIENT_ID = '...'
SCOPES = [
    'system/Patient.read',
]

PRIVATE_KEY = '-----BEGIN PRIVATE KEY-----\n...'
PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----\n...'

# current timestamp in epoch format
now = int(datetime.now().timestamp())
payload = {
    'iss': CLIENT_ID,
    'sub': CLIENT_ID,
    'aud': TOKEN_ENDPOINT,
    'exp': now + 5 * 60,
    'jti': uuid.uuid4().hex,
}

encoded = jwt.encode(payload, PRIVATE_KEY, algorithm='RS384', headers={'kid': 'requests-oauthlib-test'})

# verify that JWT can be decoded with the public key
jwt.decode(encoded, PUBLIC_KEY, algorithms=['RS384'], audience=TOKEN_ENDPOINT)

client = BackendApplicationClient(client_id=CLIENT_ID)
oauth = OAuth2Session(client=client)
token = oauth.fetch_token(
    token_url=TOKEN_ENDPOINT,
    client_id=CLIENT_ID,
    scope=' '.join(SCOPES),
    client_assertion_type='urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
    client_assertion=encoded,
)

print(f'Scope: {token["scope"]}')

patients = oauth.get(f'{FHIR_URL}/Patient')

print(f'Patients: {patients.json()["total"]}')
```

### Using `authlib`

[`authlib`](https://docs.authlib.org/en/latest/client/requests.html#using-private-key-jwt-in-requests) provides support for private key JWT authentication which makes the whole authentication very simple.

The script below shows you how to fetch the token using the built-in `PrivateKeyJWT` authentication.

```python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "authlib==1.6.0",
#     "requests==2.32.3",
# ]
# ///

import datetime as dt
from urllib.parse import urlencode

from authlib.integrations.requests_client import OAuth2Session
from authlib.oauth2.rfc7523 import PrivateKeyJWT

BASE_URL = 'https://...'
OAUTH_URL = BASE_URL + '/oauth2/default'
FHIR_URL = BASE_URL + '/apis/default/fhir'
TOKEN_ENDPOINT = f'{OAUTH_URL}/token'

CLIENT_ID = '...'
SCOPES = [
    'system/Patient.read',
]

PRIVATE_KEY = '-----BEGIN PRIVATE KEY-----\n...'

session = OAuth2Session(
    client_id=CLIENT_ID,
    client_secret=PRIVATE_KEY,
    scope=SCOPES,
    token_endpoint_auth_method=PrivateKeyJWT(
        token_endpoint=TOKEN_ENDPOINT,
        alg='RS384',
    ),
)
token = session.fetch_token(TOKEN_ENDPOINT)

response = session.get(f'{FHIR_URL}/Patient')

print(response)
print(response.json())
```

### Troubleshooting

Sometimes a response has a status code of `401` or `500` and there is not much information in the body.
The OpenEMR `error.log` usually has some helpful information.

```shell
$ tail /var/log/apache2/error.log
[Wed Jul 23 20:59:09.363827 2025] [php:notice] [pid 1448273] [client <ip>:59853] [2025-07-23T16:59:09.363409-04:00] OpenEMR.ERROR: CustomClientCredentialsGrant->validateClient() failed to retrieve jwk for client {"client":"<clientID>","exceptionMessage":"Malformed jwks missing keys property"} []
```

## What next?

Once we can retrieve data we can use [fhir.resources](https://github.com/nazrulworld/fhir.resources/) to validate this data and, if successful, have model instances for easier property access.
