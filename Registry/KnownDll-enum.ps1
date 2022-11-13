<#
.Name
  KnownDll-enum.ps1
.SYNOPSIS
  List all subkey values in a registry key.
.DESCRIPTION
  List all subkey values in a registry key. Takes any registry keypath anywhere by default
.PARAMETERS
  None.
.INPUTS
  None. You can not pipe objects to KnownDll-enum.ps1
.OUTPUTS
  System.String. Add-Extension returns a string that is a list of registry key values
.NOTES
  Version:        1.0
  Author:         dexoidan
  Creation Date:  13-11-2022
  Purpose/Change: Initial script development
.EXAMPLE
  PS> .\KnownDll-enum.ps1
.LINK
  Online version: https://github.com

Copyright © 2022 <dexoidan>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”),
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
#>

function Test-Administrator()
{
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}

if(Test-Administrator)
{
    $Hive = [Microsoft.Win32.RegistryHive]::LocalMachine
    $ComputerName = Get-WmiObject Win32_computersystem | Select-Object -ExpandProperty Name
    $OpenRegKeys = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $ComputerName)
    $KeyPath = 'SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs'
    $KeyValue = $OpenRegKeys.OpenSubKey($KeyPath)
    $RegValues = $KeyValue.GetValueNames()

    foreach($KeyValueObject in $RegValues)
    {
        Write-Host $KeyValue.GetValue($KeyValueObject)
    }
}