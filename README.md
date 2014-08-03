
This module allows you to send a message to an Amazon SNS topic from FHEM. For example you could use this to send a message to your email and your mobile number if the front door is left open.

## Definition

To define the SNS in the FHEM config file

````
define <name> SNS <Topic_ARN>
attr <name> key <Access Key ID>
attr <name> secret <Secret Access Key>
```  

Where:
- `<name>` is the unique name to assign to this notificaton
- `<Topic_ARN>` is the ARN of the SNS Topic to send notifications to
- `<Access Key ID>` is the AWS Access Key for an account with permission to publish to the `<Topic_ARN>`
- `<Secret Access Key>` is the Secret Key for an account with permission to publish to the `<Topic_ARN>`

### Note
The access and secret keys are not logged in the fhem log files as well as being available in the config files, hence I highly recommend you create an `IAM user` specially for sending notifications from FHEM, this user should only have permission to Publish to `<Topic_ARN>`. 

## Usage

To send a message to the SNS Topic:-
```
set <name> <msg>
```
where `<msg>` can be multiple words

## Example

````
define mySNS SNS arn:aws:sns:ap-southeast-2:123456789000:myTopic
attr mySNS key MyAcessKey
attr mySNS secret MySecretKey

set mySNS A Test Message


```  

