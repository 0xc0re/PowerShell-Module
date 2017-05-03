﻿#requires -Version 3
function Disconnect-Rubrik
{
    <#  
            .SYNOPSIS
            {required: high level overview}

            .DESCRIPTION
            {required: more detailed description of the function's purpose}

            .NOTES
            Written by {required}
            Twitter: {optional}
            GitHub: {optional}
            Any other links you'd like here

            .LINK
            https://github.com/rubrikinc/PowerShell-Module

            .EXAMPLE
            {required: show one or more examples using the function}
    #>

    [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'High')]
    Param(
        # The IP or FQDN of any available Rubrik node within the cluster
        [Parameter(Mandatory = $true,Position = 0)]
        [ValidateNotNullorEmpty()]
        [String]$Server
    )

    Begin {

    # The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
    # If a command needs to be run with each iteration or pipeline input, place it in the Process section
    
    # Check to ensure that a session to the Rubrik cluster exists and load the needed header data for authentication
    Test-RubrikConnection
    
    # API data references the name of the function
    # For convenience, that name is saved here to $function
    $function = $MyInvocation.MyCommand.Name

        #region On-off
        foreach ($session in $RubrikConnections)
        {
            if ($session.server -eq $Server)
            {
                $id = $session.id
                [String]$api = $session.api
                Write-Verbose -Message "Found session $id"
            }
        }
        if (!$id)
        {
            throw "No session information found for server $Server"
        }            
        #endregion
        
    # Retrieve all of the URI, method, body, query, result, filter, and success details for the API endpoint
    Write-Verbose -Message "Gather API Data for $function"
    $resources = (Get-RubrikAPIData -endpoint $function).$api
    Write-Verbose -Message "Load API data for $($resources.Function)"
    Write-Verbose -Message "Description: $($resources.Description)"
  
    }

    Process {

        $uri = New-URIString -server $Server -endpoint ($resources.URI) -id $id
        $uri = Test-QueryParam -querykeys ($resources.Query.Keys) -parameters ((Get-Command $function).Parameters.Values) -uri $uri
        $body = New-BodyString -bodykeys ($resources.Body.Keys) -parameters ((Get-Command $function).Parameters.Values)
        $result = Submit-Request -uri $uri -header $Header -method $($resources.Method) -body $body
        $result = Test-ReturnFormat -api $api -result $result -location $resources.Result
        $result = Test-FilterObject -filter ($resources.Filter) -result $result

        return $result

    } # End of process
} # End of function