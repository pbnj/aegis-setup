# Aegis Setup
## Prerequisites
* go installed
* $GOPATH set
* Have ~/.aws/credentials and ~/.aws/config setup

## Have ready
* Credentials for all API accounts
* An enumeration of the asset groups you plan on rescanning (comma separated)
* AWS KMS encryption key
### Nexpose
* Templates for your vulnerability/discovery scans existing in your Nexpose instance and their IDs
* Nexpose site ID (integer) that you will be using for vulnerability rescans
### Qualys
* SearchList and OptionProfile for your vulnerability scans in your Qualys instance and their integer IDs
* OptionProfile for your discovery scans in your Qualys instance and it's integer ID
* A list of all the group IDs that require external scanners (comma separated)
### JIRA
* The project key for the project you plan on storing tickets
* If using your own ticket transition workflow/ticket schema, mapping must be done in the JIRA source config
* (optional) a separate CERF project for tickets that remediators create for tracking exceptions and false-positives
* (optional) JIRA supports Oauth, if you have Oauth credentials, they can be set in the JIRA source config in the database after installation
 
### Database
* Create a schema in your database for Aegis to utilize

## Installation
```
cd $GOPATH/src   
mkdir nortonlifelock
cd $GOPATH/src/nortonlifelock
git clone https://github.com/nortonlifelock/aegis-setup
chmod +x aegis-setup/install.sh
./aegis-setup/install.sh
```

## Running Aegis
TODO