# Create Variables
$fileToProcess = get-childitem C:\Users\bstump.TCU\Desktop\Demo\StarTestReport1.txt | % FullName
$importPath = 'C:\Users\bstump.TCU\Desktop\Demo\Import'

# Split Reports
$iReport = [PowerShell]::Create().
  AddCommand('Expand-XtenderTextReport').
  AddParameter('FileName', $fileToProcess).
  AddParameter('Pattern', '^1').
  Invoke()

# Index Reports
$index = [PowerShell]::Create().
  AddCommand('Invoke-XtenderStarIndex').
  AddParameter('iReport', $iReport).
  AddParameter('fileToProcess', $fileToProcess).
  AddParameter('ImportPath',$importPath).
  AddParameter('fileIndex',0).
  Invoke()

# Output Indexes
$index | Out-File -FilePath C:\Users\bstump.TCU\Desktop\Demo\Import\index.txt


  
