﻿<#
Helper function to allow self-signed certificates for HTTPS connections
This is required when using RESTful API calls over PowerShell
#>
function UnblockSelfSignedCerts() 
{
    Write-Verbose -Message 'Allowing self-signed certificates'
    Add-Type -TypeDefinition @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
	    public bool CheckValidationResult(
	        ServicePoint srvPoint, X509Certificate certificate,
	        WebRequest request, int certificateProblem) {
	        return true;
	    }
    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
}