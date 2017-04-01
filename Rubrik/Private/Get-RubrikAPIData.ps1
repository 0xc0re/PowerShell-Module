﻿<#
    Helper function to retrieve API data from Rubrik
#>
function Get-RubrikAPIData($endpoint)
{
  $api = @{
    Example                       = @{
      v1 = @{
        Description = 'Details about the API endpoint'
        URI         = 'The URI expressed as /api/v#/endpoint'
        Method      = 'Method to use against the endpoint'
        Body        = 'Parameters to use in the body'
        Query       = 'Parameters to use in the URI query'
        Result      = 'If the result content is stored in a higher level key, express it here to be unwrapped in the return'
        Filter      = 'If the result content needs to be filtered based on key names, express them here'
        Success     = 'The expected HTTP status code for a successful call'
      }
    }
    Session                       = @{
      'v1.1' = @{
        Description = 'Create a new login session'
        URI         = '/api/v1/session'
        Method      = 'Post'
        Body        = ''
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '200'
      }
      'v1.0' = @{
        Description = 'Create a new login session'
        URI         = '/api/v1/login'
        Method      = 'Post'
        Body        = @('username', 'password')
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '200'
      }
    }
    ClusterIDVersionGet           = @{
      v1 = @{
        Description = 'Retrieves software version of the Rubrik cluster'
        URI         = '/api/v1/cluster/{id}/version'
        Method      = 'Get'
        Body        = ''
        Query       = ''
        Result      = 'version'
        Filter      = ''
        Success     = '200'
      }
    }
    FilesetGet                    = @{
      v1 = @{
        Description = 'Retrieve summary information for each fileset. Optionally, filter the retrieved information.'
        URI         = '/api/v1/fileset'
        Method      = 'Get'
        Body        = ''
        Query       = @{
          primary_cluster_id      = 'primary_cluster_id'
          host_id                 = 'host_id'
          is_relic                = 'is_relic'
          effective_sla_domain_id = 'effective_sla_domain_id'
          template_id             = 'template_id'
          limit                   = 'limit'
          offset                  = 'offset'
          cached                  = 'cached'
          name                    = 'name'
          host_name               = 'host_name'
        }
        Result      = 'data'
        Filter      = ''
        Success     = '200'
      } 
    }
    FilesetIDPatch                = @{
      v1 = @{
        Description = 'Update a Fileset with the specified properties.'
        URI         = '/api/v1/fileset/{id}'
        Method      = 'Patch'
        Body        = @{
          configuredSlaDomainId = 'configuredSlaDomainId'
        }
        Query       = ''
        Result      = 'data'
        Filter      = ''
        Success     = '200'
      } 
    }
    GenericSnapshotGet            = @{
      v1 = @{
        Description = 'Retrieve information for all snapshots for a VM'
        URI         = @{
          MSSQL  = '/api/v1/mssql/db/{id}/snapshot'
          VMware = '/api/v1/vmware/vm/{id}/snapshot'
        }
        Method      = 'Get'
        Body        = ''
        Query       = ''
        Result      = 'data'
        Filter      = @{
          '$CloudState'     = 'cloudState'
          '$OnDemandSnapshot' = 'isOnDemandSnapshot'
          '$Date'           = 'date'
        }
        Success     = '200'
      }
    }
    MSSQLDBGet                    = @{
      v1 = @{
        Description = 'Returns a list of summary information for Microsoft SQL databases.'
        URI         = '/api/v1/mssql/db'
        Method      = 'Get'
        Body        = ''
        Query       = @{
          instance_id             = 'instance_id'
          effective_sla_domain_id = 'effective_sla_domain_id'
          primary_cluster_id      = 'primary_cluster_id'
          is_relic                = 'is_relic'
        }
        Result      = 'data'
        Filter      = @{
          '$Database' = 'name'
          '$SLA'    = 'effectiveSlaDomainName'
          '$Host'   = 'rootProperties.rootName'
          '$Instance' = 'instanceName'
        }
        Success     = '200'
      }
    }
    MSSQLDBIDPatch                = @{
      v1 = @{
        Description = 'Update a Microsoft SQL database with the specified properties.'
        URI         = '/api/v1/mssql/db/{id}'
        Method      = 'Patch'
        Body        = @{
          logBackupFrequencyInSeconds = 'logBackupFrequencyInSeconds'
          logRetentionHours           = 'logRetentionHours'
          copyOnly                    = 'copyOnly'
          maxDataStreams              = 'maxDataStreams'
          configuredSlaDomainId       = 'configuredSlaDomainId'
        }
        Query       = 'Parameters to use in the URI query'
        Result      = 'data'
        Filter      = @{
          '$Database' = 'name'
          '$SLA'    = 'effectiveSlaDomainName'
          '$Host'   = 'rootProperties.rootName'
          '$Instance' = 'instanceName'
        }
        Success     = '200'
      } 
    }
    SLADomainGet                  = @{
      v1 = @{
        Description = 'Retrieve summary information for all SLA Domains'
        URI         = '/api/v1/sla_domain'
        Method      = 'Get'
        Body        = 'Parameters to use in the body'
        Query       = @{
          primary_cluster_id = 'primary_cluster_id'
        }
        Result      = 'data'
        Filter      = @{
          '$SLA' = 'name'
        }
        Success     = '200'
      }
    }
    SLADomainIDDelete             = @{
      v1 = @{
        Description = 'Delete an SLA Domain from a Rubrik cluster'
        URI         = '/api/v1/sla_domain/{id}'
        Method      = 'Delete'
        Body        = ''
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '204'
      }
    }
    SLADomainPost                 = @{
      v1 = @{
        Description = 'Create a new SLA Domain on a Rubrik cluster by specifying Domain Rules and policies'
        URI         = '/api/v1/sla_domain'
        Method      = 'Post'
        Body        = @{
          name        = 'name'
          frequencies = @{
            timeUnit  = 'timeUnit'
            frequency = 'frequency'
            retention = 'retention'
          }
        }
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '201'
      }
    }
    VMwareVMGet                   = @{
      v1 = @{
        Description = 'Get summary of all the VMs'
        URI         = '/api/v1/vmware/vm'
        Method      = 'Get'
        Body        = ''
        Query       = @{
          Relic  = 'is_relic'
          Search = 'name'
          SLA    = 'effective_sla_domain_id'
        }
        Result      = 'data'
        Filter      = @{
          '$VM' = 'name'
          '$SLA' = 'effectiveSlaDomainName'
        }
        Success     = '200'
      }
    }
    VMwareVMIDPatch               = @{
      v1 = @{
        Description = 'Update VM with specified properties'
        URI         = '/api/v1/vmware/vm/{id}'
        Method      = 'Patch'
        Body        = @{
          snapshotConsistencyMandate = 'snapshotConsistencyMandate'
          maxNestedVsphereSnapshots  = 'maxNestedVsphereSnapshots'
          configuredSlaDomainId      = 'configuredSlaDomainId'
          isVmPaused                 = 'isVmPaused'
          preBackupScript            = @{
            scriptPath      = 'scriptPath'
            timeoutMs       = 'timeoutMs'
            failureHandling = 'failureHandling'
          }
          postSnapScript             = @{
            scriptPath      = 'scriptPath'
            timeoutMs       = 'timeoutMs'
            failureHandling = 'failureHandling'
          }
          postBackupScript           = @{
            scriptPath      = 'scriptPath'
            timeoutMs       = 'timeoutMs'
            failureHandling = 'failureHandling'
          }
          isArrayIntegrationEnabled  = 'isArrayIntegrationEnabled'
        }
        Query       = ''
        Result      = ''
        Filter      = @{
          '$VM'    = 'name'
          '$SLA'   = 'effectiveSlaDomainName'
          '$Host'  = 'hostName'
          '$Cluster' = 'clusterName'
        }
        Success     = '200'
      }      
    }
    VMwareVMSnapshotIDMountPost   = @{
      v1 = @{
        Description = 'Create a live mount request with given configuration'
        URI         = '/api/v1/vmware/vm/snapshot/{id}/mount'
        Method      = 'Post'
        Body        = @{
          hostId               = 'hostId'
          vmName               = 'vmName'
          dataStoreName        = 'dataStoreName'
          disableNetwork       = 'disableNetwork'
          removeNetworkDevices = 'removeNetworkDevices'
          powerOn              = 'powerOn'
        }
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '202'
      }
    }
    VMwareVMSnapshotMountGet      = @{
      v1 = @{
        Description = 'Retrieve information for all live mounts'
        URI         = '/api/v1/vmware/vm/snapshot/mount'
        Method      = 'Get'
        Body        = ''
        Query       = @{
          vm_id  = 'vm_id'
          offset = 'offset'
          limit  = 'limit'
        }
        Result      = 'data'
        Filter      = ''
        Success     = '200'
      }
    }
    VMwareVMSnapshotMountIDDelete = @{
      v1 = @{
        Description = 'Create a request to delete a live mount'
        URI         = '/api/v1/vmware/vm/snapshot/mount/{id}'
        Method      = 'Delete'
        Body        = ''
        Query       = @{
          force = 'force'
        }
        Result      = ''
        Filter      = ''
        Success     = '202'
      }
    }
    VMwareVMIDSnapshotPost        = @{
      v1 = @{
        Description = 'Create an on-demand snapshot for the given VM ID'
        URI         = '/api/v1/vmware/vm/{id}/snapshot'
        Method      = 'Post'
        Body        = ''
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '202'
      }      
    }
    VMwareVMSnapshotMountIDPost   = @{
      v1 = @{
        Description = 'Power given live-mounted vm on/off'
        URI         = '/api/v1/vmware/vm/snapshot/mount/{id}'
        Method      = 'Post'
        Body        = @{
          powerStatus = 'powerStatus'
        }
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '200'
      }
    }
    VMwareVMRequestIDGet          = @{
      v1 = @{
        Description = 'Get details about a vmware vm related async request'
        URI         = '/api/v1/vmware/vm/request/{id}'
        Method      = 'Get'
        Body        = ''
        Query       = ''
        Result      = ''
        Filter      = ''
        Success     = '200'
      }
    }
  } # End of API
  
  return $api.$endpoint
} # End of function
