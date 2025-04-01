---
date:
  created: 2025-04-01
---
# Stopping VSCode Python Extension from Changing your Terminal Environment

I have tripped over an outdated environment variable a few times when running Python from within `vscode`.
And I finally figured out what caused it.

We store our environment variables in a `.env` file that is then used by our *Django* application.
We use the [django-environ](https://github.com/joke2k/django-environ) package for this.
During development, this file is loaded on startup.
When deployed, we provide the file via `env_file` in the compose file.

What happened in `vscode` is that when a value in `.env` changed, running something, such as `pytest`, would not see this new environment variable value.

After a while I noticed that there was a yellow warning sign next to the terminal process.
When hovering over it it asks you to relaunch the terminal because the environment changed.
It took me a long time to figure this out in the first place.
It's not something I expected and not very intuitive.

I had looked in the past in the settings where this is coming from and how this can be disabled and could not find anything.
Today I finally figured it out, after running into this issue *again* and wasting time until I realized why something did not work.

The popup shown when hovering over the allows you to "Show Environment Contributions".
The [Python VSCode extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) contributed the variables and causes this behaviour.
In *Settings > Extensions > Python* there is an entry called "Env File" that contains `${workspaceFolder}/.env`.
Remove the value and relaunch the terminal.

Now changes to your `.env` file won't affect your terminal's environment anymore.
