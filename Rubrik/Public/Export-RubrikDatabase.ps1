﻿#Requires -Version 3
function Export-RubrikDatabase
{
  <#
      .SYNOPSIS
      Connects to Rubrik exports a database to a MSSQL instance

      .DESCRIPTION
      The Export-RubrikDatabase command will request a database export from a Rubrik Cluster to a MSSQL instance

      .NOTES
      Written by Pete Milanese for community usage
      Twitter: @pmilano1
      GitHub: pmilano1

      .EXAMPLE
      Export-RubrikDatabase -id MssqlDatabase:::c5ecf3ef-248d-4bb2-8fe1-4d3c820a0e38 -targetInstanceId MssqlInstance:::0085b247-e718-4177-869f-e3ae1f7bb503 -targetDatabaseName ReportServer -finishRecovery -maxDataStreams 4 -timestampMs 1492661627000
      .LINK
      https://github.com/rubrikinc/PowerShell-Module
  #>

  [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'High')]
  Param(
    # Rubrik identifier of database to be exported
    [Parameter(Mandatory = $true)]
    [String]$id,
    # Number of parallel streams to copy data
    [int]$maxDataStreams,
    # Recovery Point desired in the form of Epoch with Milliseconds
    [int64]$timestampMs,
    # Take database out of recovery mode after export
    [Switch]$finishRecovery,
    # Rubrik identifier of MSSQL instance to export to
    [string]$targetInstanceId,
    # Name to give database upon export
    [string]$targetDatabaseName,
    # Rubrik server IP or FQDN
    [String]$Server = $global:RubrikConnection.server,
    # API version
    [String]$api = $global:RubrikConnection.api
  )

    Begin {

    # The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
    # If a command needs to be run with each iteration or pipeline input, place it in the Process section

    # Check to ensure that a session to the Rubrik cluster exists and load the needed header data for authentication
    Test-RubrikConnection

    # API data references the name of the function
    # For convenience, that name is saved here to $function
    $function = $MyInvocation.MyCommand.Name

    # Retrieve all of the URI, method, body, query, result, filter, and success details for the API endpoint
    Write-Verbose -Message "Gather API Data for $function"
    $resources = (Get-RubrikAPIData -endpoint $function).$api
    Write-Verbose -Message "Load API data for $($resources.Function)"
    Write-Verbose -Message "Description: $($resources.Description)"

  }

  Process {

    $uri = New-URIString -server $Server -endpoint ($resources.URI) -id $id
    $uri = Test-QueryParam -querykeys ($resources.Query.Keys) -parameters ((Get-Command $function).Parameters.Values) -uri $uri


    #region One-off
    Write-Verbose -Message "Build the body"
    $body = @{
      $resources.Body.targetInstanceId = $targetInstanceId
      $resources.Body.targetDatabaseName = $targetDatabaseName
      $resources.Body.finishRecovery = $finishRecovery.IsPresent
      $resources.Body.maxDataStreams = $maxDataStreams
      recoveryPoint = @()
    }
    $body.recoveryPoint += @{
          $resources.Body.recoveryPoint.timestampMs = $timestampMs
          }
    $body = ConvertTo-Json $body
    Write-Verbose -Message "Body = $body"
    #endregion


    $result = Submit-Request -uri $uri -header $Header -method $($resources.Method) -body $body
    $result = Test-ReturnFormat -api $api -result $result -location $resources.Result
    $result = Test-FilterObject -filter ($resources.Filter) -result $result

    return $result

  } # End of process
} # End of function
