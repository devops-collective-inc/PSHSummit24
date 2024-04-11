# README

These are the docs from the 2024 DevOps Summit from Devin Rich's session on Mastering PowerShell: Working with APIs.

You can run the API website yourself by running Azurite from VSCode or by editing the local.settings.psd1 TABLE_STORE to an Azure Table Store account. With a table store service running, you can then run server.ps1 to start a local instance of the server. Change hostname from "localhost" to "*" in local.settings.psd1 to allow other devices on the network to be able to access the app.

Note that it does require Pode, Pode.Web, and AzBobbyTables powershell modules.

## Commands

All commands that were run during the session are stored in the commands files. Commands run from PowerShell Core are in commands_core.ps1. Commands run from Windows PowerShell are in commands_win.ps1.

## Docs

Here are the docs that were pulled up during the session:

<https://app.swaggerhub.com/apis-docs/SZERAAXSWAGGERHUB/summit-lab/0.0.1#/default/get_api_quote>

<https://pokeapi.co/>

<https://discord.com/developers/docs/resources/webhook#execute-webhook>

<https://developer.microsoft.com/en-us/graph/graph-explorer>

<https://learn.microsoft.com/en-us/graph/api/educationassignment-list-resources?view=graph-rest-1.0&tabs=http>
