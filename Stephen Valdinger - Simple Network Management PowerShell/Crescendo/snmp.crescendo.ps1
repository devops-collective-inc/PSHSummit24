#region snmpwalk command

#Build an Crescendo object. We'll add things to this object as we go.
$snmpwalk = New-CrescendoCommand -Verb Start -Noun Snmpwalk -OriginalName snmpwalk

#Build our parameters for our new Cmdlet
$parameters = @(
($v = New-ParameterInfo -Name Version -OriginalName '-v')
($c = New-ParameterInfo -Name Community -OriginalName '-c')
($t = New-ParameterInfo -Name Target -OriginalName $null)
($o = New-ParameterInfo -Name Oid -OriginalName $null)
)

#Create an inline Output Handler to parse the output of snmpwalk into an object
$handler = {
    param([object[]]$lines)

    $lines | Foreach-Object {
        $matcher = '(?<oid>(.*?))\s=\s(?<type>\w+(?=:)):\s(?<value>.+)'
        #Match current item in pipeline to my regex matcher above. Automatically added to $matches
        $null = $_ -match $matcher

        [pscustomobject]@{
            Oid   = $Matches.oid
            Type  = $Matches.type
            Value = $Matches.value
        }
    }
}


#Create our Output Handler object
$OutputHandler = New-OutputHandler
$OutputHandler.ParameterSetName = 'Default'
$OutputHandler.Handler = $handler.ToString()
$OutputHandler.HandlerType = 'Inline'

#Doctor things a bit
$v.NoGap = $true
$snmpwalk.Parameters = $parameters
$snmpwalk.OutputHandlers = $OutputHandler

#Produce the json schema file
$snmpwalk | Export-CrescendoCommand

#Produce the module and load it
Export-CrescendoModule -ConfigurationFile ./Start-Snmpwalk.crescendo.json -ModuleName SNMP
Import-Module ./SNMP.psd1 -Force
#endregion

#region snmpbulkwalk command
$snmpbulkwalk = New-CrescendoCommand -Verb Start -Noun Snmpbulkwalk -OriginalName snmpbulkwalk

$parameters = @(
($v = New-ParameterInfo -Name Version -OriginalName '-v')
($c = New-ParameterInfo -Name Community -OriginalName '-c')
($t = New-ParameterInfo -Name Target -OriginalName $null)
($o = New-ParameterInfo -Name Oid -OriginalName $null)
)

$handler = {
    param([object[]]$lines)

    $lines | Foreach-Object {
        $matcher = '(?<oid>(.*?))\s=\s(?<type>\w+(?=:)):\s(?<value>.+)'
        $null = $_ -match $matcher
        [pscustomobject]@{
            Oid   = $Matches.oid
            Type  = $Matches.type
            Value = $Matches.value
        }
    }
}
$OutputHandler = New-OutputHandler
$OutputHandler.ParameterSetName = 'Default'
$OutputHandler.Handler = $handler.ToString()
$OutputHandler.HandlerType = 'Inline'

$OutputHandler.Handler

#Doctor things a bit
$v.NoGap = $true
$snmpbulkwalk.Parameters = $parameters
$snmpbulkwalk.OutputHandlers = $OutputHandler

#Produce the json schema file
Export-CrescendoCommand -Command $snmpbulkwalk
#endregion

#Region demo using Start-SnmpWalk

#Simple, get some data
Start-Snmpwalk -Version 1 -Community public -Target chocoserver.steviecoaster.dev -Oid .1.3.6.1.2.1.25.6.3.1.2

#Use the data in interesting ways
Start-Snmpwalk -Version 1 -Community public -Target chocoserver.steviecoaster.dev -Oid .1.3.6.1.2.1.25.6.3.1.2 |
Select-Object @{Name = 'DisplayName'; Expression = { $_.Value -replace '"',''}}

#Cheeky lil function
function ConvertTo-PrettiertHtml {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]]
        $InputObject
    )

    begin {
        $Array = @()
    }
    process {
        $Array += $InputObject
    }
    end {
       $Table = $Array | ConvertTo-Html -Fragment
    
    
        @"
 <style>
 .strip-decoration {
   text-decoration: none;
   color: darkgrey;
 }
 .pw {
   font-family: monospace;
 }
 .textshadow .blurry-text {
   color: transparent;
   text-shadow: 0 0 5px rgba(0,0,0,0.5);
 }
 code {
   font-family: MyFancyCustomFont, monospace;
   font-size: inherit;
 }
 p > code,
 li > code,
 dd > code,
 td > code {
   background: #ffeff0;
   word-wrap: break-word;
   box-decoration-break: clone;
   padding: .1rem .3rem .2rem;
   border-radius: .2rem;
 }
 pre code {
   display: block;
   margin-right: 25%;
   background: none;
   white-space: pre;
   -webkit-overflow-scrolling: touch;
   overflow-x: scroll;
   max-width: 100%;
   min-width: 100px;
   padding: 0;
 }
 .logo {
     border-radius: 30%;
     width: 20px;
 }
 table {
     border-collapse: collapse;
 }
 td,
 th {
     border: 0.1em solid rgba(0, 0, 0, 0.5);
     padding: 0.25em 0.5em;
     text-align: left;
 }
 blockquote {
     width: 985px;
     margin-left: 0em;
     margin-right: 25%;
     padding-left: 0.5em;
     border-left: 0.1em solid rgba(0, 0, 0, 0.5);
     border-radius: 3px;
     background-color: lightgrey;
     padding-top: 0.1em;
     padding-bottom: 0.5em;
 }
 a {
   color: #5c9fd8;
   text-decoration: none;
 }
 ul {
   list-style-type: none;
 }
 ul > li:before {
   content: "-";
   position: absolute;
   margin-left: -1.1em;
 }
 li {
   padding-bottom: 1em;
 }
 .row {
   display: flex;
   margin: 8px;
   padding-top: 8px;
 }
 .column {
   float: left;
 }
 .left {
   width: 200px;
 }
 .right {
   width: auto;
 }
 .header {
   background-color: rgba(9,16,22,.95);
   color: #fff;
 }
 .main {
   margin-left: 20px;
   margin-right: 20px;
 }
 body {
   margin: 0;
   font-family: "PT Sans", sans-serif;
 }
 h1 {
   font-size: 2.5rem;
   font-weight: 700;
   margin-bottom: 0.5rem;
   line-height: 1.2;
   margin-inline-start: 0px;
   margin-inline-end: 0px;
 }
 h2 {
   font-size: 2rem;
   font-weight: 700;
   display: block;
   margin-block-start: 0.83em;
   margin-block-end: 0.83em;
   margin-inline-start: 0px;
   margin-inline-end: 0px;
   padding-bottom: 0.5rem;
   border-bottom: 3px solid rgba(92,159,216,.25);
 }</style>
 <script>
 function CopyToClipboard(id)
 {
   var r = document.createRange();
   r.selectNode(document.getElementById(id));
   window.getSelection().removeAllRanges();
   window.getSelection().addRange(r);
   document.execCommand('copy');
   window.getSelection().removeAllRanges();
 }
 </script>
<body>
<div class="header">
  <div class="row">
    <div class="column left">
      <img src="https://chocolatey.org//assets/images/global-shared/logo-square.svg" alt="Chocolatey Logo" width="169" style="display: block; margin: auto;">
    </div>
    <div class="column right">
      <h1>SNMP Installed Software Report</h1>
      <p style="margin-left: 0.5em"><i>Installed on this computer</i></p>
    </div>
  </div>
</div>
<div class="main">
$($Table)
</div>
</body>
</html>
"@

    }
}

Start-Snmpwalk -Version 1 -Community public -Target chocoserver.steviecoaster.dev -Oid .1.3.6.1.2.1.25.6.3.1.2 |
Select-Object @{Name = 'DisplayName'; Expression = { $_.Value -replace '"',''}} |
ConvertTo-PrettiertHtml |
Out-File ./SoftwareReport.html -Force ; Invoke-Item .

#$Data | ConvertTo-Html -Property DisplayName -Title 'Installed Software Report' | Out-File .\SoftwareReport.html -Force

#endregion