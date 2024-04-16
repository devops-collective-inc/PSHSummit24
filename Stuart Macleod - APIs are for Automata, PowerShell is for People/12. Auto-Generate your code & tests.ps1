#---- Tip 12 - Auto-Generate your code & tests

https://www.youtube.com/watch?v=Bw2ctgOpmys

$Template = 'function <%= $FunctionName -%> {
    Param(
    <%- foreach($Param in $ParamNames) { -%>
        [Parameter()]
        [string]
        $<%= $Param %><%- if($Param -ne $ParamNames[-1]) { -%>,<%- } -%>
    <%- } %>
    )
    <%- if($Status -eq "good") { -%>
    return "This talk has gone well"
    <%- } else { -%>
    return "This talk has gone a little awry"
    <%- } -%>
}'

$Binding = @{
    FunctionName = "Get-TalkResponse"
    ParamNames   = 'One', 'Two', 'Three'
    Status       = 'good'
}
Invoke-EpsTemplate -Template $Template -Binding $Binding