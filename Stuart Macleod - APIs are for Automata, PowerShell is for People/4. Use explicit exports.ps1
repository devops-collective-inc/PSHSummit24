#---- Tip 4. Use Explicit FunctionsToExport & AliasesToExport

Publish-Module -Path .\Modules\DemoExplicitExports -Repository local
Publish-Module -Path .\Modules\DemoStarExports -Repository local

Install-Module DemoExplicitExports -Repository local
Install-Module DemoStarExports -Repository local