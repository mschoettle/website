import json
import sys
from http import HTTPStatus
from pathlib import Path

import requests


def check_redirect(url: str) -> bool:
    url = f'http://localhost{url}'
    print(f'checking URL: {url}')
    response = requests.get(url)

    if response.status_code != HTTPStatus.OK:
        print(f'ERROR: URL {url} returned: {response.status_code}')
        return False

    return True


with Path('.github/redirects/urls.json').open() as fd:
    urls = json.load(fd)

result = True

for url in urls:
    result &= check_redirect(url)

if not result:
    sys.exit(1)
