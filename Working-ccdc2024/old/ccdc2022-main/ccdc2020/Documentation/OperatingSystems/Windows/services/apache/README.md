# Objective

Install Apache HTTP Server (httpd) 2.4.41 on a Windows 10 machine.

# End Product

Create a test page running Apache and viewing the test page by entering the URL: http://localhost/

# Scripting Solution

TBD

# Security Analysis

TBD

# Testing

TBD

# Documentation

1. Go to the official Apache website: https://httpd.apache.org/
2. Look for the most recent stable release of Apache HTTP Server.
   - Currently 2.4.41 from the 2.4.x stable branch
3. Hit the download link under that release
   - It will bring you to further down on the same web page
4. Click the blue hyperlink that says "Files for Microsoft Windows"
5. We can use binaries from either ApacheHaus or Apache Lounge
   - We will use **Apache Lounge** for simplicity
   - Click on the blue hyperlink that says "Apache Lounge"
6. Before downloading your version of Apache 2.4.x (x meaning the latest version), Make sure you download at have at least 14.23.27820.0 Visual C++ Redistributable for Visual STudio 2015-2019
   - "vc_redist_x64" is for 64-bit machines
   - "vc_redist_x86" is for 32-bit machines
   - Most modern Windows 10 machines have this installed already, but it does not hurt to re-download it just in case
7. After downloading one of those two exe files, go to that file location and click the exe file to start installing the program.
8. Once the install is complete, right click on the "httpd-2.4.41-Win64-VC16" (in my case) and click extract all.
9. Now that you have a folder called "Apache24"
   - Copy that file and paste it to your C drive on your local disk
10. Now we need to update a path for your environmental variables.
   - In your file explorer, look for "This PC" and right click on it
   - Click properties
   - On the left hand side click "Advanced system settings"
   - Make sure you are under the "Advanced" tab at the top and then click "Environmental Variables" at the bottom
   - In the second section under "System variables" look for "Path" under Variable column and select it
   - Click "Edit"
   - Click "New"
   - Click "Browse"
   - Go into your local C drive and find and click on the Apache24 folder
   - Select the "bin" (binary) folder and click "OK", "OK", "OK"
11. Now open a Command Prompt and run as administrator by right clicking on the Command Prompt program and clicking "Run as administrator".
12. In th command-line type "httpd -k install"
   - A Windows Security Alert window will pop up
   - You can keep the first box checked and click allow access
13. Now click on the windows icon in the bottom left of your screen and type "Services" and open the app.
14. Find the service name "Apache2.4" and right click and click "Start"
15. Finally, go to your web browser and type in: http://localhost/
   - A web page should pop up displaying "It Works!" in large bold letters

# To Do

1. Make Apache Install into a script
2. Verify all downloads for:
* Authentication - PGP Signature (Public PGP key)
* Integrity - SHA1-SHA512 Checksums
3. Add PHP and MYSQL
4. Look into all-in-one Windows distributions that contain Apache, PHP, MySQL and other applications contained in a single installation file
* XAMPP (includes a Mac version)
* WampServer
* Web.Developer

# References

* [Apache Website](https://httpd.apache.org/)
* [Apache Lounge](https://www.apachelounge.com/download/)
* [How to Install Apache Web Server on Windows 10](https://www.youtube.com/watch?v=TDpllMVuoeE)
* [Changelog Apache 2.4](https://www.apachelounge.com/Changelog-2.4.html) for security updates