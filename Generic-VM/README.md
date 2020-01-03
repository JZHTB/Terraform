## Generic VM Module

This module will create a generic VM using the CIS benchmark, encrypt the disk with bitlocker, enroll the machine within a recovery services vault and install the following extensions: 

 - VM Diag to a storage account using the configuration within *diag-config.xml*
 - OMSExtension
 - Antimalware 
 - VM Encryption. 

Note, the machine will be created within a new availability set. This is to support future addition to an AS. 

