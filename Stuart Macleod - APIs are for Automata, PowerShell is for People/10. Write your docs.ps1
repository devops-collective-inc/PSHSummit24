#---- Tip 10. The best way to help users is documentation

function Invoke-UnhelpfulQuestionsThree {
    Param(
        $Name,
        $Quest,
        $AirSpeedVelocity
    )

    Write-Host $PSBoundParameters
}









function Invoke-HelpfulQuestionsThree {
    <#
    .SYNOPSIS
    Get helpful info
    .DESCRIPTION
    Some longer amount of information about helpfulness
    .LINK
    https://github.com/stuartio
    .EXAMPLE
    > Invoke-HelpfulQuestionsThree -Name 'Arthur, King of the Britons' -Quest 'To find the Holy Grail' -AirSpeedVelocity 'Is that an African or European swallow?'
    #>
    Param(
        # What is your name?
        $Name,
        # What is your quest?
        $Quest,
        # What is the air speed velocity of an unladen swallow?
        $AirSpeedVelocity
    )

    Write-Host $PSBoundParameters
}