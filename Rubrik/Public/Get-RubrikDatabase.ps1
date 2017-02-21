﻿#requires -Version 3
function Get-RubrikDatabase
{
  <#  
      .SYNOPSIS
      Retrieves details on one or more databases known to a Rubrik cluster

      .DESCRIPTION
      The Get-RubrikDatabase cmdlet is used to pull a detailed data set from a Rubrik cluster on any number of databases

      .NOTES
      Written by Chris Wahl for community usage
      Twitter: @ChrisWahl
      GitHub: chriswahl

      .LINK
      https://github.com/rubrikinc/PowerShell-Module

      .EXAMPLE
      !!!!!!!!!!!!!!!!!!!!!!!!!!Get-RubrikVM -VM 'Server1'
      This will return the ID of the virtual machine named Server1
  #>

  [CmdletBinding()]
  Param(
    # Name of the database
    # If no value is specified, will retrieve information on all databases
    [Parameter(Position = 0,ValueFromPipeline = $true)]
    [Alias('Name')]
    [String]$Database,
    # Filter results based on active, relic (removed), or all databases
    [Parameter(Position = 1)]
    [Alias('archiveStatusFilterOpt','archive_status')]
    [ValidateSet('ACTIVE', 'RELIC')]
    [String]$Filter,
    # SLA Domain policy
    [Parameter(Position = 2,ValueFromPipeline = $true)]
    [Alias('sla_domain_id')]    
    [String]$SLA,        
    # Rubrik server IP or FQDN
    [Parameter(Position = 3)]
    [String]$Server = $global:RubrikConnection.server,
    # API version
    [Parameter(Position = 4)]
    [ValidateNotNullorEmpty()]
    [String]$api = $global:RubrikConnection.api
  )

  Process {

    TestRubrikConnection
        
    Write-Verbose -Message 'Determining which version of the API to use'
    $resources = GetRubrikAPIData -endpoint ('MSSQLDBGet')
    
    Write-Verbose -Message 'Building the URI'
    $uri = 'https://'+$Server+$resources.$api.URI

    # Optional parameters for the query
    # We'll start with an empty array
    $params = @()

    # Param #1 = Filter
    # Can filter results based on active, relic (archived), or all databases
    if ($Filter -and $resources.$api.Params.Filter -ne $null) 
    {
      $params += $($resources.$api.Params.Filter)+'='+$Filter
    }
    
    # Param #2 = Search
    # Optional search filter if a DB is specified
    # Otherwise, all DBs will be retrieved
    if ($VM -and $resources.$api.Params.Search -ne $null) 
    {
      $params += $($resources.$api.Params.Search)+'='+$VM
    }
    
    # Param #3 = Limit
    # Optional limitation on the number of results returned
    # By default, the API only returns a small subset of the objects
    $params += 'limit=9999'

    # Build the optional params string for the query
    # Start by using a "?" for the first param, and then use an "&" for any additional params
    foreach ($_ in $params)
    {
      if ($_ -eq $params[0]) 
      {
        $uri += '?'+$_
      }
      else 
      {
        $uri += '&'+$_
      }
    }      

    # Set the method
    $method = $resources.$api.Method

    try 
    {
      Write-Verbose -Message "Submitting a request to $uri"
      $r = Invoke-WebRequest -Uri $uri -Headers $Header -Method $method
      
      Write-Verbose -Message 'Convert JSON content to PSObject (Max 64MB)'
      [void][System.Reflection.Assembly]::LoadWithPartialName('System.Web.Extensions')
      $result = ParseItem -jsonItem ((New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer -Property @{
            MaxJsonLength = 67108864
      }).DeserializeObject($r.Content))
      
      # The v0 API doesn't have queries
      # This will manually filter the results if the user has provided inputs
      if ($api -ne 'v0') 
      {
        # Strip out the overhead
        $result = $result.data
      }
      
      # Optionally Finds a specific VM if the user has provided the $VM param
      # Using "eq" to avoid partial string matches
      if ($Database) 
      {
        $result = $result | Where-Object -FilterScript {
          $_.name -eq $Database
        }
      }      
      
      # Optionally finds a specific SLA if the user has provided the $SLA param
      if ($SLA) 
      {
        $result = $result | Where-Object -FilterScript {
          $_.effectiveSlaDomainName -like $SLA
        }
      }
      
      return $result
    }
    catch 
    {
      throw $_
    }

  } # End of process
} # End of function
