﻿Set Commands
=========================

This page contains details on **Set** commands.

Set-RubrikBlackout
-------------------------


NAME
    Set-RubrikBlackout
    
SYNOPSIS
    Connects to Rubrik and sets blackout (stops/starts all snaps)
    
    
SYNTAX
    Set-RubrikBlackout [-Set] [[-Server] <String>] [[-api] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The Set-RubrikBlackout cmdlet will accept a flag of true/false to set cluster blackout
    

PARAMETERS
    -Set [<SwitchParameter>]
        Rubrik blackout value
        
    -Server <String>
        Rubrik server IP or FQDN
        
    -api <String>
        API version
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Set-RubrikBlackout -Set [true/false]
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-RubrikBlackout -examples".
    For more information, type: "get-help Set-RubrikBlackout -detailed".
    For technical information, type: "get-help Set-RubrikBlackout -full".
    For online help, type: "get-help Set-RubrikBlackout -online"

Set-RubrikMount
-------------------------

NAME
    Set-RubrikMount
    
SYNOPSIS
    Powers on/off a live mounted virtual machine within a connected Rubrik vCenter.
    
    
SYNTAX
    Set-RubrikMount [-id] <String> [-PowerOn <Boolean>] [-Server <String>] [-api <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The Set-RubrikMount cmdlet is used to send a power on request to mounted virtual machine visible to a Rubrik cluster.
    

PARAMETERS
    -id <String>
        Mount id
        
    -PowerOn <Boolean>
        Configuration for the change power status request
        
    -Server <String>
        Rubrik server IP or FQDN
        
    -api <String>
        API version
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-RubrikMount -id '11111111-2222-3333-4444-555555555555' | Set-RubrikMount -PowerOn:$true
    
    This will send a power on request to "Server1"
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-RubrikMount -VMID (Get-RubrikVM -VM 'Server1').id | Set-RubrikMount -PowerOn:$false
    
    This will send a power off request to "Server1"
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-RubrikMount -examples".
    For more information, type: "get-help Set-RubrikMount -detailed".
    For technical information, type: "get-help Set-RubrikMount -full".
    For online help, type: "get-help Set-RubrikMount -online"

Set-RubrikVM
-------------------------

NAME
    Set-RubrikVM
    
SYNOPSIS
    Applies settings on one or more virtual machines known to a Rubrik cluster
    
    
SYNTAX
    Set-RubrikVM [-id] <String> [[-SnapConsistency] <String>] [[-MaxNestedSnapshots] <Int32>] [[-PauseBackups] <Boolean>] [[-UseArrayIntegration] <Boolean>] [[-Server] <String>] [[-api] <String>] [-WhatIf] 
    [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The Set-RubrikVM cmdlet is used to apply updated settings from a Rubrik cluster on any number of virtual machines
    

PARAMETERS
    -id <String>
        Virtual machine ID
        
    -SnapConsistency <String>
        Consistency level mandated for this VM
        
    -MaxNestedSnapshots <Int32>
        The number of existing virtual machine snapshots allowed by Rubrik. Choices range from 0 - 4 snapshots.
        
    -PauseBackups <Boolean>
        Whether to pause or resume backups/archival for this VM.
        
    -UseArrayIntegration <Boolean>
        User setting to dictate whether to use storage array snaphots for ingest. This setting only makes sense for VMs where array based ingest is possible.
        
    -Server <String>
        Rubrik server IP or FQDN
        
    -api <String>
        API version
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-RubrikVM 'Server1' | Set-RubrikVM -PauseBackups
    
    This will pause backups on any virtual machine named "Server1"
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-RubrikVM -SLA Platinum | Set-RubrikVM -SnapConsistency 'CRASH_CONSISTENT' -MaxNestedSnapshots 2 -UseArrayIntegration
    
    This will find all virtual machines in the Platinum SLA Domain and set their snapshot consistency to crash consistent (no application quiescence)
    while also limiting the number of active hypervisor snapshots to 2 and enable storage array (SAN) snapshots for ingest
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-RubrikVM -examples".
    For more information, type: "get-help Set-RubrikVM -detailed".
    For technical information, type: "get-help Set-RubrikVM -full".
    For online help, type: "get-help Set-RubrikVM -online"



