
Now that you have the .csr file on your Windows machine, you can submit the request and generate a certificate. From the Windows Server machine, CA can be opened by typing "Certification Authority" and opening from the search bar, or intuitively through Server Manager by navigating to "AD CS" on the left side bar, right clicking the current server, and clicking "Certification Authority."

![ss2][/Images/search.png]

From inside the Certification Authority service, the CA which was created should now be an entry on the left side bar. To generate a certificate using this CA, right click, hover over "All Tasks," and click "Submit new request..."

![ss2][/Images/submit.png]

This should open a file explorer tab, in which you must navigate to your .csr file. One thing to note is you must change the file types in this file explorer tab to "All files" rather than the select few extensions. Find your .csr file, and select open.

Selecting open on this file will move it into the "Pending Requests" folder associated with your Certification Authority. Click on the arrow next to your CA and navigate to said folder. Find the specific request (it is probably worth deleting old requests as to not get swarmed with requests), right click it, hover over "All Tasks" and select "Issue."

![ss3][/Images/issue.png]

This will now move the certificate to the "Issued Certificates" folder. Now, all that is left is to export this certificate to a certificate file, which can then be sent back using SCP commands to the original machine.

To do this, right click on the issued certificate in the list (once again, it is recommended to remove old certs), and select "Open."

Here, you can look over any of the details that have been inputted, but the button we are looking for is underneath the "Details" tab, titled "Copy to File..." 

![ss4][/Images/copytofile.png]

Keeping all options as default, unless otherwise necessary, the only necessary page is the page in which you are saving the name of the certificate. Save it to a path you will remember, and while any name is fine, it is recommended to name it as yourdomain.cer. This can now be sent back to the machine.

As a last step, if not already done, the machine(s) which are going to be using this certificate will need to trust your CA which has been created in order to trust the certificate.