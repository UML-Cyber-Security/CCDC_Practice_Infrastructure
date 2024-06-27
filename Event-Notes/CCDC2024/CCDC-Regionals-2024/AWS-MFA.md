# AWS Console MFA

First we will need a authentication app. I used a chrome extension to do this, I think it also works with Firefox, and im not sure about Microsoft Edge


The extension I used is simply called authenticator on chrome extension store
![Image](/Images/Authenticator-Extensoin.png)

## On AWS Console

Next we need to setup it up on the AWS console.

To do this we first need to go to IAM.

Once we are on IAM, click on the user that we want MFA for.

After we are on that user, go to the security Credentials tab.

Click on the Assign MFA device button

Put a device name, for practice I just put test laptop.

Then click on the see Secret Key button.

![Imafe](/Images/ShowSecretKeyEG.png)

Copy the secret key and put it in the extension we downloaded.

![Image](/Images/AddKeyStep1.png)

![Image](/Images/AddKeyStep2.png)


Then click on manual entry and for issuer you can put anything and then paste in secret key


Take the first MFA it gives you and paste it in, then wait for the second and paste that one in
Put in the first two codes you get.

Then hit add MFA Device button. Then try to login and test that the MFA works